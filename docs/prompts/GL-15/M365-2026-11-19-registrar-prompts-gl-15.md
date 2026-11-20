# M365. Pedido de registro de los prompts de GL-15

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | documentación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `b8268b45839f254a54176d4c370a0c9750934d413a691b23062fed684eb0c65d` |
| Fecha y hora (UTC) | 2026-11-19 13:15:21 |

## Texto original

````text
Registrá en docs/prompts/ los pedidos de GL-15 que quedaron pendientes desde M284. Continuá la numeración consecutiva desde M285, en orden cronológico, sin renumerar entradas anteriores.

Antes de escribir, verificá que M284 sea el último ID y prepará una tabla con cada pedido, fecha disponible, ID y nombre de archivo. Usá el texto original cuando esté disponible; no reconstruyas ni inventes mensajes incompletos. Registrá pedidos y decisiones de Pablo, no respuestas de estado de Claude. Después creá los archivos siguiendo el formato existente y mostrame el diff y el estado de Git.

No cambies código ni otros documentos. No prepares el stage ni hagas commit o push.
````

## Resultado registrado

**Numeración:** M365, por posición en la transcripción (opción A, decidida
por Pablo en M366).

No se escribió nada: M284 no era el último ID, porque `prompts.md` ya
asignaba M285 a M295 y la numeración posterior al 17/11/2026 22:39 UTC
estaba pendiente. Se presentaron la tabla de pedidos con IDs
provisionales y las decisiones necesarias. Pablo eligió la opción A en
M366, que ejecutó este registro.
