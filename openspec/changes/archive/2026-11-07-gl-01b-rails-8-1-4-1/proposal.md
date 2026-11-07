# Proposal

## Why

El 04/11/2026 Rails publicó 8.1.4.1, que corrige 21 avisos de seguridad.
Con la base de avisos actualizada, `bin/bundler-audit` los informa contra
Rails 8.1.4 y `bin/ci` falla en «Security: Gem audit», lo que bloquea
GL-05 y cualquier otro cambio. Fuente:
`docs/tickets/GL-01b-rails-8-1-4-1.md`.

## What Changes

- `Gemfile.lock`: `rails` y sus 12 componentes (`actioncable`,
  `actionmailbox`, `actionmailer`, `actionpack`, `actiontext`,
  `actionview`, `activejob`, `activemodel`, `activerecord`,
  `activestorage`, `activesupport`, `railties`) de 8.1.4 a 8.1.4.1, con
  `bundle update rails --conservative`.
- `actionview` 8.1.4.1 declara `rails-html-sanitizer (~> 1.6, >= 1.7.2)`;
  el lockfile ya tenía la 1.7.2, que no cambia.
- Sin cambios en el `Gemfile` (P-18, decidida el 07/11/2026), Ruby, Bundler, otras
  gemas, código ni configuración de la auditoría.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

Ninguna. El requisito que este cambio vuelve a satisfacer ya existe:
«Verificación local en un solo comando» de `quality-pipeline`, que incluye
la auditoría de gemas vulnerables en `bin/ci`. El cambio declara
`skip_specs: true`, como GL-01a.

## Impact

- `Gemfile.lock` y las gemas instaladas localmente para Ruby 4.0.9.
- Desbloquea `bin/ci` para GL-05, que se integró y validó después.
