# M78. Registrar E10 y archivar GL-05

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-05` |
| Tipo | autorización de archivo y documentación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `2417a48ac040ba6d9efb3fb7b88c9d3a42d18f21799a4a1c39ac8453517e202d` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M78 | 2026-11-07 21:51:32 |

## Texto original

````text
En el repositorio local de Growth Log, leé `CLAUDE.md` y revisá el estado del worktree antes de editar. La rama esperada es `feature/entrega-2-pp`, en `8d0e854`. Conservá todos los cambios locales y no uses `reset`, `clean` ni stash.

Pablo confirma que los siete puntos de E10 se hicieron de las dos maneras: manualmente por él y con asistencia de Claude en su Chrome. Registrá E10 como cerrado y archivá `gl-05-personas` con el procedimiento de OpenSpec del proyecto.

Usá estos resultados observados, sin alterarlos ni ampliar lo comprobado:

- Fecha: 07/11/2026. Chrome 155 en Linux; aplicación local `http://localhost:3000`, base `growth_log_development`, datos ficticios de GL-08.
- Como Elena, `/` muestra Ada Ejemplo y Bruno Ejemplo; no muestra Carla, Darío ni Eva.
- `/personas/1` muestra Ada, su rol y equipo; no muestra otros líderes, fechas ni estado.
- Como Elena, `/personas/3` responde 404 y no revela datos de Carla.
- Cerrar sesión lleva a `/session/new`; las rutas `/` y `/personas/1` ya no muestran contenido sin sesión.
- Como Inés, `/` muestra el estado vacío y no enlaza personas. El primer intento quedó autocompletado como Elena; se repitió correctamente con Inés.
- En `/` y `/personas/1`, a 375 px emulados con DevTools, no hay desbordamiento horizontal; `innerWidth` coincide con `clientWidth` y las capturas no muestran corte.
- Con Tab, el foco es visible en los controles revisados. La verificación de teclado se hizo a 375 px emulados.
- En escritorio se usaron 1920 px reales; para el punto de cierre de sesión, 1870 px. No registres 1280 px como ancho realmente probado.
- La persona extra Eva Ejemplo (id 5) estaba en la base, pero no apareció para Elena ni Inés.

Actualizá el plan, el ticket y el diseño de GL-05 según las convenciones existentes. Registrá los resultados de E10 y este pedido en el índice de prompts con el siguiente identificador disponible después de M74; verificá la transcripción para copiar solo texto literal del usuario. No afirmes que E10 se hizo únicamente con el agente ni que se usó un ancho real de 375 px.

Después de archivar, ejecutá `openspec validate --all --strict` y `git diff --check`. No cambies código ni `Gemfile`/`Gemfile.lock`. No hagas commit, push, PR ni otro merge. Informá el estado del archivado, archivos modificados y resultados de las validaciones.
````

## Resultado registrado (no forma parte del pedido)

- **E10: cerrado.** Hecho el 07/11/2026 por Pablo a mano y con asistencia
  de Claude Code en su Chrome 155 (Linux), contra `http://localhost:3000`
  y `growth_log_development` con los datos de GL-08. Los siete puntos
  pasan. En escritorio se usaron 1920 px reales (1870 px para el cierre
  de sesión) y 375 px **emulados** con DevTools; no se probó un ancho real
  de 375 px. Resultados, la persona extra Eva Ejemplo y los desvíos
  respecto del procedimiento del diseño, en el diseño archivado.
- **OpenSpec:** `gl-05-personas` archivado como
  `2026-11-07-gl-05-personas`; creó la spec vigente `people-browsing` (6
  requisitos), cuyo propósito se completó en lugar del texto provisorio
  que genera `openspec archive`. `openspec validate --all --strict`: 15
  de 15.
- **Documentación:** plan, README, ticket GL-05, `docs/desarrollo.md`
  (enlace al diseño archivado), diseño y tareas del cambio, e índices de
  prompts.
- **Numeración:** este pedido se registró primero como M75. M79 lo
  corrigió a M78, porque antes había tres envíos de pedidos sin registrar
  (M75 a M77; criterio en `prompts.md`).
- `git diff --check` sin observaciones. Sin cambios de código, `Gemfile`
  ni `Gemfile.lock`. Sin commit, push, PR ni merge.
