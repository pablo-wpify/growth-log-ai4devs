# M87. Copiar el diff de preparación a Descargas

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | pedido de copia |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `e08cb4d82e92eb56f370c7fdc9e7c546f30236d89af7afcc9be3fce7deda2576` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M87 | 2026-11-13 01:03:51 |

## Texto original

````text
Usá el diff existente en:

`/tmp/claude-1000/-home-pablo/fc6b72ea-b092-4b92-9662-025005e93cf7/scratchpad/gl06-preparacion.diff`

Copialo sin cambios a `~/Descargas/gl06-preparacion.diff`. Después compará ambas copias byte por byte y calculá sus SHA-256; el original fue reportado con este hash: `672009a6ef52f0727a19084fef4dbda7276d8795d45ca1bd3e4a95a21054e0d7`.

No sobrescribas un destino existente. No regeneres el diff, no modifiques el repositorio, no ejecutes pruebas y no hagas commit ni push. Informá si la comparación y los hashes coinciden.
````

## Resultado registrado (no forma parte del pedido)

- **M87:** primera línea de la respuesta final de Claude Code: «El diff ya está en `~/Descargas/gl06-preparacion.diff` y la copia es idéntica al original byte por byte, según `cmp`.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
