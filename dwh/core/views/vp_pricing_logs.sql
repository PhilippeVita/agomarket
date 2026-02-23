CREATE OR REPLACE VIEW agomarket.vp_pricing_logs AS
SELECT
    pl.id AS pricing_log_id,
    pl.price_id,
    pl.previous_price,
    pl.new_price,
    pl.previous_discount,
    pl.new_discount,
    pl.change_type,
    pl.source,
    pl.processed_at,
    pl.created_at
FROM agomarket.pricing_logs pl;