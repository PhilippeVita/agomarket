CREATE OR REPLACE VIEW agomarket.vp_stock_logs AS
SELECT
    sl.id AS stock_log_id,
    sl.stock_id,
    sl.previous_quantity,
    sl.new_quantity,
    sl.change_type,
    sl.source,
    sl.processed_at,
    sl.created_at
FROM agomarket.stock_logs sl;