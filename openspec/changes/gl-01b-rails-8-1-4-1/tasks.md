# Tasks

## 1. Actualización

- [x] 1.1 Registrar la línea base: `bin/bundler-audit` con los 21 avisos y el SHA-256 de `Gemfile` y `Gemfile.lock`
- [x] 1.2 Ejecutar `bundle update rails --conservative` en una rama propia y revisar el diff del lockfile: solo las 13 gemas de Rails y la restricción de `rails-html-sanitizer` declarada por `actionview`
- [x] 1.3 Comparar los checksums nuevos con la API de RubyGems y verificar la integridad con `bundle install` en una ruta temporal

## 2. Verificación

- [x] 2.1 Ejecutar `bin/bundler-audit update`, `bin/bundler-audit`, Brakeman y `bin/ci`
- [x] 2.2 Comprobar que la aplicación arranca con Rails 8.1.4.1 y que `/up` responde 200
- [x] 2.3 Publicar en el PR #2 y verificar el CI remoto
- [x] 2.4 Integrar en `feature/entrega-2-pp` y verificar el CI posterior al merge
- [x] 2.5 Integrar en GL-05 y ejecutar `bin/ci` sobre el árbol integrado

## Workflow follow-up

- P-18: fijar o no el mínimo en el `Gemfile`.
- Archivar este cambio, con autorización de Pablo.
