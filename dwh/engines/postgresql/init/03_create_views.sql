-- 02_create_views.sql
-- Vues consolidées du DWH AgoMarket

SET search_path TO agomarket;

------------------------------------------------------------
-- Vue : vw_products_full
------------------------------------------------------------
SET search_path TO agomarket;

CREATE OR REPLACE VIEW agomarket.vw_products_full AS
SELECT
    p.id AS product_id,
    p.supplier_id,
    p.type AS product_type,
    p.label,
    p.description,
    p.brand,
    p.created_at,
    p.updated_at,
    s.name AS supplier_name,
    s.legal_name AS supplier_legal_name,
    s.code AS supplier_code,
    s.country_code
FROM agomarket.products p
LEFT JOIN agomarket.suppliers s 
       ON s.id = p.supplier_id;


------------------------------------------------------------
-- Vue : vw_tires_full
------------------------------------------------------------
SET search_path TO agomarket;

CREATE OR REPLACE VIEW agomarket.vw_tires_full AS
SELECT
    p.product_id,
    p.supplier_id,
    p.product_type,
    p.label,
    p.description,
    p.brand,
    p.created_at,
    p.updated_at,

    t.width,
    t.height,
    t.diameter,
    t.load_index,
    t.speed_index,
    t.season,
    t.runflat

FROM agomarket.vw_products_full p
LEFT JOIN agomarket.tires t 
       ON t.product_id = p.product_id
WHERE p.product_type = 'tire';


------------------------------------------------------------
-- Vue : vw_rims_full
------------------------------------------------------------
SET search_path TO agomarket;

CREATE OR REPLACE VIEW agomarket.vw_rims_full AS
SELECT
    p.product_id,
    p.supplier_id,
    p.product_type,
    p.label,
    p.description,
    p.brand,
    p.created_at,
    p.updated_at,

    r.diameter,
    r.width AS rim_width,
    r.holes,
    r.pcd,
    r.et,
    r.color,
    r.finish

FROM agomarket.vw_products_full p
LEFT JOIN agomarket.rims r 
       ON r.product_id = p.product_id
WHERE p.product_type = 'rim';


------------------------------------------------------------
-- Vue : vw_tubes_full
------------------------------------------------------------
SET search_path TO agomarket;

CREATE OR REPLACE VIEW agomarket.vw_tubes_full AS
SELECT
    p.product_id,
    p.supplier_id,
    p.product_type,
    p.label,
    p.description,
    p.brand,
    p.created_at,
    p.updated_at,

    t.valve_type,
    t.compatible_sizes

FROM agomarket.vw_products_full p
LEFT JOIN agomarket.tubes t 
       ON t.product_id = p.product_id
WHERE p.product_type = 'tube';


------------------------------------------------------------
-- Vue : vw_product_attributes
------------------------------------------------------------
CREATE OR REPLACE VIEW agomarket.vw_product_attributes AS
SELECT
    pa.product_id,
    pa.attribute_code,
    ad.label AS attribute_label,
    pa.value AS attribute_value
FROM agomarket.product_attributes pa
LEFT JOIN agomarket.attribute_definitions ad ON ad.code = pa.attribute_code;


------------------------------------------------------------
-- Vue : vw_product_identifiers
------------------------------------------------------------
CREATE OR REPLACE VIEW agomarket.vw_product_identifiers AS
SELECT
    product_id,
    type,
    value
FROM agomarket.product_identifiers;


------------------------------------------------------------
-- Vue : vw_product_pricing
------------------------------------------------------------
CREATE OR REPLACE VIEW agomarket.vw_product_pricing AS
SELECT
    product_id,
    supplier_price,
    retail_price,
    currency,
    valid_from,
    valid_to
FROM agomarket.pricing;


------------------------------------------------------------
-- Vue : vw_product_stock
------------------------------------------------------------
SET search_path TO agomarket;

CREATE OR REPLACE VIEW agomarket.vw_product_stock AS
SELECT
    s.id AS stock_id,
    s.product_id,
    s.warehouse_code,
    s.quantity,
    s.updated_at
FROM agomarket.stock s;


------------------------------------------------------------
-- Vue : vw_product_logistics
------------------------------------------------------------
SET search_path TO agomarket;

CREATE OR REPLACE VIEW agomarket.vw_product_logistics AS
SELECT
    l.id AS logistics_id,
    l.product_id,
    l.weight_kg,
    l.width_cm,
    l.height_cm,
    l.length_cm,
    l.package_type
FROM agomarket.logistics l;


------------------------------------------------------------
-- Vue : vw_product_categories
------------------------------------------------------------
SET search_path TO agomarket;

CREATE OR REPLACE VIEW agomarket.vw_product_categories AS
SELECT
    pcl.product_id,
    pcl.id AS link_id,
    c.id AS category_id,
    c.name AS category_name,
    sc.id AS sub_category_id,
    sc.name AS sub_category_name
FROM agomarket.product_category_links pcl
LEFT JOIN agomarket.sub_categories sc 
       ON sc.id = pcl.sub_category_id
LEFT JOIN agomarket.categories c 
       ON c.id = sc.category_id;


------------------------------------------------------------
-- Vue finale : vw_agomarket_catalog
------------------------------------------------------------
SET search_path TO agomarket;

CREATE OR REPLACE VIEW agomarket.vw_agomarket_catalog AS
SELECT
    -- Produit
    p.product_id,
    p.supplier_id,
    p.product_type,
    p.label,
    p.description,
    p.brand,
    p.created_at,
    p.updated_at,

    -- Identifiant EAN
    id.value AS ean,

    -- Prix
    pr.supplier_price,
    pr.retail_price,
    pr.currency,
    pr.valid_from,
    pr.valid_to,

    -- Stock
    st.stock_id,
    st.quantity AS stock_quantity,
    st.updated_at AS stock_updated_at,

    -- Catégories
    cat.category_id,
    cat.category_name,
    cat.sub_category_id,
    cat.sub_category_name

FROM agomarket.vw_products_full p
LEFT JOIN agomarket.vw_product_identifiers id 
       ON id.product_id = p.product_id 
      AND id.type = 'EAN'
LEFT JOIN agomarket.vw_product_pricing pr 
       ON pr.product_id = p.product_id
LEFT JOIN agomarket.vw_product_stock st 
       ON st.product_id = p.product_id
LEFT JOIN agomarket.vw_product_categories cat 
       ON cat.product_id = p.product_id;