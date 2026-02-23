CREATE OR REPLACE VIEW agomarket.04_pricing_catalog AS
SELECT
    -- Prix courant
    p.price_id,
    p.product_id,
    p.supplier_id,
    p.identifier_id,
    p.price,
    p.currency,
    p.priceHT,
    p.priceTTC,
    p.vatRate,
    p.price_type,
    p.min_quantity,
    p.discount,
    p.valid_from,
    p.valid_until,
    p.source AS price_source,
    p.notes AS price_notes,
    p.created_at AS price_created_at,
    p.updated_at AS price_updated_at,

    -- Logs de prix
    pl.pricing_log_id,
    pl.previous_price,
    pl.new_price,
    pl.previous_discount,
    pl.new_discount,
    pl.change_type AS pricing_change_type,
    pl.source AS pricing_change_source,
    pl.processed_at AS pricing_change_processed_at,
    pl.created_at AS pricing_log_created_at,

    -- Règles de pricing
    pr.pricing_rule_id,
    pr.rule_name,
    pr.rule_type,
    pr.value AS rule_value,
    pr.conditions AS rule_conditions,
    pr.priority AS rule_priority,
    pr.is_active AS rule_is_active,
    pr.created_at AS rule_created_at,
    pr.updated_at AS rule_updated_at,

    -- Statistiques de prix
    ps.price_statistics_id,
    ps.period_start,
    ps.period_end,
    ps.min_price AS stats_min_price,
    ps.max_price AS stats_max_price,
    ps.avg_price AS stats_avg_price,
    ps.median_price AS stats_median_price,
    ps.supplier_count AS stats_supplier_count,
    ps.price_change_count AS stats_change_count,
    ps.price_variance AS stats_variance,
    ps.calculated_at AS stats_calculated_at,

    -- Historique de prix
    ph.price_history_id,
    ph.price AS history_price,
    ph.currency AS history_currency,
    ph.priceHT AS history_priceHT,
    ph.priceTTC AS history_priceTTC,
    ph.vatRate AS history_vatRate,
    ph.price_type AS history_price_type,
    ph.min_quantity AS history_min_quantity,
    ph.discount AS history_discount,
    ph.valid_from AS history_valid_from,
    ph.valid_until AS history_valid_until,
    ph.source AS history_source,
    ph.notes AS history_notes,
    ph.created_at AS history_created_at

FROM agomarket.vp_pricing p
LEFT JOIN agomarket.vp_pricing_logs pl
    ON pl.price_id = p.price_id
LEFT JOIN agomarket.vp_pricing_rules pr
    ON pr.supplier_id = p.supplier_id
LEFT JOIN agomarket.vp_price_statistics ps
    ON ps.product_id = p.product_id
LEFT JOIN agomarket.vp_price_histories ph
    ON ph.product_id = p.product_id
   AND ph.supplier_id = p.supplier_id;