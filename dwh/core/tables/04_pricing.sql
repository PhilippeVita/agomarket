-- ======================================================================
-- BLOC 4 : PRICING
-- ======================================================================


DROP TABLE IF EXISTS pricing CASCADE;
CREATE TABLE pricing (
    id UUID PRIMARY KEY,                          -- (PK)
    product_id UUID NOT NULL,                     -- (FK) → products.id
    supplier_id UUID NOT NULL,                    -- (FK) → suppliers.id
    identifier_id UUID,                           -- (FK) → identifiers.id
    price NUMERIC(12,2) NOT NULL,
    currency CHAR(3) NOT NULL,
    priceHT NUMERIC(12,2),
    priceTTC NUMERIC(12,2),
    vatRate NUMERIC(5,2),
    price_type TEXT,
    min_quantity INTEGER DEFAULT 1,
    discount NUMERIC(12,2),
    valid_from TIMESTAMP DEFAULT NOW(),
    valid_until TIMESTAMP,
    source TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    FOREIGN KEY (identifier_id) REFERENCES identifiers(id)
);

CREATE INDEX idx_pricing_supplier_product
    ON pricing(supplier_id, product_id);

CREATE INDEX idx_pricing_validity
    ON pricing(valid_from, valid_until);

CREATE INDEX idx_pricing_price_type
    ON pricing(price_type);

CREATE OR REPLACE FUNCTION update_pricing_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_pricing_updated_at
BEFORE UPDATE ON pricing
FOR EACH ROW
EXECUTE FUNCTION update_pricing_timestamp();


---
DROP TABLE IF EXISTS pricing_logs CASCADE;
CREATE TABLE pricing_logs (
    id UUID PRIMARY KEY,                          -- (PK)
    price_id UUID NOT NULL,                       -- (FK) → pricing.id
    previous_price NUMERIC(12,2),
    new_price NUMERIC(12,2),
    previous_discount NUMERIC(12,2),
    new_discount NUMERIC(12,2),
    change_type TEXT NOT NULL,
    source TEXT,
    processed_at TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (price_id) REFERENCES pricing(id)
);

CREATE INDEX idx_pricing_logs_price_id
    ON pricing_logs(price_id);

CREATE INDEX idx_pricing_logs_processed_at
    ON pricing_logs(processed_at);


---
DROP TABLE IF EXISTS pricing_rules CASCADE;
CREATE TABLE pricing_rules (
    id UUID PRIMARY KEY,                          -- (PK)
    supplier_id UUID NOT NULL,                    -- (FK) → suppliers.id
    rule_name TEXT NOT NULL,
    rule_type TEXT NOT NULL,
    value NUMERIC(12,2),
    conditions TEXT,
    priority INTEGER DEFAULT 100,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

CREATE INDEX idx_pricing_rules_supplier
    ON pricing_rules(supplier_id);

CREATE INDEX idx_pricing_rules_priority
    ON pricing_rules(priority);

CREATE OR REPLACE FUNCTION update_pricing_rules_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_pricing_rules_updated_at
BEFORE UPDATE ON pricing_rules
FOR EACH ROW
EXECUTE FUNCTION update_pricing_rules_timestamp();


---
DROP TABLE IF EXISTS price_statistics CASCADE;

CREATE TABLE price_statistics (
    id UUID PRIMARY KEY,                          -- (PK)
    product_id UUID NOT NULL,                     -- (FK) → products.id
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    min_price NUMERIC(12,2),
    max_price NUMERIC(12,2),
    avg_price NUMERIC(12,2),
    median_price NUMERIC(12,2),
    supplier_count INTEGER,
    price_change_count INTEGER,
    price_variance NUMERIC(18,6),
    calculated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_price_statistics_product
    ON price_statistics(product_id);

CREATE INDEX idx_price_statistics_period
    ON price_statistics(period_start, period_end);


--- 
DROP TABLE IF EXISTS price_histories CASCADE;

CREATE TABLE price_histories (
    id UUID PRIMARY KEY,                          -- (PK)
    product_id UUID NOT NULL,                     -- (FK) → products.id
    supplier_id UUID NOT NULL,                    -- (FK) → suppliers.id
    price NUMERIC(12,2) NOT NULL,
    currency CHAR(3) NOT NULL,
    priceHT NUMERIC(12,2),
    priceTTC NUMERIC(12,2),
    vatRate NUMERIC(5,2),
    price_type TEXT,
    min_quantity INTEGER DEFAULT 1,
    discount NUMERIC(12,2),
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP,
    source TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

CREATE INDEX idx_price_histories_product_supplier
    ON price_histories(product_id, supplier_id);

CREATE INDEX idx_price_histories_validity
    ON price_histories(valid_from, valid_until);