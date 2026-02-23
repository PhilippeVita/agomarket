CREATE OR REPLACE VIEW agomarket.vp_logistics_logs AS
SELECT
    ll.id AS logistics_log_id,
    ll.logistics_id,
    ll.previous_values,
    ll.new_values,
    ll.change_type,
    ll.source,
    ll.processed_at,
    ll.created_at
FROM agomarket.logistics_logs ll;