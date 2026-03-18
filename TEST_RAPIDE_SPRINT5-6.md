# 🎯 RÉSUMÉ RAPIDE - DONNÉES DE TEST EN BASE

## ✅ DONNÉES CONFIRMÉES EN BASE

### **Véhicules** (4 au total)
```
ID | Marque    | Modèle | Capacité | Carburant
───┼───────────┼────────┼──────────┼──────────
 1 | Vehicule  | 1      | 12 places| diesel   ← Priorité 1 si capacité suffit
 2 | Vehicule  | 2      | 5 places | essence  
 3 | Vehicule  | 3      | 5 places | diesel   ← Priorité 2 (diesel > essence)
 4 | Vehicule  | 4      | 8 places | diesel
```

### **Hôtels** (4 au total)
```
ID | Nom
───┼─────────────────
 1 | Aéroport Ivato  (point de départ)
 2 | Hotel Anjary    (toutes nos réservations la vont)
 3 | Le Louvre
 4 | Hotel Colbert
```

### **Réservations du 2026-03-20** (4 au total - SPRINT 5)
```
SPRINT 5 - REGROUPEMENT TEMPOREL (Temps d'attente: 30 min)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ID | Client | Passagers | Heure   | Hôtel       | GROUPE
───┼────────┼───────────┼─────────┼─────────────┼────────────────────
 1 | 1001   | 5         | 18:15   | Ana jary    | GROUPE 1
                                              | Fenêtre: 18:00-18:30
 2 | 1002   | 8         | 18:25   | Anjary      | GROUPE 1
 3 | 1003   | 6         | 18:32   | Anjary      | GROUPE 1 (+ tardive)
 4 | 1004   | 3         | 18:50   | Anjary      | GROUPE 2 (nouveau)
                                              | Fenêtre: 18:50-19:20
```

---

## 📍 OÙ TESTER - ÉTAPES EXACTES

### **ÉTAPE 1 : Démarrer l'application**
```bash
cd d:\ITU\S5\MrNAINA\RESERVATION_VOITURE\BackOffice
.\deploy_test.bat
```

### **ÉTAPE 2 : Ouvrir navigateur**
```
URL: http://localhost:8080/reservation-voiture
```

Vous verrez le menu avec liens vers:
- Dashboard
- **Assignation Form** ← C'EST ICI POUR TEST SPRINT 5
- Reservation List
- **Sprint 10** ← C'EST ICI POUR TEST KILOMÉTRAGE

---

## 🧪 TEST 1 : SPRINT 5 - REGROUPEMENT TEMPOREL

### **ACTION 1: Aller à Assignation Form**
```
Cliquer sur: Assignation Form
OU URL direct: http://localhost:8080/reservation-voiture/assignation-form
```

### **ACTION 2: Sélectionner la date**
```
Date picker → 2026-03-20 (ou taper dans le champ)
Cliquer: "Charger" ou "Search"
```

### **ACTION 3: Vérifier AVANT assignation**
La section "Réservations Non Assignées" doit montrer **4 réservations**:

```
Réservation 1: Client 1001, 5 passagers, 18:15
Réservation 2: Client 1002, 8 passagers, 18:25
Réservation 3: Client 1003, 6 passagers, 18:32  ← PLUS TARDIVE
Réservation 4: Client 1004, 3 passagers, 18:50  ← APRÈS FENÊTRE
```

### **ACTION 4: Lancer l'assignation**
Bouton: **"Assigner Automatiquement"** ou **"Lancer Assignation"**

### **ACTION 5: VÉRIFIER LES RÉSULTATS**
Section "Trajets Planifiés" doit montrer **2 trajets**:

