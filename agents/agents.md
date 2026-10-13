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
- **Autenticación:** basada en **JSON Web Tokens (JWT)** (actualmente en fase inicial/simulada; ver §6).
- **Puerto por defecto:** `8080` (`PORT` sobrescribible por variable de entorno).
- **Nombre del paquete:** `alerta_vecino_backend`.

### 2.3 Base de Datos

- **PostgreSQL local.**
- Conexión configurada mediante **variables de entorno** en `.env` (nunca hardcodear credenciales).
- La capa de acceso a datos debe vivir detrás de un repositorio/datasource (nunca en las rutas).

### 2.4 Variables de Entorno

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

### 3.2 Backend (`routes/`)

Enrutamiento **file-based**: la ruta HTTP se deriva de la estructura de carpetas.

```
alerta_vecino_backend/
├── routes/
│   ├── index.dart                  # GET /  → "API AlertaVecino funcionando"
│   └── api/
│       ├── auth/
│       │   └── login.dart          # POST /api/auth/login
│       ├── users/                  # (planificado) /api/users/...
│       ├── visitors/               # (planificado) /api/visitors/... (pases QR)
│       ├── panic/                  # (planificado) /api/panic/...
│       ├── alerts/                 # (planificado) /api/alerts/...
│       └── announcements/          # (planificado) /api/announcements/...
├── test/                           # pruebas de rutas (mocktail / test)
├── pubspec.yaml
└── .env                            # (no commitear) DB + JWT secret
```

**Mapeo de archivos a rutas:**

| Archivo                         | Método / Ruta                           |
| ------------------------------- | --------------------------------------- |
| `routes/index.dart`             | `GET /`                                 |
| `routes/api/auth/login.dart`    | `/api/auth/login`                       |
| `routes/api/visitors/[id].dart` | `/api/visitors/:id` (segmento dinámico) |
| `routes/api/_middleware.dart`   | Middleware aplicado a `/api/*`          |

- Cada endpoint exporta `Future<Response> onRequest(RequestContext context)`.
- Valida el método HTTP explícitamente (`HttpMethod.post`, etc.) y responde `405` si no coincide.
- Usa `Response.json(...)` y códigos de estado de `dart:io` (`HttpStatus.*`).
- **Nunca** coloques lógica de negocio ni SQL crudo dentro de `onRequest`: extrae a servicios/repositorios.

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

# Servidor de desarrollo con hot reload (http://localhost:8080)
dart_frog dev

# Compilar a un build de producción
dart_frog build

# Servir el build
dart_frog start

# Analizar código
dart analyze

# Pruebas
dart test
```

> Para el emulador de Android, el backend en `localhost:8080` se alcanza como `http://10.0.2.2:8080/api`
> (ya configurado en `.env`). En dispositivo físico, usa la IP LAN de tu máquina.

---

## 6. Estado Actual y Notas de Implementación

- **Auth de extremo a extremo:** `routes/api/auth/login.dart` ya valida método y campos, pero la validación
  contra base de datos y la **generación real de JWT están pendientes (`//? TODO`)**; hoy devuelve un token
  simulado y un usuario de ejemplo.
- **Frontend ↔ Backend:** `LoginLogic` consume `Repository.login()` y, ante error, redirige igualmente a Home
  (comportamiento provisional a revisar al integrar JWT y manejo de sesión).
- Al implementar persistencia real: añade la conexión **PostgreSQL** detrás de un repositorio en el backend,
  firma/verifica **JWT** (login + middleware de autorización), y guarda el token de forma segura en el frontend.
- Añade aquí cualquier deuda técnica relevante al cerrar una tarea, para mantener el contexto actualizado.

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
