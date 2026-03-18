-- Sprint 7 : repartition partielle des passagers d'une reservation
-- 1) une reservation peut avoir plusieurs lignes dans assignation
-- 2) chaque ligne porte le nombre de passagers assignes

ALTER TABLE assignation
ADD COLUMN IF NOT EXISTS nb_passagers_assignes INT;

UPDATE assignation a
SET nb_passagers_assignes = r.nbPassager
FROM reservation r
WHERE r.id_reservation = a.id_reservation
  AND a.nb_passagers_assignes IS NULL;

ALTER TABLE assignation
ALTER COLUMN nb_passagers_assignes SET NOT NULL;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'chk_assignation_nb_passagers_assignes_positive'
  ) THEN
    ALTER TABLE assignation
    ADD CONSTRAINT chk_assignation_nb_passagers_assignes_positive
    CHECK (nb_passagers_assignes > 0);
  END IF;
END $$;

ALTER TABLE assignation
DROP CONSTRAINT IF EXISTS uk_assignation_reservation;
