CREATE OR REPLACE VIEW agomarket.vp_price_histories AS
SELECT
    ph.id AS price_history_id,
    ph.product_id,
    ph.supplier_id,
    ph.price,
    ph.currency,
    ph.priceHT,
    ph.priceTTC,
    ph.vatRate,
    ph.price_type,
    ph.min_quantity,
    ph.discount,
    ph.valid_from,
    ph.valid_until,
    ph.source,
    ph.notes,
    ph.created_at
FROM agomarket.price_histories ph;