# M67. Comparar las copias sin versionar

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-05` |
| Tipo | pedido de verificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `7c51aaa29eafd5cb5e70f1970f082aa603f6d7ca8ea098a855effb43d62f65d7` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M67 | 2026-11-07 17:20:09 |

## Texto original

````text
Hacé una comparación de solo lectura entre las seis copias sin versionar del worktree principal y sus versiones en `feature/GL-05-personas-rails-8-1-4-1` (`a60fb8ed4e4abed8c033bd2a827a9d5390a1e550`).

Para cada ruta, informá el SHA-256 del archivo local y el SHA-256 del blob en el commit. No muestres el contenido. Incluí solo estas rutas:

- `docs/prompts/GL-01b/M38-2026-11-06-proponer-la-actualizacion-a-rails-8-1-4-1.md`
- `docs/prompts/GL-01b/M39-2026-11-06-revisar-la-propuesta-gl-01b.md`
- `docs/prompts/GL-01b/M40-2026-11-06-corregir-discrepancias-del-ticket-gl-01b.md`
- `docs/prompts/GL-01b/M41-2026-11-06-reconciliar-el-conteo-de-avisos-de-gl-01b.md`
- `docs/prompts/GL-01b/README.md`
- `docs/tickets/GL-01b-rails-8-1-4-1.md`

Confirmá también que M36 y M37 no coinciden con rutas del commit. No muevas, borres, edites ni sobrescribas archivos; no cambies ramas o worktrees y no hagas operaciones remotas.
````

## Resultado registrado (no forma parte del pedido)

- Por SHA-256: M38 a M41 eran iguales a los del commit; el README y el
  ticket de GL-01b, distintos. M36 y M37 no estaban en el commit.
