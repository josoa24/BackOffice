-- ============================================================
-- TEST SPRINT 7 - Repartition partielle + report prochain regroupement
-- Date de test: 2026-03-25
--
-- Scenario strict:
--   Vehicules:
--     V1 = 8 places
--     V2 = 3 places
--   Reservations:
--     r1 = 6 passagers (08:00)
--     r2 = 5 passagers (08:05)
--     r3 = 3 passagers (08:10)
--     r4 = 5 passagers (09:10)
--   TA = 30 min
--
-- Attendu:
--   Groupe 08:10:
--     V1 <- r1 = 6
--     V1 <- r2 = 2 (V1 complet)
--     V2 <- r2 = 3 (V2 complet)
--     r3 reste 3 (report)
--   Groupe 09:10:
--     report r3(3) + r4(5) => V1 prend 5 (r4), puis 3 (r3)
-- ============================================================

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
('Hotel Anjary', 'ANJ', 'Destination test Sprint 7');

INSERT INTO distance (id_from, id_to, distance_km) VALUES
(1, 2, 6.0);

-- 4) Vehicules stricts
INSERT INTO vehicule (marque, modele, immatriculation, capacite, carburant) VALUES
('Vehicule', '1', 'SP7-001', 8, 'diesel'),
('Vehicule', '2', 'SP7-002', 3, 'essence');

-- 5) Reservations strictes
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(7001, 6, '2026-03-25 08:00:00', 2),
(7002, 5, '2026-03-25 08:05:00', 2),
(7003, 3, '2026-03-25 08:10:00', 2),
(7004, 5, '2026-03-25 09:10:00', 2);

-- ============================================================
-- Verification apres planification (POST date=2026-03-25):
--
-- SELECT a.id_assignation, r.id_client, a.nb_passagers_assignes, r.nbPassager AS total_reservation,
--        v.modele AS vehicule, v.capacite,
--        TO_CHAR(a.heure_depart, 'HH24:MI') AS depart
-- FROM assignation a
-- JOIN reservation r ON r.id_reservation = a.id_reservation
-- JOIN vehicule v ON v.id_vehicule = a.id_vehicule
-- WHERE DATE(a.heure_depart)='2026-03-25'
-- ORDER BY a.heure_depart, a.id_assignation;
--
-- Attendu visuel interface:
--   client 7001: 6/6
--   client 7002: 2/5
--   client 7002: 3/5
--   client 7004: 5/5
--   client 7003: 3/3
-- ============================================================
