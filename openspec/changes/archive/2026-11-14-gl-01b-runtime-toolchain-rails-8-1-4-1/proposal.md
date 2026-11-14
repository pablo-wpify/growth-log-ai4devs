# Proposal

## Why

GL-01b actualizó Rails de 8.1.4 a 8.1.4.1 por los avisos de seguridad del
04/11/2026, pero su cambio de OpenSpec declaró que no modificaba ninguna
capacidad. La spec vigente `runtime-toolchain` quedó diciendo «Rails 8.1.4»,
mientras que `Gemfile.lock` registra `rails (8.1.4.1)`: el escenario
«Versiones informadas en el directorio del proyecto» ya no coincide con lo
que informa el proyecto. La auditoría de la entrega 2 (M206) lo señaló y
Pablo pidió resolverlo con un cambio de OpenSpec (M208). Fuente:
`docs/tickets/GL-01b-rails-8-1-4-1.md` y P-18 del plan de la entrega 2.

## What Changes

- `runtime-toolchain`, requisito «Versiones de Ruby y Rails del proyecto»:
  Rails 8.1.4.1 en lugar de 8.1.4. El `Gemfile` sigue con `~> 8.1.4`
  (P-18): la versión exacta la fija el lockfile.
- Sin cambios de código, `Gemfile`, `Gemfile.lock`, Ruby, datos ni
  configuración: el producto ya usa Rails 8.1.4.1 desde GL-01b.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `runtime-toolchain`: la versión de Rails del requisito «Versiones de Ruby
  y Rails del proyecto» pasa a 8.1.4.1.

## Impact

- Solo la spec `runtime-toolchain`, al archivar el cambio. Hasta entonces,
  la spec vigente sigue diciendo 8.1.4.
- Sin dependencias, migraciones ni rutas nuevas.
