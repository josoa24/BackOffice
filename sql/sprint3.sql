-- Sprint 3-4 : Ajout Parametre, Distance, Vehicule, Assignation
-- Vérifier si les tables existent déjà, sinon les créer

-- Modifier la table hotel pour ajouter le code et libelle
ALTER TABLE hotel ADD COLUMN IF NOT EXISTS code VARCHAR(10);
ALTER TABLE hotel ADD COLUMN IF NOT EXISTS libelle VARCHAR(100);

-- Table Parametre (configuration système)
CREATE TABLE IF NOT EXISTS parametre (
    id_parametre SERIAL PRIMARY KEY,
    vitesse_moyenne_vehicule INT NOT NULL DEFAULT 60,  -- km/h
    temps_attente INT NOT NULL DEFAULT 30  -- minutes
);

-- Insérer les paramètres par défaut (si table vide)
INSERT INTO parametre (vitesse_moyenne_vehicule, temps_attente)
SELECT 60, 30 WHERE NOT EXISTS (SELECT 1 FROM parametre);

-- Table Vehicule (si pas encore créée via database.sql on la recrée proprement)
DROP TABLE IF EXISTS assignation;
DROP TABLE IF EXISTS vehicule CASCADE;

CREATE TABLE IF NOT EXISTS vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    marque VARCHAR(50) NOT NULL,
    modele VARCHAR(50) NOT NULL,
    immatriculation VARCHAR(20) UNIQUE NOT NULL,
    capacite INT NOT NULL,
    carburant VARCHAR(20) NOT NULL DEFAULT 'essence' -- 'diesel' ou 'essence'
);

-- Table Distance entre hotels/aéroport
CREATE TABLE IF NOT EXISTS distance (
    id_distance SERIAL PRIMARY KEY,
    id_from INT NOT NULL,
    id_to INT NOT NULL,
    distance_km DOUBLE PRECISION NOT NULL,
    FOREIGN KEY (id_from) REFERENCES hotel(id_hotel),
    FOREIGN KEY (id_to) REFERENCES hotel(id_hotel)
);

-- Table Assignation (lien entre reservation et vehicule)
CREATE TABLE IF NOT EXISTS assignation (
    id_assignation SERIAL PRIMARY KEY,
    id_reservation INT NOT NULL,
    id_vehicule INT NOT NULL,
    heure_depart TIMESTAMP NOT NULL,
    heure_arrivee TIMESTAMP NOT NULL,
    FOREIGN KEY (id_reservation) REFERENCES reservation(id_reservation),
    FOREIGN KEY (id_vehicule) REFERENCES vehicule(id_vehicule)
);

-- =============================================
-- DONNÉES DE TEST
-- =============================================

-- Hôtels : id=1 = Aéroport (point de départ), id=2..5 = Hôtels destinations
DELETE FROM distance;
DELETE FROM assignation;

-- Mettre à jour les hotels avec code et libelle
-- Hotel 1 = Aéroport Ivato (point de départ de tous les trajets)
UPDATE hotel SET code = 'APT-01', libelle = 'Aéroport Ivato' WHERE id_hotel = 1;
UPDATE hotel SET code = 'HOT-02', libelle = 'La Plage' WHERE id_hotel = 2;
UPDATE hotel SET code = 'HOT-03', libelle = 'Montagne' WHERE id_hotel = 3;
UPDATE hotel SET code = 'HOT-04', libelle = 'Centre Ville' WHERE id_hotel = 4;

-- Ajouter un 5ème hôtel si n'existe pas
INSERT INTO hotel (nom, code, libelle)
SELECT 'Hotel Colbert', 'HOT-05', 'Colbert'
WHERE NOT EXISTS (SELECT 1 FROM hotel WHERE nom = 'Hotel Colbert');

-- Données de test pour les vehicules
INSERT INTO vehicule (marque, modele, immatriculation, capacite, carburant) VALUES
('Renault', 'Master', 'TAN-7890', 8, 'essence'),
('Ford', 'Transit', 'TAN-2345', 10, 'diesel'),
('Hyundai', 'H350', 'TAN-9012', 12, 'essence'),
('Toyota', 'HiAce', 'TAN-1234', 15, 'diesel'),
('Mercedes', 'Sprinter', 'TAN-5678', 18, 'diesel'),
('Toyota', 'Coaster', 'TAN-3456', 25, 'diesel');

-- Distances depuis l'Aéroport (id=1) vers chaque hôtel
-- Triées : le plus proche en premier
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(1, 4, 5.0),   -- Aéroport → Centre Ville : 5 km (le plus proche)
(1, 2, 12.5),  -- Aéroport → La Plage : 12.5 km
(1, 3, 20.0),  -- Aéroport → Montagne : 20 km
(1, 5, 8.0);   -- Aéroport → Colbert : 8 km (si hotel 5 existe)

-- Distances retour (symétrique)
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(4, 1, 5.0),
(2, 1, 12.5),
(3, 1, 20.0),
(5, 1, 8.0);

-- Réservations de test pour aujourd'hui (non assignées)
-- Plusieurs clients vers le même hôtel = clients inséparables
DELETE FROM reservation;
INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(1001, 5, '2026-03-12 08:30:00', 4),  -- Centre Ville (5 km) - 5 passagers
(1002, 3, '2026-03-12 08:30:00', 4),  -- Centre Ville (5 km) - 3 passagers (inséparable avec 1001)
(1003, 7, '2026-03-12 09:00:00', 2),  -- La Plage (12.5 km) - 7 passagers
(1004, 4, '2026-03-12 09:00:00', 3),  -- Montagne (20 km) - 4 passagers
(1005, 6, '2026-03-12 09:30:00', 2),  -- La Plage (12.5 km) - 6 passagers (inséparable avec 1003)
(1006, 2, '2026-03-12 10:00:00', 5);  -- Colbert (8 km) - 2 passagers
