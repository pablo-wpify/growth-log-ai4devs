# M217. Corregir hallazgos de la revisión de GL-10

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-10` |
| Tipo | correcciones de revisión |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `6655c27e0fcfab1409adab4424c74a712ddc2f25ec05c08b31f74b8afff5e177` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M217 | 2026-11-15 00:43:31 |

## Texto original

````text
Corregí solo los hallazgos 2–4 de la revisión de GL-10:
1. Eliminá DemoData::Stop si confirmás que no tiene usos.
2. Documentá en la guía y en el diseño los comandos reales de Render para build (bin/render-build.sh) y arranque de Puma. Confirmá los comandos contra el repositorio antes de escribirlos.
3. Desambiguá los identificadores: el ticket usa R1–R11 para criterios y el diseño R1–R9 para riesgos. Renombrá una de las series y actualizá todas sus referencias.
4. Registrá este pedido como M216 en docs/prompts/GL-10/, su índice y prompts.md, siguiendo el formato existente.
Antes de editar, confirmá rama, HEAD y git status; si no coinciden con la base y los cambios GL-10 de la revisión, detenete. Después corré bin/ci y openspec validate --all --strict, e informá los resultados y el diff.

No hagas stage, commit, push ni cambios en Render. No despliegues. Dejá la autorización para publicar pendiente.
````

## Resultado registrado (no forma parte del pedido)

- **Numeración:** el pedido indicaba registrarse como M216. Por posición en la transcripción, M216 es el pedido de revisión y este es **M217**. Se registran los dos con su número de posición.
- **Hallazgo 2:** eliminada `DemoData::Stop`, sin usos en `app`, `lib` ni `spec`. Queda `DemoData::KEYS`, también sin usos, que no se tocó porque el pedido se limitaba a `Stop`.
- **Hallazgo 3:** documentados en el diseño (sección 9) y en `docs/desarrollo.md` (sección 12) los comandos del servicio. Se confirmaron contra el repositorio y contra el código de railties, pero no se ejecutaron en Render:
  - Build Command: `bin/render-build.sh`;
  - Start Command: `bin/rails server`, que arranca Puma con `config/puma.rb` y `PORT`, y escucha en `0.0.0.0` fuera de `development`.
  - Se aclaró que `WEB_CONCURRENCY` no tiene efecto, porque `config/puma.rb` no define workers.
- **Hallazgo 4:** los criterios del ticket pasan de R1–R11 a **CA1–CA11**, en orden numérico. Se actualizaron sus referencias en el diseño y las tareas. Los riesgos del diseño conservan R1–R9.
- **Verificación:** `bin/ci` con código 0 (368 ejemplos, 0 fallos) y `openspec validate --all --strict` con 19 de 19. Los logs se copiaron antes.
- Sin stage, commit, push, cambios en Render ni deploy. La publicación queda pendiente de autorización.
