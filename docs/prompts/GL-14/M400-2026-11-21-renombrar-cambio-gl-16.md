# M400. Renombre del cambio de GL-16

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-16` (entrega final); se registra junto con GL-14, como M397 a M399 |
| Tipo | documentación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `0ea060d13ede9d967502da36a1b12aee0a699ca29226138f79a6ce9f3d0031f6` |
| Fecha y hora (UTC) | 2026-11-21 16:46:12 |

## Texto original

````text
Renombrá openspec/changes/ruby-4-0-10 a openspec/changes/gl-16-ruby-4-0-10 y actualizá las referencias a esa ruta en los documentos. Conservá el contenido del cambio.

Después ejecutá openspec validate --all --strict y mostrame la salida completa, el diff del renombre y las referencias modificadas, y el estado de Git.

No marques tareas de publicación o archivo como completas. No hagas stage, commit, push, PR, merge, deploy ni archive.
````

## Resultado registrado

**Numeración:** M400, por posición en la transcripción (opción A, decidida
por Pablo en M366). Es el mensaje siguiente a M399.

`openspec/changes/ruby-4-0-10` pasó a `openspec/changes/gl-16-ruby-4-0-10`.
Los SHA-256 de sus archivos son iguales antes y después del renombre.
Se actualizaron las referencias en el plan, el ticket de GL-16, el diseño y
las tareas de GL-14, los resultados de M398 y M399 y `prompts.md`. No se
tocaron los textos originales de los prompts ni los nombres de archivo.
`openspec validate --all --strict`: 23 de 23. Sin tareas de publicación ni
de archivo marcadas, y sin commit.
