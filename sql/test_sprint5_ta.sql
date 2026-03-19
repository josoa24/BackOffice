-- ============================================================
-- TEST SPRINT 5 - Gestion du temps d'attente (TA)
-- Scenario cible:
--   TA = 30 minutes
--   r1: 08:15 (5 pax)
--   r2: 08:25 (8 pax)
--   r3: 08:32 (6 pax)
--   r4: 08:50 (3 pax)
-- Attendu:
--   Groupe 1 depart = 08:32 (r1,r2,r3)
--   Groupe 2 depart = 08:50 (r4)
-- ============================================================

-- 0) Nettoyage
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

-- 1) Parametres Sprint 5
-- TA = 30 minutes, vitesse = 60 km/h
INSERT INTO parametre (vitesse_moyenne_vehicule, temps_attente)
VALUES (60, 30);

-- 2) Hotels
-- id 1 = aeroport, id 2 = destination test
INSERT INTO hotel (nom, code, libelle) VALUES
('Aeroport Ivato', 'AER', 'Point depart'),
('Hotel Anjary', 'ANJ', 'Destination Sprint 5');

-- 3) Distance aeroport -> hotel
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(1, 2, 6.0);

-- 4) Vehicules disponibles (4 vehicules)
INSERT INTO vehicule (marque, modele, immatriculation, capacite, carburant) VALUES
('Vehicule', '1', 'SP5-001', 12, 'diesel'),
('Vehicule', '2', 'SP5-002', 8,  'essence'),
('Vehicule', '3', 'SP5-003', 6,  'diesel'),
('Vehicule', '4', 'SP5-004', 5,  'essence');

-- 5) Reservations de test Sprint 5 (date: 2026-03-23)
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(5001, 5, '2026-03-23 08:15:00', 2),
(5002, 8, '2026-03-23 08:25:00', 2),
(5003, 6, '2026-03-23 08:32:00', 2),
(5004, 3, '2026-03-23 08:50:00', 2);

-- ============================================================
-- Verification manuelle (apres planification web)
-- URL:
--   http://localhost:8080/BackOffice/assignation-planifier   (POST date=2026-03-23)
--   http://localhost:8080/BackOffice/assignation-form?date=2026-03-23
--
-- SQL de verification groupes:
 SELECT a.heure_depart,
       COUNT(*) AS nb_lignes_assignation,
        SUM(a.nb_passagers_assignes) AS total_pax_assignes,
        STRING_AGG('C' || r.id_client::text || '(' || a.nb_passagers_assignes || ')', ', ' ORDER BY r.dateHeure) AS details
 FROM assignation a
 JOIN reservation r ON r.id_reservation = a.id_reservation
 WHERE DATE(a.heure_depart) = '2026-03-23'
 GROUP BY a.heure_depart
 ORDER BY a.heure_depart;

-- Attendu:
--   08:32 -> clients 5001,5002,5003
--   08:50 -> client 5004
-- ============================================================
