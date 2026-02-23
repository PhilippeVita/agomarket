CREATE OR REPLACE VIEW agomarket.vp_rims AS
SELECT
    r.id AS rim_id,
    r.product_id,
    r.diameter,
    r.width,
    r.bolt_pattern,
    r.center_bore,
    r.offset,
    r.material,
    r.finish,
    r.color,
    r.load_rating,
    r.pressure,
    r.rim_type,
    r.created_at,
    r.updated_at
FROM agomarket.rims r;