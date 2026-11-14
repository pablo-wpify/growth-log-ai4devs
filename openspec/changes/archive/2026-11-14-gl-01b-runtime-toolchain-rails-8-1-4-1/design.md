# Design

> **Estado (14/11/2026): aprobado y archivado, sin commit.** Cambio de
> seguimiento de GL-01b pedido por Pablo en M208 y aprobado en M209. No
> implementa nada: el producto ya usa Rails 8.1.4.1. El archivo aplicó el
> delta a la spec vigente `runtime-toolchain`.

## Context

GL-01b (archivado `2026-11-07-gl-01b-rails-8-1-4-1`) actualizó el lockfile
a Rails 8.1.4.1 con `skip_specs: true`. La spec `runtime-toolchain`, creada
en GL-01, fija las versiones de Ruby y Rails y no se actualizó.

## Goals / Non-Goals

**Goals:** que la spec vigente diga la versión de Rails que usa el
producto.

**Non-Goals:** cambiar el `Gemfile` (P-18 lo deja en `~> 8.1.4`), Ruby,
gemas, código o archivos archivados.

## Decisions

- **Versión exacta 8.1.4.1:** el escenario compara lo que informa el
  proyecto; con el lockfile actual, `bin/rails -v` informa
  `Rails 8.1.4.1`.
- **Cambio propio y no edición directa:** `CLAUDE.md` pide no cambiar un
  requisito sin un cambio explícito, y el archivo de GL-01b no se
  reescribe.

## Verificación

- Lectura de `Gemfile.lock`: `rails (8.1.4.1)` y `gem "rails", "~> 8.1.4"`
  en el `Gemfile`.
- `openspec validate --all --strict`.
- No hay pruebas nuevas: ninguna prueba del repositorio comprueba el
  número de versión de Rails.

## Risks / Trade-offs

- **Una actualización futura de Rails vuelve a desalinear la spec** →
  cada cambio que actualice Rails debe declarar `runtime-toolchain` entre
  sus capacidades modificadas.

## Open Questions

Ninguna.
