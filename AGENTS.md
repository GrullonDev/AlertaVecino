# AGENTS.md

Instrucciones para agentes que trabajan en este repositorio. Consultar README y configuración para el detalle; este archivo no autoriza publicación ni cambios fuera de la tarea.

## Propósito del proyecto

Prototipo de seguridad vecinal con pantallas de alertas, mapa, pánico, residentes, visitas/QR y perfil. El backend Dart Frog solo tiene ruta inicial y login simulado; registro, alertas reales, verificación vecinal y notificaciones segmentadas del README no están demostrados como servicios implementados.

## Stack y plataformas

Provider/ChangeNotifier, GetIt, http/flutter_dotenv, flutter_map/latlong2, qr_flutter y share_plus. Backend Dart Frog ^1.1.0 con Dart ^3.11.0; sin dependencia de base de datos.

Requisito Dart declarado: `^3.11.5` en `pubspec.yaml`; los rangos de dependencias no prueban la versión resuelta. SDK mediante FVM: `3.47.1` según `.fvmrc`.

Proyectos de plataforma presentes: android, ios, web. Esto no garantiza que todos los plugins funcionen en cada plataforma.

## Estructura del repositorio

Flutter en `lib/features/`: pages/layout/widgets y modelos por flujo. Login separa data/repository/logic; DI en `lib/utils/injection_container.dart`, rutas en `lib/utils/router/`. `lib/l10n/` contiene ARB. Backend separado en `alerta_vecino_backend/routes/`, con pruebas en su `test/`.

## Preparación y comandos

Requisitos: FVM y SDK de `.fvmrc`; ejecutar `fvm install` sin modificar el pin. Android necesita su toolchain/JDK de Gradle; iOS requiere macOS/Xcode y la gestión de dependencias del proyecto. Integraciones Firebase requieren configuración de desarrollo existente.

| Acción | Comando desde la raíz |
| --- | --- |
| Dependencias | `fvm flutter pub get` |
| Ejecutar | `fvm flutter run -d <dispositivo>` |
| Formato | `fvm dart format lib test` |
| Análisis | `fvm flutter analyze` |
| Pruebas | `fvm flutter test` |
| Build Android de comprobación | `fvm flutter build apk --debug` |

`fvm flutter gen-l10n` para ARB. API_BASE_URL procede de `.env`; no copiar valores personales.

Los comandos fueron contrastados con dependencias, documentación/configuración y suites presentes; no ejecutados al redactar este archivo. Build de distribución requiere firma/configuración adicional; no sustituye despliegue.

## Arquitectura y convenciones

Mantener ChangeNotifier y DI existentes; no añadir nuevo gestor de estado para una pantalla. Usar rutas y modelos actuales. La llamada login usa API_BASE_URL y HTTP JSON; revisar status, parsing, timeout y propagación de fallos. No dar por existente autorización vecinal, almacenamiento de token seguro o envío real de pánico.

Conservar nombres y convenciones del módulo: Dart snake_case para archivos, UpperCamelCase para tipos y lowerCamelCase para miembros. No renombrar APIs/campos persistidos incidentalmente; respetar lints de analysis_options.yaml.

## Experiencia de usuario

No mostrar alerta entregada, ayuda enviada o visita autorizada sin confirmación del servicio real. Separar demostración de operación real. Pánico requiere cancelar, evitar duplicados y mostrar fallo/reintento. No navegar a home como éxito ante login fallido. Mantener localización ES/EN, accesibilidad y pantallas pequeñas.

En el flujo afectado, contemplar carga, vacío, éxito y error; dar feedback claro, conservar entradas/datos ante fallos y permitir recuperación. Reutilizar componentes visuales; revisar semántica, foco, contraste y escalado de texto.

## Seguridad y datos

No incluir secretos, credenciales ni datos personales en código, documentación o logs. Usar configuración de entorno existente, validar entradas y manejar fallos de servicios. Respetar autenticación, autorización y permisos. No ejecutar operaciones destructivas sobre datos sin autorización explícita.

`.env` está empaquetado como asset: solo configuración pública, nunca secretos. Backend actual devuelve token fijo y acepta campos no vacíos: no es autenticación de producción. El datasource registra el cuerpo del login y puede exponer contraseña; no reproducir ese patrón. Ningún QR o residencia seleccionado en cliente sustituye validación/autorización del servidor.

## Pruebas y validación

Frontend: analyze y flutter test; revisar `test/widget_test.dart`. Backend, desde su carpeta: `dart pub get`, `dart format routes test`, `dart analyze`, `dart test`. Para ejecutar backend instalar CLI compatible: `dart pub global activate dart_frog_cli`, luego `dart_frog dev`. Validar POST/login, JSON inválido, método incorrecto, timeout y login fallido; verificar simulaciones sin afirmar entregas reales.

Ejecutar análisis y pruebas relevantes según el cambio; compilar solo plataformas afectadas. Un cambio exclusivamente documental requiere revisar rutas, comandos, alcance y diff, sin pruebas artificiales que repliquen el texto. No afirmar que una prueba pasó si no se ejecutó.

## Flujo de trabajo del agente

Leer instrucciones aplicables antes de modificar archivos, incluidas las de subdirectorios: su alcance local se respeta. Las instrucciones explícitas del usuario prevalecen.

1. Revisar estado del trabajo y comprender el flujo afectado antes de implementar.
2. Hacer cambios acotados al objetivo; respetar cambios existentes del usuario y evitar refactorizaciones ajenas.
3. Reutilizar componentes y dependencias disponibles; justificar dependencias nuevas.
4. Actualizar documentación si cambia comportamiento o configuración.
5. Ejecutar verificaciones pertinentes y comunicar resultados y pendientes con su motivo.
6. No hacer commits, push o despliegues salvo solicitud o autorización previa del usuario. Esta regla prevalece sobre recomendaciones de commit automático en guías antiguas.

No imponer una política nueva de ramas/commits; seguir documentación y CI existentes.

No activar workflows de publicación ni scripts de release como comprobación rutinaria.

## Criterios de finalización

La tarea cumple el comportamiento solicitado, contempla errores/estados relevantes, mantiene convenciones y pasa las verificaciones aplicables que puedan ejecutarse. Comunicar archivos modificados, resultados reales y cualquier validación pendiente con su motivo.

## Limitaciones y aspectos por confirmar

Trabajo revisado en `develop`; `main` no debe asumirse equivalente. No hay base de datos ni JWT real en el backend. Flutter tiene android/ios/web pero panel administrador es objetivo, no funcionalidad confirmada. En dispositivo/emulador, localhost debe apuntar correctamente al backend.
