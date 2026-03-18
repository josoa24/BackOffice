-- ============================================================
-- DONNÉES DE TEST - SPRINT 5 & 6
-- Date de test: 2026-03-20 (vendredi)
-- ============================================================

-- 1. VIDER LES DONNÉES EXISTANTES (dans l'ordre inverse des dépendances)
DELETE FROM assignation;
DELETE FROM reservation;
DELETE FROM vehicule;
DELETE FROM hotel;
DELETE FROM distance;
DELETE FROM parametre;

-- Réinitialiser les séquences
ALTER SEQUENCE assignation_id_assignation_seq RESTART WITH 1;
ALTER SEQUENCE reservation_id_reservation_seq RESTART WITH 1;
ALTER SEQUENCE vehicule_id_vehicule_seq RESTART WITH 1;
ALTER SEQUENCE hotel_id_hotel_seq RESTART WITH 1;
ALTER SEQUENCE distance_id_distance_seq RESTART WITH 1;
ALTER SEQUENCE parametre_id_parametre_seq RESTART WITH 1;

-- ============================================================
-- 2. PARAMÈTRES
-- ============================================================
INSERT INTO parametre (vitesse_moyenne_vehicule, temps_attente) VALUES (60, 30);

-- ============================================================
-- 3. HÔTELS et DISTANCES
-- ============================================================
INSERT INTO hotel (nom, code, libelle) VALUES
('Aéroport Ivato', 'AER', 'Point de départ'),
('Hotel Anjary', 'ANJ', 'Andohatapenaka'),
('Le Louvre', 'LOU', 'Antaninarenina'),
('Hotel Colbert', 'COL', 'Antaninarenina');

-- Distances depuis l'aéroport (id_from=1 car id_hotel auto commence à 1)
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(1, 2, 5.0),    -- Aéroport (1) -> Anjary (2) = 5 km → 10 km aller-retour
(1, 3, 7.0),    -- Aéroport (1) -> Le Louvre (3) = 7 km → 14 km aller-retour
(1, 4, 8.0);    -- Aéroport (1) -> Colbert (4) = 8 km → 16 km aller-retour

-- ============================================================
-- 4. VÉHICULES - Configuration pour Sprint 6
-- V1: 12 places diesel, pour tester priorité de capacité
-- V2: 5 places essence, 0 trajets (PRIORITÉ pour test)
-- V3: 5 places diesel, 0 trajets (diesel prioritaire vs essence)
-- V4: 8 places diesel, pour remplissage
-- ============================================================
INSERT INTO vehicule (marque, modele, immatriculation, capacite, carburant) VALUES
('Vehicule', '1', 'TAN-001', 12, 'diesel'),    -- id = 1
('Vehicule', '2', 'TAN-002', 5,  'essence'),   -- id = 2
('Vehicule', '3', 'TAN-003', 5,  'diesel'),    -- id = 3
('Vehicule', '4', 'TAN-004', 8,  'diesel');    -- id = 4

-- ============================================================
-- 5. RÉSERVATIONS SPRINT 5 - test regroupement temporel
-- Temps d'attente: 30 minutes (18h00 à 18h30)
-- 
-- Groupe 1 (départ à 18:32 - plus tardive):
--   - R1: 18:15, 5 passagers
--   - R2: 18:25, 8 passagers
--   - R3: 18:32, 6 passagers
-- 
-- Groupe 2 (après 18h30):
--   - R4: 18:50, 3 passagers (nouveau groupe)
-- ============================================================
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
-- Groupe 1: 18:15 - 18:45
(1001, 5,  '2026-03-20 18:15:00', 2),   -- R1: 5 passagers, Anjary
(1002, 8,  '2026-03-20 18:25:00', 2),   -- R2: 8 passagers, Anjary
(1003, 6,  '2026-03-20 18:32:00', 2),   -- R3: 6 passagers, Anjary (+ tardive)

-- Groupe 2: 18:50 onwards (nouveau groupe - après fenêtre 18:30)
(1004, 3,  '2026-03-20 18:50:00', 2);   -- R4: 3 passagers - NOUVEAU GROUPE

-- ============================================================
-- 6. RÉSERVATIONS SPRINT 6 - test sélection véhicules
-- Scénario: Sélection par ordre priorité
-- V2 (0 trajets) > V3 (0 trajets diesel) > V1 (capacité max)
-- ============================================================
-- INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
-- (2001, 5, '2026-03-20 10:00:00', 3),   -- 5 pax vers Le Louvre → V2 (5 places)
-- (2002, 8, '2026-03-20 10:05:00', 3),   -- 8 pax vers Le Louvre → V1 (12 places diesel)
-- (2003, 5, '2026-03-20 10:10:00', 3);   -- 5 pax vers Le Louvre → V3 (5 places diesel)

-- ============================================================
-- 7. DONNÉES DE TEST KILOMÉTRAGE
-- Distance * 2 (aller-retour) doit être sauvegardée
-- ============================================================
-- Anjary: 5 km → 10 km total
-- Le Louvre: 7 km → 14 km total
-- Colbert: 8 km → 16 km total

-- ============================================================
-- COMMENTAIRES POUR TESTER
-- ============================================================
-- 
-- SPRINT 5 TEST:
-- 1. Date: 2026-03-20
-- 2. Aller à: Assignation Form
-- 3. Vérifier réservations listées:
--    - R1: 18:15, 5 pax
--    - R2: 18:25, 8 pax
--    - R3: 18:32, 6 pax (plus tardive)
--    - R4: 18:50, 3 pax
-- 4. Lancer assignation
-- 5. RÉSULTAT ATTENDU:
--    - Trajet 1: départ 18:32 (R1+R2+R3 = 19 pax), véhicules V1 (12) + V2 (5) = 17... NON
--      → V1 (12) = R1(5) + R2(8), puis V2 (5) = R3(6)... NON, trop
--      → V1 (12) = R1(5) + R2(8) = 13 dépasse... 
--      → Correct: V1 (12) = R2(8) + R3(6) = 14 dépasse X
--      → Correct: V1 (12) = R1(5) + R2(8) ou V1 = R2(8) + partie R3? 
--      → Logique: Tri par taille décroissante (R2:8, R3:6, R1:5)
--      → V1 (12) = R2(8) + R1(5) = 13 > 12... non
--      → Ah, capacité exacte d'abord, puis avec plus petit
--      → V1 (12) peut prendre R2(8) + R1(5) = 13? Non
--      → V1 (12) peut prendre R2(8) + petit? R1(5) = 13, non
--      → V1 (12) peut prendre R3(6) + R2(8) = 14? Non
--      → V1 (12) peut prendre R1(5) + R2(8) = 13? Non
--      → Donc V1 (12) = R2(8), puis V2(5) = R1(5), puis V3(5) = R3(6)? Non, 6>5
--    - Trajet 2: départ 18:50 (R4, 3 pax)
--
-- SPRINT 6 TEST:
-- Vérifier ordre de sélection des véhicules dans les logs/interface
--
-- KILOMÉTRAGE:
-- Vérifier colonne "Kilométrage parcouru" dans página Trajets
-- Anjary: 10 km
