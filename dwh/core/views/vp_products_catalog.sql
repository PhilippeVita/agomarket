CREATE OR REPLACE VIEW agomarket.vp_products_catalog AS
SELECT
    pc.id AS product_catalog_id,
    pc.product_id,
    pc.identifier_id,
    pc.external_id,
    pc.external_code,
    pc.source_system,
    pc.sync_status,
    pc.sync_message,
    pc.last_synced_at,
    pc.created_at,
    pc.updated_at
FROM agomarket.products_catalog pc;