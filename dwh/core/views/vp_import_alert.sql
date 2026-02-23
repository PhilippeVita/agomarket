CREATE OR REPLACE VIEW agomarket.vp_import_alert AS
SELECT
    al.id AS alert_id,
    al.import_id,
    al.level AS alert_level,
    al.message AS alert_message,
    al.created_at AS alert_created_at
FROM agomarket.import_alert al;