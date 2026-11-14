# M163. Confirmar decisiones D1 a D6

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | decisiones de Pablo |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `792848899eafb751218ade76f787676f053b880b52645e1d957c13b66d5f4b21` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M163 | 2026-11-14 13:23:58 |

## Texto original

````text
Confirmo estas decisiones y autorizo únicamente las comprobaciones que siguen:

- D1: b. Yo repetiré personalmente los pasos visuales clave; Claude Code puede asistir y registrar, pero no manejar el navegador en esas comprobaciones.
- D2: b. Repetiré el paso 15 con DevTools en modo dispositivo y los controles pendientes.
- D3: b. Comprobaré un POST después del vencimiento real de la sesión.
- Pasos 7 y 9: autorizo repetirlos después de la corrección usando la entrada ficticia 2; registrá el estado final.
- Registro: autorizo unificar los pasos 1–10 en el scratchpad con la numeración de la guía.
- D4.1: a. Además del paso 16, haré una simulación sin cookie, sin pulsar «Atrás», e inspeccionaré el formulario después de iniciar sesión para comprobar si conserva el texto.
- D4.2: a. Registrar la falta de aviso como observación en GL-06, sin mitigarla ahora.
- D5: a. Registrar los dos 422 por CSRF como observaciones no investigadas y posible seguimiento de GL-02.
- D6: a. Conservar las entradas y las copias de logs hasta archivar; antes, proponer dónde guardar fuera del repositorio las copias necesarias.

No autorizo todavía D7 ni la edición del diseño, ticket, prompts, plan o README. Después de las comprobaciones, presentame la evidencia y el diff documental propuesto para revisar. No marques F17 completa ni hagas commit, push, CI remoto o archivo del cambio.
````

## Resultado registrado (no forma parte del pedido)

- **M163:** primera línea de la respuesta final de Claude Code: «Registré tus decisiones y unifiqué el registro de F17 en el scratchpad. No empecé ninguna comprobación ni cambié código, datos o documentos del proyecto, y F17 sigue incompleta.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
