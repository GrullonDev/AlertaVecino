-- Expand panic_alerts status to support the full verification workflow.
-- Valid values: pending, registered, notified, acknowledged, responding, resolved, cancelled

-- Existing rows have status='active'; remap to 'registered'.
UPDATE panic_alerts SET status = 'registered' WHERE status = 'active';
