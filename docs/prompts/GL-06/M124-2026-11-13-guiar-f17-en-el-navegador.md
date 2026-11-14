# M124. Guiar F17 en el navegador

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | guía de comprobación en navegador |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `dc2f01e896bf752eb0f84ddaa14ba294b44cc6c694b0b17c6da82ee735b6ba19` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M124 | 2026-11-13 20:24:03 |

## Texto original

````text
Guiá a Pablo para ejecutar F17 en el navegador local de esta sesión. La comprobación es manual: Pablo realiza los pasos y comunica lo que observa; vos no inventes resultados ni la marques como hecha por adelantado.

- Abrí `http://127.0.0.1:3000` si el navegador de esta sesión puede acceder. Si no, informa el bloqueo concreto.
- Si las contraseñas de Elena y Tomás aún no están fijadas, detenete y pídele a Pablo que las establezca en su terminal. No las solicites en el chat, no las introduzcas ni las cambies.
- Guiá la tabla de F17 paso a paso. Tras cada acción de Pablo, registra resultado observado frente al esperado, cuenta y URL. Incluye escritorio, 375 px emulados, privacidad con Tomás y sesión vencida.
- Para sesión vencida, espera a que Pablo elija entre esperar el vencimiento real o borrar `session_id`. Si elige borrar la cookie, registra que es una simulación de petición sin sesión.
- No guardes contraseñas en notas o capturas. No reinicies el servidor, no borres datos ni restaures la base.
- Al terminar, entrega el registro de resultados y cualquier paso fallido o no comprobado. No edites `design.md` ni el ticket hasta que Pablo revise el registro. Sin CI remoto, commit, push ni archivado.
````

## Resultado registrado (no forma parte del pedido)

- **M124:** primera línea de la respuesta final de Claude Code: «No pude abrir la aplicación en el navegador de esta sesión: la extensión de Chrome no está conectada. El error textual es:»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
