CREATE OR REPLACE VIEW agomarket.vp_lead_times AS
SELECT
    lt.id AS lead_time_id,
    lt.supplier_id,
    lt.product_id,
    lt.lead_time_days,
    lt.lead_time_type,
    lt.notes,
    lt.created_at,
    lt.updated_at
FROM agomarket.lead_times lt;