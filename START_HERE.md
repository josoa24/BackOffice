# ⚡ SUPER RÉSUMÉ - 1 PAGE - LA MARCHE À SUIVRE

## 🎯 OBJECTIF
Tester Sprint 5 (regroupement temporel), Sprint 6 (sélection véhicules) et kilométrage.

---

## ✅ DONNÉES DÉJÀ INSÉRÉES EN BASE

**Date de test**: `2026-03-20`

**4 Véhicules**:
```
V1: Vehicule 1, 12 places, diesel
V2: Vehicule 2, 5 places, essence
V3: Vehicule 3, 5 places, diesel
V4: Vehicule 4, 8 places, diesel
```

**4 Réservations** (18h à 18h50):
```
R1: 18:15, 5 pax  → Hôtel Anjary (groupe 1)
R2: 18:25, 8 pax  → Hôtel Anjary (groupe 1)
R3: 18:32, 6 pax  → Hôtel Anjary (groupe 1) ← Plus tardive
R4: 18:50, 3 pax  → Hôtel Anjary (groupe 2) ← Hors fenêtre 30min
```

---

## 🚀 ÉTAPES À FAIRE

### ÉTAPE 1: Démarrer l'app (1 min)
```bash
cd d:\ITU\S5\MrNAINA\RESERVATION_VOITURE\BackOffice
.\deploy_test.bat
```

### ÉTAPE 2: Ouvrir navigateur (30 sec)
```
http://localhost:8080/reservation-voiture
```

### ÉTAPE 3a: TEST SPRINT 5 (5 min)
```
1. Menu → Assignation Form
2. Date: 2026-03-20
3. Vérifier: 4 réservations listées
   ✓ 18:15, 18:25, 18:32, 18:50
4. Bouton: "Assigner Automatiquement"
5. ATTENDRE LES RÉSULTATS...

RÉSULTAT ATTENDU:
─────────────────────────────────────
TRAJET 1:
  • Départ: 18:32 ← (R3, plus tardive!)
  • Contains: R1, R2, R3
  • Véhicule: V1 ou V2 ou V3
  • Kilométrage: 10 km
  
TRAJET 2:
  • Départ: 18:50 ← (R4, nouveau groupe)
  • Contains: R4 seule
  • Véhicule: V4
  • Kilométrage: 10 km
```

### ÉTAPE 3b: TEST SPRINT 6 (dans résultats ci-dessus)
```
Vérifier l'ordre de SÉLECTION des véhicules:
✓ TRAJET 1: V1 (12 places diesel) = meilleur score
✓ TRAJET 2: V4 (8 places diesel) = 2ème meilleur après V1

Ordre priorité tester:
1. Moins de trajets effectués
2. Diesel > Essence
3. Capacité plus grande
```

### ÉTAPE 3c: TEST KILOMÉTRAGE (2 min)
```
1. Dans la même page de résultats, colonne "Kilométrage"
2. Doit afficher: 10 km (pour Hôtel Anjary à 5km)
3. OU aller à: http://localhost:8080/.../sprint10.jsp
4. Date: 2026-03-20 
5. Vérifier colonne kilométrage = 10 km
```

### ÉTAPE 4: Vérifier en Base de Données (1 min)
```sql
-- Ouvrir terminal PostgreSQL:
psql -U postgres -d reservation_voiture

-- Coller cette requête:
SELECT id_assignation, heure_depart, kilometrage, id_hotel 
FROM assignation 
WHERE DATE(heure_depart) = '2026-03-20'
ORDER BY heure_depart;

-- RÉSULTAT ATTENDU:
id_assignation | heure_depart        | kilometrage | id_hotel
───────────────┼─────────────────────┼─────────────┼──────────
1              | 2026-03-20 18:32:00 | 10.0        | 2
2              | 2026-03-20 18:32:00 | 10.0        | 2
3              | 2026-03-20 18:32:00 | 10.0        | 2
4              | 2026-03-20 18:50:00 | 10.0        | 2

✓ Colonnes kilométrage et id_hotel NON-NULL
✓ Valeurs correctes (10.0 km)
```

---

## ✅ CHECKLIST FINAL

```
SPRINT 5 (Regroupement temporel):
[ ] Trajet 1 départ = 18:32 (plus tardive)
[ ] Trajet 1 regroupe R1, R2, R3
[ ] Fenêtre 30min respectée (18:00-18:30)
[ ] Trajet 2 = R4 (18:50, hors fenêtre)
[ ] Heures retour calculées OK (+ 10-20 min)

SPRINT 6 (Sélection véhicules):
[ ] Véhicules sélectionnés dans ordre priorité
[ ] Sprint 6 pas d'erreur "aucun véhicule"

KILOMÉTRAGE:
[ ] Colonne UI affiche 10 km
[ ] Base de données: kolométrage = 10.0
[ ] id_hotel = 2 (Anjary)
[ ] Pas NULL

FINAL:
[ ] SI TOUS ✓ = SPRINT 5-6 VALIDÉ! 🎉
```

---

## 🔥 SI QUELQUE CHOSE NE VA PAS

| Problème | Solution |
|----------|----------|
| Réservations ne s'affichent pas | Vérify date exacte: 2026-03-20 |
| Kilométrage = 0 ou NULL | SQL migration pas exécutée? Vérify: `\d assignation` en psql |
| Mauvais départ (pas 18:32) | Sprint 5 bug: devrait être la PLUS TARDIVE |
| Mauvais véhicule choisi | Sprint 6 bug: vérify ordre (trajets < diesel < capacité) |
| **Besoin d'aide?** | Lire: TEST_RAPIDE_SPRINT5-6.md ou GUIDE_TEST_SPRINT5-6.md |

---

## 📚 DOCUMENTS DISPONIBLES

- **INDEX_DOCUMENTS_SPRINT5-6.md** ← Navigation entre tous les docs
- **TEST_RAPIDE_SPRINT5-6.md** ← Étapes détaillées
- **ATTENDUS_VISUELS_SPRINT5-6.md** ← Screenshots ASCII
- **GUIDE_TEST_SPRINT5-6.md** ← Requêtes SQL + URLs
- **GUIDE_EXECUTION_SPRINT5-6.md** ← Déploiement
- **SPRINT5-6_CORRECTIONS.md** ← Aspect technique

**Bon test! 🚀**
