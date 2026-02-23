CREATE OR REPLACE VIEW agomarket.vp_pricing_rules AS
SELECT
    pr.id AS pricing_rule_id,
    pr.supplier_id,
    pr.rule_name,
    pr.rule_type,
    pr.value,
    pr.conditions,
    pr.priority,
    pr.is_active,
    pr.created_at,
    pr.updated_at
FROM agomarket.pricing_rules pr;