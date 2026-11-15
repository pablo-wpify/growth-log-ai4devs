# M236. Borrador documental de GL-11: presentación del inicio de sesión

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-11` |
| Tipo | fase documental |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `58537c5369377d0fe1ced0a400c7611de97401cdad22e8a3bbf822b9a7a3e24c` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M236 | 2026-11-15 13:33:53 |

## Texto original

````text
Trabajá en el checkout local de Growth Log y seguí `CLAUDE.md`, los archivos `AGENTS.md` aplicables y el flujo SDD del proyecto.

## Fase 1: verificar el estado antes de editar

No leas ni muestres `.env`, secretos, credenciales ni valores de variables.

1. Informá la rama actual, HEAD, remotos y upstream. Revisá el estado completo: cambios staged, unstaged y untracked.
2. Identificá la rama de entrega, que esperamos que sea `feature/entrega-2-pp`, y el remoto configurado para `growth-log-publico/feature/entrega-2-pp`.
3. Ejecutá `git fetch` para actualizar referencias remotas, sin hacer pull, merge, rebase, checkout, reset ni stash. Compará HEAD local con la rama remota: debe estar limpio, sin commits ahead ni behind.
4. Verificá en el historial que el merge commit del PR #7 de GL-10, conocido como `6177aef04a6cd64c85f27cad832cb4b5cf54e949`, esté integrado en la rama de entrega. Si `gh` está disponible, comprobá además el estado del PR #7 y los checks remotos asociados al head y al merge.
5. Revisá `docs/plan-entrega-2.md` y `openspec/changes/` para identificar si GL-10 sigue teniendo tareas o cierre documental pendientes. No archives ni cierres GL-10 como parte de este trabajo.

**Detenete e informá antes de editar** si la rama no es la esperada, hay cambios locales, la rama remota avanzó o quedó ahead/behind, el merge del PR #7 no está integrado, el CI de ese merge no está verde o hay trabajo previo que `CLAUDE.md` indique que debe cerrarse primero. No corrijas esas diferencias por tu cuenta. No cambies de rama.

## Fase 2: preparar el borrador SDD del login

Avanzá solo si la Fase 1 confirma un checkout limpio y sincronizado y no hay una tarea anterior que deba cerrarse primero.

La evidencia visual que compartió Pablo:
- La ficha de una persona y la navegación una vez iniciada la sesión se ven coherentes.
- En `/session/new`, el formulario se ve casi sin formato: etiquetas y campos quedan mal alineados y los inputs no siguen el aspecto del resto de la aplicación.
- En el código actual la vista de login parece no tener clases de presentación para los campos. Comprobalo antes de afirmarlo; no asumas que falló la carga global del CSS.
- El Anexo E tiene mocks de otras pantallas, pero no de login. Usá las pantallas internas como referencia visual y registrá que todavía no hay un mock aprobado del login. No inventes cuál herramienta de IA enseñaron en el curso.

Prepará, sin implementar:

1. Un ticket breve para corregir la presentación de `/session/new`.
2. Una propuesta OpenSpec con el alcance y exclusiones.
3. El delta de OpenSpec mínimo para expresar el resultado visual. Revisá si ya existe una capacidad de interfaz apropiada; si no, proponé una capacidad pequeña y separada. No cambies requisitos funcionales de `authentication`.
4. `design.md` y `tasks.md`, con implementación y verificación todavía pendientes de aprobación.
5. La actualización de `docs/plan-entrega-2.md`, su única fuente de secuencia. Usá el siguiente ID disponible que indique ese plan; no supongas el número.
6. El registro del pedido y del resultado en `docs/prompts/`, siguiendo la numeración vigente de `prompts.md`, y su actualización.

El resultado de interfaz debe ser concreto y comprobable: etiquetas sobre los campos, alineación y espaciado consistentes, campos legibles y utilizables, foco visible, mensajes de error accesibles y adaptación móvil sin desbordamiento horizontal. Conservá el lenguaje visual existente. No cambies la autenticación, sesiones, límites de intentos, rutas ni privacidad.

## Límites y validación

No cambies código de la aplicación, configuración, base de datos, Render ni servicios. No ejecutes pruebas, CI ni auditorías. Cuando el borrador documental esté completo, ejecutá únicamente `openspec validate --all --strict` si el CLI está disponible.

No hagas stage, commit, push, PR, merge ni archivo del cambio. Dejá la aprobación para implementar a Pablo.

Al terminar, informá:
- rama, HEAD, upstream y estado de sincronización;
- estado del PR #7 y CI, si pudiste comprobarlos;
- cualquier pendiente de GL-10 que afecte la secuencia;
- archivos creados o modificados;
- resultado de la validación estricta;
- el diff documental completo y los puntos que requieren revisión.
````

## Resultado registrado (no forma parte del pedido)

- **Fase 1, sin bloqueos (15/11/2026):**
  - Rama `feature/entrega-2-pp`, HEAD `6177aef`, igual a `growth-log-publico/feature/entrega-2-pp` tras `git fetch`: 0 commits adelante y 0 atrás. La rama no tiene upstream configurado; se comparó contra la rama remota.
  - Sin cambios locales.
  - Merge del PR #7 integrado. PR #7 `MERGED`; checks del head `d4fd753` en verde (scan_ruby, scan_js, lint, test) y CI del merge `6177aef` (`push`) en `success`.
  - GL-10 sigue en curso, sin archivar: faltan los pasos en Render 5.3 y 5.4, el registro del CI remoto (6.1b), el README (6.2), el archivo y P-30. No se cerró ni archivó como parte de este pedido.
- **Fase documental de GL-11, sin aprobar:**
  - Ticket `docs/tickets/GL-11-presentacion-inicio-sesion.md`.
  - Cambio `gl-11-presentacion-inicio-sesion` (propuesta, diseño, tareas y capability nueva `sign-in-presentation`).
  - Plan actualizado en las secciones 2, 3, 5, 6 (P-32) y 9.
- **Causa comprobada en el código:** la hoja global se carga en todas las páginas. La vista de login no tiene clases de presentación y `application.css` solo da estilo a los campos dentro de `.entry-form`.
- **Sin mock aprobado del login** en el Anexo E. La referencia son las pantallas internas (P-32, abierta).
- **Validación:** `openspec validate --all --strict`, 20 de 20 válidos con el cambio de GL-11. La primera ejecución falló porque un requisito superaba los 500 caracteres. Se dividió en «Etiquetas sobre los campos» y «Campos y botón con el aspecto de la aplicación», y la segunda ejecución pasó. No se ejecutaron pruebas, CI ni auditorías.
- Sin código, configuración, datos ni cambios en Render. Sin stage, commit, push, PR, merge ni archivo.
- **Pendiente:** revisión de Pablo (P-32 y el ancho del formulario) y aprobación para implementar.
