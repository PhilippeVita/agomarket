CREATE OR REPLACE VIEW agomarket.vp_suppliers_catalog AS
SELECT
    sc.id AS supplier_catalog_id,
    sc.supplier_id,
    sc.identifier_id,
    sc.external_id,
    sc.external_code,
    sc.source_system,
    sc.sync_status,
    sc.sync_message,
    sc.last_synced_at,
    sc.created_at,
    sc.updated_at
FROM agomarket.suppliers_catalog sc;