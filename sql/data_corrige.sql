-- ============================================================
-- DONNEES VERSION FINALE - Sprint 3 & Sprint 4
-- Base : reservation_voiture (PostgreSQL)
-- ============================================================
-- PREREQUIS : Exécuter conception_version_final.sql d'abord
-- ============================================================

-- Nettoyage des données existantes (dans l'ordre des dépendances)
DELETE FROM assignation;
DELETE FROM distance;
DELETE FROM reservation;
DELETE FROM vehicule;
DELETE FROM parametre;
DELETE FROM hotel;

-- Réinitialiser les séquences pour avoir des IDs prévisibles
ALTER SEQUENCE hotel_id_hotel_seq RESTART WITH 1;
ALTER SEQUENCE reservation_id_reservation_seq RESTART WITH 1;
ALTER SEQUENCE vehicule_id_vehicule_seq RESTART WITH 1;
ALTER SEQUENCE parametre_id_parametre_seq RESTART WITH 1;
ALTER SEQUENCE distance_id_distance_seq RESTART WITH 1;
ALTER SEQUENCE assignation_id_assignation_seq RESTART WITH 1;

-- ============================================================
-- 1. HOTELS
--    id_hotel = 1 : Aéroport Ivato (point de départ)
--    id_hotel = 2..5 : Hôtels destinations
-- ============================================================
INSERT INTO hotel (nom, code, libelle) VALUES
('Aéroport Ivato',     'APT-01', 'Aéroport Ivato'),     -- id = 1
('Hotel La Plage',     'HOT-02', 'La Plage'),            -- id = 2
('Hotel Montagne',     'HOT-03', 'Montagne'),            -- id = 3
('Hotel Centre Ville', 'HOT-04', 'Centre Ville'),        -- id = 4
('Hotel Colbert',      'HOT-05', 'Colbert');              -- id = 5

-- ============================================================
-- 2. PARAMETRE (configuration système)
--    vitesse_moyenne_vehicule = 60 km/h
--    temps_attente = 30 minutes
-- ============================================================
INSERT INTO parametre (vitesse_moyenne_vehicule, temps_attente) VALUES (60, 30);

-- ============================================================
-- 3. VEHICULES
--    6 véhicules de capacités variées, diesel et essence
--    Pour tester les règles de sélection Sprint 3
-- ============================================================
INSERT INTO vehicule (marque, modele, immatriculation, capacite, carburant) VALUES
('Renault',  'Master',   'TAN-7890', 8,  'essence'),   -- id = 1
('Ford',     'Transit',  'TAN-2345', 10, 'diesel'),     -- id = 2
('Hyundai',  'H350',     'TAN-9012', 12, 'essence'),    -- id = 3
('Toyota',   'HiAce',    'TAN-1234', 15, 'diesel'),     -- id = 4
('Mercedes', 'Sprinter', 'TAN-5678', 18, 'diesel'),     -- id = 5
('Toyota',   'Coaster',  'TAN-3456', 25, 'diesel');     -- id = 6

-- ============================================================
-- 4. DISTANCES (depuis l'Aéroport id=1 vers chaque hôtel)
--    Le plus proche : Centre Ville (5 km)
--    Puis : Colbert (8 km), La Plage (12.5 km), Montagne (20 km)
-- ============================================================
-- Aller (Aéroport → Hôtels)
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(1, 2, 12.5),   -- Aéroport → La Plage : 12.5 km
(1, 3, 20.0),   -- Aéroport → Montagne : 20 km
(1, 4, 5.0),    -- Aéroport → Centre Ville : 5 km (le plus proche)
(1, 5, 8.0);    -- Aéroport → Colbert : 8 km

-- Retour (Hôtels → Aéroport) - symétrique
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(2, 1, 12.5),   -- La Plage → Aéroport
(3, 1, 20.0),   -- Montagne → Aéroport
(4, 1, 5.0),    -- Centre Ville → Aéroport
(5, 1, 8.0);    -- Colbert → Aéroport

-- ============================================================
-- 5. RESERVATIONS DE TEST
--    Date : 2026-03-12 (aujourd'hui)
--    Scénarios de test :
--
-- GROUPE 1 : Centre Ville (id_hotel=4, 5 km) = le plus proche
--   Résa 1 : client 1001, 5 passagers, 08:30
--   Résa 2 : client 1002, 3 passagers, 08:30
--   → Total = 8 passagers, inséparables (même hôtel)
--   → Véhicule attendu : Renault Master (8 places, essence)
--     ou Ford Transit (10 places, diesel)
--     Règle : capacité la plus proche = 8, donc Renault Master
--
-- GROUPE 2 : Colbert (id_hotel=5, 8 km)
--   Résa 6 : client 1006, 2 passagers, 10:00
--   → Véhicule attendu : le plus petit ayant >= 2 places restantes
--
-- GROUPE 3 : La Plage (id_hotel=2, 12.5 km)
--   Résa 3 : client 1003, 7 passagers, 09:00
--   Résa 5 : client 1005, 6 passagers, 09:30
--   → Total = 13 passagers, inséparables (même hôtel)
--   → Véhicule attendu : Toyota HiAce (15 places, diesel)
--
-- GROUPE 4 : Montagne (id_hotel=3, 20 km) = le plus éloigné
--   Résa 4 : client 1004, 4 passagers, 09:00
--   → Véhicule attendu : dépend de ce qui reste
-- ============================================================
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES 
(1001, 5, '2026-03-12 08:30:00', 4),  -- Résa 1 : Centre Ville, 5 passagers
(1002, 3, '2026-03-12 08:30:00', 4),  -- Résa 2 : Centre Ville, 3 passagers (inséparable avec résa 1)
(1003, 7, '2026-03-12 09:00:00', 2),  -- Résa 3 : La Plage, 7 passagers
(1004, 4, '2026-03-12 09:00:00', 3),  -- Résa 4 : Montagne, 4 passagers
(1005, 6, '2026-03-12 09:30:00', 2),  -- Résa 5 : La Plage, 6 passagers (inséparable avec résa 3)
(1006, 2, '2026-03-12 10:00:00', 5);  -- Résa 6 : Colbert, 2 passagers

-- ============================================================
-- RÉSULTATS ATTENDUS après planification automatique :
--
-- Ordre de traitement (par distance croissante depuis l'aéroport) :
--   1. Centre Ville (5 km)  → 8 passagers → Renault Master (8 places)
--   2. Colbert (8 km)       → 2 passagers → le plus petit restant avec >= 2 places
--   3. La Plage (12.5 km)   → 13 passagers → Toyota HiAce (15 places, diesel)
--   4. Montagne (20 km)     → 4 passagers → dépend de ce qui reste
--
-- Calcul des heures (vitesse=60 km/h, temps_attente=30 min) :
--   Centre Ville : départ=08:30+30min=09:00, route=5/60*60=5min, arrivée=09:05
--   Colbert :      départ=10:00+30min=10:30, route=8/60*60=8min, arrivée=10:38
--   La Plage :     départ=09:00+30min=09:30, route=12.5/60*60=13min, arrivée=09:43
--   Montagne :     départ=09:00+30min=09:30, route=20/60*60=20min, arrivée=09:50
-- ============================================================
