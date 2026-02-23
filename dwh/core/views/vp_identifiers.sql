CREATE OR REPLACE VIEW agomarket.vp_identifiers AS
SELECT
    i.id AS identifier_id,
    i.product_id,
    i.type,
    i.value,
    i.country,
    i.source,
    i.is_primary,
    i.is_active,
    i.created_at,
    i.updated_at
FROM agomarket.identifiers i;