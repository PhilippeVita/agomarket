CREATE OR REPLACE VIEW agomarket.vp_sync_logs AS
SELECT
    sl.id AS sync_log_id,
    sl.entity_type,
    sl.entity_id,
    sl.operation,
    sl.status,
    sl.message,
    sl.payload_sent,
    sl.payload_received,
    sl.synced_at,
    sl.created_at
FROM agomarket.sync_logs sl;