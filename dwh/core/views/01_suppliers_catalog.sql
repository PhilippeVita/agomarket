CREATE OR REPLACE VIEW agomarket.01_suppliers_catalog AS
SELECT
    s.supplier_id,
    s.external_id,
    s.name,
    s.legal_name,
    s.country_code,
    s.email,
    s.phone,
    s.website,
    s.logo_url,
    s.address,
    s.postal_code,
    s.city,
    s.is_active,
    s.notes,
    s.created_at AS supplier_created_at,
    s.updated_at AS supplier_updated_at,

    d.import_id,
    d.file_name,
    d.file_size,
    d.rows_processed,
    d.rows_success,
    d.rows_error,
    d.import_status,
    d.error_log,
    d.imported_at,
    d.processed_at,

    a.audit_id,
    a.audit_step,
    a.audit_status,
    a.audit_details,
    a.audit_created_at,

    al.alert_id,
    al.alert_level,
    al.alert_message,
    al.alert_created_at

FROM agomarket.vp_suppliers s
LEFT JOIN agomarket.vp_import_data d
    ON d.supplier_id = s.supplier_id
LEFT JOIN agomarket.vp_import_audit a
    ON a.import_id = d.import_id
LEFT JOIN agomarket.vp_import_alert al
    ON al.import_id = d.import_id;
