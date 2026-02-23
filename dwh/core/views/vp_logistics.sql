CREATE OR REPLACE VIEW agomarket.vp_logistics AS
SELECT
    l.id AS logistics_id,
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
    l.created_at,
    l.updated_at
FROM agomarket.logistics l;