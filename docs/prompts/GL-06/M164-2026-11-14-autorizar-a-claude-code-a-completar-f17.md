# M164. Autorizar a Claude Code a completar F17

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | autorización de verificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `19f3096a45982b3fe508eeb4b1344446b75fb28112ec88424912b42b222b89dd` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M164 | 2026-11-14 13:27:31 |

## Texto original

````text
Autorizo a Claude Code a completar las verificaciones pendientes de F17 en desarrollo. Registrá que Claude manejó el navegador; no afirmes que Pablo ejecutó manualmente esos pasos.

1. Repetí los pasos 7 y 9 con el formulario corregido, reutilizando la entrada ficticia 2. Registrá que quedará modificada; no crees otra entrada ni borres datos.
2. Repetí el paso 15 con DevTools en modo dispositivo a 375 px. Revisá la ficha, la captura, el detalle y la edición, incluidos los controles pendientes. No uses el iframe como sustituto.
3. Para el paso 16, comprobá un POST después del vencimiento real de la sesión: dejá la captura abierta más de dos horas sin actividad, enviá el texto ficticio y, después de iniciar sesión, inspeccioná si el texto se conserva. No pulses «Atrás». Confirmá también que no se creó ninguna entrada ni se filtró el texto en los logs. Si no podés comprobar el vencimiento real, detenete y reportalo; no lo reemplaces por la simulación sin cookie.
4. Unificá en el registro del scratchpad los pasos 1–10 con la numeración de la guía, usando solo evidencia disponible.

Registrá la falta de aviso y los 422 por CSRF como observaciones, sin mitigarlos ni investigarlos ahora. Conservá las entradas y las copias de logs.

No marques F17 completa ni edites el diseño, el ticket, tasks, plan o README. Después, presentame un informe único con los resultados y el diff documental propuesto para revisar. No repitas RuboCop, bin/ci ni auditorías; no hagas commit, push, CI remoto ni archivo del cambio.
````

## Resultado registrado (no forma parte del pedido)

- **M164:** primera línea de la respuesta final de Claude Code: «Los pasos 7 y 9 ya pasaron con el formulario corregido. El paso 16 está en espera del vencimiento real de la sesión, y el paso 15 necesita que actives una vez el modo dispositivo de DevTools. F17 sigue incompleta.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
