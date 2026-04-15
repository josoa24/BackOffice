╔══════════════════════════════════════════════════════════════════════════════╗
║                         SPRINT 5-6 - PRÊT À TESTER! ✅                       ║
╚══════════════════════════════════════════════════════════════════════════════╝

CE QUI A ÉTÉ FAIT POUR VOUS:
═════════════════════════════════════════════════════════════════════════════════

✓ Données de test insérées en base (4 véhicules, 4 réservations, date: 2026-03-20)
✓ Code Java corrigé et compilé (Assignation.java + AssignationService.java)
✓ Migration SQL créée (colonnes kilométrage et id_hotel ajoutées)
✓ 6 guides de documentation créés pour vous aider à tester

═════════════════════════════════════════════════════════════════════════════════


DOCUMENTS CRÉÉS - À CONSULTER EN CET ORDRE:
═════════════════════════════════════════════════════════════════════════════════

    1️⃣  START_HERE.md
        └─→ Résumé super rapide (1 page)
            • Objectif
            • Données en base
            • 4 étapes simples
            • Checklist final
            ⏱️  TEMPS: 2 min de lecture
            🎯 FAIRE: Lire en premier!

    2️⃣  TEST_RAPIDE_SPRINT5-6.md
        └─→ Guide de test complet mais lisible
            • Exactement ce que vous verrez
            • Où tester dans l'app
            • Étapes progressives
            • Checklist détaillé
            ⏱️  TEMPS: 5 min de lecture + 30 min de test
            🎯 FAIRE: Consulter avant de tester

    3️⃣  ATTENDUS_VISUELS_SPRINT5-6.md
        └─→ Interface UI en ASCII (réaliste)
            • Avant/après assignation
            • Explications Sprint 5
            • Explications Sprint 6
            • Vérification kilométrage
            ⏱️  TEMPS: 2 min (pendant le test)
            🎯 FAIRE: Garder à côté pendant tests

    4️⃣  GUIDE_TEST_SPRINT5-6.md
        └─→ Référence complète avec SQL
            • URLs exactes de l'app
            • Pages à visiter
            • Requêtes PostgreSQL complètes
            • Tableau de correspondance
            ⏱️  TEMPS: Consulter au besoin
            🎯 FAIRE: Si question sur requête SQL

    5️⃣  INDEX_DOCUMENTS_SPRINT5-6.md
        └─→ Navigation entre tous les docs
            • Tableau "Quel doc pour quel besoin?"
            • Cas d'usage exemples
            • Chronologie d'utilisation
            ⏱️  TEMPS: 2 min (référence)
            🎯 FAIRE: Si besoin de s'orienter

    6️⃣  GUIDE_EXECUTION_SPRINT5-6.md
        └─→ Checklist pré-test (déploiement)
            • Migration SQL
            • Compilation Java
            • Redéploiement
            • Validation technique
            ⏱️  TEMPS: Déjà fait pour vous
            🎯 FAIRE: Si retest sans changements

    7️⃣  SPRINT5-6_CORRECTIONS.md
        └─→ Aspect technique (pour dev)
            • Fichiers modifiés
            • Détail des changements
            • Code avant/après
            ⏱️  TEMPS: Consulter au besoin
            🎯 FAIRE: Pour code review

═════════════════════════════════════════════════════════════════════════════════


MARCHE À SUIVRE RAPIDE:
═════════════════════════════════════════════════════════════════════════════════

    ÉTAPE 1: Lire START_HERE.md                          [2 min]
    ÉTAPE 2: Démarrer l'app (.\deploy_test.bat)          [1 min]
    ÉTAPE 3: Tester dans Assignation Form (date: 2026-03-20)  [10 min]
    ÉTAPE 4: Vérifier résultats vs ATTENDUS_VISUELS      [5 min]
    ÉTAPE 5: Requête PostgreSQL pour kilométrage         [2 min]
    ÉTAPE 6: Cocher la Checklist Final                    [1 min]

    ════════════════╤════════════════════════════════════
    TEMPS TOTAL:    │  ~21 minutes pour valider tout! ⏱️
    ════════════════╧════════════════════════════════════

═════════════════════════════════════════════════════════════════════════════════


RÉSUMÉ DES TESTS:
═════════════════════════════════════════════════════════════════════════════════

    📌 SPRINT 5 - REGROUPEMENT TEMPOREL
       • Tester dans: Assignation Form
       • Date: 2026-03-20
       • Résultat attendu: 2 trajets
         - Trajet 1: Départ 18:32 (plus tardive), contient R1+R2+R3
         - Trajet 2: Départ 18:50 (nouveau groupe), contient R4
       • Vérifier: Fenêtre 30 min respectée

    📌 SPRINT 6 - SÉLECTION VÉHICULES
       • Tester dans: Même page (résultats des trajets)
       • Vérifier: Ordre sélection véhicules
         - Moins de trajets = PRIORITÉ 1
         - Diesel = PRIORITÉ 2 (si égalité)
         - Capacité max = PRIORITÉ 3 (si égalité)
       • Résultat attendu: V1 pour trajet 1, V4 pour trajet 2

    📌 KILOMÉTRAGE
       • Tester dans: Colonne "Kilométrage Parcouru"
       • OU: Sprint 10 (si disponible)
       • Vérifier: Affiche 10 km (5 km × 2)
       • Base de données: SELECT ... FROM assignation WHERE DATE(...) = '2026-03-20'
       • Colonnes: kilometrage = 10.0, id_hotel = 2

