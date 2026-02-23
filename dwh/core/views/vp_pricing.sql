CREATE OR REPLACE VIEW agomarket.vp_pricing AS
SELECT
    p.id AS price_id,
    p.product_id,
    p.supplier_id,
    p.identifier_id,
    p.price,
    p.currency,
    p.priceHT,
    p.priceTTC,
    p.vatRate,
    p.price_type,
    p.min_quantity,
    p.discount,
    p.valid_from,
    p.valid_until,
    p.source,
    p.notes,
    p.created_at,
    p.updated_at
FROM agomarket.pricing p;