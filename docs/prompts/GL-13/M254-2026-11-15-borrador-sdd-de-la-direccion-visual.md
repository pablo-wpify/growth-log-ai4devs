# M254. Borrador SDD de la dirección visual (GL-13)

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-13` (entrega final) |
| Tipo | fase documental |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada); el mensaje llegó en cola durante la ejecución de M250 |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `87b83988b12f8fe8e583d76e014bd369e143f6911888e01cb96fbfa30824ad29` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M254 | 2026-11-15 21:23:46 (entrada en cola) |

## Texto original

````text
En el checkout local de Growth Log, prepará el borrador SDD para definir un look & feel coherente para la aplicación y sus pantallas principales. Todavía no implementes.

Este trabajo pertenece a la Entrega Final. La Entrega 2 está cerrada: no modifiques sus documentos, tickets, registros de prompts ni cambios archivados.

Seguí CLAUDE.md y el flujo SDD del proyecto: ticket → propuesta, specs, diseño y tareas → validación → revisión de Pablo.

Antes de editar:
- Comprobá rama, HEAD y git status. La rama esperada es feature/entrega-final-pp.
- Si la rama es otra o encontrás cambios ajenos o inesperados, detenete e informá antes de editar.
- No leas ni muestres archivos .env, secretos ni credenciales.
- Confirmá que existe y podés leer la referencia visual indicada abajo. Si no está disponible, informá la ruta que falta y detenete antes de preparar la dirección visual.

Referencia visual candidata:
~/Descargas/Ficha de persona · versión combinada@2x.png

Usá esa imagen para orientar la paleta y el look & feel: navegación superior, tonos crema, terracota, marrón y verde salvia. Es una referencia visual para explorar, no una especificación funcional ni una decisión definitiva de Pablo.

Fuentes de verdad del producto:
- La propuesta aprobada de la Entrega 1 y sus anexos, especialmente los anexos A, E y G.
- Las specs vigentes, los cambios archivados y el código actual.
- El código muestra qué está implementado; no reemplaza ni reduce el alcance aprobado.
- No edites la propuesta original ni documentos de la Entrega 2.

Secuencia de la Entrega Final:
- Revisá si ya existe un plan propio para la Entrega Final.
- Si existe, usalo como única fuente de secuencia para esta entrega.
- Si no existe, creá docs/plan-entrega-final.md como única fuente de secuencia para la Entrega Final.
- No agregues tickets de la Entrega Final a docs/plan-entrega-2.md.

Compará el diseño propuesto con las historias, criterios de aceptación y flujos de la propuesta aprobada. Si encontrás algo mal planteado o incompleto, proponé el cambio con su motivo y registralo como decisión pendiente; no lo descartes ni lo cambies en silencio.

Cobertura visual:
Prepará una propuesta coherente para estas pantallas:
1. Inicio de sesión.
2. Lista de personas asignadas.
3. Ficha de persona.
4. Captura rápida.
5. Detalle de entrada y acción para compartir.
6. Feed de feedback.
7. Administración e invitaciones previstas en la propuesta.

Para cada pantalla, indicá:
- Qué mock, vista o criterio existente la respalda.
- Qué está implementado y qué sigue pendiente, según el código y el plan.
- Los estados importantes que faltan representar: vacío, error, borrador, lista sin compartir, compartida y pantalla angosta, cuando correspondan.

Criterios para la propuesta visual:
- Considerá Personas y Feedback como destinos principales y evaluá la navegación superior de la imagen frente al alcance actual.
- Mantené la evidencia para conversaciones en el centro; no conviertas el resumen en un puntaje de desempeño.
- Conservá la privacidad por defecto y las reglas de autorización vigentes.
- Compartir ocurre sobre una entrada según el flujo de H5. No agregues una pestaña «Compartir» en la ficha como nuevo destino sin justificarla contra la propuesta y dejar la decisión abierta.
- En la imagen de referencia, Ada es la persona acompañada, no la destinataria. Las etiquetas deben identificar correctamente al otro líder o a quien ve la entrada.
- Diferenciá con claridad un borrador privado de una entrada lista que todavía no se compartió.
- La especificación exige orden cronológico por fecha del hecho, pero no establece cuál extremo aparece primero. «Más recientes primero» puede quedar como recomendación pendiente, no como decisión de Pablo.
- No agregues funciones, roles, puntajes, recomendaciones automáticas ni destinos de navegación que no estén respaldados por la propuesta aprobada.
- La comprobación manual de GL-11 sigue pendiente para el cierre de la Entrega Final; no la marques como completada.

Entregables SDD:
- Revisá qué ID de ticket está libre y proponé el siguiente.
- Prepará ticket, proposal.md, design.md, tasks.md y solo los deltas de OpenSpec que sean necesarios.
- Separá decisiones aprobadas, recomendaciones y preguntas abiertas.
- Si no hay una herramienta disponible para crear e inspeccionar mocks, no inventes capturas. Dejá un mapa de pantallas y estados claramente marcado como propuesta.
- Registrá este pedido en el lugar que indiquen las reglas de prompts para la Entrega Final. No alteres registros de la Entrega 2.
- Dejá el trabajo listo para revisión de Pablo; no marques aprobada la dirección visual por él.

Al terminar, ejecutá solo openspec validate --all --strict si el CLI está disponible. No ejecutes pruebas, CI ni auditorías.

No cambies código funcional, configuración de Render, datos ni servicios. No hagas stage, commit, push, PR, merge ni archive.

Entregá el diff completo, la cobertura visual, las decisiones propuestas, las preguntas abiertas y el estado final de Git.
````

## Resultado registrado (no forma parte del pedido)

**Verificación previa (en M250, repetida antes de seguir con M254):**

- rama `feature/entrega-final-pp`, HEAD `eabac8e`, árbol limpio;
- la referencia visual existe y se pudo leer;
- no había un plan propio de la entrega final.

**Archivos preparados, sin stage ni commit:**

- `docs/plan-entrega-final.md`: nuevo, única fuente de la secuencia de la
  entrega final, con GL-13 y las decisiones P-34 a P-40;
- `docs/tickets/GL-13-direccion-visual.md`;
- cambio `openspec/changes/gl-13-direccion-visual/`: `proposal.md`,
  `design.md`, `tasks.md` y la capability nueva `visual-language` (solo
  `ADDED`);
- este registro, el README de la etapa y la sección «Entrega final» de
  `prompts.md`.

**Documentos de la entrega 2:** no se modificaron, ni su plan, ni sus
tickets, ni sus registros, ni los cambios archivados.

**Validación:** `openspec validate --all --strict`, 21 de 21 en verde,
incluido `change/gl-13-direccion-visual`. Sin pruebas, CI ni auditorías.

**Desvío informado:** el pedido dice que la especificación no fija qué
extremo de la cronología aparece primero. En el repositorio sí lo fija:
`feedback-summary` vigente y P-10, aprobada el 14/11/2026, exigen de la más
antigua a la más reciente. «Más recientes primero» en la ficha quedó como
la decisión pendiente P-36, que reabriría P-10. No se cambió.

**Pendiente:**

- la revisión de Pablo;
- P-34 a P-40;
- la aprobación para implementar;
- la tarea 3.3 de GL-11, que sigue sin marcar.
