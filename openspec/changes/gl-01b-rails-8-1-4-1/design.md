# Design

## Context

El ticket `docs/tickets/GL-01b-rails-8-1-4-1.md` registra el problema, la
aplicabilidad de cada uno de los 21 avisos según su advisory, los
criterios B1 a B9 y la ejecución con su evidencia. Este diseño resume las
decisiones.

## Goals / Non-Goals

**Goals:**
- Llevar Rails a la versión corregida con el menor diff posible en el
  lockfile.

**Non-Goals:**
- Actualizar otras gemas, Ruby o Bundler.
- Tocar la configuración de la auditoría o agregar ignorados.
- Fijar un mínimo en el `Gemfile` (P-18, pendiente).

## Decisions

1. **`bundle update rails --conservative`.** Actualiza `rails` y los
   componentes que fija con `=`, sin subir dependencias compartidas. Se
   admite cualquier otra dependencia que Bundler necesite estrictamente,
   justificada en el ticket. No hizo falta ninguna.
2. **`Gemfile` sin cambios.** `~> 8.1.4` ya admite 8.1.4.1. La alternativa
   de fijar `>= 8.1.4.1` queda como P-18, sin aprobar.
3. **Checksums contra RubyGems.** Los 13 `sha256` nuevos se comparan con
   la API de RubyGems y con la verificación de integridad de Bundler; no
   con el anuncio de Rails.
4. **Rama propia.** GL-01b se trabajó en `feature/GL-01b-rails-8-1-4-1`,
   desde `feature/entrega-2-pp`, en un worktree aparte, para no mezclarlo
   con los cambios sin commit de GL-05.

## Verificación

- **Local:** lo registra el ticket, con lo respaldado por logs separado de
  lo solo observado en la sesión. `bin-ci.log` registra «Continuous
  Integration passed» con 164 ejemplos sobre la base.
- **CI remoto:**
  - PR [#2](https://github.com/pablo-wpify/growth-log-ai4devs/pull/2):
    ejecuciones 42376879636 (`d4c61eb`), 42377950141 (`659b3d8`),
    42378605273 (`dcd2188`) y 42379478309 (`faec846`), todas en success con
    `scan_ruby`, `scan_js`, `lint` y `test`.
  - Integración en `feature/entrega-2-pp` (`8ae8723`): CI
    [42380986492](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/42380986492),
    disparado por el push, en success con los cuatro jobs.
- **Integración en GL-05:** `feature/GL-05-personas` se llevó a `a60fb8e`,
  el merge de `d9365c6` con `8ae8723`. En ese árbol, antes del commit, Rails
  8.1.4.1 y `bin/ci` con «Continuous Integration passed» y 192 ejemplos y 0
  fallas.

## Risks / Trade-offs

- El aviso GHSA-2gff-2mmg-m73p queda **condicional** hasta conocer el proxy
  del despliegue. GHSA-8474-xrp6-wh69 queda **no confirmable**. Ver el
  ticket.

## Migration Plan

Sin migraciones ni datos.

## Open Questions

- P-18: fijar 8.1.4.1 como mínimo en el `Gemfile`.