═════════════════════════════════════════════════════════════════════════════════


DONNÉES EN BASE CONFIRMÉES:
═════════════════════════════════════════════════════════════════════════════════

    VÉHICULES (4):
    ─────────────────────────────────────────────────────────────────
    ID │ Marque   │ Modèle │ Capacité │ Carburant
    ───┼──────────┼────────┼──────────┼─────────
    1  │ Vehicule │ 1      │ 12       │ diesel
    2  │ Vehicule │ 2      │ 5        │ essence
    3  │ Vehicule │ 3      │ 5        │ diesel
    4  │ Vehicule │ 4      │ 8        │ diesel

    RÉSERVATIONS (4) - Date: 2026-03-20:
    ─────────────────────────────────────────────────────────────────
    ID │ Client │ Passagers │ Heure   │ Hôtel
    ───┼────────┼───────────┼─────────┼───────────────
    1  │ 1001   │ 5         │ 18:15   │ Hotel Anjary
    2  │ 1002   │ 8         │ 18:25   │ Hotel Anjary
    3  │ 1003   │ 6         │ 18:32   │ Hotel Anjary ← Plus tardive
    4  │ 1004   │ 3         │ 18:50   │ Hotel Anjary ← Hors fenêtre

    DISTANCE:
    ─────────────────────────────────────────────────────────────────
    Aéroport → Hotel Anjary: 5 km (→ Kilométrage = 10 km A/R)

═════════════════════════════════════════════════════════════════════════════════


CHECKLIST FINAL:
═════════════════════════════════════════════════════════════════════════════════

    AVANT TESTS:
    ☐ Lire START_HERE.md (2 min)
    ☐ Vérifier app démarrée (.\deploy_test.bat)
    ☐ Vérifier http://localhost:8080/reservation-voiture accessible

    SPRINT 5:
    ☐ 4 réservations affichées
    ☐ Trajet 1: départ 18:32 (pas 18:15!)
    ☐ Trajet 1: contient R1+R2+R3 (19 passagers total)
    ☐ Trajet 2: départ 18:50 (R4 seule)
    ☐ Fenêtre 30 min correctement gérée

    SPRINT 6:
    ☐ Véhicules sélectionnés dans l'ordre correct
    ☐ Diesel prioritaire vs essence
    ☐ Pas "aucun véhicule disponible" erreur

    KILOMÉTRAGE:
    ☐ UI affiche 10 km
    ☐ Base de données: kilométrage = 10.0
    ☐ Base de données: id_hotel = 2
    ☐ Pas NULL dans ces colonnes

    ════════════════════════════════════════════════════════════════
    SI TOUS LES CARRÉS COCHÉS ✓:
    SPRINT 5-6 EST COMPLÈTEMENT VALIDÉ! 🎉🎉🎉
    ════════════════════════════════════════════════════════════════

═════════════════════════════════════════════════════════════════════════════════


FICHIERS MODIFIÉS (pour votre info):
═════════════════════════════════════════════════════════════════════════════════

    📝 src/main/java/entity/Assignation.java
       • Ajout: double kilometrage
       • Ajout: int idHotel
       • Ajout: getters/setters

    📝 src/main/java/service/AssignationService.java
       • Modification 1: enregistrerAssignation() → +2 paramètres
       • Modification 2: enregistrerBatchAssignations() → +2 paramètres
       • Modification 3: assignerVehiculesParDate() → calcule puis passe
       • Modification 4: assignerReservationManuelle() → passe paramètre
       • Modification 5: getAssignationsByDate() → SELECT inclut kilomét/hôtel
       • Modification 6: getTrajets() → lit depuis base au lieu de recalculer

    📝 sql/sprint5-6_update.sql (migration)
       • ALTER TABLE assignation ADD COLUMN kilometrage DOUBLE PRECISION
       • ALTER TABLE assignation ADD COLUMN id_hotel INT

═════════════════════════════════════════════════════════════════════════════════


BESOIN D'AIDE?
═════════════════════════════════════════════════════════════════════════════════

    ❓ "Où je teste ça?"
       → Consulter: TEST_RAPIDE_SPRINT5-6.md (section "OÙ TESTER")

    ❓ "Rien n'apparaît après assignation"
       → Consulter: TEST_RAPIDE_SPRINT5-6.md (section "DÉPANNAGE")

    ❓ "Je veux vérifier en base de données"
       → Consulter: GUIDE_TEST_SPRINT5-6.md (section "Vérifier en BD")

    ❓ "Je comprendre pas le changement de code"
       → Consulter: SPRINT5-6_CORRECTIONS.md

    ❓ "Je me suis perdu dans les docs"
       → Consulter: INDEX_DOCUMENTS_SPRINT5-6.md (tableau "Quel doc?")

═════════════════════════════════════════════════════════════════════════════════


                              ALLEZ-Y! 🚀 BON TEST!

                    Lire START_HERE.md en premier (2 min)
                            puis commencer à tester

═════════════════════════════════════════════════════════════════════════════════
