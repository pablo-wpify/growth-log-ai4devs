# M79. Revisar la numeración y los pendientes de E10

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-05` |
| Tipo | pedido de revisión documental |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `53823dc0147fc10da0f184cfdcf9432ad96011d9effe5c4587b2c572cb4226eb` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M79 | 2026-11-07 21:59:38 |

## Texto original

````text
En el worktree de Growth Log, leé `CLAUDE.md` y revisá primero `git status`, la rama y el HEAD. El estado esperado es `feature/entrega-2-pp` en `8d0e854`. Preservá todos los cambios locales y no uses `reset`, `clean` ni stash.

E10 está cerrado y `gl-05-personas` archivado. La comprobación se hizo manualmente por Pablo y con asistencia de Claude en Chrome. No reabras esos trabajos salvo que encuentres una contradicción concreta en el registro.

Revisá y resolvé estas observaciones:

1. **Numeración de M75.** Contrasta `prompts.md`, `docs/prompts/GL-05/README.md` y los registros posteriores a M70. Determiná el siguiente número según las convenciones del repo y los pedidos que realmente deben registrarse; no cuentes automáticamente cada mensaje de la conversación como un prompt. Si M75 no corresponde, corrige el nombre, los índices y las referencias afectadas, explicando el criterio.
2. **“URL directa pendiente en GL-05”.** Lee el contexto de esa línea en `docs/plan-entrega-2.md`. Si se refiere al acceso directo de Elena a `/personas/3`, actualízala con el resultado de E10 (404 sin datos de Carla) y la evidencia automatizada correspondiente. Si se refiere a un caso diferente, dejala pendiente y aclara cuál es.
3. **Pasos adicionales del diseño.** Revisá si “volver a Personas”, Inés a 375 px, la cabecera en dos líneas y el tamaño de los enlaces son criterios obligatorios o comprobaciones adicionales. No los marques como aprobados sin evidencia. Si son obligatorios y se pueden verificar en la sesión local ya disponible sin pedir ni cambiar credenciales, comprobálos y registra lo observado. Si no, déjalos explícitamente como pendientes de seguimiento y no alteres el resultado de los siete puntos E10.

Conservá los datos de E10 tal como se observaron: Chrome 155 en Linux; escritorio a 1920 px reales (1870 px para cierre de sesión); 375 px emulados con DevTools; resultado de los siete puntos, y que el primer acceso de Inés se autocompletó como Elena pero se repitió correctamente. No afirmes que se usó un viewport real de 375 px.

Actualizá solo los documentos e índices necesarios, siguiendo sus convenciones. Ejecutá `openspec validate --all --strict` y `git diff --check`. No cambies código, `Gemfile` ni `Gemfile.lock`; no hagas commit, push, PR ni merge. Al terminar, reportá los cambios exactos, cómo resolviste cada observación y cualquier comprobación que siga pendiente.
````

## Resultado registrado (no forma parte del pedido)

- **Numeración:** M75 no correspondía. Después de M74 había tres envíos de
  pedidos sin registrar: el pedido de E10 (dos envíos con el mismo
  SHA-256, en dos sesiones) y la revisión de la conexión a la base. Se
  registraron como M75 a M77, y el registro de E10 y archivo pasó de M75 a
  M78. Las catorce respuestas operativas breves y las dos capturas no se
  numeran; el criterio quedó en `prompts.md`.
- **URL directa:** la línea del plan se refería a los casos L3 y A con las
  personas P y Q. Quedó comprobada con `people_spec` (CI 42398717466
  sobre `8d0e854`) y con el caso manual de Elena y Carla en E10.
- **Pasos adicionales del diseño:** no son criterios de E10, sino pasos
  del procedimiento. No se comprobaron y quedaron como seguimiento en el
  plan y el ticket. Los siete puntos de E10 no cambian.
- Sin cambios de código, `Gemfile` ni `Gemfile.lock`. Sin commit, push,
  PR ni merge.
