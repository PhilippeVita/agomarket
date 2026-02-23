CREATE OR REPLACE VIEW agomarket.06_agolink_catalog AS
SELECT
    -- PRODUITS EXTERNES
    pc.product_catalog_id,
    pc.product_id,
    pc.identifier_id AS product_identifier_id,
    pc.external_id AS product_external_id,
    pc.external_code AS product_external_code,
    pc.source_system AS product_source_system,
    pc.sync_status AS product_sync_status,
    pc.sync_message AS product_sync_message,
    pc.last_synced_at AS product_last_synced_at,
    pc.created_at AS product_catalog_created_at,
    pc.updated_at AS product_catalog_updated_at,

    -- FOURNISSEURS EXTERNES
    sc.supplier_catalog_id,
    sc.supplier_id,
    sc.identifier_id AS supplier_identifier_id,
    sc.external_id AS supplier_external_id,
    sc.external_code AS supplier_external_code,
    sc.source_system AS supplier_source_system,
    sc.sync_status AS supplier_sync_status,
    sc.sync_message AS supplier_sync_message,
    sc.last_synced_at AS supplier_last_synced_at,
    sc.created_at AS supplier_catalog_created_at,
    sc.updated_at AS supplier_catalog_updated_at,

    -- ENDPOINTS
    e.endpoint_id,
    e.endpoint_url,
    e.method AS endpoint_method,
    e.auth_type,
    e.auth_credentials,
    e.is_active AS endpoint_is_active,
    e.created_at AS endpoint_created_at,
    e.updated_at AS endpoint_updated_at,

    -- MAPPINGS
    m.mapping_id,
    m.local_field,
    m.external_field,
    m.data_type,
    m.transformation_rule,
    m.is_active AS mapping_is_active,
    m.created_at AS mapping_created_at,
    m.updated_at AS mapping_updated_at,

    -- LOGS DE SYNCHRO
    sl.sync_log_id,
    sl.entity_type,
    sl.entity_id,
    sl.operation,
    sl.status AS sync_status,
    sl.message AS sync_message,
    sl.payload_sent,
    sl.payload_received,
    sl.synced_at AS sync_timestamp,
    sl.created_at AS sync_log_created_at

FROM agomarket.vp_products_catalog pc
LEFT JOIN agomarket.vp_suppliers_catalog sc
    ON sc.source_system = pc.source_system
LEFT JOIN agomarket.vp_endpoints e
    ON e.source_system = pc.source_system
LEFT JOIN agomarket.vp_mappings m
    ON m.source_system = pc.source_system
LEFT JOIN agomarket.vp_sync_logs sl
    ON sl.entity_id = pc.product_id
   AND sl.entity_type = 'products';