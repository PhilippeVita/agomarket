-- ======================================================================
-- BLOC 6 : AGOLINK / INTERCONNEXION
-- ======================================================================

-- Bloc d'interconnexion entre le DWH AgoMarket et l'ERP AgoLink contient : 
-- les endpoints d'API (FastAPI, ERP), 
-- les logs d'appels, 
-- les configurations d'intégration.


-- Table principale : endpoints
DROP TABLE IF EXISTS endpoints CASCADE;
CREATE TABLE endpoints (
    id UUID PRIMARY KEY,                          -- (PK)
    source_system TEXT NOT NULL,
    endpoint_url TEXT NOT NULL,
    method TEXT NOT NULL CHECK (method IN ('GET','POST','PUT','DELETE')),
    auth_type TEXT,
    auth_credentials TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_endpoints_source
    ON endpoints(source_system);

CREATE INDEX idx_endpoints_active
    ON endpoints(is_active);

CREATE OR REPLACE FUNCTION update_endpoints_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_endpoints_updated_at
BEFORE UPDATE ON endpoints
FOR EACH ROW
EXECUTE FUNCTION update_endpoints_timestamp();


---
DROP TABLE IF EXISTS mappings CASCADE;
CREATE TABLE mappings (
    id UUID PRIMARY KEY,                          -- (PK)
    local_field TEXT NOT NULL,
    external_field TEXT NOT NULL,
    source_system TEXT NOT NULL,
    data_type TEXT,
    transformation_rule TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_mappings_source
    ON mappings(source_system);

CREATE INDEX idx_mappings_active
    ON mappings(is_active);

CREATE OR REPLACE FUNCTION update_mappings_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_mappings_updated_at
BEFORE UPDATE ON mappings
FOR EACH ROW
EXECUTE FUNCTION update_mappings_timestamp();


---
DROP TABLE IF EXISTS sync_logs CASCADE;
CREATE TABLE sync_logs (
    id UUID PRIMARY KEY,                          -- (PK)

    -- Polymorphic reference :
    -- entity_type = nom de la table cible (products, suppliers, stocks, pricing, etc.)
    -- entity_id   = UUID de la ligne dans la table cible
    entity_type TEXT NOT NULL,                    -- polymorphic reference
    entity_id UUID NOT NULL,                      -- polymorphic reference

    operation TEXT NOT NULL,                      -- opérations CRUD
    status TEXT NOT NULL,                         -- SUCCESS / FAILED
    message TEXT,
    payload_sent TEXT,
    payload_received TEXT,
    synced_at TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_sync_logs_entity
    ON sync_logs(entity_type, entity_id);

CREATE INDEX idx_sync_logs_status
    ON sync_logs(status);

CREATE INDEX idx_sync_logs_synced_at
    ON sync_logs(synced_at);


---
DROP TABLE IF EXISTS products_catalog CASCADE;
CREATE TABLE products_catalog (
    id UUID PRIMARY KEY,                          -- (PK)
    product_id UUID NOT NULL,                     -- (FK) → products.id
    identifier_id UUID,                           -- (FK) → identifiers.id
    external_id TEXT UNIQUE NOT NULL,             -- Identifiant externe (ex: EAN, SKU, etc.)
    external_code TEXT,                           -- Code externe secondaire (ex: référence fournisseur, etc.)
    source_system TEXT NOT NULL,
    sync_status TEXT,
    sync_message TEXT,
    last_synced_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (identifier_id) REFERENCES identifiers(id)
);

CREATE INDEX idx_products_catalog_product
    ON products_catalog(product_id);

CREATE INDEX idx_products_catalog_identifier
    ON products_catalog(identifier_id);

CREATE INDEX idx_products_catalog_external
    ON products_catalog(external_id);

CREATE OR REPLACE FUNCTION update_products_catalog_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_products_catalog_updated_at
BEFORE UPDATE ON products_catalog
FOR EACH ROW
EXECUTE FUNCTION update_products_catalog_timestamp();


---
DROP TABLE IF EXISTS suppliers_catalog CASCADE;
CREATE TABLE suppliers_catalog (
    id UUID PRIMARY KEY,                          -- (PK)
    supplier_id UUID NOT NULL,                    -- (FK) → suppliers.id
    identifier_id UUID,                           -- (FK) → identifiers.id
    external_id TEXT UNIQUE NOT NULL,             -- Identifiant externe (ex: EAN, SKU, etc.)
    external_code TEXT,                           -- Code externe secondaire (ex: référence fournisseur, etc.)
    source_system TEXT NOT NULL,
    sync_status TEXT,
    sync_message TEXT,
    last_synced_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    FOREIGN KEY (identifier_id) REFERENCES identifiers(id)
);

CREATE INDEX idx_suppliers_catalog_supplier
    ON suppliers_catalog(supplier_id);

CREATE INDEX idx_suppliers_catalog_identifier
    ON suppliers_catalog(identifier_id);

CREATE INDEX idx_suppliers_catalog_external
    ON suppliers_catalog(external_id);

CREATE OR REPLACE FUNCTION update_suppliers_catalog_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_suppliers_catalog_updated_at
BEFORE UPDATE ON suppliers_catalog
FOR EACH ROW
EXECUTE FUNCTION update_suppliers_catalog_timestamp();
