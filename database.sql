CREATE TABLE hotel (
    id_hotel INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL
);

CREATE TABLE reservation (
    id_reservation INT PRIMARY KEY AUTO_INCREMENT,
    id_client INT NOT NULL,
    nbPassager INT NOT NULL,
    dateHeure DATETIME NOT NULL,
    id_hotel INT NOT NULL,
    FOREIGN KEY (id_hotel) REFERENCES hotel (id_hotel),
    CONSTRAINT chk_id_client CHECK (
        id_client >= 1000
        AND id_client <= 9999
    )
);

CREATE INDEX idx_reservation_date ON reservation (dateHeure);

CREATE INDEX idx_reservation_hotel ON reservation (id_hotel);