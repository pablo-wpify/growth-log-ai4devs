# M76. Ejecutar la comprobación manual E10 (segundo envío)

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-05` |
| Tipo | pedido de comprobación manual |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `86e71ccdd1997e6da8d9848dd2a4ed4c4cb209901734e63496f6309646470263` |
| Repetición | segundo envío del texto de M75 (SHA-256 idéntico), en una sesión nueva de Claude Code |

| Envío | Fecha y hora (UTC) |
|---|---|
| M76 | 2026-11-07 21:08:48 |

## Texto original

````text
En el repositorio local de Growth Log, ejecutá la comprobación manual E10 de GL-05.

Antes de empezar:

- Leé `CLAUDE.md` y consultá el ticket y el diseño de OpenSpec de GL-05 para confirmar el procedimiento y los datos de prueba.
- Verificá la rama, el HEAD y `git status`. El estado informado es `feature/entrega-2-pp` en `8d0e854`. Conservá todos los cambios locales: no cambies de rama, no guardes cambios en stash, no limpies ni restaures archivos.
- Usá solo la aplicación y la base de datos locales de desarrollo. Confirmá que la URL sea local antes de iniciar sesión.
- Usá los datos ficticios existentes. No crees cuentas, no cambies contraseñas y no uses datos de producción.
- No me pidas que pegue contraseñas en la terminal, el chat ni archivos. Cuando haga falta iniciar sesión, dejá el navegador en la pantalla de acceso y esperá a que yo ingrese la contraseña directamente.

Comprobá estos siete puntos y anotá el resultado observado, sin modificar código:

1. Como Elena, en escritorio, `/` muestra Ada y Bruno; no muestra Carla ni Darío.
2. Como Elena, `/personas/1` muestra de Ada nombre, rol y equipo; no muestra otros líderes, fechas ni estado.
3. Como Elena, `/personas/3` responde 404 y no revela la ficha de Carla.
4. Como Elena, “Cerrar sesión” cierra la sesión correctamente.
5. Como Inés, `/` muestra el estado vacío.
6. A 375 px de ancho no hay desplazamiento horizontal.
7. Al navegar con Tab, el foco es visible en los controles interactivos.

Para los puntos 1 a 5, usá una ventana de escritorio. Para los puntos 6 y 7, cambiá a 375 px. Si se necesita cambiar de cuenta, esperá a que yo ingrese la contraseña en el navegador.

Si faltan usuarios o datos, la URL no es local, el resultado no coincide, o no podés verificar un punto visualmente, detenete en ese punto y registrá el bloqueo o el resultado real. No simules resultados ni arregles el problema.

Al terminar, devolveme una tabla con cada punto como `pasa`, `falla` o `bloqueado`, el resultado observado, la fecha, el navegador y el ancho de ventana. No archives GL-05, no ejecutes commits, push ni PR, y no hagas cambios en los archivos del repositorio.
````

## Resultado registrado (no forma parte del pedido)

- **Ejecutado** con Claude in Chrome sobre `http://localhost:3000`, sin
  modificar archivos. Pablo ingresó las contraseñas en el navegador; el
  agente no las conoció.
- Los siete puntos pasan. Resultados, anchos y desvíos registrados en el
  [diseño archivado de GL-05](../../../openspec/changes/archive/2026-11-07-gl-05-personas/design.md#comprobación-en-navegador-e10-07112026-local-manual),
  según M78.
- Durante la ejecución, M77 resolvió la conexión a la base para
  establecer contraseñas. Siguieron una captura y ocho respuestas breves
  de Pablo para avanzar los pasos (ajustar el ancho, confirmar inicios de
  sesión y elegir repetir el punto 5); no son pedidos y no tienen número.
