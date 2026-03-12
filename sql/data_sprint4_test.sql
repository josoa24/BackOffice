-- ============================================================
-- DONNEES DE TEST - Sprint 4 (overflow)
-- Tous les clients : même heure (9h), même destination (Hotel La Plage)
-- Base : reservation_voiture (PostgreSQL)
-- ============================================================
-- PREREQUIS : Exécuter reset_database.sql puis conception_version_final.sql
-- ============================================================

-- ============================================================
-- 1. HOTELS
-- ============================================================
INSERT INTO hotel (nom, code, libelle) VALUES
('Aéroport Ivato',     'APT-01', 'Aéroport Ivato'),     -- id = 1
('Hotel La Plage',     'HOT-02', 'La Plage');            -- id = 2

-- ============================================================
-- 2. PARAMETRE
--    vitesse_moyenne = 50 km/h
--    temps_attente = 30 minutes
-- ============================================================
INSERT INTO parametre (vitesse_moyenne_vehicule, temps_attente) VALUES (50, 30);

-- ============================================================
-- 3. DISTANCES
--    Aéroport (id=1) <-> Hotel La Plage (id=2) : 50 km
-- ============================================================
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(1, 2, 50),   -- Aéroport -> Hotel La Plage
(2, 1, 50);   -- Hotel La Plage -> Aéroport

-- ============================================================
-- 4. VEHICULES
--    v1 : 12 places diesel
--    v2 : 5 places essence
--    v3 : 5 places diesel
--    v4 : 12 places essence
-- ============================================================
INSERT INTO vehicule (marque, modele, immatriculation, capacite, carburant) VALUES
('Vehicule', '1', 'TAN-001', 12, 'diesel'),    -- id = 1
('Vehicule', '2', 'TAN-002', 5,  'essence'),   -- id = 2
('Vehicule', '3', 'TAN-003', 5,  'diesel'),    -- id = 3
('Vehicule', '4', 'TAN-004', 12, 'essence');   -- id = 4

-- ============================================================
-- 5. RESERVATIONS
--    6 clients, tous à 09:00, tous vers Hotel La Plage (id=2)
--    Total passagers = 7 + 11 + 3 + 1 + 2 + 20 = 44
--
--    client 1 : 7 passagers
--    client 2 : 11 passagers
--    client 3 : 3 passagers
--    client 4 : 1 passager
--    client 5 : 2 passagers
--    client 6 : 20 passagers
-- ============================================================
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(1001, 7,  '2026-03-12 09:00:00', 2),   -- client 1 : 7 passagers
(1002, 11, '2026-03-12 09:00:00', 2),   -- client 2 : 11 passagers
(1003, 3,  '2026-03-12 09:00:00', 2),   -- client 3 : 3 passagers
(1004, 1,  '2026-03-12 09:00:00', 2),   -- client 4 : 1 passager
(1005, 2,  '2026-03-12 09:00:00', 2),   -- client 5 : 2 passagers
(1006, 20, '2026-03-12 09:00:00', 2);   -- client 6 : 20 passagers
