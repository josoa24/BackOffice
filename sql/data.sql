-- Données de test pour les hôtels
-- Ajoute 4 hôtels (sans doublons) afin d'avoir des id_hotel valides pour les réservations

INSERT INTO hotel (nom, code, libelle)
SELECT 'Hotel Le Royal', 'HOT-01', 'Le Royal' WHERE NOT EXISTS (SELECT 1 FROM hotel WHERE nom = 'Hotel Le Royal');
INSERT INTO hotel (nom, code, libelle)
SELECT 'Hotel La Plage', 'HOT-02', 'La Plage' WHERE NOT EXISTS (SELECT 1 FROM hotel WHERE nom = 'Hotel La Plage');
INSERT INTO hotel (nom, code, libelle)
SELECT 'Hotel Montagne', 'HOT-03', 'Montagne' WHERE NOT EXISTS (SELECT 1 FROM hotel WHERE nom = 'Hotel Montagne');
INSERT INTO hotel (nom, code, libelle)
SELECT 'Hotel Centre Ville', 'HOT-04', 'Centre Ville' WHERE NOT EXISTS (SELECT 1 FROM hotel WHERE nom = 'Hotel Centre Ville');

-- Données de test pour les réservations
-- Utilise des id_hotel existants (1..4) sans en créer de nouveaux

INSERT INTO reservation (id_client, nbPassager, dateHeure, id_hotel) VALUES
(1001, 8, '2026-03-12 08:30:00', 1),
(1002, 5, '2026-03-12 08:50:00', 2),
(1003, 4, '2026-03-12 09:00:00', 3),
(1004, 2, '2026-03-12 09:15:00', 4);
