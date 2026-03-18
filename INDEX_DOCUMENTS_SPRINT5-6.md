# 📑 INDEX - Tous les documents créés pour Sprint 5-6

## 📚 DOCUMENTS DE RÉFÉRENCE CRÉÉS

### 🎯 **1. TEST_RAPIDE_SPRINT5-6.md** (Commencez ici !)
   **À LIRE EN PREMIER** avant de tester
   ```
   ✓ Résumé des données en base (4 véhicules, 4 réservations)
   ✓ Étapes exactes pour tester Sprint 5
   ✓ Étapes exactes pour tester Sprint 6
   ✓ Étapes exactes pour tester kilométrage
   ✓ Checklist final de validation
   ✓ Dépannage rapide si problèmes
   
   → OÙ ALLER: PREMIER ENDROIT À CONSULTER
   → POIDS: ~5 min de lecture avant de tester
   ```

### 🎨 **2. ATTENDUS_VISUELS_SPRINT5-6.md**
   **Voyez visuellement ce que vous verrez dans l'app**
   ```
   ✓ Screenshots ASCII de l'interface Assignation Form
   ✓ Affichage des 4 réservations AVANT assignation
   ✓ Affichage des 2 trajets APRÈS assignation
   ✓ Explication visuelle Sprint 5 (fenêtre temps d'attente)
   ✓ Explication visuelle Sprint 6 (ordre priorité véhicules)
   ✓ Vérification kilométrage avec UI + PostgreSQL
   ✓ Résultat final attendu en base de donnéesaux
   
   → UTILITÉ: Savez exactement ce que vous cherchez
   → QUAND L'UTILISER: Pendant que vous testez
   ```

### 🔧 **3. GUIDE_TEST_SPRINT5-6.md**
   **Guide détaillé avec requêtes SQL et URL exactes**
   ```
   ✓ URLs complètes pour accéder aux pages
   ✓ Étapes détaillées pour chaque test
   ✓ Pages spécifiques de l'application à visiter
   ✓ Requêtes PostgreSQL pour vérifier en base
   ✓ Mise en correspondance Sprint 5 ↔ UI
   ✓ Mise en correspondance Sprint 6 ↔ Critères
   ✓ Table d'index: Sprint → Page → Vérification
   ✓ Requêtes PostedSQL complètes copiable-collable
   
   → UTILITÉ: Document de référence complet
   → QUAND L'UTILISER: Besoin plus de détails, requêtes DB
   ```

### 📊 **4. SPRINT5-6_CORRECTIONS.md**
   **Résumé technique des changements**
   ```
   ✓ Quels problèmes ont été identifiés
   ✓ Comment ils ont été corrigés (code + logique)
   ✓ Fichiers modifiés et détail des changements
   ✓ Migrations SQL appliquées
   ✓ Validation de la compilation
   
   → UTILITÉ: Comprendre les changements techniques
   → POUR QUOI: Developer / Tech Lead review
   ```

### 🚀 **5. GUIDE_EXECUTION_SPRINT5-6.md**
   **Avant de tester: étapes d'exécution**
   ```
   ✓ Migration SQL à exécuter (sql/sprint5-6_update.sql)
   ✓ Compilation du projet Java
   ✓ Redéploiement de l'application
   ✓ Vérification validations Sprint 5-6
   ✓ Checklist déploiement
   
   → UTILITÉ: Checklist pré-test déploiement
   → FAIRE: Avant de commencer les tests
   ```

### 📝 **6. sql/test_sprint5-6.sql** (Scripts SQL)
   **Données de test en PostgreSQL**
   ```
   ✓ DELETE toutes les données existantes
   ✓ INSERT 4 véhicules de test
   ✓ INSERT 4 hôtels + distances
   ✓ INSERT 4 réservations pour 2026-03-20
   ✓ Commentaires explicatifs
   
   → UTILITÉ: Remplir la base avec données de test
   → EXÉCUWER: psql -U postgres -d reservation_voiture -f sql/test_sprint5-6.sql
   ```

---

## 🗂️ STRUCTURE DES DOCUMENTS

```
TEST_RAPIDE_SPRINT5-6.md ← COMMENCEZ ICI (lire 5 min)
         ↓
Vous avez des données confirmées en base
         ↓
ATTENDUS_VISUELS_SPRINT5-6.md ← Consultez pendant le test
         ▼
Vous testez dans l'application...
         ↓
✓ Je vois bien ce qu'attendu? → Bravo c'est OK!
✗ Quelque chose n'est pas normal? → Consultez GUIDE_TEST_SPRINT5-6.md
         ↓
GUIDE_TEST_SPRINT5-6.md ← Requêtes SQL + URLs exactes
         ↓
Comprenez le problème → SPRINT5-6_CORRECTIONS.md pour contexte technique
```

---

## ⏱️ CHRONOLOGIE D'UTILISATION

### Phase 1: PRÉ-TEST (15 min)
```
1. Lire: GUIDE_EXECUTION_SPRINT5-6.md
2. Exécuter: Migration SQL (sprint5-6_update.sql)
3. Recompiler: Projet Java
4. Redéployer: Application (deploy_test.bat)
5. Vérifier: Données en base
```

### Phase 2: TESTS (30 min)
```
1. Lire: TEST_RAPIDE_SPRINT5-6.md (résumé complet)
2. Consulter: ATTENDUS_VISUELS_SPRINT5-6.md (pendant le test)
3. Accéder à: http://localhost:8080/reservation-voiture
4. Naviguer: Assignation Form (date: 2026-03-20)
5. Test 1: Sprint 5 - Regroupement
6. Test 2: Sprint 6 - Sélection véhicules
7. Test 3: Kilométrage
```

