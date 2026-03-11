-- Sprint 3 : Ajout Aeroport, Distance, Vehicule

-- Modifier la table hotel pour ajouter le code aeroport
ALTER TABLE hotel ADD COLUMN IF NOT EXISTS code VARCHAR(10);
ALTER TABLE hotel ADD COLUMN IF NOT EXISTS libelle VARCHAR(100);

-- Table Vehicule
CREATE TABLE IF NOT EXISTS vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    marque VARCHAR(50) NOT NULL,
    modele VARCHAR(50) NOT NULL,
    immatriculation VARCHAR(20) UNIQUE NOT NULL,
    capacite INT NOT NULL,
    carburant VARCHAR(20) NOT NULL DEFAULT 'essence' -- 'diesel' ou 'essence'
);

-- Table Distance entre aeroports/hotels
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

-- Données de test pour les vehicules
INSERT INTO vehicule (marque, modele, immatriculation, capacite, carburant) VALUES
('Toyota', 'HiAce', 'TAN-1234', 15, 'diesel'),
('Mercedes', 'Sprinter', 'TAN-5678', 20, 'diesel'),
('Hyundai', 'H350', 'TAN-9012', 12, 'essence'),
('Toyota', 'Coaster', 'TAN-3456', 25, 'diesel'),
('Renault', 'Master', 'TAN-7890', 8, 'essence'),
('Ford', 'Transit', 'TAN-2345', 10, 'diesel');

-- Mettre à jour les hotels avec code et libelle
UPDATE hotel SET code = 'APT-01', libelle = 'Aéroport Ivato' WHERE id_hotel = 1;
UPDATE hotel SET code = 'APT-02', libelle = 'Aéroport Fascène' WHERE id_hotel = 2;

-- Données de test pour les distances
INSERT INTO distance (id_from, id_to, distance_km) VALUES
(1, 2, 15.5),
(2, 1, 15.5);
