-- Comunicados oficiales de administración.

CREATE TABLE IF NOT EXISTS announcements (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title       VARCHAR(300) NOT NULL,
    body        TEXT NOT NULL,
    category    VARCHAR(20) NOT NULL DEFAULT 'info',
    image_url   TEXT,
    pdf_url     TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_announcements_category ON announcements(category);
CREATE INDEX IF NOT EXISTS idx_announcements_created ON announcements(created_at DESC);

-- Constraint: category must be one of the valid values.
ALTER TABLE announcements
    ADD CONSTRAINT chk_announcements_category
    CHECK (category IN ('urgent', 'maintenance', 'info'));
