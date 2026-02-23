CREATE OR REPLACE VIEW agomarket.vp_mappings AS
SELECT
    m.id AS mapping_id,
    m.local_field,
    m.external_field,
    m.source_system,
    m.data_type,
    m.transformation_rule,
    m.is_active,
    m.created_at,
    m.updated_at
FROM agomarket.mappings m;