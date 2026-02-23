-- ======================================================================
-- BLOC 3 : STOCKS
-- ======================================================================


DROP TABLE IF EXISTS stocks CASCADE;
CREATE TABLE stocks (
    id UUID PRIMARY KEY,                          -- (PK)
    supplier_id UUID NOT NULL,                    -- (FK) → suppliers.id
    product_id UUID NOT NULL,                     -- (FK) → products.id
    quantity INTEGER DEFAULT 0,
    quantity_reserved INTEGER DEFAULT 0,
    quantity_in_transit INTEGER DEFAULT 0,
    availability_status TEXT,
    warehouse_code TEXT,
    price_supplier NUMERIC(12,2),
    currency CHAR(3),
    min_order_quantity INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_stocks_supplier_product
    ON stocks(supplier_id, product_id);

CREATE INDEX idx_stocks_availability
    ON stocks(availability_status);

CREATE INDEX idx_stocks_updated_at
    ON stocks(updated_at);

CREATE OR REPLACE FUNCTION update_stocks_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_stocks_updated_at
BEFORE UPDATE ON stocks
FOR EACH ROW
EXECUTE FUNCTION update_stocks_timestamp();


---
DROP TABLE IF EXISTS stock_logs CASCADE;
CREATE TABLE stock_logs (
    id UUID PRIMARY KEY,                          -- (PK)
    stock_id UUID NOT NULL,                       -- (FK) → stocks.id
    previous_quantity INTEGER,
    new_quantity INTEGER,
    change_type TEXT NOT NULL,
    source TEXT,
    processed_at TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (stock_id) REFERENCES stocks(id)
);

CREATE INDEX idx_stock_logs_stock_id
    ON stock_logs(stock_id);

CREATE INDEX idx_stock_logs_processed_at
    ON stock_logs(processed_at);


---
DROP TABLE IF EXISTS lead_times CASCADE;
CREATE TABLE lead_times (
    id UUID PRIMARY KEY,                          -- (PK)
    supplier_id UUID NOT NULL,                    -- (FK) → suppliers.id
    product_id UUID NOT NULL,                     -- (FK) → products.id
    lead_time_days INTEGER NOT NULL,
    lead_time_type TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_lead_times_supplier_product
    ON lead_times(supplier_id, product_id);

CREATE INDEX idx_lead_times_days
    ON lead_times(lead_time_days);

CREATE OR REPLACE FUNCTION update_lead_times_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_lead_times_updated_at
BEFORE UPDATE ON lead_times
FOR EACH ROW
EXECUTE FUNCTION update_lead_times_timestamp();