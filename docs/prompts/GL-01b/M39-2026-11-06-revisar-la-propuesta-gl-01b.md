# M39. Revisar la propuesta GL-01b

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-01b` |
| Tipo | pedido de planificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `91b8b8c4240bc6009d421cca7c88d7eb9687d21d6884ec7af7f61ec2603211ee` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M39 | 2026-11-06 22:43:15 |

## Texto original

````text
Revisá y corregí la propuesta GL-01b de Rails 8.1.4.1. Esta tarea es solo de planificación: no modifiques Gemfile, Gemfile.lock ni código; no ejecutes la actualización; no crees ramas, commits, push ni PR.

Primero, lee CLAUDE.md y localiza la propuesta GL-01b y los documentos de planificación relacionados. Conservá el alcance separado de GL-05.

Ajustá la propuesta para que:
1. El criterio de cambios en Gemfile.lock no exija limitarse a las 13 gemas de Rails. Rails 8.1.4.1 requiere rails-html-sanitizer 1.7.2 o posterior. Permití esa actualización y cualquier dependencia transitiva que Bundler necesite estrictamente para resolver los requisitos; exigí documentar y justificar cada cambio, y dejar intactas las dependencias no necesarias.
2. Revises la lista de avisos clasificados como “no aplican en runtime”. Dice que son 11, pero enumera 10. Verificá cada aviso en su advisory y agregá el que falta —revisá especialmente GHSA-3f4q-8x5m-76v8— o corregí el total si corresponde. No clasifiques un aviso solo a partir del resumen de Rails.
3. Corrijas la verificación de checksums. No uses el anuncio de Rails como fuente. Indicá que se validen con los datos de RubyGems y la verificación de integridad de Bundler.
4. Mantengas P-18 sin aprobar. Dejá documentada la recomendación de no cambiar el Gemfile porque ~> 8.1.4 admite 8.1.4.1, pero no presentes esa decisión como aprobada por Pablo.
5. Dejes el CI remoto como pendiente de autorización para push y PR. No lo marques como un paso ejecutado o autorizado.
Conservá las demás decisiones y límites de la propuesta. Al terminar, mostrame los archivos que cambiaste y un resumen de los ajustes. No avances a implementación ni solicites autorización para actualizar Rails en esta misma tarea.
````

## Resultado registrado (no forma parte del pedido)

- La propuesta no estaba en el repositorio, solo en la respuesta a M38. Se
  guardó corregida en `docs/tickets/GL-01b-rails-8-1-4-1.md`, sin versionar,
  separada de GL-05.
- **Lockfile:** admite `rails-html-sanitizer >= 1.7.2` y cualquier
  dependencia transitiva estrictamente necesaria, con justificación de cada
  cambio. Según la API de RubyGems, es la única dependencia nueva, y el
  lockfile ya tiene 1.7.2.
- **Avisos:** se clasificaron con el advisory de cada uno en `rails/rails`.
  - El conteo anterior de «no aplican» era correcto: 11, con
    GHSA-3f4q-8x5m-76v8 incluido.
  - Ocho avisos pasaron a «no aplica»; dos eran errores de la versión
    anterior (GHSA-gmj8-hvj3-49mw y GHSA-68p9-83h6-5wpj).
  - Resultado: 19 no aplican, 1 aplica (GHSA-2gff-2mmg-m73p) y 1 no es
    confirmable (GHSA-8474-xrp6-wh69).
- **Checksums:** se validan con la API de RubyGems y la verificación de
  integridad de Bundler, no con el anuncio.
- P-18 queda sin aprobar y el CI remoto, pendiente de la autorización de
  push y PR.
- Sin cambios en `Gemfile`, `Gemfile.lock` ni código; sin ramas, commits,
  push ni PR.
- El índice general `prompts.md` no se actualizó, porque tiene cambios de
  GL-05 sin commit. Queda pendiente para el commit de GL-01b.
