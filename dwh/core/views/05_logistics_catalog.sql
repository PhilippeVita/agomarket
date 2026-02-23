CREATE OR REPLACE VIEW agomarket.05_logistics_catalog AS
SELECT
    -- Logistique principale
    l.logistics_id,
    l.supplier_id,
    l.product_id,
    l.identifier_id,
    l.package_type,
    l.package_width,
    l.package_height,
    l.package_length,
    l.package_weight,
    l.stackable,
    l.hazardous_material,
    l.shipping_class,
    l.incoterm,
    l.origin_warehouse,
    l.created_at AS logistics_created_at,
    l.updated_at AS logistics_updated_at,

    -- Logs de logistique
    ll.logistics_log_id,
    ll.previous_values AS logistics_previous_values,
    ll.new_values AS logistics_new_values,
    ll.change_type AS logistics_change_type,
    ll.source AS logistics_change_source,
    ll.processed_at AS logistics_change_processed_at,
    ll.created_at AS logistics_log_created_at,

    -- Options de livraison
    so.shipping_option_id,
    so.name AS shipping_option_name,
    so.description AS shipping_option_description,
    so.delivery_time_min,
    so.delivery_time_max,
    so.shipping_cost,
    so.currency AS shipping_currency,
    so.conditions AS shipping_conditions,
    so.is_active AS shipping_is_active,
    so.created_at AS shipping_created_at,
    so.updated_at AS shipping_updated_at

FROM agomarket.vp_logistics l
LEFT JOIN agomarket.vp_logistics_logs ll
    ON ll.logistics_id = l.logistics_id
LEFT JOIN agomarket.vp_shipping_options so
    ON so.supplier_id = l.supplier_id;