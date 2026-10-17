# AGENTS.md — AlertaVecino

> **Guía de contexto estricta y manual técnico.**
> Este documento es la fuente de verdad para cualquier IA o desarrollador que trabaje en el
> repositorio **AlertaVecino**. Léelo completo antes de escribir, refactorizar o revisar código.
> Si una instrucción de este archivo entra en conflicto con una práctica genérica, **prevalece este archivo**.

---

## 1. Visión General y Propósito del Proyecto

**AlertaVecino** es una plataforma de seguridad y gestión residencial para condominios,
sectores y comunidades vecinales. Reemplaza los grupos de mensajería genéricos (WhatsApp)
por una red privada y verificada, donde cada usuario está asociado a una residencia y a un
sector concreto, garantizando que solo reciba y emita alertas relevantes para su zona.

El problema que resuelve:

1. **Alertas desordenadas** — los incidentes se mezclan con conversación cotidiana.
2. **Falta de ubicación precisa** — reportes ambiguos ("por la entrada") que retrasan la respuesta.
3. **Pérdida de historial** — no hay trazabilidad ni análisis de zonas de riesgo.

### Módulos funcionales

| Módulo                          | Descripción                                                                                         |
| ------------------------------- | --------------------------------------------------------------------------------------------------- |
| **Autenticación / Onboarding**  | Login, registro, selección de residencia, aprobación pendiente.                                     |
| **Botón de Pánico**             | Activación en 2 pasos (selección de tipo → cuenta regresiva → alerta activa). Emergencias críticas. |
| **Control de Visitas**          | Generación de pases con **código QR**, compartir, visitante en puerta e historial.                  |
| **Comunicados (Announcements)** | Feed de avisos oficiales con detalle expandible.                                                    |
| **Alertas / Notificaciones**    | Historial filtrable y buscable de alertas y notificaciones.                                         |
| **Mapas y Geolocalización**     | Mapa de reportes activos con marcadores, filtros, búsqueda y botón SOS.                             |
| **Perfil (Profile)**            | Datos del usuario, residencia, preferencias y ajustes.                                              |
| **Home / Dashboard**            | Resumen con saludo, botón de pánico, acciones rápidas, comunicado destacado y visitas.              |

---

## 2. Stack Tecnológico Completo

### 2.1 Frontend Móvil

