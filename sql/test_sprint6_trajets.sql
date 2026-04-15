-- ============================================================
-- TEST SPRINT 6 - Gestion du nombre de trajets / priorite vehicules
-- Date de test: 2026-03-24
--
-- Objectifs verifies:
-- 1) Le moins de trajets est prioritaire meme si essence
-- 2) Si meme nb trajets, diesel prioritaire
--
-- Scenario:
--   Vehicule 1: 12 places, ESSENCE, 0 trajet
--   Vehicule 2: 12 places, DIESEL,  1 trajet deja effectue (06:00)
--   Vehicule 3: 8 places,  DIESEL,  0 trajet
--
-- Reservation principale:
--   Client 6001, 10 passagers a 08:30
--
-- Attendu planification:
--   Etape A (egalite nb trajets entre V1 et V3 -> diesel prioritaire):
--      V3 prend 8 passagers
--   Etape B (reste 2 passagers, V1=0 trajet vs V2=1 trajet):
--      V1 prend 2 passagers (moins de trajets meme essence)
-- ============================================================

-- 0) Compatibilite schema Sprint 7 (necessaire pour code actuel)
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

-- 1) Nettoyage
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
INSERT INTO parametre (vitesse_moyenne_vehicule, temps_attente)
VALUES (60, 30);

-- 3) Hotels + distance
INSERT INTO hotel (nom, code, libelle) VALUES
('Aeroport Ivato', 'AER', 'Point depart'),
('Hotel Anjary', 'ANJ', 'Destination test Sprint 6');

INSERT INTO distance (id_from, id_to, distance_km) VALUES
(1, 2, 6.0);

-- 4) Vehicules
INSERT INTO vehicule (marque, modele, immatriculation, capacite, carburant) VALUES
('Vehicule', '1', 'SP6-001', 12, 'essence'),
('Vehicule', '2', 'SP6-002', 12, 'diesel'),
('Vehicule', '3', 'SP6-003', 8,  'diesel');

-- 5) Reservation historique pour donner 1 trajet a Vehicule 2
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(6999, 4, '2026-03-24 06:00:00', 2);

INSERT INTO assignation (id_reservation, id_vehicule, heure_depart, heure_arrivee, kilometrage, id_hotel, nb_passagers_assignes)
VALUES (1, 2, '2026-03-24 06:00:00', '2026-03-24 06:12:00', 12.0, 2, 4);

-- 6) Reservation cible sprint 6
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(6001, 10, '2026-03-24 08:30:00', 2);

-- ============================================================
-- Verification apres planification (POST date=2026-03-24):
--
-- SELECT a.id_assignation, r.id_client, a.nb_passagers_assignes, r.nbPassager AS total_reservation,
--        v.modele AS vehicule, v.carburant,
--        TO_CHAR(a.heure_depart, 'HH24:MI') AS depart
-- FROM assignation a
-- JOIN reservation r ON r.id_reservation = a.id_reservation
-- JOIN vehicule v ON v.id_vehicule = a.id_vehicule
-- WHERE DATE(a.heure_depart)='2026-03-24'
-- ORDER BY a.heure_depart, a.id_assignation;
--
-- Attendu pour client 6001:
--   Vehicule 3 diesel: 8/10 (depart 08:30)
--   Vehicule 1 essence: 2/10 (depart 08:30)
-- ============================================================
