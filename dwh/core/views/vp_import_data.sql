CREATE OR REPLACE VIEW agomarket.vp_import_data AS
SELECT
    d.id AS import_id,
    d.supplier_id,
    d.file_name,
    d.file_size,
    d.rows_processed,
    d.rows_success,
    d.rows_error,
    d.status AS import_status,
    d.error_log,
    d.imported_at,
    d.processed_at
FROM agomarket.import_data d;