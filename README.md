# AlertaVecino

**AlertaVecino** es una plataforma comunitaria integral de seguridad y gestión residencial para condominios, sectores y comunidades vecinales. Reemplaza los grupos de mensajería genéricos por una red privada y verificada donde cada usuario está asociado a una residencia concreta.

---

## El Problema

Las comunidades vecinales dependen de grupos de WhatsApp para comunicarse, lo que genera:

1. **Alertas desordenadas** — incidentes mezclados con conversación cotidiana.
2. **Falta de ubicación precisa** — reportes ambiguos que retrasan la respuesta.
3. **Pérdida de historial** — sin trazabilidad ni análisis de zonas de riesgo.

---

## Solución

Una red privada por colonia con tres componentes:

- **App Móvil** (Flutter) — para residentes: botón de pánico, pases de visita con QR, comunicados, mapa de alertas.
- **Backend API** (Dart Frog + PostgreSQL) — autenticación JWT, roles, endpoints REST.
- **Panel Web** (HTML/CSS/JS) — para administradores y guardias de seguridad.

---

## Características Implementadas

- **Autenticación completa** — registro, login con JWT (HS256), roles (resident/admin/guard), aprobación de cuentas por administrador.
- **Botón de Pánico** — activación en 2 pasos con cuenta regresiva, alertas activas con resolución.
- **Control de Visitas** — pases con QR (`alertavecino://pass/<id>`), flujo de estados (expected → at_gate → entered → expired).
- **Comunicados** — CRUD de avisos oficiales con categorías (urgent/maintenance/info).
- **Panel de Administración Web** — gestión de residentes (aprobar/rechazar) y verificación de pases para guardias.
- **Geolocalización** — mapa de reportes activos con marcadores y filtros.

---

## Stack Tecnológico

| Componente | Tecnología |
|---|---|
| App Móvil | Flutter 3.47.1 (FVM), Dart ^3.11.5, Material 3, Provider + ChangeNotifier, GetIt |
| Backend | Dart Frog, PostgreSQL 17, JWT (dart_jsonwebtoken), bcrypt |
| Panel Web | HTML5 / CSS3 / JavaScript vanilla |
| QR | qr_flutter (generación), alertavecino:// URL scheme |
| Mapas | flutter_map + latlong2 |

---

## Estructura del Proyecto

```
AlertaVecino/
├── lib/                            # App Flutter (feature-first)
│   ├── features/
│   │   ├── auth/                   # login, registro, selección de residencia
│   │   ├── home/                   # dashboard
│   │   ├── panic/                  # botón de pánico
│   │   ├── visitors/               # pases de visita + QR
│   │   ├── announcements/          # comunicados
│   │   ├── alerts/                 # historial de alertas
│   │   ├── maps/                   # mapa de reportes
│   │   └── profile/                # perfil de usuario
│   ├── l10n/                       # app_es.arb, app_en.arb
│   └── utils/                      # DI, router, widgets globales
├── alerta_vecino_backend/          # Backend Dart Frog
│   ├── routes/api/v1/              # Endpoints REST
│   │   ├── auth/                   # login, register, me, complete-profile, select_residency
│   │   ├── admin/                  # users (list/approve/reject/delete), announcements (create)
│   │   ├── announcements/          # list, detail
│   │   ├── panic/                  # trigger, active, [id]/resolve
│   │   └── visitors/passes/        # list, create, [id] detail, [id]/status
│   ├── migrations/                 # 0001–0006 SQL migrations
│   └── build.sh                    # Build con fix de route ordering
├── admin_web/                      # Panel web admin/guardia
│   ├── index.html
│   ├── style.css
│   └── app.js
└── .env                            # Variables de entorno (no commitear)
```

---

## Configuración de Desarrollo

### Prerrequisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (o FVM)
- [Dart Frog CLI](https://dartfrog.vgv.dev/)
- PostgreSQL 17
- Un emulador o dispositivo físico

### Instalación

```bash
git clone git@github.com:GrullonDev/AlertaVecino.git
cd AlertaVecino

# Frontend
flutter pub get
flutter gen-l10n

# Backend
cd alerta_vecino_backend
dart pub get
# Aplicar migraciones (requiere PostgreSQL corriendo)
psql -U alerta_vecino -d alerta_vecino_db -f migrations/0001_create_users.sql
# ... hasta 0006
```

### Ejecución

```bash
# Backend (desde alerta_vecino_backend/)
./build.sh                          # Build con fix de route ordering
dart build/bin/server.dart          # http://localhost:8080

# App Flutter (desde la raíz)
flutter run

# Panel Web (desde admin_web/)
python3 -m http.server 3000        # http://localhost:3000
```

### Variables de Entorno

**Frontend** (`.env` en la raíz):
```
API_BASE_URL=http://10.0.2.2:8080/api
```
> `10.0.2.2` = host desde el emulador Android. En iOS Simulator usa `localhost`. En dispositivo físico, la IP LAN.

**Backend** (`.env` en `alerta_vecino_backend/`): credenciales PostgreSQL y secreto JWT.

---

## API Endpoints

### Autenticación (`/api/v1/auth`)
| Método | Ruta | Descripción |
|---|---|---|
| POST | `/login` | Login con email + password, devuelve JWT con rol |
| POST | `/register` | Registro de nuevo residente (status: pending) |
| GET | `/me` | Datos del usuario autenticado |
| POST | `/complete-profile` | Completar residencia y unidad |
| POST | `/select_residency` | Cambiar residencia activa |
| GET | `/pending_approval` | Estado de aprobación |

### Administración (`/api/v1/admin`) — requiere rol admin
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/users?status=` | Listar usuarios con filtro opcional |
| POST | `/users/approve` | Aprobar residente |
| POST | `/users/reject` | Rechazar residente |
| POST | `/users/create` | Crear usuario |
| POST | `/users/delete` | Eliminar usuario |
| POST | `/announcements/create` | Crear comunicado |

### Comunicados (`/api/v1/announcements`)
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/?category=` | Listar comunicados con filtro |
| GET | `/:id` | Detalle de comunicado |

### Pases de Visita (`/api/v1/visitors/passes`)
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/` | Listar pases del residente autenticado |
| POST | `/` | Crear nuevo pase |
| GET | `/:id` | Detalle del pase (incluye datos del residente) |
| PATCH | `/:id/status` | Cambiar estado (admin/guard para at_gate/entered) |

### Pánico (`/api/v1/panic`)
| Método | Ruta | Descripción |
|---|---|---|
| POST | `/trigger` | Activar alerta de pánico |
| GET | `/active` | Alertas activas |
| POST | `/:id/resolve` | Resolver alerta |

---

## Roles de Usuario

| Rol | Acceso App | Acceso Panel Web | Capacidades |
|---|---|---|---|
| `resident` | Completo | No | Crear pases, reportar, ver comunicados |
| `admin` | Completo | Completo | Aprobar/rechazar residentes, crear comunicados, gestionar pases |
| `guard` | Limitado | Solo pases | Verificar pases QR, registrar entradas |

---

## Contribución

Actualmente mantenido por el equipo principal de desarrollo.
