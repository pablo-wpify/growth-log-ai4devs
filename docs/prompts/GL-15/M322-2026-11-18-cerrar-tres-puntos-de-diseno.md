# M322. Cierre de ruta, aviso y «Cancelar»

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | decisiones |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `c764c448b004e4324516e8ace98f19cbdf17c994d33c406014068392568a8abd` |
| Fecha y hora (UTC) | 2026-11-18 10:51:28 |

## Texto original

````text
Cerrá los tres puntos de diseño que siguen pendientes en GL-15, usando estas decisiones:

- La ruta debe seguir las convenciones que ya usa la aplicación. Inspeccioná las rutas existentes y documentá la convención; no inventes una URL como requisito de producto.
- Al guardar como lista, mostrar el aviso «Feedback guardado como lista.»
- «Cancelar» vuelve a la ficha de la persona sin guardar los cambios.

Actualizá solo la documentación de GL-15 que necesite reflejar estas decisiones. Conservá el enfoque acordado de Rails y Turbo Frames, con navegación normal como fallback sin JavaScript. No cambies GL-14 ni el plan en este pedido. No implementes código ni corras pruebas.

Al terminar, mostrame el diff completo, los archivos afectados y el estado de Git. No hagas stage, commit, push, PR, merge, deploy ni archive.
````

## Resultado registrado

**Numeración:** M322, por posición en la transcripción (opción A, decidida
por Pablo en M366).

Diseño, sección 4.2: la ruta sigue la convención de la aplicación, el
aviso al guardar como lista es «Feedback guardado como lista.» y
«Cancelar» vuelve a la ficha sin guardar (tarea 0.5). Se señaló que el
aviso chocaba con el requisito vigente «Textos que separan "lista" de
"compartida"» y se plantearon opciones (sección 4.3). Sin commit.
