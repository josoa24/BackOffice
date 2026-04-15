-- ============================================================
-- CONCEPTION VERSION FINALE - Sprint 3 & Sprint 4
-- Base : reservation_voiture (PostgreSQL)
-- ============================================================
-- IMPORTANT : Exécuter ce script sur une base VIDE
--             ou après un DROP de toutes les tables existantes.
-- ============================================================
CREATE DATABASE reservation_voiture;
\c reservation_voiture
-- Suppression dans l'ordre inverse des dépendances
DROP TABLE IF EXISTS assignation CASCADE;
DROP TABLE IF EXISTS distance CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS vehicule CASCADE;
DROP TABLE IF EXISTS parametre CASCADE;
DROP TABLE IF EXISTS token CASCADE;
DROP TABLE IF EXISTS hotel CASCADE;

-- ============================================================
-- 1. TABLE HOTEL
--    id_hotel = 1 sera l'Aéroport (point de départ de tous les trajets)
-- ============================================================
CREATE TABLE hotel (
    id_hotel SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    code VARCHAR(10),
    libelle VARCHAR(100)
);

-- ============================================================
-- 2. TABLE RESERVATION
--    id_client : numéro à 4 chiffres (1000-9999)
--    nbPassager : nombre de passagers
--    dateHeure : date et heure de la réservation
--    id_hotel : hôtel de destination
-- ============================================================
CREATE TABLE reservation (
    id_reservation SERIAL PRIMARY KEY,
    id_client INTEGER NOT NULL,
    nbPassager INTEGER NOT NULL,
    dateHeure TIMESTAMP NOT NULL,
    id_hotel INTEGER NOT NULL,
    CONSTRAINT fk_reservation_hotel FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel) ON DELETE CASCADE,
    CONSTRAINT chk_id_client CHECK (id_client >= 1000 AND id_client <= 9999)
);

CREATE INDEX idx_reservation_date ON reservation(dateHeure);
CREATE INDEX idx_reservation_hotel ON reservation(id_hotel);

-- ============================================================
-- 3. TABLE VEHICULE
--    marque, modele, immatriculation, capacite (nb places), carburant
--    carburant : 'diesel' ou 'essence'
-- ============================================================
CREATE TABLE vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    marque VARCHAR(50) NOT NULL,
    modele VARCHAR(50) NOT NULL,
    immatriculation VARCHAR(20) UNIQUE NOT NULL,
    capacite INT NOT NULL,
    carburant VARCHAR(20) NOT NULL DEFAULT 'essence',
    heure_debut_disponibilite TIME NOT NULL DEFAULT '00:00:00'
);

ALTER TABLE vehicule ADD COLUMN IF NOT EXISTS heure_debut_disponibilite TIME NOT NULL DEFAULT '00:00:00';

DROP TABLE vehicule;

-- ============================================================
-- 4. TABLE PARAMETRE
--    vitesse_moyenne_vehicule : en km/h
--    temps_attente : en minutes (temps d'attente avant départ)
-- ============================================================
CREATE TABLE parametre (
    id_parametre SERIAL PRIMARY KEY,
    vitesse_moyenne_vehicule INT NOT NULL DEFAULT 60,
    temps_attente INT NOT NULL DEFAULT 30
);

-- ============================================================
-- 5. TABLE DISTANCE
--    Distance entre deux hôtels (ou entre l'aéroport et un hôtel)
--    id_from, id_to : références vers hotel.id_hotel
--    distance_km : distance en kilomètres
-- ============================================================
CREATE TABLE distance (
    id_distance SERIAL PRIMARY KEY,
    id_from INT NOT NULL,
    id_to INT NOT NULL,
    distance_km DOUBLE PRECISION NOT NULL,
    CONSTRAINT fk_distance_from FOREIGN KEY (id_from) REFERENCES hotel(id_hotel) ON DELETE CASCADE,
    CONSTRAINT fk_distance_to FOREIGN KEY (id_to) REFERENCES hotel(id_hotel) ON DELETE CASCADE
);

-- ============================================================
-- 6. TABLE ASSIGNATION
--    Lien entre une réservation et le véhicule assigné
--    heure_depart : heure de départ calculée
--    heure_arrivee : heure d'arrivée estimée
--    Sprint 4 : un véhicule peut avoir plusieurs assignations
-- ============================================================
CREATE TABLE assignation (
    id_assignation SERIAL PRIMARY KEY,
    id_reservation INT NOT NULL,
    id_vehicule INT NOT NULL,
    heure_depart TIMESTAMP NOT NULL,
    heure_arrivee TIMESTAMP NOT NULL,
    CONSTRAINT fk_assignation_reservation FOREIGN KEY (id_reservation) REFERENCES reservation(id_reservation) ON DELETE CASCADE,
    CONSTRAINT fk_assignation_vehicule FOREIGN KEY (id_vehicule) REFERENCES vehicule(id_vehicule) ON DELETE CASCADE,
    CONSTRAINT uk_assignation_reservation UNIQUE (id_reservation)
);

-- ============================================================
-- 7. TABLE TOKEN (authentification client - existante)
-- ============================================================
CREATE TABLE token (
    id_token SERIAL PRIMARY KEY,
    token VARCHAR(255) NOT NULL UNIQUE,
    date_expiration TIMESTAMP NOT NULL,
    id_client INTEGER NOT NULL,
    CONSTRAINT chk_token_client CHECK (id_client >= 1000 AND id_client <= 9999)
);

CREATE INDEX idx_token_value ON token(token);
CREATE INDEX idx_token_expiration ON token(date_expiration);
