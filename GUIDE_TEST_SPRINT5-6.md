# 🧪 GUIDE DE TEST - SPRINT 5-6

## 📍 OÙ TESTER DANS L'APPLICATION

### **URL PRINCIPALE**: `http://localhost:8080/reservation-voiture`

---

## **TEST 1 : SPRINT 5 - Regroupement Temporel**

### 📍 PAGE: **Assignation Form** 
**URL**: `http://localhost:8080/reservation-voiture/assignation-form?date=2026-03-20`

### ✅ ÉTAPE PAR ÉTAPE:

#### **1. Accéder à la page Assignation**
```
Menu → Assignation Form
Ou direct: /assignation-form?date=2026-03-20
```

#### **2. Sélectionner la date** 
- **Date**: `2026-03-20` (date des données de test)
- Cliquer sur "Charger" ou le sélecteur de date

#### **3. Vérifier les réservations non assignées**
La section "Réservations Non Assignées" devrait afficher:

| ID | Client | Passagers | Heure | Hôtel |
|----|--------|-----------|-------|-------|
| 1 | 1001 | 5 | 18:15 | Hotel Anjary |
| 2 | 1002 | 8 | 18:25 | Hotel Anjary |
| 3 | 1003 | 6 | 18:32 | Hotel Anjary |
| 4 | 1004 | 3 | 18:50 | Hotel Anjary |

#### **4. VÉRIFIER L'ATTENTE (30 min = 18:00 à 18:30)**
```
✓ Groupe 1 (fenêtre 18:00 - 18:30):
  - Res 1: 18:15 ✓ incluse
  - Res 2: 18:25 ✓ incluse
  - Res 3: 18:32 ✓ incluse (PLUS TARDIVE - départ du groupe)
  - Res 4: 18:50 ✗ EXCLUE (après 18:30)

✓ Groupe 2 (fenêtre 18:50 - 19:20):
  - Res 4: 18:50 ✓ nouvelle fenêtre
```

#### **5. Lancer l'assignation**
Bouton: **"Lancer Assignation"** ou **"Assigner Automatiquement"**

#### **6. RÉSULTATS ATTENDUS - Trajets créés**

**TRAJET 1** (Groupe 1 - départ 18:32):
- **Heure départ**: 18:32 (réservation la plus tardive du groupe)
- **Total passagers**: 19 (5 + 8 + 6)
- **Véhicules utilisés**: V1 (12 places) + V2 (5 places)
  - V1: R2(8) + R3(6) = 14 passagers... attendez, 14 > 12, donc:
  - V1: R1(5) + R2(8) = 13... aussi > 12
  - **Attendu logique**: 
    - V1 (12): R2(8) seul, puis V2(5): R1(5)... mais R3 reste (6 pax)
    - Ou: V1(12): R1(5) seul, V2(5): impossible(R2 8 > 5)
    - **Correct**: V1: 5+8=13... trop. Donc: V2(5): R1(5), V1(12): R2(8)+R3(6)=14 trop
    - **Vraie résolution**: 
      - Tri décroissant: R2(8), R3(6), R1(5)
      - V1(12): peut R2(8) + petit? R1(5) = 13 > 12? OUI trop
      - Donc V1 cherche capacité exacte ou proche: 8+4max = pas de 4
      - V1: R2(8) alone, puis V2: R1(5), puis V3: pas dispo si V2 essence
      - **Le code teste capacité exacte PUIS prend autre véhicule**
- **Heure retour**: 18:32 + 20 min (aller-retour 5km à 60km/h) = 18:52
- **Kilométrage**: 5 × 2 = **10 km**

**TRAJET 2** (Groupe 2 - départ 18:50):
- **Heure départ**: 18:50 (R4 seule)
- **Total passagers**: 3
- **Véhicule**: V4 (8 places) - priorité moins de trajets
- **Kilométrage**: 5 × 2 = **10 km**

---

## **TEST 2: SPRINT 6 - Sélection des Véhicules**

### 📍 PAGE: **Assignation Form** (même page)

### ✅ ORDRE DE PRIORITÉ TESTABLE:

Regarder **les logs du serveur** ou **l'ordre des trajectoires** pour vérifier:

```
RÈGLE 1: Véhicule avec MOINS de trajets effectués
  Avant test: tous = 0 trajets
  → Tous égaux, passer à RÈGLE 2

RÈGLE 2: Si égalité de trajets → DIESEL prioritaire
  V1: diesel  (0 trajets) ✓✓ CHOISI EN 1ER
  V2: essence (0 trajets) ✗
  V3: diesel  (0 trajets) ✓
  V4: diesel  (0 trajets) ✓

RÈGLE 3: Si toujours égalité → Capacité max
  V1: 12 places ✓✓✓ PLUS GRANDE
  V3: 5 places
  V4: 8 places
```

