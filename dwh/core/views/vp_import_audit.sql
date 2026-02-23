CREATE OR REPLACE VIEW agomarket.vp_import_audit AS
SELECT
    a.id AS audit_id,
    a.import_id,
    a.step AS audit_step,
    a.status AS audit_status,
    a.details AS audit_details,
    a.created_at AS audit_created_at
FROM agomarket.import_audit a;