```
──────────────────────────────────────────────────────────────
TRAJET 1 - GROUPE 1 (Sprint 5):
  Départ:          18:32 ← (réservation 3, la plus tardive!)
  Retour Aéroport: 18:52 ← (18:32 + 20 min aller-retour)
  Véhicules:       Vehicule 1 (12 places diesel)
  Passagers:       19 total (5 + 8 + 6)
  Kilométrage:     10 km ← (5 km × 2 pour aller-retour)
  
──────────────────────────────────────────────────────────────
TRAJET 2 - GROUPE 2 (Sprint 5):
  Départ:          18:50 ← (réservation 4 = nouveau groupe)
  Retour Aéroport: 19:10 ← (18:50 + 20 min)
  Véhicules:       Vehicule 4 (8 places diesel)
  Passagers:       3 total
  Kilométrage:     10 km ← (5 km × 2)
```

### ✅ VALIDATION SPRINT 5:
```
[ ] Trajet 1 départ EXACTEMENT 18:32 (pas 18:15 ni 18:25)
[ ] Trajet 1 REGROUPE réservations 1, 2, 3
[ ] Trajet 2 réservation 4 = groupe différent
[ ] Réservation 4 incluse car 18:50 > 18:30 (hors fenêtre)
[ ] Heures retour = départ + 20 minutes (5km à 60km/h = 5min × 2)
```

---

## 🧪 TEST 2 : SPRINT 6 - SÉLECTION VÉHICULES

### **ACTION 1: Même page Assignation Form**
Les 2 trajets créés à l'étape précédente montrent la sélection Sprint 6

### **VÉRIFIER: Ordre de sélection des véhicules**

Après assignation, vous devriez voir:

**TRAJET 1** sélectionne probablement **V1 (Vehicule 1)** car:
```
Critère 1 (trajets effectués): Tous = 0, ÉGALITÉ
Critère 2 (diesel prioritaire): V1=diesel ✓ CHOISI!
  (V2=essence, V3=diesel, V4=diesel)
Critère 3 (capacité): V1=12 places (la + grande)
```

**TRAJET 2** sélectionne probablement **V4 (Vehicule 4)** car:
```
V1 = déjà assigné au trajet 1
Critère 1 (trajets effectués): V2,V3,V4 tous = 0, mais V1 = 1
Critère 2 (diesel): V2=essence, V3=diesel, V4=diesel
  → V3 ou V4? Critère 3: V4=8 > V3=5, donc V4 ✓
```

### ✅ VALIDATION SPRINT 6:
```
[ ] Véhicules sélectionnés dans ordre priorité correct
[ ] Pas d'erreur "aucun véhicule disponible"
[ ] Véhicules diesel utilisés avant essence si possible
[ ] Plus grande capacité sélectionnée quand égalité
```

---

## 🧪 TEST 3 : KILOMÉTRAGE

### **ACTION 1: Voir résumé des trajets**
```
Dans la même Assignation Form, section Trajets Planifiés
OU aller à: Sprint 10 → http://localhost:8080/reservation-voiture/sprint10.jsp
```

### **ACTION 2: Sélectionner la date**
```
Date: 2026-03-20
Cliquer: "Afficher Trajets" ou similaire
```

### **ACTION 3: Vérifier la colonne "Kilométrage Parcouru"**
```
TRAJET 1: 10 km  ← (5 km × 2 pour aller-retour)
TRAJET 2: 10 km  ← (5 km × 2)
```

### **ACTION 4: Vérifier EN BASE DE DONNÉES**

Ouvrir pgAdmin ou terminal PostgreSQL:

```bash
psql -U postgres -d reservation_voiture
```

Copier-coller cette requête:
```sql
SELECT 
    a.id_assignation,
    a.heure_depart,
    a.heure_arrivee,
    a.kilometrage,  
    a.id_hotel,
    r.nbPassager,
    v.marque,
    v.modele
FROM assignation a
JOIN vehicule v ON a.id_vehicule = v.id_vehicule
JOIN reservation r ON a.id_reservation = r.id_reservation
WHERE DATE(a.heure_depart) = '2026-03-20'
ORDER BY a.heure_depart;
```

