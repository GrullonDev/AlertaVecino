CREATE TABLE IF NOT EXISTS residencies (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name           VARCHAR(200) NOT NULL,
    location       VARCHAR(300),
    resident_count INTEGER NOT NULL DEFAULT 0,
    is_active      BOOLEAN NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_residencies_active ON residencies(is_active);

INSERT INTO residencies (name, location, resident_count) VALUES
    ('Colonia La Esperanza',    'Zona 10, Guatemala',         234),
    ('Residencial Los Álamos',  'Zona 16, Guatemala',         180),
    ('Condominio Vista Hermosa','Zona 15, Guatemala',         312),
    ('Residencial El Encinal',  'Carretera a El Salvador',    156),
    ('Torres del Campo',        'Zona 14, Guatemala',         420),
    ('Colonia San Cristóbal',   'Mixco, Guatemala',            98)
ON CONFLICT DO NOTHING;
