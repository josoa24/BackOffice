-- Jeu de test Sprint 7 STRICT
-- Objectif: verifier repartition partielle + report au prochain regroupement
-- Cas cible:
--   v1: 8 places, v2: 3 places
--   r1: 6, r2: 5, r3: 3, r4: 5

-- 0) Assurer schema Sprint 7
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
DELETE FROM hotel;
DELETE FROM distance;
DELETE FROM parametre;

ALTER SEQUENCE assignation_id_assignation_seq RESTART WITH 1;
ALTER SEQUENCE reservation_id_reservation_seq RESTART WITH 1;
ALTER SEQUENCE vehicule_id_vehicule_seq RESTART WITH 1;
ALTER SEQUENCE hotel_id_hotel_seq RESTART WITH 1;
ALTER SEQUENCE distance_id_distance_seq RESTART WITH 1;
ALTER SEQUENCE parametre_id_parametre_seq RESTART WITH 1;

-- 2) Parametres
INSERT INTO parametre (vitesse_moyenne_vehicule, temps_attente)
VALUES (60, 30);

-- 3) Hotels
INSERT INTO hotel (nom, code, libelle) VALUES
('Aeroport Ivato', 'AER', 'Point depart'),
('Hotel Anjary', 'ANJ', 'Destination test Sprint 7');

-- 4) Distance aeroport -> hotel (6 km)
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(1, 2, 6.0);

-- 5) Vehicules stricts
INSERT INTO vehicule (marque, modele, immatriculation, capacite, carburant) VALUES
('Vehicule', '1', 'SPR7-001', 8, 'diesel'),
('Vehicule', '2', 'SPR7-002', 3, 'essence');

-- 6) Reservations
-- Groupe 1 (TA 30 min): 08:00, 08:05, 08:10  -> depart groupe a 08:10
-- Groupe 2: 09:10 -> doit integrer les reports non assignes du groupe 1
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(7001, 6, '2026-03-21 08:00:00', 2), -- r1
(7002, 5, '2026-03-21 08:05:00', 2), -- r2
(7003, 3, '2026-03-21 08:10:00', 2), -- r3 (report)
(7004, 5, '2026-03-21 09:10:00', 2); -- r4
