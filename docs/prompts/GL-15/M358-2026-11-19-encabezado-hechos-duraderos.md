# M358. Encabezado del ticket con hechos duraderos

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | documentación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | sin marca de texto pegado en la transcripción; origen de la redacción no declarado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `cb22225db1814b50ea7352bbe1e36e9ea39124712b2492424bb67eeb132fa3ac` |
| Fecha y hora (UTC) | 2026-11-19 11:17:57 |

## Texto original

````text
Ajustá únicamente el encabezado de estado de docs/tickets/GL-15-formulario-feedback.md: quitá las afirmaciones transitorias sobre que el archivo OpenSpec está sin commit, sin push o sin publicar. Conservá los hechos duraderos: GL-15 está archivado y validado estrictamente 22/22; la implementación está publicada en feature/entrega-final-pp y el CI pasó sobre 711ee6c; la tarea 0.3 sigue abierta; no hubo PR, merge ni deploy. No cambies otros archivos ni el resto del ticket. Mostrame el diff y el estado de Git, sin stage, commit ni push.
````

## Resultado registrado

**Numeración:** M358, por posición en la transcripción (opción A, decidida
por Pablo en M366).

Se quitaron del encabezado las afirmaciones transitorias sobre commit,
push y publicación del archivo; quedan los hechos duraderos. Sin
commit.
