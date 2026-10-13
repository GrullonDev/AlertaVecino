-- Flujo de verificación de residentes (aprobación por administración).
--
-- Agrega el estado de la solicitud de registro y los datos de contacto que se
-- capturan en la app. Los usuarios creados antes de existir este flujo se
-- marcan como aprobados para no bloquear el acceso en desarrollo.

ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(30);
ALTER TABLE users ADD COLUMN IF NOT EXISTS status VARCHAR(20) NOT NULL DEFAULT 'pending';
ALTER TABLE users ADD COLUMN IF NOT EXISTS rejection_reason TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS verified_at TIMESTAMPTZ;

-- Usuarios existentes (previos al flujo de verificación) => aprobados.
UPDATE users
SET status = 'approved', verified_at = NOW()
WHERE status = 'pending';

-- Índice para que el panel de administración liste por estado rápidamente.
CREATE INDEX IF NOT EXISTS users_status_idx ON users (status);