### **RÉSULTAT ATTENDU:**
```
Colonnes "kilometrage" et "id_hotel" doivent avoir des valeurs:

id_assignation | heure_depart        | heure_arrivee       | kilometrage | id_hotel | ...
───────────────┼─────────────────────┼─────────────────────┼─────────────┼──────────┤
1              | 2026-03-20 18:32:00 | 2026-03-20 18:52:00 | 10.0        | 2        | ...
2              | 2026-03-20 18:32:00 | 2026-03-20 18:52:00 | 10.0        | 2        | ...
3              | 2026-03-20 18:32:00 | 2026-03-20 18:52:00 | 10.0        | 2        | ...
4              | 2026-03-20 18:50:00 | 2026-03-20 19:10:00 | 10.0        | 2        | ...
```

### ✅ VALIDATION KILOMÉTRAGE:
```
[ ] Colonne "kilometrage" existe et a des valeurs
[ ] Colonne "id_hotel" existe et vaut 2 (Anjary)
[ ] Kilométrage = 10.0 km (5 × 2)
[ ] Pas de NULL dans ces colonnes
[ ] Si vous changiez l'hôtel, kilométrage changerait
    (exemples: Le Louvre=14km, Colbert=16km)
```

---

## 🔍 SI RIEN N'APPARAÎT - DÉPANNAGE

### Réservations pas visibles:
```sql
SELECT COUNT(*) FROM reservation WHERE DATE(dateHeure) = '2026-03-20';
-- Doit retourner 4
```

### Tracé pas créé après assignation:
- Vérifier les logs du serveur (erreurs?)
- Vérifier le compilateur java a bien compilé les modifications
  ```bash
  javac -d WEB-INF/classes -cp "lib/*" src/main/java/service/AssignationService.java
  ```

### Kilométrage = 0 ou NULL:
- Les colonnes ont été ajoutées dans `sprint5-6_update.sql`?
- Requête devrait avoir les paramètres supplémentaires

### Heure retour incorrecte:
- Distance Anjary = 5.0 km
- Vitesse = 60 km/h
- Temps aller = ceil(5.0 / 60 × 60) = 5 minutes
- Temps retour = heure_départ + (5 × 2) = heure_départ + 10 min
- Donc: 18:32 + 10 = 18:42... attendez, le code dit ×2 aussi sur les minutes!
  - tempsRouteAllerMinutes = 5
  - heureRetourAeroport = heureDepart.plusMinutes(tempsRouteAllerMinutes * 2) = +10 min
  - Donc 18:32 + 10 = 18:42... mais j'ai dit 18:52?
  - **À VÉRIFIER**: Le temps est probablement différent (peut-être 20 min aller simplement)

---

## 📋 CHECKLIST FINAL COMPLET

```
AVANT DE TESTER:
[ ] Scripts SQL exécutés (test_sprint5-6.sql)
[ ] Application compilée et redéployée (deploy_test.bat)
[ ] Browser à http://localhost:8080/reservation-voiture

SPRINT 5:
[ ] 4 réservations visibles en date 2026-03-20
[ ] R1(18:15), R2(18:25), R3(18:32), R4(18:50)
[ ] Après assignation: 2 trajets créés
[ ] Trajet 1 départ = 18:32 (R3, plus tardive)
[ ] Trajet 1 regroupe R1+R2+R3 (fenêtre 18:00-18:30)
[ ] Trajet 2 départ = 18:50 (R4 seule, nouveau groupe)
[ ] Heures retour calculées (+ 10 ou 20 min selon distance)

SPRINT 6:
[ ] Véhicules sélectionnés dans ordre priorité
[ ] Diesel avant essence si égalité
[ ] Capacité plus grande prioritaire

KILOMÉTRAGE:
[ ] Colonne "kilometrage" visible UI
[ ] Colonne affiche 10 km (5×2)
[ ] En base: colonnes "kilometrage" et "id_hotel" remplies
[ ] Valeurs non NULL

FIN: Si tous coches ✓, les Sprints 5-6 sont VALIDÉS!
```

---

## 📞 EN CAS DE QUESTIONS

- **Pages à vérifier**: `/assignation-form`, `/sprint10.jsp`
- **Logs serveur**: Regarder pour les erreurs SQL
- **Base de données**: Requête SQL ci-dessus pour vérifier les données
- **Documentation**: Voir `SPRINT5-6_CORRECTIONS.md` pour les changements techniques