### Phase 3: VALIDATION (15 min)
```
1. Consulter: ATTENDUS_VISUELS_SPRINT5-6.md (checklist final)
2. Utiliser: Requêtes PostgreSQL depuis GUIDE_TEST_SPRINT5-6.md
3. Vérifier: Toutes les métriques OK
4. Conclure: Les sprints 5-6 sont VALIDÉS ✓
```

---

## 🔍 TABLEAU RAPIDE - QUEL DOCUMENT POUR QUEL BESOIN?

| BESOIN | DOCUMENT |
|--------|----------|
| **Je commence les tests** | TEST_RAPIDE_SPRINT5-6.md |
| **Je veux savoir exactement ce que je verrai** | ATTENDUS_VISUELS_SPRINT5-6.md |
| **J'ai une question technique** | GUIDE_TEST_SPRINT5-6.md |
| **Je comprendre le problème** | GUIDE_TEST_SPRINT5-6.md (requêtes SQL) |
| **Je dois revoir les changements** | SPRINT5-6_CORRECTIONS.md |
| **Je dois déployer avant de tester** | GUIDE_EXECUTION_SPRINT5-6.md |
| **Je deux données exactes en base** | TEST_RAPIDE_SPRINT5-6.md (section DONNÉES) |
| **J'ai besoin de requêtes SQLexactes** | GUIDE_TEST_SPRINT5-6.md (section 5) |

---

## 📍 PAGES DE L'APP À TESTER

| Sprint | URL | Document de référence |
|--------|-----|----------------------|
| **5** | `http://localhost:8080/.../assignation-form?date=2026-03-20` | TEST_RAPIDE: Étape 1-5 |
| **5** | Regarder section "Trajets Planifiés" | ATTENDUS_VISUELS: PAGE 2 |
| **6** | Même page Assignation Form (résultats) | ATTENDUS_VISUELS: TEST 2 |
| **Kilométrage** | `/sprint10.jsp?date=2026-03-20` | ATTENDUS_VISUELS: TEST 3 |
| **Base de données** | PostgreSQL requête | GUIDE_TEST: Section 5, Test 3 |

---

## 🎯 CAS D'USAGE EXAMPLES

### Cas 1: "Je veux juste savoir où tester"
```
1. Lire: TEST_RAPIDE_SPRINT5-6.md (section "OÙ TESTER")
2. URL: http://localhost:8080/.../assignation-form?date=2026-03-20
3. Action: Charger date, lancer assignation, vérifier résultats
```

### Cas 2: "Je vois quelque chose de bizarreérant" 
```
1. Consulter: ATTENDUS_VISUELS_SPRINT5-6.md (section correspondante)
2. Comparer: Est-ce que je vois la même chose?
3. Prune: Non? Aller à GUIDE_TEST_SPRINT5-6.md pour SQL debug
4. Exécuter: Les requêtes SQL pour vérifier les données
```

### Cas 3: "Je dois comprendre le code changé"
```
1. Lire: SPRINT5-6_CORRECTIONS.md
2. Voir: Quels fichiers ont changé + quoi a changé
3. Contexte: Comprendre l'impact des changements
```

### Cas 4: "Rien n'apparaît après assignation"
```
1. Vérifier: GUIDE_EXECUTION_SPRINT5-6.md (déploiement OK?)
2. Vérifier: sql/test_sprint5-6.sql (données dans base?)
3. DEBUG: Requêtes PostgreSQL (GUIDE_TEST_SPRINT5-6.md)
4. VOIR: Colonnes kilométrage/id_hotel existent en base?
```

---

## 📚 FICHIERS VUS CRÉÉS

```
PROJECT_ROOT/
├── TEST_RAPIDE_SPRINT5-6.md              ← Commencez ici
├── ATTENDUS_VISUELS_SPRINT5-6.md         ← Pendant tests
├── GUIDE_TEST_SPRINT5-6.md               ← Détails + SQL
├── SPRINT5-6_CORRECTIONS.md              ← Vue technique
├── GUIDE_EXECUTION_SPRINT5-6.md          ← Pré-test
├── sql/
│   └── test_sprint5-6.sql                ← Données test
└── src/main/java/
    ├── entity/Assignation.java           ← Modifiée (+2 champs)
    └── service/AssignationService.java   ← Modifiée (6 appels)
```

---

## ✅ CHECK FINAL AVANT DE COMMENCER

```
[ ] Tous les documents lus? (au moins skim)
[ ] Vou avez Git cloned / projet ouvert?
[ ] Base de données PostgreSQL running?
[ ] Terminal PowerShell ouvert?
[ ] VS Code / IDE prêt?
[ ] Documentation visuelle à côté (screenshots ASCII)?

→ SI OUI PARTOUT: Prêt à tester! Allez-y! 🚀
```

---

## 📞 RÉSUMÉ EN 1 LIGNE POUR CHAQUE DOC

| Doc | En 1 ligne |
|-----|----------|
| TEST_RAPIDE | Étapes exactes pour tester + donnés en base + checklist |
| ATTENDUS_VISUELS | Voyez UI ASCII ce quevous verrez + résultats attendus |
| GUIDE_TEST | URLs, requêtes SQL, pages app, débogage technique |
| CORRECTIONS | Quoi a changé, comment, qui a fait quoi |
| EXECUTION | Migration SQL + compilation + déploiement avant test |

---

**Bonne chance avec les tests! 🎉 N'hésitez pas à consulter ces docs!**
