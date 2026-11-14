# M90. Copiar el diff v3 a Descargas

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
| SHA-256 del texto | `c4d992d8a77bbcf88c0685cee5a66e068f09c1cc3c96ea0b3ac7c94a038f08c9` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M90 | 2026-11-13 01:19:56 |

## Texto original

````text
Copiá el diff existente:

`/tmp/claude-1000/-home-pablo/fc6b72ea-b092-4b92-9662-025005e93cf7/scratchpad/gl06-preparacion-v3.diff`

a `~/Descargas/gl06-preparacion-v3.diff`, sin sobrescribir un archivo existente. Compará ambas copias byte por byte y calculá los dos SHA-256. El original fue reportado con este hash:

`605cc651df520469aedf5c9e2d351fd57a57990eff54e1792d3e833977931f36`

No modifiques el repositorio, no regeneres el diff, no ejecutes pruebas ni hagas commit o push. Informá el resultado para que pueda adjuntar la copia a Codex.
````

## Resultado registrado (no forma parte del pedido)

- **M90:** primera línea de la respuesta final de Claude Code: «La copia ya está en `~/Descargas/gl06-preparacion-v3.diff` y es idéntica al original byte por byte (según `cmp`). La podés adjuntar a Codex.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
