-- ============================================================
-- DONNEES TEST ALEATOIRES - SCENARIO METIER DEMANDE
-- Date cible : 2026-03-19
-- Usage : psql -U postgres -d reservation_voiture -f sql/DATA_ALEA.sql
-- ============================================================

BEGIN;

-- 0) Compatibilite schema actuel
ALTER TABLE vehicule ADD COLUMN IF NOT EXISTS nombre_trajets INT NOT NULL DEFAULT 0;
ALTER TABLE vehicule ADD COLUMN IF NOT EXISTS heure_debut_disponibilite TIME NOT NULL DEFAULT '00:00:00';
ALTER TABLE hotel ADD COLUMN IF NOT EXISTS code VARCHAR(10);
ALTER TABLE hotel ADD COLUMN IF NOT EXISTS libelle VARCHAR(100);

-- 1) Nettoyage des donnees de test
DELETE FROM assignation;
DELETE FROM reservation;
DELETE FROM distance;
DELETE FROM vehicule;
DELETE FROM hotel;
DELETE FROM parametre;

ALTER SEQUENCE assignation_id_assignation_seq RESTART WITH 1;
ALTER SEQUENCE reservation_id_reservation_seq RESTART WITH 1;
ALTER SEQUENCE distance_id_distance_seq RESTART WITH 1;
ALTER SEQUENCE vehicule_id_vehicule_seq RESTART WITH 1;
ALTER SEQUENCE hotel_id_hotel_seq RESTART WITH 1;
ALTER SEQUENCE parametre_id_parametre_seq RESTART WITH 1;

-- 2) Parametre
-- TA=30 min, vitesse moyenne=50 km/h
INSERT INTO parametre (vitesse_moyenne_vehicule, temps_attente)
VALUES (50, 30);

-- 3) Hotels
-- id=1 aeroport, id=2 hotel1, id=3 hotel2
INSERT INTO hotel (nom, code, libelle) VALUES
('Aeroport Ivato', 'AER', 'Point depart/retour'),
('Hotel 1', 'H1', 'Hotel destination 1'),
('Hotel 2', 'H2', 'Hotel destination 2');

-- 4) Distances (km)
-- aeroport -> hotel1 = 90
-- aeroport -> hotel2 = 35
-- hotel1 -> hotel2 = 60
-- On stocke les deux sens pour fiabiliser les calculs.
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(1, 2, 90.0),
(2, 1, 90.0),
(1, 3, 35.0),
(3, 1, 35.0),
(2, 3, 60.0),
(3, 2, 60.0);

-- 5) Vehicules
-- vehicule1 5 places diesel 00:00
-- vehicule2 5 places essence 00:00
-- vehicule3 12 places diesel 00:00
-- vehicule4 9 places diesel 00:00
-- vehicule5 12 places essence 13:00
INSERT INTO vehicule (
    marque,
    modele,
    immatriculation,
    capacite,
    carburant,
    nombre_trajets,
    heure_debut_disponibilite
) VALUES
('Vehicule', '1', 'ALEA-001',  5, 'diesel',  0, '00:00:00'),
('Vehicule', '2', 'ALEA-002',  5, 'essence', 0, '00:00:00'),
('Vehicule', '3', 'ALEA-003', 12, 'diesel',  0, '00:00:00'),
('Vehicule', '4', 'ALEA-004',  9, 'diesel',  0, '00:00:00'),
('Vehicule', '5', 'ALEA-005', 12, 'essence', 0, '13:00:00');

-- 6) Reservations
-- client1: 7  19/03/2026 09:00:00 hotel1
-- client2: 20 19/03/2026 08:00:00 hotel2
-- client3: 3  19/03/2026 09:10:00 hotel1
-- client4: 10 19/03/2026 09:15:00 hotel1
-- client5: 5  19/03/2026 09:20:00 hotel1
-- client6: 12 19/03/2026 09:30:00 hotel1
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(7001,  7, '2026-03-19 09:00:00', 2),
(7002, 20, '2026-03-19 08:00:00', 3),
(7003,  3, '2026-03-19 09:10:00', 2),
(7004, 10, '2026-03-19 09:15:00', 2),
(7005,  5, '2026-03-19 09:20:00', 2),
(7006, 12, '2026-03-19 09:30:00', 2);

COMMIT;

-- Verification rapide
-- SELECT id_hotel, nom, code FROM hotel ORDER BY id_hotel;
-- SELECT id_vehicule, marque, modele, capacite, carburant, nombre_trajets, heure_debut_disponibilite FROM vehicule ORDER BY id_vehicule;
-- SELECT id_reservation, id_client, nbPassager, dateHeure, id_hotel FROM reservation ORDER BY dateHeure;