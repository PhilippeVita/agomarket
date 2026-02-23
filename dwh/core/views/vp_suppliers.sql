CREATE OR REPLACE VIEW agomarket.vp_suppliers AS
SELECT
    s.id AS supplier_id,
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
    s.created_at,
    s.updated_at
FROM agomarket.suppliers s;