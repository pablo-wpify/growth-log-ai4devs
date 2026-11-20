# M327. Confirmación de la corrección

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | revisión de solo lectura |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `47436984efef3f1b6a97fc0f4101123aa45d4dae794d65a0e82644b0d8c26b58` |
| Fecha y hora (UTC) | 2026-11-18 11:58:56 |

## Texto original

````text
Sin modificar archivos ni ejecutar pruebas, CI o auditorías, confirmá estos dos puntos de la corrección:

1. Mostrá la línea exacta del aviso en el código y las líneas correspondientes de la sección 4.3 y la tarea 0.6. Confirmá si el texto es exactamente «Feedback guardado como lista.» y si se eliminó «Solo vos podés verlo.».
2. Mostrá la declaración pertinente de config/routes.rb y la referencia en la vista. Explicá si la ruta define el helper person_complete_feedback_entry_path, sin cargar .env ni iniciar la aplicación.

Incluí el diff de esos cambios, si existe, y el estado de Git. No hagas ninguna modificación.
````

## Resultado registrado

**Numeración:** M327, por posición en la transcripción (opción A, decidida
por Pablo en M366).

Se mostraron la línea exacta del aviso en el controlador y la
comprobación estática del helper. Sin cambios en archivos ni
ejecuciones.
