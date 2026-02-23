CREATE OR REPLACE VIEW agomarket.vp_endpoints AS
SELECT
    e.id AS endpoint_id,
    e.source_system,
    e.endpoint_url,
    e.method,
    e.auth_type,
    e.auth_credentials,
    e.is_active,
    e.created_at,
    e.updated_at
FROM agomarket.endpoints e;