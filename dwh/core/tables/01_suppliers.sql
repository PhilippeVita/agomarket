-- =====================================================================
-- BLOC 1 : SUPPLIERS (FOURNISSEURS)
-- =====================================================================

-- Suppliers (pivot principal)
DROP TABLE IF EXISTS suppliers CASCADE;
CREATE TABLE suppliers (
    id UUID PRIMARY KEY,
    external_id TEXT UNIQUE,
    name TEXT NOT NULL,
    legal_name TEXT NOT NULL,
    country_code CHAR(2) NOT NULL,
    email TEXT,
    phone TEXT,
    website TEXT,
    logo_url TEXT,
    address TEXT,
    postal_code TEXT,
    city TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE UNIQUE INDEX suppliers_name_legal_unique
    ON suppliers(name, legal_name);

CREATE INDEX idx_suppliers_name
    ON suppliers(name);

CREATE INDEX idx_suppliers_country_code
    ON suppliers(country_code);

CREATE INDEX idx_suppliers_is_active
    ON suppliers(is_active);

CREATE OR REPLACE FUNCTION update_suppliers_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_suppliers_updated_at
BEFORE UPDATE ON suppliers
FOR EACH ROW
EXECUTE FUNCTION update_suppliers_timestamp();


--- import_data
DROP TABLE IF EXISTS import_data CASCADE;
CREATE TABLE import_data (
    id UUID PRIMARY KEY,
    supplier_id UUID NOT NULL,
    file_name TEXT NOT NULL,
    file_size INTEGER,
    rows_processed INTEGER DEFAULT 0,
    rows_success INTEGER DEFAULT 0,
    rows_error INTEGER DEFAULT 0,
    status TEXT NOT NULL CHECK (
        status IN ('PENDING','SUCCESS','FAILED','PARTIAL')
    ),
    error_log TEXT,
    imported_at TIMESTAMP DEFAULT NOW(),
    processed_at TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

CREATE INDEX idx_import_data_supplier_id
    ON import_data(supplier_id);

CREATE INDEX idx_import_data_status
    ON import_data(status);

CREATE INDEX idx_import_data_imported_at
    ON import_data(imported_at);


--- import_audit
DROP TABLE IF EXISTS import_audit CASCADE;
CREATE TABLE import_audit (
    id UUID PRIMARY KEY,
    import_id UUID NOT NULL,
    step TEXT NOT NULL,
    status TEXT NOT NULL,
    details TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (import_id) REFERENCES import_data(id)
);

CREATE INDEX idx_import_audit_import_id
    ON import_audit(import_id);

CREATE INDEX idx_import_audit_status
    ON import_audit(status);


--- import_alert
DROP TABLE IF EXISTS import_alert CASCADE;
CREATE TABLE import_alert (
    id UUID PRIMARY KEY,
    import_id UUID NOT NULL,
    level TEXT NOT NULL CHECK (
        level IN ('INFO','WARNING','ERROR','CRITICAL')
    ),
    message TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (import_id) REFERENCES import_data(id)
);

CREATE INDEX idx_import_alert_import_id
    ON import_alert(import_id);

CREATE INDEX idx_import_alert_level
    ON import_alert(level);