CREATE OR REPLACE VIEW agomarket.03_stocks_catalog AS
SELECT
    -- Stock principal
    st.stock_id,
    st.supplier_id,
    st.product_id,
    st.quantity,
    st.quantity_reserved,
    st.quantity_in_transit,
    st.availability_status,
    st.warehouse_code,
    st.price_supplier,
    st.currency,
    st.min_order_quantity,
    st.created_at AS stock_created_at,
    st.updated_at AS stock_updated_at,

    -- Logs de stock
    sl.stock_log_id,
    sl.previous_quantity,
    sl.new_quantity,
    sl.change_type AS stock_change_type,
    sl.source AS stock_change_source,
    sl.processed_at AS stock_change_processed_at,
    sl.created_at AS stock_log_created_at,

    -- Lead times
    lt.lead_time_id,
    lt.lead_time_days,
    lt.lead_time_type,
    lt.notes AS lead_time_notes,
    lt.created_at AS lead_time_created_at,
    lt.updated_at AS lead_time_updated_at

FROM agomarket.vp_stocks st
LEFT JOIN agomarket.vp_stock_logs sl
    ON sl.stock_id = st.stock_id
LEFT JOIN agomarket.vp_lead_times lt
    ON lt.product_id = st.product_id
   AND lt.supplier_id = st.supplier_id;