-- Pases de visita generados por los residentes.

CREATE TABLE IF NOT EXISTS visitor_passes (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    resident_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    visitor_name  VARCHAR(200) NOT NULL,
    dpi           VARCHAR(30),
    plate         VARCHAR(20),
    visit_type    VARCHAR(20) NOT NULL DEFAULT 'other',
    valid_from    TIMESTAMPTZ NOT NULL,
    valid_until   TIMESTAMPTZ NOT NULL,
    status        VARCHAR(20) NOT NULL DEFAULT 'expected',
    entry_time    TIMESTAMPTZ,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_visitor_passes_resident
    ON visitor_passes(resident_id);
CREATE INDEX IF NOT EXISTS idx_visitor_passes_status
    ON visitor_passes(status);

ALTER TABLE visitor_passes
    ADD CONSTRAINT chk_visit_type
    CHECK (visit_type IN ('family', 'delivery', 'service', 'other'));

ALTER TABLE visitor_passes
    ADD CONSTRAINT chk_visitor_status
    CHECK (status IN ('expected', 'at_gate', 'entered', 'expired'));
