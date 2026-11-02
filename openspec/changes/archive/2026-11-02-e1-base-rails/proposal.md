# Proposal

## Why

Growth Log todavía no tiene código. Antes de cualquier incremento funcional
(I1 en adelante, según el Anexo G) hace falta una base que arranque, se
pruebe sola contra PostgreSQL y tenga definido el CI. Este cambio
implementa la tarea habilitadora E1 tal como la acota el ticket
`ensayo/ticket-e1.md`.

## What Changes

- Se genera una aplicación Rails 8.1.4 sobre Ruby 4.0.9 configurada para
  PostgreSQL 18.6, sin los componentes que el ticket excluye (Kamal,
  Thruster, Dockerfile, Solid, Action Mailbox, Action Text, Active Storage,
  Jbuilder) y sin Minitest.
- `.ruby-version` es la única fuente de la versión de Ruby.
- La conexión a PostgreSQL se configura con las mismas variables
  `DATABASE_*` en local y en el CI; las bases de desarrollo y de test se
  preparan de forma explícita.
- Se adopta RSpec, con tests del chequeo de salud `/up`, de una consulta
  real a PostgreSQL en test y de la condición que limita los seeds a
  desarrollo.
- `bin/ci` y el workflow ejecutan el mismo pipeline: RuboCop,
  `bundler-audit`, auditoría de importmap, `brakeman`, preparación de la
  base de test y RSpec.
- Se define `.github/workflows/ci.yml` con el servicio `postgres:18.6`
  autenticado por una contraseña exclusivamente de prueba. **No se ejecuta
  en este ensayo**: el criterio A6 queda pendiente hasta correrlo en GitHub
  Actions.
- Fuera del cambio: autenticación, invitaciones, feedback, modelos del
  dominio, pantallas, despliegue y herramienta E2E.

## Capabilities

### New Capabilities
- `runtime-toolchain`: versiones de Ruby y Rails del proyecto y su
  declaración única (A1).
- `database-configuration`: conexión a PostgreSQL por variables de entorno,
  preparación de las bases de desarrollo y de test, consulta real en test y
  seeds limitados a desarrollo (A2, A4, A7).
- `health-check`: respuesta del chequeo de salud de la aplicación (A3).
- `quality-pipeline`: verificación de estilo, seguridad y tests en local
  (`bin/ci`) y en GitHub Actions (A5, A6).
- `secrets-handling`: ausencia de secretos y de credenciales locales o
  reales en el repositorio (A8).

### Modified Capabilities
- Ninguna: el proyecto no tiene especificaciones previas.

## Impact

- Código nuevo: la estructura de una aplicación Rails en la raíz del
  repositorio, junto a la documentación existente, que no se modifica.
- Dependencias nuevas: Rails 8.1.4, `pg`, `rspec-rails`, RuboCop,
  `bundler-audit`, `brakeman` e importmap.
- Sistemas: el contenedor del ensayo `growthlog-ensayo-pg` (PostgreSQL 18.6
  en `127.0.0.1:55432`) para desarrollo y test; GitHub Actions solo como
  definición.
