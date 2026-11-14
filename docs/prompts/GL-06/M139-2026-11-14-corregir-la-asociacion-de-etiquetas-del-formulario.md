# M139. Corregir la asociación de etiquetas del formulario

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | corrección con regresión y verificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Escrito directamente en Claude Code. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `d07ccbf5d0055b75a170d126cad6d9b8aa6371bebccf5903bc2b53f997fc6083` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M139 | 2026-11-14 11:57:36 |

## Texto original

````text
Corregí el formulario de edición para que cada etiqueta quede asociada al id real de su radio y el botón y su texto se mantengan juntos al pasar de línea. Agregá una prueba de regresión que compruebe la asociación de las opciones y ejecutá la prueba pertinente.

Después, repetí la revisión del formulario a escritorio y a 375 px: verificá que tocar el texto seleccione la opción, que las opciones no se confundan y que no haya desborde. Registrá el resultado. No cambies documentos ni marques F17 completa hasta que Pablo revise la evidencia. Luego continuá con el paso 16, registrándolo como simulación si borrás la cookie, no como vencimiento real de la sesión.
````

## Resultado registrado (no forma parte del pedido)

- **M139:** primera línea de la respuesta final de Claude Code: «Corregí el formulario de edición y la revisión en escritorio y a 375 px **pasa**. El paso 16 está preparado pero sin enviar: no puedo borrar la cookie de sesión desde mis herramientas y necesito que la borres vos.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
