CREATE OR REPLACE VIEW agomarket.vp_price_statistics AS
SELECT
    ps.id AS price_statistics_id,
    ps.product_id,
    ps.period_start,
    ps.period_end,
    ps.min_price,
    ps.max_price,
    ps.avg_price,
    ps.median_price,
    ps.supplier_count,
    ps.price_change_count,
    ps.price_variance,
    ps.calculated_at
FROM agomarket.price_statistics ps;