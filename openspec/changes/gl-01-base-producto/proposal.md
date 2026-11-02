# Proposal

## Why

La entrega 2 parte de la base Rails construida en el ensayo `e1-base-rails`,
incorporada a `feature/entrega-2-pp` por avance rápido. Esa base sigue
identificada como un ensayo descartable (nombre de la aplicación, bases de
datos, contexto de OpenSpec) y sus verificaciones se ejecutaron en otro
repositorio. Antes de construir el primer incremento hay que convertirla en
la base del producto y volver a verificarla aquí. Fuente:
`docs/tickets/GL-01-base-producto.md`.

## What Changes

- La aplicación se identifica como Growth Log (módulo `GrowthLog`, título y
  manifiesto), sin rastros del ensayo fuera de los artefactos de
  procedencia.
- Las bases de datos pasan a `growth_log_development`, `growth_log_test` y
  `growth_log_production`; las variables `DATABASE_*` de desarrollo y test
  no cambian.
- El contexto de `openspec/config.yaml` describe el producto: tickets en
  `docs/tickets/`, decisiones aprobadas y abiertas.
- Se agrega una guía de desarrollo local sin secretos y el registro de las
  decisiones de GL-01 (versiones aceptadas, PostgreSQL propio, CI,
  documentación y declaración de Ruby).
- Un PostgreSQL 18.6 propio en `127.0.0.1:55440`, variables `DATABASE_*` en
  un `.env` ignorado y una plantilla `.env.example` sin secretos.
- Se versiona `.tool-versions` con Ruby 4.0.9, coherente con
  `.ruby-version`, que sigue siendo la fuente del `Gemfile` y del CI.
- El workflow también se dispara en push a `feature/entrega-2-pp`.
- Todas las verificaciones de E1 se repiten en este repositorio, incluido el
  CI en `pablo-wpify/growth-log-ai4devs`.
- Sin cambios de versiones ni de dependencias: Ruby 4.0.9, Rails 8.1.4,
  PostgreSQL 18.6.
- **BREAKING (solo entornos locales):** las bases `growth_log_ensayo_*`
  dejan de usarse; hay que preparar las nuevas.

## Capabilities

### New Capabilities
- `application-identity`: nombre con el que la aplicación se identifica en
  su código, sus páginas y su manifiesto.
- `development-environment`: guía de desarrollo reproducible, variables
  locales sin secretos versionados y una única suite de pruebas que detecta
  fallos. Adaptada de la capacidad homónima de Clima API, con PostgreSQL y
  sin las reglas de bloqueo HTTP.

### Modified Capabilities
- `runtime-toolchain`: las versiones pasan a ser las del producto; la
  «fuente única» se renombra y reemplaza por una declaración coherente en
  `.ruby-version` y `.tool-versions`; se agregan la coherencia del lockfile
  y el rechazo de otro Ruby al cargar las dependencias.
- `database-configuration`: nombres de las bases de desarrollo y de test, y
  servidor local del producto en lugar del contenedor del ensayo.
- `quality-pipeline`: la verificación local y el CI se refieren al
  PostgreSQL y al repositorio del producto, y el CI también corre en push a
  `feature/entrega-2-pp`.
- `secrets-handling`: la búsqueda de credenciales locales se refiere a las
  del producto.

`health-check` no cambia. Las cuatro capacidades modificadas existen hoy
solo dentro del cambio `e1-base-rails`, que no está archivado: **E1 debe
archivarse antes de archivar este cambio** (ver tasks.md, «Workflow
follow-up»).

## Impact

- Código: `config/application.rb`, `config/database.yml`, `config/cable.yml`,
  `app/views/layouts/application.html.erb`, `app/views/pwa/manifest.json.erb`,
  `spec/db/postgresql_connection_spec.rb`.
- Configuración de OpenSpec: `openspec/config.yaml`.
- Documentación nueva: `docs/desarrollo.md`, `docs/decisiones/`. Sin
  cambios en `README.md`, `prompts.md` ni `anexos/`.
- Sistemas: un PostgreSQL 18.6 local para el producto (ver design.md,
  D-GL01-1) y GitHub Actions de `pablo-wpify/growth-log-ai4devs` (D-GL01-2).
- Sin dependencias nuevas ni cambios de versión. `rack`, `rubocop` y
  `msgpack` están un parche por detrás de Clima API; no se actualizan aquí.
- Prácticas de verificación tomadas de Clima API (`~/code/clima-api`,
  `0972b5a`), por lectura: ver design.md, decisión 8.
