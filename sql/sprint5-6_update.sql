-- Sprint 5-6 : Mise à jour table assignation pour stocker kilométrage et hôtel
-- Cette migration ajoute les colonnes manquantes pour compléter la structure des trajets

ALTER TABLE assignation
ADD COLUMN IF NOT EXISTS kilometrage DOUBLE PRECISION DEFAULT 0;

ALTER TABLE assignation
ADD COLUMN IF NOT EXISTS id_hotel INT DEFAULT NULL;

-- Optionnel : Ajouter contrainte de clé étrangère si besoin
-- ALTER TABLE assignation
-- ADD CONSTRAINT fk_assignation_hotel FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel);

-- Vérification de la structure finale
-- SELECT column_name, data_type FROM information_schema.columns 
-- WHERE table_name = 'assignation' ORDER BY ordinal_position;
