CREATE OR REPLACE VIEW agomarket.vp_products AS
SELECT
    p.id AS product_id,
    p.external_id,
    p.type,
    p.libelle,
    p.marque,
    p.modele,
    p.description,
    p.created_at,
    p.updated_at
FROM agomarket.products p;