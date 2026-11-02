# Proposal

## Why

GL-01 está bloqueado: su criterio G6 exige que `bin/ci` termine sin errores,
y la auditoría de gemas falla con 15 avisos publicados después del CI del
ensayo en `rack`, `loofah`, `nokogiri` y `rails-html-sanitizer`. Fuente:
`docs/tickets/GL-01a-avisos-seguridad.md`.

## What Changes

- `Gemfile.lock`: `rack` 3.2.7 → 3.2.8, `loofah` 2.25.2 → 2.25.3,
  `nokogiri` 1.19.4 → 1.19.5 (todas las plataformas del lockfile) y
  `rails-html-sanitizer` 1.7.1 → 1.7.2: la versión corregida mínima de cada
  una.
- Sin cambios en el `Gemfile`, Ruby, Rails, otras gemas ni la configuración
  de la auditoría.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

Ninguna. El requisito que este cambio vuelve a satisfacer ya existe:
«Verificación local en un solo comando» de `quality-pipeline` (la auditoría
de gemas vulnerables forma parte de `bin/ci`). El cambio declara
`skip_specs: true`.

## Impact

- `Gemfile.lock` y las gemas instaladas localmente para Ruby 4.0.9.
- Desbloquea G6 de GL-01. G7 (CI remoto) sigue pendiente.
