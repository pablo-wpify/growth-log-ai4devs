# M75. Ejecutar la comprobación manual E10

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

| Envío | Fecha y hora (UTC) |
|---|---|
| M75 | 2026-11-07 20:44:28 |

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

- **Bloqueado, sin simular resultados.** La extensión Claude in Chrome
  no se conectó a la sesión: la lista de navegadores conectados siguió
  vacía en todos los intentos. Ningún punto de E10 quedó comprobado.
- Antes del bloqueo se verificó, sin modificar nada, la rama
  `feature/entrega-2-pp` en `8d0e854` y la presencia de los datos
  ficticios en la base local de desarrollo.
- Siguieron seis respuestas breves de Pablo para reintentar la conexión
  y una captura de la extensión; no son pedidos y no tienen número. Se
  propuso abrir una sesión nueva de Claude Code y reenviar el pedido, que
  es M76.
