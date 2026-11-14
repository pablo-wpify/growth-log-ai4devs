# M129. Consultar si el servidor está levantado

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | consulta |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Escrito directamente en Claude Code. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `3a06a119c93d6ad54c06d802767becb92dafdb06279bdda9aa6654e640d2569e` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M129 | 2026-11-13 23:45:25 |

## Texto original

````text
esta levantado el server?
````

## Resultado registrado (no forma parte del pedido)

- **M129:** primera línea de la respuesta final de Claude Code: «Sí, el servidor de desarrollo está levantado en `http://127.0.0.1:3000`: lo comprobé recién y `GET /up` responde 200 (PID 3291433).»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
