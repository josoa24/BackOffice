CREATE TABLE hotel (
    id_hotel SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL
);

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
