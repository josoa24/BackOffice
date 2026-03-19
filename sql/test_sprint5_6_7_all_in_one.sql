-- ============================================================
-- TEST GLOBAL SPRINT 5 + 6 + 7 (jeu unique)
-- Date cible: 2026-03-27
--
-- Couvre en meme temps:
-- Sprint 5: regroupement par TA (<= 30 min meme groupe, > 30 nouveau groupe)
-- Sprint 6: choix vehicule par ratio capacite/(trajets+1), puis moins de trajets,
--           puis diesel, puis aleatoire si egalite complete
-- Sprint 7: split de reservation + report au prochain groupe meme hotel
--
-- IMPORTANT:
-- 1) Lancer ce script
-- 2) Planifier via l'application pour date=2026-03-27
-- 3) Lancer le script de verification associe
-- ============================================================

BEGIN;

-- 0) Compatibilite schema Sprint 7
ALTER TABLE assignation ADD COLUMN IF NOT EXISTS nb_passagers_assignes INT;

UPDATE assignation a
SET nb_passagers_assignes = r.nbPassager
FROM reservation r
WHERE r.id_reservation = a.id_reservation
  AND a.nb_passagers_assignes IS NULL;

ALTER TABLE assignation DROP CONSTRAINT IF EXISTS uk_assignation_reservation;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'chk_assignation_nb_passagers_assignes_positive'
  ) THEN
    ALTER TABLE assignation
    ADD CONSTRAINT chk_assignation_nb_passagers_assignes_positive
    CHECK (nb_passagers_assignes > 0);
  END IF;
END $$;

-- 1) Nettoyage complet
DELETE FROM assignation;
DELETE FROM reservation;
DELETE FROM vehicule;
DELETE FROM distance;
DELETE FROM hotel;
DELETE FROM parametre;

ALTER SEQUENCE assignation_id_assignation_seq RESTART WITH 1;
ALTER SEQUENCE reservation_id_reservation_seq RESTART WITH 1;
ALTER SEQUENCE vehicule_id_vehicule_seq RESTART WITH 1;
ALTER SEQUENCE distance_id_distance_seq RESTART WITH 1;
ALTER SEQUENCE hotel_id_hotel_seq RESTART WITH 1;
ALTER SEQUENCE parametre_id_parametre_seq RESTART WITH 1;

-- 2) Parametres
-- TA = 30 min, vitesse = 60 km/h
INSERT INTO parametre (vitesse_moyenne_vehicule, temps_attente)
VALUES (60, 30);

-- 3) Hotels
-- id=1 aeroport (obligatoire pour le service)
-- id=2 hotel principal (cas Sprint 5/6/7)
-- id=3 hotel tie-break random (Sprint 6 regle 4)
INSERT INTO hotel (nom, code, libelle) VALUES
('Aeroport Ivato', 'AER', 'Point depart et retour'),
('Hotel Anjary', 'ANJ', 'Hotel principal des cas metier'),
('Hotel Randomia', 'RND', 'Hotel pour egalite complete');

-- 4) Distances depuis aeroport
-- 1->2 = 6 km (aller), A/R = 12 km, duree A/R = 12 min a 60 km/h
-- 1->3 = 8 km (aller), A/R = 16 km, duree A/R = 16 min a 60 km/h
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(1, 2, 6.0),
(1, 3, 8.0);

-- 5) Vehicules
-- V1/V2: meme capacite + meme carburant pour permettre random final (regle 4)
-- V3: diesel 8 places pour priorite diesel (regle 3)
-- V4: diesel 3 places pour split/reports (Sprint 7)
INSERT INTO vehicule (marque, modele, immatriculation, capacite, carburant) VALUES
('Vehicule', '1', 'ALL-001', 8, 'essence'),
('Vehicule', '2', 'ALL-002', 8, 'essence'),
('Vehicule', '3', 'ALL-003', 8, 'diesel'),
('Vehicule', '4', 'ALL-004', 3, 'diesel');

-- 6) Reservation historique pour injecter nb trajets initial
-- Donne 1 trajet pre-existant a V2 le jour de test, avant les autres vols.
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(8999, 3, '2026-03-27 06:00:00', 2);

INSERT INTO assignation (id_reservation, id_vehicule, heure_depart, heure_arrivee, kilometrage, id_hotel, nb_passagers_assignes)
VALUES (1, 2, '2026-03-27 06:00:00', '2026-03-27 06:12:00', 12.0, 2, 3);

-- 7) Reservations cibles (ordre voulu par metier)
--
-- GROUPE A (Sprint 5): 08:00, 08:20, 08:30 -> depart groupe attendu 08:30
--   - r2=9 pax force split (Sprint 7)
--   - r3=4 pax peut etre report si capacite indisponible
--
-- GROUPE B (Sprint 5): 09:10 (> 30 min de 08:30) -> nouveau groupe, absorbe reports
--
-- CAS RANDOM (Sprint 6 regle 4): 10:15 hotel 3
--   V1 et V2 peuvent arriver en egalite complete apres les trajets precedents.
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(8101, 6, '2026-03-27 08:00:00', 2),
(8102, 9, '2026-03-27 08:20:00', 2),
(8103, 4, '2026-03-27 08:30:00', 2),
(8104, 5, '2026-03-27 09:10:00', 2),
(8301, 4, '2026-03-27 10:15:00', 3);

COMMIT;

-- ============================================================
-- Notes d'attendus metier (verification via script dedie):
--
-- Sprint 5:
-- - Deux departs distincts sur hotel 2: 08:30 puis 09:10
--
-- Sprint 6:
-- - Le calcul du nombre de trajets influence le choix (V2 part avec +1 trajet)
-- - A egalite de ratio et trajets, diesel prioritaire
-- - A egalite complete (capacite, trajets, carburant), random entre finalistes
--
-- Sprint 7:
-- - Reservation 8102 (9 pax) doit etre split sur plusieurs lignes assignation
-- - Si capacite indisponible au groupe 08:30, une partie est reportee sur 09:10
-- ============================================================
