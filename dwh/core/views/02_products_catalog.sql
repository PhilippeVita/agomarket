CREATE OR REPLACE VIEW agomarket.02_products_catalog AS
SELECT
    -- Produit (pivot principal)
    p.product_id,
    p.external_id,
    p.type,
    p.libelle,
    p.marque,
    p.modele,
    p.description,
    p.created_at AS product_created_at,
    p.updated_at AS product_updated_at,

    -- Pneus
    t.tire_id,
    t.dimension_raw AS tire_dimension_raw,
    t.width AS tire_width,
    t.aspect_ratio AS tire_aspect_ratio,
    t.diameter AS tire_diameter,
    t.construction AS tire_construction,
    t.load_index AS tire_load_index,
    t.speed_rating AS tire_speed_rating,
    t.season AS tire_season,

    -- Jantes
    r.rim_id,
    r.diameter AS rim_diameter,
    r.width AS rim_width,
    r.bolt_pattern,
    r.center_bore,
    r.offset,

    -- Chambres à air
    tb.tube_id,
    tb.width_min AS tube_width_min,
    tb.width_max AS tube_width_max,
    tb.diameter AS tube_diameter,
    tb.valve_type AS tube_valve_type,

    -- Identifiants
    i.identifier_id,
    i.type AS identifier_type,
    i.value AS identifier_value,
    i.country AS identifier_country,
    i.source AS identifier_source,
    i.is_primary AS identifier_is_primary

FROM agomarket.vp_products p
LEFT JOIN agomarket.vp_tires t
    ON t.product_id = p.product_id
LEFT JOIN agomarket.vp_rims r
    ON r.product_id = p.product_id
LEFT JOIN agomarket.vp_tubes tb
    ON tb.product_id = p.product_id
LEFT JOIN agomarket.vp_identifiers i
    ON i.product_id = p.product_id;