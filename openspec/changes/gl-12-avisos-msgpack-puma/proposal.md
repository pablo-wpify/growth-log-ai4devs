# Proposal

> **Autorizado e implementado en local en M241 (15/11/2026), sin commit.**

## Why

El 15/11/2026, con la base de avisos actualizada, `bin/bundler-audit`
informa CVE-2026-126366 (GHSA-73v3-wf97-vpgj) contra `msgpack` 1.8.6 y
siete avisos del 13/11/2026 contra `puma` 8.0.2. `bin/ci` falla en
«Security: Gem audit», lo que bloquea GL-11 y cualquier otro cambio.
Fuente: `docs/tickets/GL-12-avisos-msgpack-puma.md`.

## What Changes

- `Gemfile.lock`: `msgpack` de 1.8.6 a 1.8.7 y `puma` de 8.0.2 a 8.0.3, con
  `bundle update msgpack puma --conservative --patch`.
- Ninguna dependencia transitiva cambia: `puma` sigue con `nio4r` 2.7.5 y
  `bootsnap` sigue en 1.26.1, con `msgpack (~> 1.5)`.
- Sin cambios en el `Gemfile`, Ruby, Bundler, otras gemas, código ni
  configuración de Puma o de la auditoría.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

Ninguna. El requisito que este cambio vuelve a satisfacer ya existe:
«Verificación local en un solo comando» de `quality-pipeline`, que incluye
la auditoría de gemas vulnerables en `bin/ci`. Ninguna spec fija las
versiones de `msgpack` ni de `puma`. El cambio declara `skip_specs: true`,
como GL-01a y GL-01b.

## Impact

- `Gemfile.lock` y las gemas instaladas localmente para Ruby 4.0.9.
- Desbloquea `bin/ci` para GL-11.
- La demo de GL-10 en Render recibe Puma 8.0.3 solo con un deploy manual
  de Pablo.