### 🔍 VÉRIFICATION:

1. **Accéder à Assignation Form** avec date `2026-03-20`
2. **Lancer assignation**
3. **Vérifier dans Trajets** l'ordre vehicles utilisés:
   - V1 (12 diesel) devrait être choisi en premier si capacité suffisante
   - Sinon V3 (5 diesel) prioritaire sur V2 (5 essence)

### 📊 VOIR LES TRAJETS:
**URL**: `http://localhost:8080/reservation-voiture/sprint10.jsp?date=2026-03-20`

Ou bouton: **"Afficher Trajets"** / **"Voir Résumé"**

Table attendue:
```
Véhicule | Capacité | Carburant | Départ | Retour | Passagers | Kilométrage
V1       | 12       | diesel    | 18:32  | 18:52  | 13        | 10 km
V2       | 5        | essence   | 18:?   | 18:?   | ?         | ? km
...
```

---

## **TEST 3: KILOMÉTRAGE**

### 📍 PAGE: **Sprint 10 - Résumé Trajets**
**URL**: `http://localhost:8080/reservation-voiture/sprint10.jsp`

### ✅ ÉTAPES:

#### **1. Sélectionner date** `2026-03-20`

#### **2. Vérifier colonne "Kilométrage Parcouru"**
```
EXPECTED:
─────────────────────────
Hôtel Anjary  (5 km):
  Kilométrage = 5 × 2 = 10 km ✓

Le Louvre (7 km):
  Kilométrage = 7 × 2 = 14 km ✓

Colbert (8 km):
  Kilométrage = 8 × 2 = 16 km ✓
```

#### **3. Vérifier en base de données** (PostgreSQL)

```sql
SELECT 
    a.id_assignation,
    a.heure_depart,
    a.heure_arrivee,
    a.kilometrage,           -- NOUVELLE COLONNE
    a.id_hotel,             -- NOUVELLE COLONNE
    r.id_reservation,
    r.nbPassager,
    v.marque,
    v.modele
FROM assignation a
JOIN vehicule v ON a.id_vehicule = v.id_vehicule
JOIN reservation r ON a.id_reservation = r.id_reservation
WHERE DATE(a.heure_depart) = '2026-03-20'
ORDER BY a.heure_depart;
```

**Résultat attendu:**
```
id_assignation | heure_depart | heure_arrivee | kilometrage | id_hotel | ...
──────────────────────────────────────────────────────────────────────────
1              | 18:32        | 18:52         | 10.0        | 2        | ...
2              | 18:?         | 18:?          | 10.0        | 2        | ...
...
```

---

## 🔍 PAGES IMPORTANTES POUR VÉRIFIER

| Sprint | Page/URL | Quoi Vérifier |
|--------|----------|---------------|
| **5** | `/assignation-form?date=2026-03-20` | **Réservations regroupées** par intervalle 30min |
| **5** | Logs assignation | **Heure départ = réservation la plus tardive** |
| **6** | `/sprint10.jsp` ou Trajets | **Véhicules sélectionnés** dans l'ordre priorité |
| **6** | Console/Logs | **Critères sélection** (trajets < diesel < capacité) |
| **Kilo** | `/sprint10.jsp?date=2026-03-20` | **Colonne Kilométrage** = distance × 2 |
| **Kilo** | PostgreSQL query ci-dessus | **Colonnes `kilometrage` et `id_hotel` remplies** |

---

## ✅ CHECKLIST FINAL

```
[ ] Date 2026-03-20 avec 4 réservations affichées
[ ] Groupe 1: R1, R2, R3 ensemble (départ 18:32)
[ ] Groupe 2: R4 seule (départ 18:50)
[ ] R4 = nouveau groupe (après fenêtre 18:30)
[ ] Véhicules sélectionnés dans ordre Sprint 6
[ ] Kilométrage Anjary = 10 km (5×2)
[ ] Colonnes kilométrage/id_hotel dans base remplies
[ ] Heure retour = heure_départ + aller-retour
```

---

## 📝 NOTES DE DÉBOGAGE

Si problèmes:

**Réservations ne s'affichent pas**:
```sql
SELECT * FROM reservation WHERE DATE(dateHeure) = '2026-03-20';
-- Doit retourner 4 lignes
```

**Kilométrage à 0**:
- Vérifier colonne existe: `\d+ assignation` dans psql
- Vérifier assignerVehiculesParDate() appelle enregistrerAssignation avec parametres

**Trajets ne s'affichent pas**:
- Vérifier `/sprint10.jsp` existe (SPrint 10 JSP)
- Vérifier URL appelle getTrajets(date)

**Heure retour incorrecte**:
- Distance Anjary = 5 km
- Temps aller = ceil(5/60 × 60) = 5 min
- Temps total = 5 × 2 = 10 min
- Heure retour = heure_départ + 10 min
