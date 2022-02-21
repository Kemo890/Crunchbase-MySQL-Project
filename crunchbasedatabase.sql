CREATE TABLE IF NOT EXISTS cb_objects (
    id VARCHAR(10) NOT NULL UNIQUE PRIMARY KEY,
    entity_type VARCHAR(15),
    entity_id INT,
    name VARCHAR(300),
    category_code VARCHAR(20),
    status VARCHAR(15),
    founded_at DATE
);

LOAD DATA INFILE "cb_objects.csv"
INTO TABLE cb_objects
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS cb_offices (
    object_id VARCHAR(10),
    office_id INT NOT NULL UNIQUE PRIMARY KEY,
    description VARCHAR(60),
    region VARCHAR(40),
    city VARCHAR(70),
    zip_code VARCHAR(50),
    state_code CHAR(2),
    country_code CHAR(3)
);
    
LOAD DATA INFILE "cb_offices.csv"
INTO TABLE cb_offices
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS cb_funding_roundss (
    id INT NOT NULL UNIQUE PRIMARY KEY AUTO_INCREMENT,
    object_id VARCHAR(10),
    funded_at DATE,
    funding_round_type VARCHAR(20),
    raised_amount_usd BIGINT,
    participants TINYINT,
    office_id INT
);
# Original data had normalization issues so I removed columns and added an id column for the funding rounds to achieve 3NF.

LOAD DATA INFILE "cb_funding_roundss.csv"
INTO TABLE cb_funding_roundss
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(object_id, funded_at, funding_round_type, raised_amount_usd, participants, office_id, @dummy, @dummy, @dummy);

CREATE TABLE IF NOT EXISTS cb_acquisitions (
    acquisitions_id SMALLINT NOT NULL UNIQUE PRIMARY KEY,
    acquiring_object_id VARCHAR(10),
    acquired_object_id VARCHAR(10),
    price_amount BIGINT,
    price_currency_code CHAR(5),
    acquired_at DATE
);

LOAD DATA INFILE "cb_acquisitions.csv"
INTO TABLE cb_acquisitions
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

# Altering tables to have foreign keys.
ALTER TABLE cb_offices ADD FOREIGN KEY (object_id) REFERENCES cb_objects(id);

ALTER TABLE cb_funding_roundss ADD FOREIGN KEY (object_id) REFERENCES cb_objects(id);
ALTER TABLE cb_funding_roundss ADD FOREIGN KEY (office_id) REFERENCES cb_offices(office_id);

SET FOREIGN_KEY_CHECKS=0;
# Turning off foreign key checks to add foreign key relationship between cb_acquisitons table and cb_objects table.

ALTER TABLE cb_acquisitions ADD FOREIGN KEY (acquiring_object_id) REFERENCES cb_objects(id);
ALTER TABLE cb_acquisitions ADD FOREIGN KEY (acquired_object_id) REFERENCES cb_objects(id);

