CREATE OR REPLACE VIEW agomarket.vp_stocks AS
SELECT
    s.id AS stock_id,
    s.supplier_id,
    s.product_id,
    s.quantity,
    s.quantity_reserved,
    s.quantity_in_transit,
    s.availability_status,
    s.warehouse_code,
    s.price_supplier,
    s.currency,
    s.min_order_quantity,
    s.created_at,
    s.updated_at
FROM agomarket.stocks s;