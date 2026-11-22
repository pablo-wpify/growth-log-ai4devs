# M408. Borrador de GL-17 para la presentación del listado «Personas»

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | Revisión de UI de la entrega final |
| Tipo | borrador documental (SDD) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `55429d9809f0f4cd1ba50cbe08e4d7de002a0c28596f74dbc22538b47ca9d92b` |
| Fecha y hora (UTC) | 2026-11-21 21:03:39 |

## Texto original

````text
Retomá la revisión de UI/UX de «Personas» desde el estado actual del repositorio.

Primero verificá la rama, HEAD y estado de Git. Leé CLAUDE.md y los registros M404–M406, además de las specs y el diseño archivado de GL-14.

Con los hallazgos de la auditoría local y la exploración de Stitch, prepará un cambio documental nuevo para las mejoras recomendadas:
- separar el total de personas del aviso de privacidad, en líneas apiladas;
- aplicar la alternativa B para «Registrar la primera»: acción pequeña, diferenciada de la fila y del conteo, respetando el diseño responsive propuesto.

GL-14 ya está archivado: no lo reabras ni modifiques sus archivos archivados. Buscá el siguiente ID libre para el nuevo ticket/cambio. Dejá los selects apilados en móvil; ponerlos en una fila queda fuera de este cambio porque requiere revisar la spec de pantalla angosta.

Registrá la auditoría y este pedido en docs/prompts, siguiendo la numeración y el formato existentes. Actualizá los índices correspondientes. Conservá el proyecto privado de Stitch como referencia.

No cambies código del producto, no marques tareas de aprobación o implementación, no subas más datos a Stitch, no corras pruebas ni validaciones y no hagas stage, commit, push, PR, merge, deploy ni archive. Al terminar, mostrame el alcance del borrador, los archivos cambiados y el estado de Git.
````

## Resultado registrado

**Numeración:** M408, por posición (opción A; ver M407).

- **Estado inicial:** rama `feature/entrega-final-pp`, HEAD `63b86d0`.
  Sin cambios en el índice. Cambios sin commit de M404 a M406:
  `prompts.md` modificado y, sin seguimiento, `.claude/agents/`,
  `.claude/skills/impeccable/` y esta carpeta.
- **ID:** GL-17, el siguiente libre. GL-16 es el último usado y no hay
  otro GL-17 en el repositorio, los cambios de OpenSpec ni las ramas.
- **Cambio de OpenSpec** `gl-17-presentacion-listado-personas`, creado con
  `openspec new change`: propuesta, delta de `people-browsing`, diseño y
  tareas, más el ticket `docs/tickets/GL-17-presentacion-listado-personas.md`.
  - El delta modifica «Total de personas y aviso de privacidad» (dos
    líneas, sin separador) y agrega «"Registrar la primera" como acción
    secundaria» y «Detalles de la fila en pantalla ancha» (a la derecha
    desde 40 rem).
  - `feedback-capture`, `authorization` y `visual-language` no cambian.
    Los selects siguen apilados a 375 px y «Listado en pantalla angosta»
    no se toca.
- **Plan de la entrega final:** GL-17 en la secuencia, P-54 y P-55
  propuestas (sección 5.4) y su revisión en el próximo paso.
- **Tareas:** solo la 0.1 (creación del borrador) está marcada. La
  validación, la revisión, la aprobación y la implementación siguen
  abiertas.
- GL-14 y sus archivos archivados no se modificaron. El proyecto de Stitch
  se conserva como referencia, sin subir nada nuevo.
- Sin cambios en el código del producto, sin `openspec validate`, sin
  pruebas y sin stage, commit, push, PR, merge, deploy ni archivo.
