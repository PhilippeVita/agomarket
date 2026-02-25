CREATE OR REPLACE VIEW agomarket.99_agomarket_catalog AS
SELECT
    -- ============================
    -- BLOC 2 : PRODUITS (pivot)
    -- ============================
    p.*,

    -- ============================
    -- BLOC 1 : FOURNISSEURS
    -- ============================
    s.supplier_id AS supplier_supplier_id,
    s.external_id AS supplier_external_id,
    s.name AS supplier_name,
    s.legal_name AS supplier_legal_name,
    s.country_code AS supplier_country_code,
    s.email AS supplier_email,
    s.phone AS supplier_phone,
    s.website AS supplier_website,
    s.logo_url AS supplier_logo_url,
    s.address AS supplier_address,
    s.postal_code AS supplier_postal_code,
    s.city AS supplier_city,
    s.is_active AS supplier_is_active,
    s.notes AS supplier_notes,
    s.supplier_created_at,
    s.supplier_updated_at,
    s.import_id,
    s.file_name AS import_file_name,
    s.file_size AS import_file_size,
    s.rows_processed AS import_rows_processed,
    s.rows_success AS import_rows_success,
    s.rows_error AS import_rows_error,
    s.import_status,
    s.error_log AS import_error_log,
    s.imported_at,
    s.processed_at,
    s.audit_id,
    s.audit_step,
    s.audit_status,
    s.audit_details,
    s.audit_created_at,
    s.alert_id,
    s.alert_level,
    s.alert_message,
    s.alert_created_at,

    -- ============================
    -- BLOC 3 : STOCKS
    -- ============================
    st.stock_id,
    st.quantity,
    st.quantity_reserved,
    st.quantity_in_transit,
    st.availability_status,
    st.warehouse_code,
    st.price_supplier,
    st.stock_currency,
    st.min_order_quantity,
    st.stock_created_at,
    st.stock_updated_at,
    st.stock_log_id,
    st.stock_previous_quantity,
    st.stock_new_quantity,
    st.stock_change_type,
    st.stock_change_source,
    st.stock_change_processed_at,
    st.stock_log_created_at,
    st.lead_time_id,
    st.lead_time_days,
    st.lead_time_type,
    st.lead_time_notes,
    st.lead_time_created_at,
    st.lead_time_updated_at,

    -- ============================
    -- BLOC 4 : PRICING
    -- ============================
    pr.price_id,
    pr.price,
    pr.price_currency,
    pr.priceHT,
    pr.priceTTC,
    pr.vatRate,
    pr.price_type,
    pr.price_min_quantity,
    pr.price_discount,
    pr.price_valid_from,
    pr.price_valid_until,
    pr.price_source,
    pr.price_notes,
    pr.price_created_at,
    pr.price_updated_at,
    pr.pricing_log_id,
    pr.pricing_previous_price,
    pr.pricing_new_price,
    pr.pricing_previous_discount,
    pr.pricing_new_discount,
    pr.pricing_change_type,
    pr.pricing_change_source,
    pr.pricing_change_processed_at,
    pr.pricing_log_created_at,
    pr.pricing_rule_id,
    pr.rule_name,
    pr.rule_type,
    pr.rule_value,
    pr.rule_conditions,
    pr.rule_priority,
    pr.rule_is_active,
    pr.rule_created_at,
    pr.rule_updated_at,
    pr.price_statistics_id,
    pr.period_start,
    pr.period_end,
    pr.stats_min_price,
    pr.stats_max_price,
    pr.stats_avg_price,
    pr.stats_median_price,
    pr.stats_supplier_count,
    pr.stats_change_count,
    pr.stats_variance,
    pr.stats_calculated_at,
    pr.price_history_id,
    pr.history_price,
    pr.history_currency,
    pr.history_priceHT,
    pr.history_priceTTC,
    pr.history_vatRate,
    pr.history_price_type,
    pr.history_min_quantity,
    pr.history_discount,
    pr.history_valid_from,
    pr.history_valid_until,
    pr.history_source,
    pr.history_notes,
    pr.history_created_at,

    -- ============================
    -- BLOC 5 : LOGISTICS
    -- ============================
    lg.logistics_id,
    lg.logistics_identifier_id,
    lg.package_type,
    lg.package_width,
    lg.package_height,
    lg.package_length,
    lg.package_weight,
    lg.stackable,
    lg.hazardous_material,
    lg.shipping_class,
    lg.incoterm,
    lg.origin_warehouse,
    lg.logistics_created_at,
    lg.logistics_updated_at,
    lg.logistics_log_id,
    lg.logistics_previous_values,
    lg.logistics_new_values,
    lg.logistics_change_type,
    lg.logistics_change_source,
    lg.logistics_change_processed_at,
    lg.logistics_log_created_at,
    lg.shipping_option_id,
    lg.shipping_option_name,
    lg.shipping_option_description,
    lg.delivery_time_min,
    lg.delivery_time_max,
    lg.shipping_cost,
    lg.shipping_currency,
    lg.shipping_conditions,
    lg.shipping_is_active,
    lg.shipping_created_at,
    lg.shipping_updated_at,

    -- ============================
    -- BLOC 6 : AGOLINK
    -- ============================
    a.product_catalog_id,
    a.product_external_id,
    a.product_external_code,
    a.product_source_system,
    a.product_sync_status,
    a.product_sync_message,
    a.product_last_synced_at,
    a.supplier_catalog_id,
    a.supplier_external_id,
    a.supplier_external_code,
    a.supplier_source_system,
    a.supplier_sync_status,
    a.supplier_sync_message,
    a.supplier_last_synced_at,
    a.endpoint_id,
    a.endpoint_url,
    a.endpoint_method,
    a.auth_type,
    a.auth_credentials,
    a.endpoint_is_active,
    a.mapping_id,
    a.local_field,
    a.external_field,
    a.data_type,
    a.transformation_rule,
    a.mapping_is_active,
    a.sync_log_id,
    a.entity_type,
    a.entity_id,
    a.operation,
    a.agolink_sync_status,
    a.agolink_sync_message,
    a.payload_sent,
    a.payload_received,
    a.sync_timestamp

FROM agomarket.02_products_catalog p

LEFT JOIN agomarket.01_suppliers_catalog s
    ON s.supplier_id = p.supplier_id

LEFT JOIN agomarket.03_stocks_catalog st
    ON st.product_id = p.product_id
   AND st.supplier_id = p.supplier_id

LEFT JOIN agomarket.04_pricing_catalog pr
    ON pr.product_id = p.product_id
   AND pr.supplier_id = p.supplier_id

LEFT JOIN agomarket.05_logistics_catalog lg
    ON lg.product_id = p.product_id
   AND lg.supplier_id = p.supplier_id

LEFT JOIN agomarket.06_agolink_catalog a
    ON a.product_id = p.product_id;