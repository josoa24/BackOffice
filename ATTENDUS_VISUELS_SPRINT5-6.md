# 📊 ATTENDUS VISUELS - SPRINT 5-6 TESTS

## 🎯 AVANT TOUT
À côté du guide rapide (**TEST_RAPIDE_SPRINT5-6.md**), ce fichier montre  **VISUELLEMENT** ce que vous verrez dans l'application pour chaque test.

---

## TEST 1️⃣: SPRINT 5 - Regroupement Temporel

### PAGE 1: Assignation Form - AVANT Assignation
**URL**: `http://localhost:8080/reservation-voiture/assignation-form?date=2026-03-20`

```
┌─────────────────────────────────────────────────────────────────────┐
│  ASSIGNATION FORM - 2026-03-20                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ 📅 Date: [2026-03-20] [Charger]                                     │
│                                                                       │
│ ──────────────────────────────────────────────────────────────────   │
│ 📋 RÉSERVATIONS NON ASSIGNÉES (4 au total)                          │
│ ──────────────────────────────────────────────────────────────────   │
│                                                                       │
│ ID │ Client │ Passagers │ Heure   │ Hôtel         │ Action           │
│────┼────────┼───────────┼─────────┼───────────────┼──────────────────│
│ 1  │ 1001   │ 5         │ 18:15   │ Hotel Anjary  │ [Assigner]       │
│────┼────────┼───────────┼─────────┼───────────────┼──────────────────│
│ 2  │ 1002   │ 8         │ 18:25   │ Hotel Anjary  │ [Assigner]       │
│────┼────────┼───────────┼─────────┼───────────────┼──────────────────│
│ 3  │ 1003   │ 6         │ 18:32   │ Hotel Anjary  │ [Assigner]       │
│────┼────────┼───────────┼─────────┼───────────────┼──────────────────│
│ 4  │ 1004   │ 3         │ 18:50   │ Hotel Anjary  │ [Assigner]       │
│────┴────────┴───────────┴─────────┴───────────────┴──────────────────│
│                                                                       │
│ [Assigner Automatiquement]  [Annuler]                                │
│                                                                       │
│ ℹ️ INFO: 4 réservations non assignées pour cette date                │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

### PAGE 2: Assignation Form - APRÈS Assignation (SPRINT 5 RÉSULTATS)
```
┌─────────────────────────────────────────────────────────────────────┐
│  TRAJETS PLANIFIÉS - 2026-03-20                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ✅ Assignation réussie!  2 trajets créés                             │
│                                                                       │
│ ╔═══════════════════════════════════════════════════════════════╗   │
│ ║ TRAJET 1 - GROUPE 1 (Sprint 5: Départ plus tardive)          ║   │
│ ╠═══════════════════════════════════════════════════════════════╣   │
│ ║                                                               ║   │
│ ║ 🚗 Véhicule:               Vehicule 1 (12 places - diesel)  ║   │
│ ║ ⏰ Heure Départ:           18:32 ← ***PLUS TARDIVE***        ║   │
│ ║ ⏰ Heure Retour Aéroport:  18:52 (+ 20 min aller-retour)    ║   │
│ ║ 👥 Total Passagers:        19 (5 + 8 + 6)                   ║   │
│ ║ 📍 Hôtel:                  Hotel Anjary                      ║   │
│ ║ 📏 Kilométrage:            10 km ← ***NOUVEAU CHAMP***       ║   │
│ ║                                                               ║   │
│ ║ 📦 Réservations incluses:                                    ║   │
│ ║    ✓ Res 1: 1001, 5 pax, 18:15                             ║   │
│ ║    ✓ Res 2: 1002, 8 pax, 18:25                             ║   │
│ ║    ✓ Res 3: 1003, 6 pax, 18:32 (départ groupe)             ║   │
│ ║                                                               ║   │
│ ║ 💡 VALIDATION SPRINT 5:                                      ║   │
│ ║    • Regroupement = RES dans intervalle 30min (18:00-18:30)║   │
│ ║    • Départ = Res plus tardive (18:32)                      ║   │
│ ║    • Fenêtre glissante OK (+ 30 min à partir du 1er vol)    ║   │
│ ╚═══════════════════════════════════════════════════════════════╝   │
│                                                                       │
│ ╔═══════════════════════════════════════════════════════════════╗   │
│ ║ TRAJET 2 - GROUPE 2 (Après fenêtre = nouveau groupe)         ║   │
│ ╠═══════════════════════════════════════════════════════════════╣   │
│ ║                                                               ║   │
│ ║ 🚗 Véhicule:               Vehicule 4 (8 places - diesel)   ║   │
│ ║ ⏰ Heure Départ:           18:50 ← (18:30 + fenêtre glisse)  ║   │
│ ║ ⏰ Heure Retour Aéroport:  19:10 (+ 20 min)                 ║   │
│ ║ 👥 Total Passagers:        3                                ║   │
│ ║ 📍 Hôtel:                  Hotel Anjary                      ║   │
│ ║ 📏 Kilométrage:            10 km                             ║   │
│ ║                                                               ║   │
│ ║ 📦 Réservations incluses:                                    ║   │
│ ║    ✓ Res 4: 1004, 3 pax, 18:50 (hors fenêtre groupe 1)     ║   │
│ ║                                                               ║   │
│ ║ 💡 VALIDATION SPRINT 5:                                      ║   │
│ ║    • Res 4 (18:50) EXCLUE du groupe 1 (fenêtre ≤ 18:30)     ║   │
│ ║    • Nouveau groupe créé pour Res 4                          ║   │
│ ║    • Fenêtre glisse: départ 18:50, window 18:50-19:20       ║   │
│ ╚═══════════════════════════════════════════════════════════════╝   │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

