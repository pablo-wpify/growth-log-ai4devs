# Tasks

GL-16 (ID propuesto en M399). Cambio independiente de GL-14, autorizado
por Pablo en M398 (21/11/2026) para implementarse en local. Sin commit,
publicación, deploy ni archivo.

## 1. Actualización

- [x] 1.1 Actualizar el plugin `ruby` de asdf, instalar Ruby 4.0.10 y comprobar `ruby -v`. Evidencia: 21/11/2026, M398 (`ruby 4.0.10 (2026-11-19 revision a704b7cd95)`)
- [x] 1.2 Cambiar `.ruby-version` y `.tool-versions` a 4.0.10 y ejecutar `bundle install`. Revisar el diff del lockfile: solo `RUBY VERSION`, sin otras gemas. Evidencia: 21/11/2026, M398
- [x] 1.3 Deltas de `runtime-toolchain` y `development-environment`, y la guía de desarrollo y el paso de instalación del `README.md` con Ruby 4.0.10. Evidencia: 21/11/2026, M398
- [x] 1.4 Conciliar la versión vigente en `CLAUDE.md`, el estado del `README.md` y `openspec/config.yaml`; ID, ticket y lugar en el plan. Evidencia: 21/11/2026, M399

## 2. Verificación

- [x] 2.1 `openspec validate --all --strict`. Evidencia: 21/11/2026, M398, 23 de 23
- [x] 2.2 `bin/ci` con código 0. Evidencia: 21/11/2026, M398: `bin/bundler-audit update` y `bin/ci` con código 0; estilo sin ofensas, sin vulnerabilidades, Brakeman 8.1.1 sin advertencias y 463 ejemplos con 0 fallos

## 3. Publicación y cierre (cada paso con su autorización)

- [ ] 3.1 Commit y push; CI remoto con enlace y SHA
- [ ] 3.2 Archivo del cambio
