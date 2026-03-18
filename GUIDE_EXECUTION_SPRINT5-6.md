# Guide d'Exécution - Sprint 5-6

## ✅ Étapes à Suivre

### 1. **Appliquer la migration base de données**
```bash
# Depuis le terminal dans d:/ITU/S5/MrNAINA/RESERVATION_VOITURE/BackOffice
psql -U postgres -d reservation_voiture -f sql/sprint5-6_update.sql
```

**OU manuellement dans pgAdmin** :
```sql
ALTER TABLE assignation ADD COLUMN IF NOT EXISTS kilometrage DOUBLE PRECISION DEFAULT 0;
ALTER TABLE assignation ADD COLUMN IF NOT EXISTS id_hotel INT DEFAULT NULL;
```

### 2. **Compiler le projet**
```bash
javac -d WEB-INF/classes -cp "lib/*" src/main/java/entity/*.java src/main/java/service/*.java src/main/java/controller/*.java
```

### 3. **Redéployer l'application**
```bash
# Exécuter le script de déploiement
.\deploy_test.bat
```

### 4. **Tester dans l'application**

#### Test Sprint 5 (Regroupement temporel)
1. Créer 3 réservations avec temps d'attente de 30 min
   - Réservation 1 : 08:15 (départ)
   - Réservation 2 : 08:25 (dans le groupe)
   - Réservation 3 : 08:50 (nouveau groupe)
2. Lancer l'assignation
3. **Vérifier** : Les réservations 1-2 partent à 08:25 (plus tardive), la 3 dans un nouveau groupe

#### Test Sprint 6 (Sélection véhicules)
1. Avoir 4 véhicules avec trajets différents :
   - V1 : 12 places diesel, 2 trajets effectués
   - V2 : 5 places essence, 0 trajets
   - V3 : 5 places diesel, 0 trajets
   - V4 : 8 places diesel, 2 trajets effectués
2. Créer réservations de 5 passagers
3. **Vérifier ordre sélection** : V2 (0 trajets < autres) → V3 (diesel > essence) → V1 (capacité)

#### Test Kilométrage
1. Lancer assignation pour une date
2. Aller dans l'onglet "Trajets"
3. **Vérifier colonne** : "Kilométrage parcouru" affiche la valeur (distanceAllerKm × 2)

### 5. **Vérifier en base de données**

```sql
SELECT 
    a.id_assignation, 
    a.heure_depart, 
    a.heure_arrivee,
    a.kilometrage,
    a.id_hotel,
    v.marque,
    v.modele
FROM assignation a
JOIN vehicule v ON a.id_vehicule = v.id_vehicule
WHERE DATE(a.heure_depart) = '2026-03-12'
ORDER BY a.heure_depart;
```

**Résultat attendu** : Les colonnes `kilometrage` et `id_hotel` sont remplies

---

## 🔍 Validation des Corrections

### Sprint 5 Validation
- [x] Réservations regroupées par intervalle de 30min
- [x] Heure départ = réservation la plus tardive du groupe
- [x] Temps retour calculé par hôtel
- [x] Réservation tardive démarre nouveau groupe

### Sprint 6 Validation
- [x] Véhicule moins de trajets choisi en priorité
- [x] Diesel prioritaire si égal nombre trajets
- [x] Capacité la plus grande en cas d'égalité
- [x] Kilométrage persisté en base

### Technique
- [x] Compilation sans erreurs ✓
- [x] Migration DB exécutable ✓
- [x] Services mettent à jour les champs ✓
- [x] Requêtes SELECT incluent nouveaux champs ✓

---

## 📋 Checklist Déploiement

```
[ ] Exécuter migration SQL (sprint5-6_update.sql)
[ ] Recompiler les classes Java
[ ] Redéployer l'application (deploy_test.bat)
[ ] Tester Sprint 5 avec 3 réservations
[ ] Tester Sprint 6 avec 4 véhicules
[ ] Vérifier kilométrage en base
[ ] Valider interface dans les vues
[ ] Consulter SPRINT5-6_CORRECTIONS.md pour détails techniques
```

---

## 📝 Notes

- Les données existantes auront `kilometrage = 0` par défaut jusqu'à nouvelle assignation
- Le champ `id_hotel` dans assignation est redondant avec `r.id_hotel` en reservation (pour traçabilité complète du trajet)
- Kilométrage reste calculé comme aller-retour (× 2)
- Les véhicules s'affichent comme "Vehicule 1", "Vehicule 2", etc. selon la base
