-- Roles de usuario: resident (vecino), admin, guard (seguridad).

ALTER TABLE users ADD COLUMN IF NOT EXISTS role VARCHAR(20) NOT NULL DEFAULT 'resident';
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- El usuario demo se convierte en admin para desarrollo.
UPDATE users SET role = 'admin' WHERE email = 'vecino@alertavecino.com';
