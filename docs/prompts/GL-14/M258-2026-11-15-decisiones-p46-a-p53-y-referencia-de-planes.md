# M258. Decisiones P-46 a P-53 de GL-14 y referencia de planes en CLAUDE.md

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-14` (entrega final); también actualiza `CLAUDE.md` y referencias de GL-13 |
| Tipo | fase documental (decisiones y ajuste de deltas) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente, incluidos los tres acentos graves del final; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `a3a0fcbf088c81e3cd03f8ed334dcd17cf54ddfe47efb365678c655218b808e2` |
| Fecha y hora (UTC) | 2026-11-15 23:59:10 |

## Texto original

````text
Continuemos en la Entrega Final. Antes de editar, confirmá que estás en `feature/entrega-final-pp`, en `eabac8e` o en el commit posterior que contiene únicamente el borrador esperado de GL-13/GL-14. Revisá `git status` y asegurate de que no haya cambios ajenos. Si algo no coincide, frená y reportalo.

Quiero cerrar las decisiones abiertas de GL-14 y corregir la referencia de planificación, solo en documentación. No implementes código ni modifiques nada de la Entrega 2.

Decisiones para registrar en GL-14:

- P-46: cuando hay entradas listas y ningún borrador, mostrar «N entradas listas».
- P-47: en «Hechos más recientes», las personas sin entradas listas visibles para la cuenta actual van al final. Los borradores no participan del orden.
- P-48: «Limpiar filtros» borra la búsqueda y el filtro por equipo, pero conserva el orden elegido.
- P-49: buscar coincidencias parciales en el nombre, sin distinguir mayúsculas ni acentos.
- P-50: incluir «Sin equipo indicado» en el filtro si hay personas sin equipo; no inventar una opción si el modelo no permite ese estado.
- P-51: búsqueda y filtro se procesan en el navegador sobre las personas ya autorizadas. No se conservan al recargar ni se agregan a la URL.
- P-52: la captura abierta desde el listado vuelve a la ficha de la persona, como hoy.
- P-53: mostrar tanto el total de personas asignadas como el aviso breve de privacidad. Mantenerlos discretos y sin duplicar información.

Además:

1. Revisá que «Registrar la primera» no revele si existen entradas que la cuenta actual no puede ver. Su disponibilidad y cualquier conteo deben basarse únicamente en las entradas visibles para esa cuenta y en los borradores propios. No hagas consultas globales para decidir si mostrarlo.
2. Conservá las decisiones ya aprobadas P-41 a P-45, los requisitos originales 1.14–1.16 y P-10 sin cambios. No agregues la pestaña «Compartir».
3. Actualizá `CLAUDE.md` para que la secuencia de trabajo remita al plan correspondiente a cada entrega: la Entrega 2 queda cerrada y congelada; la Entrega Final se planifica en `docs/plan-entrega-final.md`. No cambies `docs/plan-entrega-2.md`.
4. Actualizá las decisiones en el ticket, propuesta, diseño, tareas, deltas OpenSpec, plan final y registros/índices que correspondan. Evitá duplicar la misma decisión con redacciones contradictorias.
5. Dejá P-34, P-35 y P-38 a P-40 de GL-13 abiertas. No apruebes ni implementes GL-13 ni GL-14.

Al terminar, ejecutá únicamente `openspec validate --all --strict`. No corras pruebas, CI ni auditorías. Informá qué archivos cambiaste, el resultado del validador y el estado de Git. No hagas stage, commit, push, PR, merge, deploy ni archivo.```
````

## Resultado registrado (no forma parte del pedido)

**Comprobaciones previas:** rama `feature/entrega-final-pp`, HEAD
`eabac8e`, sin commits posteriores; en el árbol solo estaba el borrador de
GL-13 y GL-14, sin cambios ajenos. El modelo admite personas sin equipo
(`people.team` es opcional), así que P-50 se aplica.

**GL-14:**

- P-46 a P-53 registradas como aprobadas en el ticket, la propuesta, el
  diseño (sección 5), las tareas y el plan;
- `people-browsing`: búsqueda parcial sin mayúsculas ni acentos, «Sin
  equipo indicado», «Limpiar filtros» que conserva el orden, las personas
  sin entradas listas al final, y dos requisitos nuevos: «Búsqueda, filtro
  y orden en el navegador» y «Total de personas y aviso de privacidad»;
- `feedback-capture`: «Registrar la primera» se decide solo con el
  alcance de la cuenta y no revela entradas ajenas, con un escenario de
  otro líder; la captura conserva su enlace de vuelta a la ficha;
- `authorization`: la decisión de mostrar «Registrar la primera» entra en
  las lecturas agregadas con alcance, sin cambiar permisos.

**Interpretaciones a confirmar por Pablo:**

- P-51 nombra la búsqueda y el filtro; el orden se aplica con el mismo
  mecanismo, porque «Limpiar filtros» debe conservarlo;
- P-53: los textos son los de la referencia, el total no cambia al
  filtrar y en el estado vacío no se muestran ni el total ni el aviso.

**Sin cambios:** P-41 a P-45, 1.14 a 1.16, P-10, la Entrega 2 y el código.
Sin pestaña «Compartir». GL-13 conserva abiertas P-34, P-35 y P-38 a P-40;
solo se actualizó su mención de R-12, R-13 y P-53.

**`CLAUDE.md`:** cada entrega remite a su plan; la entrega final, a
`docs/plan-entrega-final.md`, y la Entrega 2, cerrada y congelada. El
índice vivo de `prompts.md` pasa a ser la sección «Entrega final».

**Validación:** `openspec validate --all --strict`, 22 de 22. Sin pruebas,
CI ni auditorías. Sin stage, commit, push ni archivo.

**Pendiente:** revisión de Pablo; aprobación para implementar GL-13 y
GL-14; GL-13: P-34, P-35 y P-38 a P-40; la tarea 3.3 de GL-11.
