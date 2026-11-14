# M88. Aplicar la revisión del diff de preparación

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | ajustes documentales de una revisión |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `3dd57388d0d08228cc54e28071c63c76462643000eff4c41305c39548605f60a` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M88 | 2026-11-13 01:14:05 |

## Texto original

````text
Aplicá al diff de preparación de GL-06 los ajustes de esta revisión. Trabajá sobre el estado local que produjo `gl06-preparacion.diff`; no hagas commit ni push.

1. En `README.md`, actualizá la fecha del encabezado a 12/11/2026 y corregí las referencias que quedaron desactualizadas respecto de GL-05: la fila de GL-03 que dice que falta verificar la autorización de personas por URL y la sección 1.3 que dice que no hay pantallas más allá del inicio de sesión y la página provisoria. Conservá el nuevo estado de GL-06 como preparado y sin aprobar.
2. Aclarà en el ticket y la spec de P-24 que, sin acceso a la ficha, el autor sigue viendo **todos los campos de su entrada**; de la persona solo se muestra el nombre, sin enlace a la ficha ni acciones de escritura. Alineá los criterios y escenarios que describen ese detalle.
3. No decidas por Pablo cómo se encuentran las entradas propias después de terminar una asignación o desactivar una persona. P-24 propone el acceso por URL, pero la sección «Tus entradas» está en una ficha que en esos casos ya no se puede abrir. Dejá explícita esta limitación y las alternativas en el punto de decisión existente; no agregues una decisión aprobada ni un P nuevo.
4. No cambies el alcance, no implementes código, no marques tareas y no toques otras decisiones o requisitos.

Después, ejecutá solo `openspec validate --all --strict` y `git diff --check`. Entregá el diff actualizado completo o un archivo descargable, su SHA-256, los resultados de esas dos verificaciones y los archivos modificados. Sin commit ni push.
````

## Resultado registrado (no forma parte del pedido)

- **M88:** primera línea de la respuesta final de Claude Code: «Apliqué los tres ajustes de la revisión sobre el mismo estado local que produjo el diff anterior. Las dos verificaciones pasan; no hice commit ni push.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
