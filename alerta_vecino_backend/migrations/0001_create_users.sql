-- Esquema base de AlertaVecino.
-- Ejecutar una sola vez contra la base de datos `alerta_vecino_db`:
--   psql -U alerta_vecino -d alerta_vecino_db -f migrations/0001_create_users.sql

CREATE TABLE IF NOT EXISTS users (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    first_name    VARCHAR(100),
    last_name     VARCHAR(100),
    residency     VARCHAR(150),
    house         VARCHAR(50),
    is_active     BOOLEAN NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Índice para búsquedas por correo durante el login.
CREATE UNIQUE INDEX IF NOT EXISTS users_email_idx ON users (email);

-- Usuario de prueba (password en claro SOLO para desarrollo).
INSERT INTO users (email, password_hash, first_name, last_name, residency, house)
VALUES (
    'vecino@alertavecino.com',
    'prueba12345',
    'Vecino',
    'Demo',
    'Residencial Los Sauces',
    'Casa #42'
)
ON CONFLICT (email) DO NOTHING;
