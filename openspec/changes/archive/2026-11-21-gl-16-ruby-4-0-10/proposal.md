# Proposal

> **GL-16, cambio independiente de GL-14, autorizado e implementado en
> M398, publicado y archivado en M401 (21/11/2026).** Commit `d2c6db4`
> en `feature/entrega-final-pp`, CI [44938564609](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/44938564609) en verde
> sobre `ca2d5da`. ID propuesto en M399; ticket:
> `docs/tickets/GL-16-ruby-4-0-10.md`.

## Why

Al cerrar la tarea 3.2 de GL-14, Pablo autorizó actualizar Brakeman de
8.1.0 a 8.1.1 (M396), porque `bin/brakeman` exige la última versión.
Brakeman 8.1.1 informa una advertencia de confianza alta sobre
`.ruby-version`: según su salida, Ruby 4.0.9 tiene una vulnerabilidad
crítica de ejecución remota de código (CVE-2026-132825) y hay que pasar a
4.0.10 o posterior. Con esa advertencia, `bin/ci` falla en «Security:
Brakeman code analysis». La spec vigente `runtime-toolchain` fija Ruby
4.0.9, así que el cambio de versión necesita su propio delta (M397 y
M398).

## What Changes

- `.ruby-version` y `.tool-versions`: Ruby de 4.0.9 a 4.0.10.
- `Gemfile.lock`: `RUBY VERSION` pasa a `ruby 4.0.10`, regenerado por
  `bundle install`. Ninguna gema cambia por esta actualización; Brakeman
  8.1.1 viene de M396 y Bundler sigue en 4.0.20.
- Guía de desarrollo (`docs/desarrollo.md`) y paso de instalación del
  `README.md`: piden Ruby 4.0.10.
- Entorno local: plugin `ruby` de asdf actualizado e instalación de Ruby
  4.0.10 (fuera del repositorio).
- Sin cambios en el `Gemfile`, Rails, otras gemas, código ni
  configuración de Brakeman.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `runtime-toolchain`: `MODIFIED` «Versiones de Ruby y Rails del
  proyecto» y «Declaración coherente de la versión de Ruby», con Ruby
  4.0.10. Se conservan todos sus escenarios.
- `development-environment`: `MODIFIED` «Guía de desarrollo
  reproducible», cuyo escenario «Recorrido desde un clon limpio» nombra la
  versión de Ruby.

## Impact

- Quien desarrolla necesita Ruby 4.0.10 instalado; con asdf, actualizar el
  plugin `ruby` si no lo ofrece.
- El CI remoto toma la versión de `.ruby-version`; que su instalador ya
  ofrezca 4.0.10 solo se comprueba al publicar.
- La demo en Render recibe Ruby 4.0.10 solo con un deploy.
- `CLAUDE.md`, el estado del `README.md` y la lista de decisiones
  aprobadas de `openspec/config.yaml` nombran Ruby 4.0.10 (M399). Los
  tickets, decisiones y archivos anteriores son históricos y no cambian.
