# M257. Separación de la dirección visual (GL-13) y de las mejoras del listado «Personas» (GL-14)

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-14` (entrega final); también actualiza `GL-13` |
| Tipo | fase documental (separación de un borrador y ticket nuevo) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `7e67539f8f688fbfbb16c6fdc41cc9b970deff3e2ae4477e37ce6626240ea799` |
| Fecha y hora (UTC) | 2026-11-15 23:39:46 |

**Numeración.** Es el primer mensaje de Pablo después de M256 en la
transcripción. Entre los dos solo está el resumen automático que Claude
Code agregó al continuar la sesión, que no es un pedido.

## Texto original

````text
En el checkout local de Growth Log, separá el trabajo de dirección visual de GL-13 de las mejoras funcionales del listado de Personas. Seguí CLAUDE.md y el flujo SDD. No implementes.

Antes de editar:
- Comprobá rama, HEAD y git status. La rama esperada es feature/entrega-final-pp.
- El borrador local de GL-13 y su registro de prompts son cambios esperados. Si encontrás otros cambios ajenos o inesperados, detenete e informá.
- No leas ni muestres archivos .env, secretos ni credenciales.

Límites:
- La Entrega 2 está cerrada. No modifiques docs/plan-entrega-2.md, sus tickets, registros ni cambios archivados.
- Usá docs/plan-entrega-final.md como única fuente de secuencia para la Entrega Final.
- No cambies la propuesta original aprobada. Los cambios de comportamiento van en deltas de OpenSpec.
- No cambies código, configuración de Render, datos ni servicios. No hagas stage, commit, push, PR, merge ni archive.

GL-13 — Dirección visual:
- Conservá GL-13 como el cambio visual transversal: paleta, tipografía, navegación, componentes y mapa de pantallas.
- Retirá de GL-13 los requisitos funcionales de búsqueda, filtro, orden alternativo, conteos ampliados y acceso directo a la captura. Trasladalos al nuevo GL-14.
- La referencia visual del listado está en ~/Descargas/Lista de personas@1x.png. Confirmá que puedas abrirla y que corresponda a la captura compartida.
- Conservá como pendientes las decisiones P-34 y P-35. Mantené P-10: la cronología de la ficha sigue de la más antigua a la más reciente. No agregues una pestaña «Compartir».

GL-14 — Mejoras del listado de Personas:
- Verificá que GL-14 sea el siguiente ID libre.
- Prepará ticket, proposal.md, design.md, tasks.md y los deltas necesarios de OpenSpec.
- Registrá como decisiones aprobadas por Pablo en este pedido:
  1. Presentar los nombres como enlaces de fila completa, con foco de teclado visible. Evitá enlaces o botones anidados.
  2. Mostrar nombre y, debajo, «rol · equipo».
  3. Usar etiquetas neutrales:
     - Sin entradas en ningún estado: «Sin entradas todavía».
     - Borradores propios, sin entradas listas visibles: «Sin entradas listas · N borradores».
     - Entradas listas visibles y borradores propios: «N entradas listas · M borradores».
     Los conteos de entradas listas se limitan a lo que el líder puede ver; los borradores cuentan solo si pertenecen a ese líder.
  4. Mostrar la fecha del hecho más reciente entre las entradas listas visibles, con el rótulo «Último hecho». Usar la misma fecha para la opción de orden «Hechos más recientes». Los borradores no cuentan para la fecha ni para ese orden.
  5. Agregar búsqueda por nombre y filtro por equipo, limitados a las personas activas asignadas al líder.
  6. Mantener el orden por nombre como predeterminado, según el criterio 1.14. Agregar «Hechos más recientes» como opción. En empates, ordenar por nombre y luego por ID.
  7. Agregar «Registrar la primera» para una persona sin entradas. Debe ser una acción independiente de la fila que lleva a la captura existente, conserva la autorización y vuelve a la ficha al guardar.
  8. Distinguir la lista vacía —sin personas asignadas— de una persona sin entradas.
  9. Incluir estados sin resultados, limpieza de filtros y una presentación usable a 375 px.

Ubicación de las deltas:
- El texto y comportamiento del listado corresponden a people-browsing. Ahí deben quedar la búsqueda, el filtro, el orden, los conteos y sus estados.
- El acceso directo a la captura corresponde a feedback-capture.
- authorization debe especificar el alcance de los registros visibles, no ser la fuente del texto de pantalla. No cambies sus reglas de autorización existentes salvo que el nuevo flujo exija un requisito explícito; si lo exige, justificá el delta sin alterar el modelo de permisos.

Decisiones que siguen abiertas:
- GL-13 P-34, P-35 y las demás decisiones visuales que Pablo todavía no haya resuelto.
- En GL-14, no agregues decisiones nuevas por inferencia. Explicá las decisiones aprobadas anteriores y dejá abiertas solo las consecuencias funcionales que todavía necesiten definición.
- No cambies el texto de P-10 ni el orden cronológico aprobado.

Actualizá docs/plan-entrega-final.md para mostrar GL-13 y GL-14 en la secuencia adecuada. Registrá este pedido en docs/prompts según las reglas del proyecto. Si prompts.md requiere una entrada compartida, agregá solo la de Entrega Final y preservá intacto el contenido de Entrega 2.

Al terminar, ejecutá solo openspec validate --all --strict si el CLI está disponible. No ejecutes pruebas, CI ni auditorías.

Entregá el diff completo, las decisiones registradas, las preguntas abiertas y el estado de Git.
````

## Resultado registrado (no forma parte del pedido)

**Comprobaciones previas:**

- rama `feature/entrega-final-pp`, HEAD `eabac8e`;
- en el árbol solo estaban el borrador de GL-13 y su registro de prompts,
  sin cambios ajenos;
- la imagen `~/Descargas/Lista de personas@1x.png` se abrió y es la
  captura compartida en M256: el listado «Personas» con búsqueda, filtro
  por equipo, orden, conteos y «Registrar la primera»;
- GL-14 es el siguiente ID libre: no aparece en el repositorio, en los
  cambios de OpenSpec ni en las ramas.

**GL-13** (`gl-13-direccion-visual`) quedó como el cambio visual
transversal:

- se retiraron los deltas de `people-browsing`, `feedback-capture` y
  `authorization`;
- del diseño se retiraron la sección 7.2.1, R-10 a R-13 y P-41 a P-45;
- se actualizaron el ticket, la propuesta, el diseño y las tareas;
- P-34, P-35 y P-38 a P-40 siguen abiertas;
- P-36 y P-37 se registraron como resueltas según el pedido: se mantiene
  P-10 y no hay pestaña «Compartir».

**GL-14** (`gl-14-mejoras-listado-personas`, nuevo):

- ticket, propuesta, diseño y tareas;
- deltas:
  - `people-browsing`: `MODIFIED` ×3 y `ADDED` ×6;
  - `feedback-capture`: `MODIFIED` «Acceso visible a la captura rápida»;
  - `authorization`: `MODIFIED` «Lecturas agregadas con el alcance de
    entradas», sin cambios en el modelo de permisos y sin textos de
    pantalla;
- decisiones 1 a 9 aprobadas por Pablo; P-41 a P-45, con «Último hecho»
  y «Hechos más recientes»;
- P-46 a P-53 abiertas.

**Plan de la entrega final:** la secuencia es GL-13, después GL-14 y al
final la tarea 3.3 de GL-11. Se separaron las decisiones de cada ticket.

**Validación:** `openspec validate --all --strict`, 22 de 22 en la primera
corrida. Sin pruebas, CI ni auditorías.

**Sin cambios:** la propuesta original, la Entrega 2 y el código.

**Sin stage, commit, push ni archivo.**

**Pendiente:**

- la revisión de Pablo;
- GL-13: P-34, P-35 y P-38 a P-40;
- GL-14: P-46 a P-53;
- la aprobación para implementar cada cambio;
- la tarea 3.3 de GL-11, sin marcar.