- **Framework:** [Flutter](https://flutter.dev/) — gestionado con **FVM** (versión fijada en `.fvmrc` → `3.47.1`).
- **Lenguaje:** Dart (SDK `^3.11.5`). Nombre del paquete: `neighbour_alert`.
- **UI:** **Material 3** (`useMaterial3: true`). Tema claro/oscuro centralizado en `lib/config/app_theme.dart`.
  Tipografía con `google_fonts` (Plus Jakarta Sans + Inter).
- **Arquitectura:** **Clean Architecture** por features, con capas **Data**, **Domain** y **Presentation**
  (en este repositorio la capa Domain puede fusionarse con `logic/` y `model/`).
- **Gestión de estado:** **`ChangeNotifier` + `Provider`** (`ChangeNotifierProvider` / `Consumer`).
  Toda la lógica de negocio y el estado viven en clases `*Logic extends ChangeNotifier`.
- **Inyección de dependencias:** **`GetIt`** (`sl`) — registro en `lib/utils/injection_container.dart`, invocado desde `main()`.
- **Internacionalización (i18n):** `flutter_localizations` + `intl` con archivos `.arb` (ES/EN) y `l10n.yaml`.
  Locale por defecto: **Español** (`app_es.arb` es el template).
- **Red:** `http` para llamadas REST; `flutter_dotenv` para variables de entorno (`.env`).
- **Mapas:** `flutter_map` + `latlong2`. **QR:** `qr_flutter`. **Compartir:** `share_plus`.
- **Diseño:** responsivo y mobile-first riguroso, con `EdgeInsets` y componentes reutilizables por feature.

### 2.2 Backend

- **Framework:** **Dart Frog** — enrutamiento **basado en archivos** bajo `routes/`.
  Cada archivo define un endpoint y exporta `onRequest(RequestContext context)`.
- **Autenticación:** **JWT real** con `dart_jsonwebtoken` (HS256, 24 h de expiración). El token incluye
  `sub` (userId), `email`, `residency`, `house` y `role`. Contraseñas hasheadas con `bcrypt`.
- **Roles:** `resident` (default), `admin`, `guard` — almacenados en `users.role` e incluidos en el JWT.
- **Middleware:** `routes/api/_middleware.dart` aplica CORS, JWT guard y pool de conexiones.
  `routes/api/v1/admin/_middleware.dart` acepta `x-admin-key` O JWT con `role=admin`.
- **Puerto por defecto:** `8080` (`PORT` sobrescribible por variable de entorno).
- **Nombre del paquete:** `alerta_vecino_backend`.
- **Build:** usar `./build.sh` (no `dart_frog build` directo) — el script limpia archivos AppleDouble
  y corrige el orden de montaje de rutas en `shelf_router` (rutas específicas antes que padres).

### 2.3 Base de Datos

- **PostgreSQL 17** (Homebrew).
- Conexión mediante **pool** (`package:postgres`) configurada en variables de entorno.
- **Migraciones** en `migrations/` (0001–0006): users, announcements, user roles, visitor_passes.
- SQL parametrizado con `Sql.named()` y `TypedValue` — nunca concatenar valores en queries.

### 2.4 Panel Web de Administración

- **Ubicación:** `admin_web/` — HTML/CSS/JS vanilla, sin framework.
- **Funcionalidad Admin:** tabla de usuarios con filtro por estado, acciones de aprobar/rechazar.
- **Funcionalidad Guardia:** búsqueda de pase por ID (o URL QR `alertavecino://pass/<id>`),
  visualización de detalles del visitante y residente, cambio de estado del pase.
- **Autenticación:** usa el mismo endpoint `/api/v1/auth/login`, almacena JWT en `sessionStorage`.
- **Servir:** cualquier servidor HTTP estático (e.g. `python3 -m http.server 3000`).

### 2.5 Variables de Entorno

**Frontend** (`.env` en la raíz; ya declarado como asset en `pubspec.yaml`):

```
API_BASE_URL=http://10.0.2.2:8080/api
```

- `10.0.2.2` es el alias del host para el **emulador de Android**. En iOS Simulator usa `localhost`;
  en dispositivo físico usa la IP LAN de la máquina.
- Acceso en código: `dotenv.env['API_BASE_URL']` (siempre con fallback).

**Backend** (`.env` propio del backend): credenciales de PostgreSQL y secreto JWT.
**Regla de oro:** ningún secreto, token ni credencial se commitea ni se imprime en logs.

---

## 3. Arquitectura y Estructura de Directorios

### 3.1 Frontend (`lib/`)

Estructura **feature-first**. Cada feature encapsula sus capas:

```
lib/
├── main.dart                       # Bootstrap: dotenv + GetIt init + runApp
├── config/
│   └── app_theme.dart              # AppColors + AppTheme.light/dark (Material 3)
├── features/
│   ├── splash.dart
│   ├── auth/
│   │   ├── login/
│   │   │   ├── data/               # datasource.dart, repository.dart
│   │   │   ├── logic/              # login_logic.dart (ChangeNotifier)
│   │   │   ├── model/              # login_request.dart, login_response.dart, user.dart
│   │   │   ├── pages/              # login_page.dart, login_layout.dart
│   │   │   └── widgets/            # componentes aislados y reutilizables
│   │   ├── register/
│   │   ├── select_residency/
│   │   └── pending_approval/
│   ├── home/                        # dashboard (panic, quick actions, greeting...)
│   ├── panic/                       # type_selection → countdown → active
│   ├── visitors/                    # pases QR, visitante en puerta, historial
│   ├── announcements/               # feed y detalle
│   ├── alerts/                      # historial + filtros + búsqueda
│   ├── maps/                        # flutter_map, markers, filtros, SOS
│   └── profile/
├── l10n/                           # app_es.arb, app_en.arb y archivos generados
└── utils/
    ├── app.dart                     # MaterialApp (tema, i18n, onGenerateRoute)
    ├── injection_container.dart     # Registro GetIt (sl)
    ├── router/
    │   ├── route_path.dart          # Constantes de rutas (nombres)
    │   └── route_switch.dart        # onGenerateRoute
    └── widgets/                     # widgets globales (AuthScaffold, WidgetNotFound)
```

**Convenciones de nombres:**

- Archivos y carpetas: `snake_case.dart`.
- Clases: `PascalCase`. Instancia global de GetIt: `sl` (service locator).
- Un widget por archivo, con nombre igual al archivo.
- Patrón de página: `*_page.dart` (dueña del `ChangeNotifierProvider`) y `*_layout.dart` (UI, `Consumer`).

### 3.2 Backend (`alerta_vecino_backend/`)

Enrutamiento **file-based**: la ruta HTTP se deriva de la estructura de carpetas.

```
alerta_vecino_backend/
├── lib/
│   ├── auth/
│   │   ├── jwt_service.dart        # issueSessionToken / verifySessionToken (HS256)
│   │   └── password_verifier.dart  # bcrypt verify
│   └── config/
│       └── env.dart                # Variables de entorno
├── routes/
│   ├── index.dart                  # GET / → health check
│   └── api/
│       ├── _middleware.dart         # CORS + JWT guard + DB pool
│       └── v1/
│           ├── auth/
│           │   ├── login.dart              # POST — login con JWT + rol
│           │   ├── register.dart           # POST — registro (status: pending)
│           │   ├── me.dart                 # GET  — datos del usuario
│           │   ├── complete-profile.dart   # POST — completar residencia
│           │   ├── select_residency.dart   # POST — cambiar residencia
│           │   └── pending_approval.dart   # GET  — estado de aprobación
│           ├── admin/
│           │   ├── _middleware.dart         # Admin guard (x-admin-key o JWT admin)
│           │   ├── users/
│           │   │   ├── index.dart          # GET  — listar usuarios (?status=)
│           │   │   ├── approve.dart        # POST — aprobar residente
│           │   │   ├── reject.dart         # POST — rechazar residente
│           │   │   ├── create.dart         # POST — crear usuario
│           │   │   └── delete.dart         # POST — eliminar usuario
│           │   └── announcements/
│           │       └── create.dart         # POST — crear comunicado
│           ├── announcements/
│           │   ├── index.dart              # GET  — listar (?category=)
│           │   └── [id].dart              # GET  — detalle
│           ├── visitors/passes/
│           │   ├── index.dart              # GET/POST — listar/crear pases
│           │   └── [id]/
│           │       ├── index.dart          # GET  — detalle del pase
│           │       └── status.dart         # PATCH — cambiar estado
│           └── panic/
│               ├── trigger.dart            # POST — activar pánico
│               ├── active.dart             # GET  — alertas activas
│               └── [id]/
│                   └── resolve.dart        # POST — resolver alerta
├── migrations/
│   ├── 0001_create_users.sql
│   ├── 0002_add_user_verification.sql
│   ├── 0003_fix_rejection_flow.sql
│   ├── 0004_create_announcements.sql
│   ├── 0005_add_user_roles.sql
│   └── 0006_create_visitor_passes.sql
├── build.sh                        # Build + fix route ordering + AppleDouble cleanup
├── pubspec.yaml
└── .env                            # (no commitear) DB + JWT secret
```

**Convenciones de endpoints:**

- Cada endpoint exporta `Future<Response> onRequest(RequestContext context)`.
- Valida el método HTTP explícitamente (`HttpMethod.post`, etc.) y responde `405` si no coincide.
- Usa `Response.json(...)` y códigos de estado de `dart:io` (`HttpStatus.*`).
- SQL parametrizado con `Sql.named()` + `TypedValue` — nunca concatenar valores.
- Rutas dinámicas (`[id]`) reciben el parámetro como `String id` en `onRequest`.

**Nota sobre routing:** Dart Frog genera el `server.dart` con mounts en orden que puede causar que
rutas padre capturen requests antes que rutas hijas (e.g. `/passes` antes de `/passes/<id>`).
El script `build.sh` corrige esto automáticamente. Siempre usar `./build.sh` en vez de `dart_frog build` directamente.

### 3.3 Panel Web (`admin_web/`)

```
admin_web/
├── index.html                      # Login + layout con tabs por rol
├── style.css                       # Design tokens, responsive
└── app.js                          # Auth, user management, pass scanner
```

---

## 4. Reglas de Codificación y Clean Code

### 4.1 Principios SOLID (aplicación estricta)

- **S — Responsabilidad única:** cada clase hace una sola cosa. Un `*Logic` no formatea UI; un widget no
  llama HTTP directamente; un datasource solo sabe hablar con el API.
- **O — Abierto/cerrado:** extiende comportamiento mediante nuevos widgets/clases, no con `if/else` crecientes
  dentro de componentes existentes.
- **L — Sustitución de Liskov:** las implementaciones (`*Impl`) deben respetar el contrato de su abstracción.
- **I — Segregación de interfaces:** interfaces (`DataSource`, `Repository`) pequeñas y específicas del feature.
- **D — Inversión de dependencias:** depende de abstracciones, no de implementaciones concretas.
  La construcción se resuelve en `injection_container.dart`, no dentro de los widgets.

### 4.2 Reglas de UI

- **Widgets de formulario limpios y orientados a `StatelessWidget`.** Siempre que no haya estado interno,
  usa `StatelessWidget`; reserva `StatefulWidget` solo para ciclos de vida/animation controllers.
- **La lógica de negocio NO vive en la UI.** Toda la lógica, validación y controladores (`TextEditingController`,
  `GlobalKey<FormState>`, `ValueNotifier`) se exponen desde el `ChangeNotifier` del feature y se consumen
  vía `Provider` (`Consumer` / `context.watch` / `context.read`).
- Patrón de composición obligatorio:
  - `XxxPage` (`StatelessWidget`) → crea el `ChangeNotifierProvider` inyectando el `Repository` de GetIt.
  - `XxxLayout` (`StatelessWidget`) → construye la UI dentro de un `Consumer<XxxLogic>`.
  - `XxxWidget` → componentes atómicos, sin lógica de negocio.
- **UI reactiva solo a lo necesario:** usa `Selector`/`Consumer` para evitar rebuilds innecesarios; para valores
  puntuales usa `ValueListenableBuilder`.
- **Internacionalización obligatoria:** ningún texto visible hardcodeado. Todo string pasa por
  `AppLocalizations.of(context)!` y se declara en `app_es.arb` **y** `app_en.arb`.
- **Accesibilidad y responsividad:** usa tokens del tema (`Theme.of(context).colorScheme`, `textTheme`),
  evitando colores/tamaños mágicos. Respeta safe areas y adapta paddings por breakpoint.
- **Navegación por nombres:** registra rutas en `RoutePath` y resuélvelas en `RouteSwitch`. No uses
  `MaterialPageRoute` inline dispersas por el código.

### 4.3 Estilo Dart / Flutter

- Respeta `analysis_options.yaml`: `flutter_lints` activo, `prefer_single_quotes: true`.
- **Sin `print`** en código de producción; usa `dart:developer` (`dev.log(...)`).
- Ordena imports: SDK → paquetes (`package:`) → locales, separados por líneas en blanco.
- Prefiere `const` en constructores y widgets siempre que sea posible.
- Maneja errores en datasources (try/catch) y devuelve modelos seguros; nunca dejes excepciones sin capturar
  llegar a la UI.
- `dispose()` de todo `ChangeNotifier`/controlador que crees.

### 4.4 Calidad

- **Cero errores ni advertencias en `flutter analyze`** (y `dart analyze` en el backend). Un PR/commit no se
  considera terminado si el analyzer reporta issues.
- Todo código nuevo relevante debe acompañarse de pruebas donde aplique (`test/`).

---

## 5. Comandos Esenciales de Desarrollo

> Ejecuta los comandos del frontend desde la raíz del repo y los del backend desde `alerta_vecino_backend/`.

### Frontend (Flutter)

```bash
# Dependencias
flutter pub get

# Generar localizaciones (cada vez que cambies un .arb)
flutter gen-l10n

# Ejecutar en el dispositivo/emulador activo
flutter run

# Ejecutar en un dispositivo concreto
flutter run -d <deviceId>          # flutter devices para listar

# Analizar código (debe salir limpio: 0 issues)
flutter analyze

# Formatear
dart format lib/ test/

# Pruebas
flutter test

# Compilar (release)
flutter build apk --release        # Android
flutter build ios --release        # iOS
flutter build web --release        # Web (panel / futuro)
```

Con **FVM** (versión fijada en `.fvmrc`), antepón `fvm`: `fvm flutter run`, `fvm flutter analyze`.

### Backend (Dart Frog)

```bash
# Desde alerta_vecino_backend/

# Dependencias
dart pub get

# Build de producción (limpia AppleDouble, corrige route ordering)
./build.sh

# Servir el build
dart build/bin/server.dart          # http://localhost:8080

# Servidor de desarrollo con hot reload (puede fallar en terminal no interactiva)
dart_frog dev

# Analizar código
dart analyze

# Pruebas
dart test
```

> **Nota:** `dart_frog dev` puede fallar con `StdinException` en terminales no interactivas.
> En ese caso, usar `./build.sh` + `dart build/bin/server.dart`.
>
> **Nota:** En volúmenes SMB/AFP (como WorkShare), macOS genera archivos AppleDouble (`._*`)
> que corrompen el build de Dart Frog. El script `build.sh` los limpia automáticamente.

> Para el emulador de Android, el backend en `localhost:8080` se alcanza como `http://10.0.2.2:8080/api`
> (ya configurado en `.env`). En dispositivo físico, usa la IP LAN de tu máquina.

### Panel Web

```bash
# Desde admin_web/
python3 -m http.server 3000        # http://localhost:3000
```

---

## 6. Estado Actual y Notas de Implementación

### Completado

- **Autenticación real de extremo a extremo:** login con PostgreSQL, bcrypt para passwords, JWT (HS256, 24 h)
  con claims de rol, residencia y email. Middleware JWT en todas las rutas `/api/*`.
- **Sistema de roles:** `resident`, `admin`, `guard` — almacenado en `users.role`, incluido en JWT,
  verificado en middleware admin y endpoints de pases.
- **Flujo de aprobación de cuentas:** registro → pending → admin aprueba/rechaza → login habilitado/bloqueado.
- **Comunicados (Announcements):** CRUD completo con categorías (urgent/maintenance/info), frontend wired
  con datasource, repository, logic (ChangeNotifier) y UI (Page/Layout pattern).
- **Pases de visita:** CRUD + flujo de estados (expected → at_gate → entered → expired), detalle con
  datos del residente, QR encoding `alertavecino://pass/<id>`.
- **Panel Web de administración:** login, gestión de residentes (aprobar/rechazar), verificación de pases
  para guardias con cambio de estado.
- **CORS:** habilitado en middleware para acceso cross-origin desde el panel web.
- **Migraciones:** 6 migraciones aplicadas (users, verification, rejection flow, announcements, roles, visitor_passes).

### Pendiente / Deuda Técnica

- **Passwords en texto plano** en usuarios de prueba (demo, guardia). Los usuarios reales registrados
  via `/register` sí usan bcrypt.
- **Frontend de pases de visita** — datasource, repository, logic y UI en la app móvil (estructura existe pero no wired).
- **Notificaciones push** — no implementadas.
- **Alertas / Historial** — endpoints y frontend pendientes.
- **Tests** — cobertura mínima; faltan tests de integración para endpoints.
- Añade aquí cualquier deuda técnica relevante al cerrar una tarea.

---

## 7. Lista de Verificación antes de cada PR / Commit

- [ ] `flutter analyze` (frontend) y `dart analyze` (backend) sin errores ni advertencias.
- [ ] Lógica de negocio en `ChangeNotifier`, UI en `StatelessWidget`.
- [ ] Sin textos hardcodeados: todo en `app_es.arb` / `app_en.arb`.
- [ ] Nuevas rutas registradas en `RoutePath` + `RouteSwitch`.
- [ ] Nuevas dependencias registradas en `injection_container.dart`.
- [ ] Sin secretos ni credenciales en el código o en logs.
- [ ] Manejo de errores y `dispose()` correctos.
- [ ] Pruebas relevantes añadidas y en verde.
