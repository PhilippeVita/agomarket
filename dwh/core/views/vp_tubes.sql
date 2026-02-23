CREATE OR REPLACE VIEW agomarket.vp_tubes AS
SELECT
    tb.id AS tube_id,
    tb.product_id,
    tb.width_min,
    tb.width_max,
    tb.diameter,
    tb.valve_type,
    tb.valve_length,
    tb.material,
    tb.thickness,
    tb.created_at,
    tb.updated_at
FROM agomarket.tubes tb;