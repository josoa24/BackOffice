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

CREATE TABLE Vehicule (
    id_vehicule BIGINT PRIMARY KEY,
    reference VARCHAR(255) NOT NULL,
    place INTEGER NOT NULL,
    type_vehicule VARCHAR(255) NOT NULL
);

create table Token (
    id_token SERIAL PRIMARY KEY,
    token VARCHAR(255) NOT NULL UNIQUE,
    date_expiration TIMESTAMP NOT NULL,
    id_client INTEGER NOT NULL,
    CONSTRAINT chk_token_client CHECK (id_client >= 1000 AND id_client <= 9999)
);

CREATE INDEX idx_token_value ON token(token);
CREATE INDEX idx_token_expiration ON token(date_expiration);