# Proposal

## Why

La aplicación todavía no identifica a nadie. Antes de invitar líderes (GL-04)
o aplicar políticas sobre recursos (GL-03), cada petición tiene que estar
asociada a una cuenta individual activa, y las rutas del producto tienen que
estar cerradas por defecto. Fuente: `docs/tickets/GL-02-autenticacion.md`
(PP-1, D1, AM-2, AM-5, README §2.5 y §4, tarea E2 del Anexo G).

## What Changes

- Cuentas individuales: correo único y normalizado, nombre, contraseña con
  hash bcrypt, rol de administrador y estado activo. Sin registro público.
- Inicio y cierre de sesión con correo y contraseña, mensaje genérico ante
  cualquier fallo y limitación de intentos.
- Sesiones guardadas en el servidor, con vencimiento por inactividad y
  máximo absoluto; cerrar sesión, vencer o desactivar la cuenta las
  invalida.
- Todas las rutas del producto exigen sesión salvo las excepciones
  declaradas: chequeo de salud, formulario y envío del inicio de sesión.
- Tarea reproducible para crear el primer administrador, sin credenciales
  en el código ni secretos versionados.
- Página de inicio mínima que confirma la sesión y permite cerrarla.
- Nueva dependencia: `bcrypt` 3.1.22 (ADR-2, pendiente de aprobación).
- Fuera de este cambio: invitaciones y asignaciones (GL-04), políticas sobre
  recursos (GL-03), acción de desactivar cuentas y último administrador
  (I7), recuperación de contraseña.

## Capabilities

### New Capabilities
- `user-accounts`: cuentas individuales, sus datos obligatorios, el
  almacenamiento de la contraseña, la política de contraseñas y el estado
  activo; ausencia de registro público.
- `authentication`: inicio y cierre de sesión, errores genéricos,
  limitación de intentos, sesiones con vencimiento e invalidación,
  protección CSRF y protección de las rutas del producto.
- `initial-administrator`: procedimiento reproducible para crear la primera
  cuenta administradora sin secretos en el repositorio.

### Modified Capabilities

Ninguna. `health-check` ya exige que `GET /up` responda sin sesión;
`secrets-handling` ya prohíbe credenciales versionadas.

## Impact

- Código nuevo: modelos `User`, `Session` y `Current`; concern de
  autenticación; controladores de sesión e inicio; vistas; tarea de
  administrador inicial; migraciones de `users` y `sessions`.
- Configuración: almacén de la limitación de intentos en test; rutas.
- Dependencias: `bcrypt` (descomentar la línea existente del `Gemfile`).
- Documentación: `docs/desarrollo.md` (administrador inicial) y
  `docs/decisiones/` (ADR-2 y D-GL02-2 a D-GL02-6).
- Base de datos: dos tablas nuevas en `growth_log_development` y
  `growth_log_test`.
