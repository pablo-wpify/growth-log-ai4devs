# M330. Corrección de dos detalles visuales

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | implementación (corrección dentro de la autorización de M325) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `f4b9ab04910a6caaac59006360917e618585f02d3167140757b82f4e043befde` |
| Fecha y hora (UTC) | 2026-11-18 13:59:25 |

## Texto original

````text
En Growth Log, revisá y corregí únicamente estos dos detalles visuales de GL-15 observados en las capturas de 375×812 y 1280×800:

1. En móvil, los botones «Guardar borrador», «Guardar como lista» y «Cancelar» quedan repartidos en dos filas de manera despareja. Ajustá su disposición para que se vea ordenada y siga siendo cómoda de usar.
2. Al volver a la ficha con errores de validación, «Personas» pierde el resaltado activo de la navegación. Hacé que la respuesta de error conserve el mismo estado activo que la ficha normal.

Antes de editar, inspeccioná cómo se construyen hoy la ficha, la respuesta con errores y sus estilos. Seguí las instrucciones de CLAUDE.md y trabajá primero sobre las pruebas pertinentes. No cambies el comportamiento del formulario ni agregues JavaScript o dependencias.

Dejá fuera de alcance el resumen por dimensión que se desplaza horizontalmente en móvil: es un problema previo a GL-15. No toques GL-14, el plan ni otros cambios locales pendientes. No marques la tarea 3.3 como completada: falta la conformidad visual de Pablo.

Verificá los cambios con las pruebas pertinentes y `bin/ci`. Después, regenerá capturas del formulario abierto y del estado con errores en ambos tamaños, usando datos ficticios y sin dejar cambios en la base de desarrollo. No hagas commit, push, PR, merge ni deploy.

Al terminar, informá los archivos modificados, las verificaciones ejecutadas, dónde quedaron las nuevas capturas y cualquier observación que siga pendiente.
````

## Resultado registrado

**Numeración:** M330, por posición en la transcripción (opción A, decidida
por Pablo en M366).

Pruebas primero: las dos que cubren los defectos fallaron por la razón
esperada. Después: los botones del formulario en móvil quedan uno por
fila, y «Personas» conserva el estado activo en la ficha con errores. Specs
de GL-15, navegación y lenguaje visual: 39 ejemplos, 0 fallos; `bin/ci`
en código 0 con 428 ejemplos. Capturas regeneradas en
`~/Descargas/gl-15-capturas-20261118-110138`. La tarea 3.3 quedó sin
marcar. Sin commit.