---

## TEST 2️⃣: SPRINT 6 - Sélection Véhicules

### Les 2 trajets en dessus MONTRENT déjà SPRINT 6

**TRAJET 1** choisit **Vehicule 1** car:
```
Critère SPRINT 6 - Ordre Priorité:
════════════════════════════════════════

1. MOINS DE TRAJETS EFFECTUÉS (avant this assignment):
   • V1: 0 trajets ✓
   • V2: 0 trajets ✓ (égalité, aller à critère 2)
   • V3: 0 trajets ✓ (égalité, aller à critère 2)
   • V4: 0 trajets ✓ (égalité, aller à critère 2)
   Résultat: TOUS ÉGAUX → Continue au critère 2

2. SI ÉGALITÉ → DIESEL PRIORITAIRE:
   • V1: diesel   ✓✓ CHOISI! (moteur diesel = meilleur carburant)
   • V2: essence  ✗  (carburant moins efficace)
   • V3: diesel   ✓ (mais V1 déjà choisi)
   • V4: diesel   ✓ (mais V1 déjà choisi)
   Résultat: V1 choisie (diesel + capacité max)

3. CAPACITÉ LA PLUS GRANDE:
   • V1: 12 places ✓✓✓ (MAXIMUM)
   • V3: 5 places
   • V4: 8 places
   Résultat: V1 = 12 places → CHOIX FINAL
```

**TRAJET 2** choisit **Vehicule 4** car:
```
Critère SPRINT 6 - Ordre Priorité:
════════════════════════════════════════

1. MOINS DE TRAJETS EFFECTUÉS (APRÈS trajet 1):
   • V1: 1 trajet → (assigné à trajet 1)
   • V2: 0 trajets ✓
   • V3: 0 trajets ✓ (égalité, aller à critère 2)
   • V4: 0 trajets ✓ (égalité, aller à critère 2)
   Résultat: V2, V3, V4 = 0 → Tous à égalité

2. SI ÉGALITÉ → DIESEL PRIORITAIRE:
   • V2: essence ✗ (carburant essence)
   • V3: diesel ✓ (carburant diesel)
   • V4: diesel ✓ (carburant diesel)
   Résultat: V3 ou V4 → Continue au critère 3

3. CAPACITÉ LA PLUS GRANDE:
   • V3: 5 places
   • V4: 8 places ✓✓✓ (MAXIMUM entre V3 et V4)
   Résultat: V4 choisie → CHOIX FINAL
```

### ✅ VALIDATION SPRINT 6:
```
TRAJET 1:  V1 ✓ (diesel, 0 trajets, 12 places max)
TRAJET 2:  V4 ✓ (diesel, 0 trajets après T1, 8 places > V3's 5)

Ordre sélection respecte: moins trajets → diesel → capacité
```

---

## TEST 3️⃣: KILOMÉTRAGE

### UI - Colonne Kilométrage Visible

```
┌──────────────────────────────────────────────────────────────────────┐
│  SPRINT 10 - RÉSUMÉ TRAJETS                                          │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│ 📅 Date: [2026-03-20]  [Afficher Trajets]                            │
│                                                                        │
│ ┌─ TRAJETS PLANIFIÉS ─────────────────────────────────────────────┐  │
│ │                                                                  │  │
│ │ Départ │ Véhicule      │ Capa. │ Carbu. │ Retour │ Pax │ Kilo  │  │
│ │────────┼───────────────┼───────┼────────┼────────┼─────┼───────│  │
│ │ 18:32  │ Vehicule 1    │ 12    │ diesel │ 18:52  │ 19  │ 10km  │  │
│ │        │   (12 diesel) │   pl. │        │        │     │       │  │
│ ├────────┼───────────────┼───────┼────────┼────────┼─────┼───────│  │
│ │ 18:50  │ Vehicule 4    │ 8     │ diesel │ 19:10  │ 3   │ 10km  │  │
│ │        │   (8 diesel)  │   pl. │        │        │     │       │  │
│ └────────┴───────────────┴───────┴────────┴────────┴─────┴───────┘  │
│                                                                        │
│ ⚠️  IMPORTANTE: Colonne "Kilométrage" montrent 10 km                 │
│                                                                        │
│ 📊 Explication Kilométrage:                                          │
│    • Hôtel Anjary = 5 km de l'aéroport (distance DB)                │
│    • Trajet = aller + retour = 5 × 2 = 10 km ✓                    │
│                                                                        │
│ Si vous testiez d'autres hôtels:                                     │
│    • Le Louvre (7 km) → Kilométrage = 14 km                         │
│    • Colbert (8 km) → Kilométrage = 16 km                           │
│                                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

### PostgreSQL - Vérification BASE DE DONNÉES

```sql
-- REQUÊTE À EXÉCUTER:
SELECT 
    a.id_assignation,
    a.heure_depart,
    a.heure_arrivee,
    a.kilometrage,          ← NOUVELLE COLONNE
    a.id_hotel,            ← NOUVELLE COLONNE
    r.nbPassager,
    v.marque,
    v.modele
