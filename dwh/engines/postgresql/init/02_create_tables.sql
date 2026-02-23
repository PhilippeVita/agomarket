-- 01_create_tables.sql
-- Création des 14 tables du DWH AgoMarket dans le schéma agomarket

SET search_path TO agomarket;

------------------------------------------------------------
-- TABLE: suppliers (nouvelle version alignée)
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.suppliers CASCADE;

CREATE TABLE agomarket.suppliers (
    id            UUID PRIMARY KEY,
    name          TEXT NOT NULL,
    legal_name    TEXT NOT NULL,
    code          TEXT,
    country_code  TEXT,
    created_at    TIMESTAMP DEFAULT NOW(),
    updated_at    TIMESTAMP DEFAULT NOW()
);

-- Contrainte d’unicité logique
CREATE UNIQUE INDEX ux_suppliers_name_legalname
    ON agomarket.suppliers (name, legal_name);


------------------------------------------------------------
-- TABLE: products (nouvelle version alignée)
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.products CASCADE;

CREATE TABLE agomarket.products (
    id            UUID PRIMARY KEY,
    supplier_id   UUID NOT NULL REFERENCES agomarket.suppliers(id) ON DELETE CASCADE,
    type          TEXT NOT NULL,     -- tire, rim, tube, etc.
    label         TEXT NOT NULL,
    description   TEXT,
    brand         TEXT,
    created_at    TIMESTAMP DEFAULT NOW(),
    updated_at    TIMESTAMP DEFAULT NOW()
);

-- Index pour accélérer les recherches par fournisseur
CREATE INDEX idx_products_supplier_id
    ON agomarket.products (supplier_id);

-- Index pour les recherches par type (utile pour l’API)
CREATE INDEX idx_products_type
    ON agomarket.products (type);


------------------------------------------------------------
-- TABLE: tires
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.tires CASCADE;

CREATE TABLE agomarket.tires (
    product_id     UUID PRIMARY KEY REFERENCES agomarket.products(id) ON DELETE CASCADE,
    width          INTEGER,
    height         INTEGER,
    diameter       INTEGER,
    load_index     TEXT,
    speed_index    TEXT,
    season         TEXT,
    runflat        BOOLEAN
);

------------------------------------------------------------
-- TABLE: rims
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.rims CASCADE;

CREATE TABLE agomarket.rims (
    product_id     UUID PRIMARY KEY REFERENCES agomarket.products(id) ON DELETE CASCADE,
    diameter       INTEGER,
    width          NUMERIC(4,1),
    holes          INTEGER,
    pcd            TEXT,
    et             INTEGER,
    color          TEXT,
    finish         TEXT
);

------------------------------------------------------------
-- TABLE: tubes
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.tubes CASCADE;

CREATE TABLE agomarket.tubes (
    product_id        UUID PRIMARY KEY REFERENCES agomarket.products(id) ON DELETE CASCADE,
    valve_type        TEXT,
    compatible_sizes  TEXT
);


------------------------------------------------------------
-- TABLE: attribute_definitions
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.attribute_definitions CASCADE;

CREATE TABLE agomarket.attribute_definitions (
    code         TEXT PRIMARY KEY,
    label        TEXT NOT NULL,
    description  TEXT
);


------------------------------------------------------------
-- TABLE: product_attributes
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.product_attributes CASCADE;

CREATE TABLE agomarket.product_attributes (
    id              UUID PRIMARY KEY,
    product_id      UUID NOT NULL REFERENCES agomarket.products(id) ON DELETE CASCADE,
    attribute_code  TEXT NOT NULL REFERENCES agomarket.attribute_definitions(code),
    value           TEXT NOT NULL
);

CREATE INDEX idx_product_attributes_product_id
    ON agomarket.product_attributes(product_id);


------------------------------------------------------------
-- TABLE: product_identifiers
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.product_identifiers CASCADE;

CREATE TABLE agomarket.product_identifiers (
    id               UUID PRIMARY KEY,
    product_id       UUID NOT NULL REFERENCES agomarket.products(id) ON DELETE CASCADE,
    type             TEXT NOT NULL,      -- EAN, SKU, OEM, etc.
    value            TEXT NOT NULL
);

CREATE INDEX idx_identifiers_product_id
    ON agomarket.product_identifiers(product_id);

CREATE INDEX idx_identifiers_value
    ON agomarket.product_identifiers(value);


------------------------------------------------------------
-- TABLE: pricing
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.pricing CASCADE;

CREATE TABLE agomarket.pricing (
    id              UUID PRIMARY KEY,
    product_id      UUID NOT NULL REFERENCES agomarket.products(id) ON DELETE CASCADE,
    supplier_price  NUMERIC(10,2),
    retail_price    NUMERIC(10,2),
    currency        TEXT DEFAULT 'EUR',
    valid_from      DATE,
    valid_to        DATE
);

CREATE INDEX idx_pricing_product_id
    ON agomarket.pricing(product_id);


------------------------------------------------------------
-- TABLE: stock
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.stock CASCADE;

CREATE TABLE agomarket.stock (
    id              UUID PRIMARY KEY,
    product_id      UUID NOT NULL REFERENCES agomarket.products(id) ON DELETE CASCADE,
    warehouse_code  TEXT NOT NULL,
    quantity        INTEGER NOT NULL,
    updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_stock_product_id
    ON agomarket.stock(product_id);


------------------------------------------------------------
-- TABLE: logistics
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.logistics CASCADE;

CREATE TABLE agomarket.logistics (
    id           UUID PRIMARY KEY,
    product_id   UUID NOT NULL REFERENCES agomarket.products(id) ON DELETE CASCADE,
    weight_kg    NUMERIC(10,2),
    width_cm     INTEGER,
    height_cm    INTEGER,
    length_cm    INTEGER,
    package_type TEXT
);

CREATE INDEX idx_logistics_product_id
    ON agomarket.logistics(product_id);


------------------------------------------------------------
-- TABLE: categories
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.categories CASCADE;

CREATE TABLE agomarket.categories (
    id      UUID PRIMARY KEY,
    name    TEXT NOT NULL
);


------------------------------------------------------------
-- TABLE: sub_categories
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.sub_categories CASCADE;

CREATE TABLE agomarket.sub_categories (
    id       UUID PRIMARY KEY,
    category_id   UUID NOT NULL REFERENCES agomarket.categories(id) ON DELETE CASCADE,
    name     TEXT NOT NULL
);

CREATE INDEX idx_sub_categories_category_id
    ON agomarket.sub_categories(category_id);


------------------------------------------------------------
-- TABLE: sectors
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.sectors CASCADE;

CREATE TABLE agomarket.sectors (
    id    UUID PRIMARY KEY,
    name  TEXT NOT NULL
);


------------------------------------------------------------
-- TABLE: product_category_links
------------------------------------------------------------
DROP TABLE IF EXISTS agomarket.product_category_links CASCADE;

CREATE TABLE agomarket.product_category_links (
    id              UUID PRIMARY KEY,
    product_id      UUID NOT NULL REFERENCES agomarket.products(id) ON DELETE CASCADE,
    sub_category_id UUID NOT NULL REFERENCES agomarket.sub_categories(id) ON DELETE CASCADE
);

CREATE INDEX idx_product_category_links_product_id
    ON agomarket.product_category_links(product_id);
