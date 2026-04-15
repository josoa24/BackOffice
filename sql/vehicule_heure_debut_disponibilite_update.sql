-- ============================================================
-- Migration: heure_debut_disponibilite pour vehicule
-- Type: TIME
-- Regle: un vehicule n'est disponible qu'a partir de cette heure
-- Valeur par defaut: 00:00:00
-- ============================================================

ALTER TABLE vehicule
ADD COLUMN IF NOT EXISTS heure_debut_disponibilite TIME;

UPDATE vehicule
SET heure_debut_disponibilite = '00:00:00'
WHERE heure_debut_disponibilite IS NULL;

ALTER TABLE vehicule
ALTER COLUMN heure_debut_disponibilite SET DEFAULT '00:00:00';

ALTER TABLE vehicule
ALTER COLUMN heure_debut_disponibilite SET NOT NULL;
