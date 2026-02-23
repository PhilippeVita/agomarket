CREATE OR REPLACE VIEW agomarket.vp_shipping_options AS
SELECT
    so.id AS shipping_option_id,
    so.supplier_id,
    so.name,
    so.description,
    so.delivery_time_min,
    so.delivery_time_max,
    so.shipping_cost,
    so.currency,
    so.conditions,
    so.is_active,
    so.created_at,
    so.updated_at
FROM agomarket.shipping_options so;