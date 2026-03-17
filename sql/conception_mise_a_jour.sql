-- Sprint 6 : Ajout du compteur de trajets sur les véhicules
ALTER TABLE vehicule
ADD COLUMN IF NOT EXISTS nombre_trajets INT DEFAULT 0;

-- Sprint 6 : Création de la table pour gérer les trajets
CREATE TABLE IF NOT EXISTS trajet (
    id_trajet SERIAL PRIMARY KEY,
    id_vehicule INT REFERENCES vehicule(id_vehicule),
    heure_depart_aeroport TIMESTAMP,
    heure_retour_aeroport TIMESTAMP,
    kilometrage_parcouru DOUBLE PRECISION,
    date_trajet DATE DEFAULT CURRENT_DATE
);

-- Table de liaison pour associer les réservations à un trajet
CREATE TABLE IF NOT EXISTS trajet_reservations (
    id_trajet INT REFERENCES trajet(id_trajet),
    id_reservation INT REFERENCES reservation(id_reservation),
    PRIMARY KEY (id_trajet, id_reservation)
);


--- DONNÉES DE TEST ---

-- Vider les tables pour repartir de zéro avec les tests
DELETE FROM trajet_reservations;
DELETE FROM trajet;
DELETE FROM assignation;
DELETE FROM reservation;
DELETE FROM vehicule;
DELETE FROM hotel;
DELETE FROM distance;

-- Réinitialiser les séquences
ALTER SEQUENCE vehicule_id_vehicule_seq RESTART WITH 1;
ALTER SEQUENCE hotel_id_hotel_seq RESTART WITH 1;
ALTER SEQUENCE distance_id_distance_seq RESTART WITH 1;
ALTER SEQUENCE reservation_id_reservation_seq RESTART WITH 1;
ALTER SEQUENCE trajet_id_trajet_seq RESTART WITH 1;


-- 1. Hôtels et Distances
-- On considère que l'aéroport a l'id 0, même s'il n'est pas dans la table hotel.
INSERT INTO hotel (nom, code, libelle) VALUES
('Hotel Anjary', 'ANJ', 'Andohatapenaka'),
('Le Louvre', 'LOU', 'Antaninarenina'),
('Hotel Colbert', 'COL', 'Antaninarenina');

-- L'aéroport n'est pas dans la table hotel, on utilise 0 comme convention
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(0, 1, 5.2),  -- Aéroport vers Anjary
(0, 2, 7.8),  -- Aéroport vers Le Louvre
(0, 3, 8.0);  -- Aéroport vers Colbert


-- 2. Véhicules de test (Sprint 6)
-- On met des compteurs de trajets différents pour tester la priorisation
-- Note: l'immatriculation doit être unique
INSERT INTO vehicule (marque, modele, immatriculation, capacite, carburant, nombre_trajets) VALUES
('Renault Express', 'Van', '1001-TBA', 4, 'essence', 1),
('Mercedes Sprinter', 'Minibus', '1002-TBA', 8, 'diesel', 0),
('Toyota Hiace', 'Minibus', '1003-TBA', 6, 'essence', 0),
('Ford Transit', 'Minibus', '1004-TBA', 8, 'diesel', 1);


-- 3. Réservations de test (Sprint 5)
-- Scénario : Temps d'attente de 30 minutes
-- Groupe 1 : vols arrivant entre 8h15 et 8h45
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(1001, 5, '2026-03-17 08:15:00', 1), -- Premier vol, déclenche l'attente jusqu'à 8h45
(1002, 8, '2026-03-17 08:25:00', 2), -- Dans l'intervalle
(1003, 6, '2026-03-17 08:32:00', 3); -- Dans l'intervalle, le départ se fera à 8h32

-- Ne fait pas partie du premier groupe car arrive après 8h45
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(1004, 4, '2026-03-17 08:50:00', 1);

-- Groupe 2 : commence un nouvel intervalle
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(1005, 3, '2026-03-17 09:15:00', 2);

-- Réservation qui ne pourra pas être assignée (capacité trop grande)
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(1006, 12, '2026-03-17 10:00:00', 3);

