-- ============================================================
-- BLOC 5 : LOGISTICS
-- ============================================================


DROP TABLE IF EXISTS logistics CASCADE;
CREATE TABLE logistics (
    id UUID PRIMARY KEY,                          -- (PK)
    supplier_id UUID NOT NULL,                    -- (FK) → suppliers.id
    product_id UUID NOT NULL,                     -- (FK) → products.id
    identifier_id UUID,                           -- (FK) → identifiers.id
    package_type TEXT,
    package_width NUMERIC(10,2),
    package_height NUMERIC(10,2),
    package_length NUMERIC(10,2),
    package_weight NUMERIC(10,2),
    stackable BOOLEAN,
    hazardous_material BOOLEAN,
    shipping_class TEXT,
    incoterm TEXT,
    origin_warehouse TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (identifier_id) REFERENCES identifiers(id)
);

CREATE INDEX idx_logistics_supplier_product
    ON logistics(supplier_id, product_id);

CREATE INDEX idx_logistics_identifier
    ON logistics(identifier_id);

CREATE OR REPLACE FUNCTION update_logistics_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_logistics_updated_at
BEFORE UPDATE ON logistics
FOR EACH ROW
EXECUTE FUNCTION update_logistics_timestamp();


---
DROP TABLE IF EXISTS logistics_logs CASCADE;
CREATE TABLE logistics_logs (
    id UUID PRIMARY KEY,                          -- (PK)
    logistics_id UUID NOT NULL,                   -- (FK) → logistics.id
    previous_values TEXT,
    new_values TEXT,
    change_type TEXT NOT NULL,
    source TEXT,
    processed_at TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (logistics_id) REFERENCES logistics(id)
);

CREATE INDEX idx_logistics_logs_logistics_id
    ON logistics_logs(logistics_id);

CREATE INDEX idx_logistics_logs_processed_at
    ON logistics_logs(processed_at);


--- 
DROP TABLE IF EXISTS shipping_options CASCADE;
CREATE TABLE shipping_options (
    id UUID PRIMARY KEY,                          -- (PK)
    supplier_id UUID NOT NULL,                    -- (FK) → suppliers.id
    name TEXT NOT NULL,
    description TEXT,
    delivery_time_min INTEGER,
    delivery_time_max INTEGER,
    shipping_cost NUMERIC(12,2),
    currency CHAR(3),
    conditions TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

CREATE INDEX idx_shipping_options_supplier
    ON shipping_options(supplier_id);

CREATE INDEX idx_shipping_options_active
    ON shipping_options(is_active);

CREATE OR REPLACE FUNCTION update_shipping_options_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_shipping_options_updated_at
BEFORE UPDATE ON shipping_options
FOR EACH ROW
EXECUTE FUNCTION update_shipping_options_timestamp();
