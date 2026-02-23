-- ======================================================================
-- BLOC 2 : PRODUCTS (PRODUITS)
-- ======================================================================


DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
    id UUID PRIMARY KEY,
    external_id TEXT UNIQUE NOT NULL,     -- Identifiant externe (ex: SKU, EAN, etc.)  
    type TEXT NOT NULL,
    libelle TEXT NOT NULL,
    marque TEXT,
    modele TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_products_type
    ON products(type);

CREATE INDEX idx_products_regional_code
    ON products(regional_code);

CREATE OR REPLACE FUNCTION update_products_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_products_updated_at
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_products_timestamp();


--- 
DROP TABLE IF EXISTS tires CASCADE;
CREATE TABLE tires (
    id UUID PRIMARY KEY,
    product_id UUID NOT NULL,
    dimension_raw TEXT,
    width INTEGER,
    aspect_ratio INTEGER,
    diameter INTEGER,
    construction TEXT,
    load_index INTEGER,
    load_index_single INTEGER,
    load_index_dual INTEGER,
    speed_rating TEXT,
    speed_rating_single TEXT,
    speed_rating_dual TEXT,
    tubeless BOOLEAN,
    tube_type TEXT,
    ply_rating TEXT,
    usage TEXT,
    season TEXT,
    runflat BOOLEAN,
    reinforced BOOLEAN,
    extra_load BOOLEAN,
    fuel_efficiency TEXT,
    wet_grip_class TEXT,
    noise_level INTEGER,
    noise_class TEXT,
    snow_grip BOOLEAN,
    ice_grip BOOLEAN,
    pattern TEXT,
    tread_depth NUMERIC(5,2),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_tires_dimensions
    ON tires(width, aspect_ratio, diameter);

CREATE INDEX idx_tires_season
    ON tires(season);

CREATE INDEX idx_tires_product_id
    ON tires(product_id);

CREATE OR REPLACE FUNCTION update_tires_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_tires_updated_at
BEFORE UPDATE ON tires
FOR EACH ROW
EXECUTE FUNCTION update_tires_timestamp();


---
DROP TABLE IF EXISTS rims CASCADE;
CREATE TABLE rims (
    id UUID PRIMARY KEY,
    product_id UUID NOT NULL,
    diameter NUMERIC(5,2),
    width NUMERIC(5,2),
    bolt_pattern TEXT,
    center_bore NUMERIC(6,2),
    offset NUMERIC(6,2),
    material TEXT,
    finish TEXT,
    color TEXT,
    load_rating INTEGER,
    pressure INTEGER,
    rim_type TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_rims_dimensions
    ON rims(diameter, width);

CREATE INDEX idx_rims_product_id
    ON rims(product_id);

CREATE OR REPLACE FUNCTION update_rims_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_rims_updated_at
BEFORE UPDATE ON rims
FOR EACH ROW
EXECUTE FUNCTION update_rims_timestamp();


--- 
DROP TABLE IF EXISTS tubes CASCADE;
CREATE TABLE tubes (
    id UUID PRIMARY KEY,
    product_id UUID NOT NULL,
    width_min INTEGER,
    width_max INTEGER,
    diameter INTEGER,
    valve_type TEXT,
    valve_length INTEGER,
    material TEXT,
    thickness NUMERIC(5,2),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_tubes_dimensions
    ON tubes(width_min, width_max, diameter);

CREATE INDEX idx_tubes_product_id
    ON tubes(product_id);

CREATE OR REPLACE FUNCTION update_tubes_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_tubes_updated_at
BEFORE UPDATE ON tubes
FOR EACH ROW
EXECUTE FUNCTION update_tubes_timestamp();


--- Table d'identifiants produits (EAN, UPC, SKU, etc.)
DROP TABLE IF EXISTS identifiers CASCADE;
CREATE TABLE identifiers (
    id UUID PRIMARY KEY,                         -- (PK)
    product_id UUID NOT NULL,                    -- (FK) → products.id
    type TEXT NOT NULL CHECK (
        type IN ('EAN','UPC','SKU','MPN','OEM','OTHER','ASIN','GTIN','ISBN')
    ),
    value TEXT NOT NULL,
    country CHAR(2),                             -- Code pays ISO (optionnel)
    source TEXT,                                 -- Origine de l’identifiant
    is_primary BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE UNIQUE INDEX idx_identifiers_unique
    ON identifiers(product_id, type, value);

CREATE INDEX idx_identifiers_type
    ON identifiers(type);

CREATE INDEX idx_identifiers_value
    ON identifiers(value);

CREATE OR REPLACE FUNCTION update_identifiers_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_identifiers_updated_at
BEFORE UPDATE ON identifiers
FOR EACH ROW
EXECUTE FUNCTION update_identifiers_timestamp();