FROM assignation a
JOIN vehicule v ON a.id_vehicule = v.id_vehicule
JOIN reservation r ON a.id_reservation = r.id_reservation
WHERE DATE(a.heure_depart) = '2026-03-20'
ORDER BY a.heure_depart;

-- RÉSULTAT ATTENDU:
id_assignation | heure_depart        | heure_arrivee       | kilometrage | id_hotel | nbPassager | marque   | modele
───────────────┼─────────────────────┼─────────────────────┼─────────────┼──────────┼────────────┼──────────┼────────
1              | 2026-03-20 18:32:00 | 2026-03-20 18:52:00 | 10,0        | 2        | 5          | Vehicule | 1
2              | 2026-03-20 18:32:00 | 2026-03-20 18:52:00 | 10,0        | 2        | 8          | Vehicule | 1
3              | 2026-03-20 18:32:00 | 2026-03-20 18:52:00 | 10,0        | 2        | 6          | Vehicule | 1
4              | 2026-03-20 18:50:00 | 2026-03-20 19:10:00 | 10,0        | 2        | 3          | Vehicule | 4

✅ OBSERVATIONS:
   • Colonnes "kilometrage" et "id_hotel" = NON NULL
   • Valeurs killométrage = 10.0 (correct pour 5km distance)
   • id_hotel = 2 (Hotel Anjary)
   • Heure départ/arrivée = correctes (calculées)
```

---

## 📋 RÉSUMÉ VALIDATION FINALE

```
╔════════════════════════════════════════════════════════════════╗
║  VALIDATION SPRINT 5 - REGROUPEMENT TEMPOREL                   ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║  ✓ Fenêtre temps d'attente: 30 minutes OK                     ║
║  ✓ Réservations regroupées correctement                        ║
║  ✓ Départ groupe = réservation la PLUS TARDIVE (18:32)        ║
║  ✓ Réservation après fenêtre = nouveau groupe (18:50)         ║
║  ✓ Calcul heure retour: départ + aller-retour OK              ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════╗
║  VALIDATION SPRINT 6 - SÉLECTION VÉHICULES                     ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║  ✓ Moins de trajets = PRIORITÉ 1                              ║
║  ✓ Diesel = PRIORITÉ 2 en cas d'égalité                       ║
║  ✓ Capacité max = PRIORITÉ 3 en cas d'égalité                 ║
║  ✓ Vérification: V1(trajet1), V4(trajet2)                     ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════╗
║  VALIDATION KILOMÉTRAGE - PERSISTANCE DONNÉES                  ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║  ✓ Colonne UI affiche 10 km pour Anjary                       ║
║  ✓ Formule: distance × 2 (aller-retour) = 5 × 2 = 10         ║
║  ✓ Nouveau champ "kilometrage" en base = 10.0                 ║
║  ✓ Nouveau champ "id_hotel" en base = 2                       ║
║  ✓ Pas de NULL dans les données                               ║
║  ✓ Persisté automatiquement à chaque assignation              ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝

═══════════════════════════════════════════════════════════════════
  SI TOUT CELA ✓, BRAVO! SPRINT 5-6 COMPLÈTEMENT VALIDÉ! 🎉
═══════════════════════════════════════════════════════════════════
```

---

## 📞 EN CAS DE PROBLÈME

| Problème | Solution |
|----------|----------|
| **Réservations ne s'affichent pas** | Vérifier date 2026-03-20, ou vérifier data_test insérées (voir TEST_RAPIDE_SPRINT5-6.md) |
| **Seulement 1 trajet au lieu de 2** | Logique regroupement = bug, vérifier window temps d'attente |
| **Heure départ ≠ 18:32** | Sprint 5 bug: départ devrait être heure la plus tardive du groupe |
| **Kilométrage = 0 ou NULL** | Migration SQL pas exécutée, ou paramètres pas passés à enregistrerAssignation() |
| **Mauvais véhicule choisi** | Sprint 6 bug: vérifier ordre priorité (trajets < diesel < capacité) |

Consultez **GUIDE_TEST_SPRINT5-6.md** pour les requêtes SQL de débogage.
