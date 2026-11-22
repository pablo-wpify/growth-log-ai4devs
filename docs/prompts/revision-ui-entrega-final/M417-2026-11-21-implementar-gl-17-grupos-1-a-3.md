# M417. Implementación local de GL-17, grupos 1 a 3

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | Revisión de UI de la entrega final |
| Tipo | implementación (SDD), grupos 1 a 3 de GL-17 |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `be056036d8ae95080c893b916266a940b5d3928496cd45a303c455112d1105d4` |
| Fecha y hora (UTC) | 2026-11-21 23:00:38 |

## Texto original

````text
Autorizo la implementación local de GL-17, grupos 1 a 3, según `openspec/changes/gl-17-presentacion-listado-personas/tasks.md`.

Antes de empezar:
- Confirmá rama, HEAD, stage y estado del árbol.
- Conservá todos los cambios locales existentes, incluidos los documentos y registros de prompts de GL-17/UI. No los reviertas ni los mezcles con cambios de código ajenos.
- Leé `tasks.md`, `design.md`, `proposal.md` y el ticket. Seguí el alcance y las decisiones aprobadas P-54 y P-55.

Ejecutá los grupos 1 a 3 en el orden documentado: pruebas primero, implementación después y verificación al final. Para cada tarea, actualizá su estado y evidencia solo cuando esté realmente completada. Registrá los desvíos y límites observados en los documentos previstos.

La tarea de comprobación manual 3.3 me corresponde a mí: prepará y mostrame la aplicación en los tamaños y estados indicados, pero dejala abierta hasta que yo confirme esa revisión.

No hagas trabajo del grupo 4. No hagas stage, commit, push, PR, merge, deploy ni archive. No marques tareas incompletas como completas. No cambies otras funcionalidades ni documentos fuera del alcance requerido por GL-17.

Al terminar, informá los archivos cambiados, las tareas completadas y abiertas, las verificaciones ejecutadas con sus resultados y el estado final de Git. Registrá este pedido en `docs/prompts/` siguiendo la convención del proyecto y la numeración vigente, sin renumerar registros anteriores.
````

## Resultado registrado

**Numeración:** M417, por posición (opción A; ver M407). M416 (22:48 UTC)
pidió solo ejecutar `openspec validate --all --strict`, con 22 de 22, y
prohibía editar: no tiene registro propio.

- **Estado inicial:** rama `feature/entrega-final-pp`, HEAD `63b86d0`,
  stage vacío y los siete cambios documentales sin commit, que se
  conservaron.
- **Recurso:** la skill del proyecto `openspec-apply-change`, sobre el
  cambio `gl-17-presentacion-listado-personas`.
- **Tareas completadas:** 0.4 (esta autorización), 1.1, 1.2, 2.1, 2.2, 2.3,
  3.1 y 3.3.
- **Tarea abierta: 3.2**, las capturas y la conformidad visual de Pablo. En
  este `tasks.md` la comprobación manual es la 3.2, no la 3.3 que nombra
  el pedido; la 3.3 es el registro en el diseño. Se dejó abierta la 3.2.
- **Pruebas primero:** 8 ejemplos nuevos en
  `spec/system/people_listing_spec.rb`, dos por ancho a 1280, 640, 639 y
  375 px. Se vieron fallar contra el código de `63b86d0` por las razones
  esperadas y pasaron después de implementar.
- **Código:** `app/views/people/index.html.erb` (el total y el aviso en dos
  párrafos; la clase `button` en «Registrar la primera») y
  `app/assets/stylesheets/application.css` (la variante compacta y la
  fila en tres columnas desde 40 rem). Sin tokens nuevos ni cambios de
  controlador, helpers ni rutas.
- **Verificación:** las pruebas del listado (sistema y peticiones) dieron
  43 ejemplos y 0 fallas en dos corridas. `bin/bundler-audit update` y
  `bin/ci` terminaron en código 0, con 471 ejemplos y 0 fallas;
  `openspec validate --all --strict` dio 22 de 22.
- **Desvíos** (detalle en el diseño, entrada M417):
  - el umbral de ancho de la prueba se ajustó al criterio de la spec;
  - el helper de la prueba se corrigió antes de la fase roja;
  - hubo una falla intermitente, no reproducida, del ejemplo «sin
    JavaScript» de GL-14.
- **Preparación de la 3.2:**
  - el servidor de desarrollo local quedó en `127.0.0.1:3000`;
  - se tomaron capturas a 1280, 640, 639 y 375 px (listado, foco, sin
    resultados y estado vacío) con las cuentas ficticias. Están en el
    scratchpad de la sesión, fuera del repositorio;
  - las sesiones de la revisión se cerraron y la base quedó como estaba:
    0 sesiones, 2 entradas, 5 cuentas y 1 contador;
  - la contraseña aportada en la sesión no se registra [omitido:
    contraseña].
- **Documentos:** se actualizaron las tareas, los estados del ticket, la
  propuesta, el diseño (con la entrada M417 del «Registro») y el plan.
- Sin stage, commit, push, PR, merge, deploy ni archivo, y sin trabajo
  del grupo 4.
