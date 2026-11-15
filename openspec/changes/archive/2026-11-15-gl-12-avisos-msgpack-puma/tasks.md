# Tasks

Documentación SDD e implementación dirigida autorizadas por Pablo en M241
(15/11/2026), sin esperar otra aprobación. Sin commit, publicación,
deploy ni archivo.

## 0. Documentación

- [x] 0.1 Proponer GL-12 en el plan (secciones 2, 3, 5 y 9) y preparar el ticket. Evidencia: 15/11/2026, M241
- [x] 0.2 Preparar la propuesta, el diseño (aplicabilidad de cada aviso) y estas tareas, con `skip_specs: true` como GL-01a y GL-01b. Evidencia: 15/11/2026, M241

## 1. Actualización

- [x] 1.1 Registrar la línea base: versiones, plataformas y checksums de `msgpack` y `puma` en el lockfile; los ocho avisos de `bin/bundler-audit` (M240). Evidencia: diseño, «Context»
- [x] 1.2 Verificar los avisos contra sus fuentes oficiales (GitHub Advisory Database y avisos de `puma/puma`) y evaluar su aplicabilidad. Evidencia: diseño, tabla de avisos
- [x] 1.3 Ejecutar `bundle update msgpack puma --conservative --patch` y revisar el diff del lockfile: solo `msgpack` 1.8.7 y `puma` 8.0.3, sin cambios transitivos ni en el `Gemfile`
- [x] 1.4 Comparar los checksums nuevos con la API de RubyGems. Evidencia: coinciden para la variante `ruby`

## 2. Verificación

- [x] 2.1 Ejecutar `bin/bundler-audit update`, `bin/bundler-audit` y `bin/ci`. Evidencia: auditoría sin vulnerabilidades; `bin/ci` con código 0 (383 ejemplos, 0 fallos)
- [x] 2.2 Ejecutar `openspec validate --all --strict`. Evidencia: 21 de 21
- [x] 2.3 Comprobar que los cambios locales de GL-10 y GL-11 siguen intactos. Evidencia: SHA-256 iguales a los de antes del cambio

## 3. Publicación y cierre (cada paso con su autorización)

- [x] 3.1 Commit y push; CI remoto con enlace y SHA. Evidencia (M242): commit `cef5d80` publicado directamente en `feature/entrega-2-pp`, sin PR porque M242 no lo autorizó; CI [43730010839](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43730010839) sobre `cad6afe` en `success`
- 3.2 Merge: **no aplica.** El commit se publicó directamente en la rama de integración `feature/entrega-2-pp` (M242).
- [x] 3.3 Deploy manual en Render y comprobación de que la demo arranca con Puma 8.0.3. Evidencia (M242): deploy manual en Render de `cad6afe` (15/11/2026, Live); el log muestra «Puma version: 8.0.3» y Ruby 4.0.9. El agente lanzó el deploy con la autorización de M242
- 3.4 Archivo del cambio: hecho en M243 (ver «Workflow follow-up»).

## Workflow follow-up

- Archivado en M243 (15/11/2026), por autorización de Pablo. Sin pendientes.
