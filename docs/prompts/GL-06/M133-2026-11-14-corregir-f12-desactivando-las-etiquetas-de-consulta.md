# M133. Corregir F12 desactivando las etiquetas de consulta

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | corrección con regresión |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Escrito directamente en Claude Code. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `94b80e505e111cab859c7f423e92413c490f6b84df067f0a6c731a60c7fdc587` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M133 | 2026-11-14 00:06:05 |

## Texto original

````text
Aplicá la alternativa 1 para resolver F12: desactivá config.active_record.query_log_tags_enabled en desarrollo. Agregá una regresión que compruebe explícitamente esa configuración y que el texto ficticio no aparezca en el log de consultas de desarrollo; no dependas de una prueba que corre en test, porque ahí las sentencias preparadas están activas. Conservá el requisito de privacidad de F12. No relajes el filtro ni cambies el nivel general del log. No borres los logs actuales: preservá la evidencia del fallo y proponé cómo iniciar una verificación limpia. No hagas commit, push, CI ni archivo del cambio. Cuando la corrección esté verificada, informá el resultado antes de retomar F17.
````

## Resultado registrado (no forma parte del pedido)

- **M133:** primera línea de la respuesta final de Claude Code: «Corregí F12 en desarrollo y la corrección está verificada en local. F17 sigue en pausa hasta que me digas cómo seguir.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
