-- ============================================================
-- SCRIPT DE REINITIALISATION DE LA BASE DE DONNEES
-- Vide toutes les tables et remet les sequences (ID) à 1
-- Usage : psql -U postgres -d reservation_voiture -f sql/reset_database.sql
-- ============================================================

-- Suppression des données (ordre : enfants -> parents)
DELETE FROM assignation;
DELETE FROM distance;
DELETE FROM reservation;
DELETE FROM vehicule;
DELETE FROM parametre;
DELETE FROM token;
DELETE FROM hotel;

-- Remise à 1 de toutes les séquences (SERIAL)
ALTER SEQUENCE assignation_id_assignation_seq RESTART WITH 1;
ALTER SEQUENCE distance_id_distance_seq RESTART WITH 1;
ALTER SEQUENCE reservation_id_reservation_seq RESTART WITH 1;
ALTER SEQUENCE vehicule_id_vehicule_seq RESTART WITH 1;
ALTER SEQUENCE parametre_id_parametre_seq RESTART WITH 1;
ALTER SEQUENCE token_id_token_seq RESTART WITH 1;
ALTER SEQUENCE hotel_id_hotel_seq RESTART WITH 1;

-- Confirmation
DO $$ BEGIN RAISE NOTICE 'Base de données réinitialisée avec succès. Tous les IDs recommencent à 1.'; END $$;
