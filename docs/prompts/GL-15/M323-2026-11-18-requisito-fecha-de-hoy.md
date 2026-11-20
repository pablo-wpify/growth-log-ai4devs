# M323. Requisito «Fecha de hoy en el formulario»

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | fase documental |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `c1d9c30adac0d9698032643af7989e11033b5727125ec46a0cf3832999af9780` |
| Fecha y hora (UTC) | 2026-11-18 10:56:50 |

## Texto original

````text
Agregá a GL-15 el requisito «Fecha de hoy en el formulario»:
- Al abrir el formulario, la fecha se precarga con la fecha actual según la zona horaria configurada por la aplicación.
- El usuario puede cambiarla antes de guardar.
- Se guarda la fecha elegida por el usuario.

Revisá que la propuesta, el diseño, las tareas y la trazabilidad expresen el mismo comportamiento. No cambies código ni el plan; no hagas stage, commit, push, PR, merge, deploy ni archive. Mostrame el diff completo.
````

## Resultado registrado

**Numeración:** M323, por posición en la transcripción (opción A, decidida
por Pablo en M366).

El requisito «Fecha de hoy en el formulario» ya existía en el delta de
`feedback-capture`; se completó en lugar de crear uno nuevo. Se agregó
que la fecha se precarga según la zona horaria configurada en la
aplicación (hoy Buenos Aires, P-23), que se puede cambiar antes de
guardar y que se guarda la fecha elegida, con el escenario nuevo
«Guardar con otra fecha». El ticket, la propuesta, el diseño y las
tareas se alinearon con el requisito. `openspec validate --all
--strict`: 23 de 23. Sin commit.
