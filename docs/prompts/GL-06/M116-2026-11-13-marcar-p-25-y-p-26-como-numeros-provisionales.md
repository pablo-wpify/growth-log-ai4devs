# M116. Marcar P-25 y P-26 como números provisionales

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | ajustes editoriales de una revisión |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `41a667e6262f354913ec339bb7cc9e42bb035b61eafad6d86b28dab495e66b23` (del texto del mensaje fuente; igual en los dos envíos) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M116 | 2026-11-13 19:08:47 |
| M117 | 2026-11-13 19:11:19 (mismo texto, enviado de nuevo después del resultado de M116) |

## Texto original

````text
Aplicá solo los ajustes editoriales de esta revisión a GL-06. No vuelvas a inspeccionar todo el checkout.

- Conservá el contenido confirmado de las dos decisiones adicionales, pero distingue explícitamente ese contenido de sus identificadores provisionales P-25 y P-26. No marques los identificadores como confirmados ni vuelvas a abrir el contenido de las decisiones.
- Alineá las referencias a esas decisiones en el plan, el registro de decisiones, ticket, proposal, design, tasks y README. Donde aparezca el rango P-19 a P-26, deja claro que los dos últimos números son provisionales hasta que Pablo los confirme.
- En las filas de P-26 del plan y del registro de decisiones, agrega que la rama de lectura de PT-11 es parcial mientras “con datos mínimos” siga pendiente de interpretación.
- No cambies el alcance de GL-06: P-24 conserva su contenido; reasignación, compartir y revocar siguen fuera. La tarea 0.4 queda sin marcar y la implementación sigue bloqueada.
- No cambies la decisión sobre MVP-FE-1 ni alteres tareas de implementación.

Después de editar, ejecutá únicamente `openspec validate --all --strict` para registrar la validación del estado final. No ejecutes pruebas, lint ni migraciones. Sin commit, push ni archivado.

Informa los archivos modificados, el resultado de la validación y confirma que el cambio sigue sin aprobar y sin autorización de implementación.
````

## Resultado registrado (no forma parte del pedido)

- El contenido de las dos decisiones adicionales se conserva como
  decidido, y sus identificadores **P-25 y P-26** quedan marcados como
  **provisionales** hasta que Pablo los confirme. Cambiaron el plan
  (encabezado, secuencia, sección 6, filas P-25 y P-26 y próximo paso),
  el registro de decisiones del 13/11/2026, el ticket, `proposal.md`,
  `design.md`, `tasks.md`, el README y `openspec/config.yaml`. Ningún
  rango queda como «P-19 a P-26» sin la aclaración.
- Las filas de P-26 del plan y del registro, y la de `design.md`, dicen que
  la rama de lectura de PT-11 es parcial mientras «con datos mínimos» siga
  pendiente de interpretación.
- Sin cambios de alcance: P-24 conserva su contenido; reasignación,
  compartir y revocar siguen fuera; P-22 y MVP-FE-1 no cambian. 0.4 sin
  marcar; ninguna tarea de implementación tocada.
- `openspec validate --all --strict` (19:09 UTC, estado final): 16
  elementos válidos, 0 fallidos; anotado en la evidencia de 0.3.
- Sin commit ni push. El cambio de OpenSpec **no** está aprobado y la
  implementación no está autorizada.
- M115 (revisión documental de solo lectura) no está registrado.
- **M117** repitió el texto de M116. Como los documentos ya estaban
  ajustados, no se volvieron a editar: solo se registró el segundo envío y
  se repitió `openspec validate --all --strict`.
