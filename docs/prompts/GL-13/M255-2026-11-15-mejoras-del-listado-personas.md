# M255 y M256. Mejoras del listado «Personas» en el borrador de GL-13

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-13` (entrega final) |
| Tipo | fase documental (ampliación del borrador) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | M255: texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. M256: escrito directamente en Claude Code |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: los textos son idénticos a los de los mensajes fuente; de M255 solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | M255: `1d397d54f0ae1018773e0a035ad212ece7d4803dbc38d8485c1b9f2fbfdf1262`; M256: `cf8774b5dbfe93083faa91138782f03e3ab1a7598e70bf6d0812baba391066af` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M255 | 2026-11-15 22:22:11 |
| M256 | 2026-11-15 22:23:36 |

## Texto original de M255

````text
Actualizá el borrador SDD de GL-13 para incorporar las mejoras propuestas para la lista de Personas. Seguimos en la Entrega Final. No implementes.

Seguí CLAUDE.md y el flujo SDD. Trabajá sobre el cambio GL-13 existente; no crees un cambio duplicado.

Antes de editar:
- Comprobá rama, HEAD y git status. La rama esperada es feature/entrega-final-pp.
- Si la rama es otra o hay cambios ajenos o inesperados, detenete e informá.
- No leas ni muestres .env, secretos ni credenciales.
- Confirmá que podés consultar la captura adjunta del listado. Si no está disponible, detenete antes de editar los artefactos visuales.

Alcance:
- La Entrega 2 está cerrada. No modifiques docs/plan-entrega-2.md, sus tickets, sus registros ni sus cambios archivados.
- Usá docs/plan-entrega-final.md como fuente de secuencia de esta entrega.
- La propuesta aprobada y sus anexos siguen siendo la fuente funcional. El diseño adjunto sirve como referencia para revisar; no convierte automáticamente sus elementos en requisitos.
- No marques aprobadas las decisiones visuales de GL-13 ni la autorización para implementar.

Mejoras para proponer en el listado:
1. Cada fila abre la ficha de la persona. Asegurá que la navegación funcione con teclado y tenga un foco visible, sin anidar controles interactivos de forma confusa.
2. Mostrá el nombre como texto principal y debajo rol y equipo, en una segunda línea.
3. Usá etiquetas neutras para los conteos. Si no hay entradas listas, proponé “Sin entradas todavía”; si hay borradores pero ninguna lista, distinguí ambas situaciones.
4. Evaluá mostrar la fecha de la última entrada lista visible y el conteo de borradores propios. Nunca calcules esos datos a partir de entradas privadas de otros líderes.
5. Proponé búsqueda por nombre y filtro por equipo, aplicados solo a las personas activas asignadas al líder.
6. La especificación actual ordena Personas por nombre. Conservá ese orden como predeterminado y documentá “Actividad reciente” como opción nueva propuesta, no aprobada. Definí la actividad usando solo entradas listas visibles para ese líder y un desempate estable.
7. Evaluá “Registrar la primera” para una persona sin entradas. Si crea un recorrido nuevo, registralo como decisión pendiente y describí adónde lleva. No permitas que el atajo eluda la autorización ni la asignación.
8. Diferenciá el estado vacío de la lista —sin personas asignadas— del estado de una persona que todavía no tiene entradas.
9. Incluí la vista angosta de 375 px y los estados sin resultados de búsqueda o filtro.

Actualizá los artefactos existentes de GL-13 que correspondan: ticket, proposal.md, design.md, tasks.md, plan-entrega-final.md y el delta de OpenSpec necesario. Si se modifica el comportamiento descrito por 1.14, escribí el delta explícito; no edites la propuesta original ni cambies requisitos de forma silenciosa.

Separá con claridad:
- lo ya aprobado, incluido el orden alfabético predeterminado;
- las mejoras que propongo revisar ahora;
- las preguntas pendientes para Pablo.

Registrá este pedido en docs/prompts siguiendo las reglas del proyecto. Si prompts.md requiere un índice compartido, agregá solo la entrada de la Entrega Final y preservá intacto su contenido de la Entrega 2.

Al terminar, ejecutá solo openspec validate --all --strict si el CLI está disponible. No ejecutes pruebas, CI ni auditorías.

No cambies código, configuración de Render, datos ni servicios. No hagas stage, commit, push, PR, merge ni archive.

Entregá el diff completo, las decisiones propuestas, las preguntas abiertas y el estado de Git.
````

## Texto original de M256

````text
Usá ~/Descargas/Lista de personas@1x.png como referencia visual. Confirmá que sea el listado compartido y continuá con la actualización de GL-13 según el prompt.
````

## Resultado registrado (no forma parte del pedido)

**M255, detenido antes de editar:**

- rama `feature/entrega-final-pp`, HEAD `eabac8e`;
- en el árbol solo estaba el borrador de GL-13 de M254, sin cambios
  ajenos;
- el mensaje no traía una captura adjunta, así que se informó un candidato
  en `~/Descargas` sin abrirlo.

**M256:** Pablo indicó la ruta. La imagen es el listado «Personas», con
búsqueda, filtro por equipo, orden «Actividad reciente», conteos y
«Registrar la primera». Después se actualizó el cambio existente
`gl-13-direccion-visual`, sin crear uno duplicado.

**Archivos actualizados:**

- **ticket, propuesta, tareas y plan de la entrega final:** P-41 a P-45;
- **diseño:** sección 7.2 con 7.2.1, recomendaciones R-10 a R-13, riesgos y
  registro;
- **delta de `visual-language`:** su requisito sobre el comportamiento
  ahora admite cambios solo por requisitos explícitos.

**Deltas nuevos:**

- **`people-browsing`:**
  - `MODIFIED`: «Listado de personas asignadas», «Estado vacío» y «Solo
    lectura y sin funciones inexistentes»;
  - `ADDED`: fila navegable, búsqueda y filtro, orden por actividad
    reciente, sin resultados y pantalla angosta;
- **`feedback-capture`:** `MODIFIED` «Acceso visible a la captura rápida»;
- **`authorization`:** `MODIFIED` «Lecturas agregadas con el alcance de
  entradas».

**Ya aprobado y conservado:** el listado muestra solo las personas activas
asignadas, con el **orden por nombre como predeterminado** (1.14), y el
mensaje sin personas (1.16). La propuesta original no se editó.

**Validación:** `openspec validate --all --strict`, 21 de 21. La primera
corrida marcó un escenario omitido en el `MODIFIED` y un requisito
demasiado largo; los dos se corrigieron antes del resultado final. Sin
pruebas, CI ni auditorías.

**Entrega 2:** sin cambios.

**Pendiente:**

- la revisión de Pablo;
- P-34 a P-45;
- la aprobación para implementar;
- la tarea 3.3 de GL-11, sin marcar.
