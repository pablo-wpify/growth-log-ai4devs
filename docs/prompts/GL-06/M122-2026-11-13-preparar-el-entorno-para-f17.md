# M122. Preparar el entorno para F17

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | preparación del entorno local |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `c54f592e261f7aca07c928420c46b4fc5416a778bc98023e2218fa6ff4a457c3` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M122 | 2026-11-13 20:12:51 |

## Texto original

````text
Prepará el entorno local para que Pablo pueda ejecutar F17. No realices la comprobación en navegador ni la marques como hecha.

1. Leé el paso 7 de `docs/desarrollo.md` y reiniciá el Puma de `127.0.0.1:3000` para que cargue la zona horaria y el filtro de logs actuales. Verificá que sea el proceso de desarrollo de este proyecto antes de detenerlo; no termines procesos ajenos.
2. Confirmá que estás en el entorno `development` y revisá si existen los datos ficticios de GL-08. Si faltan, verificá en el código que `bin/rails growth_log:datos_ficticios` solo crea los que faltan y ejecutalo únicamente en `development`. No resetees ni borres la base y no corras migraciones.
3. No fijes ni muestres contraseñas. Indicá a Pablo cómo fijar las contraseñas ficticias con el mecanismo ya documentado, advirtiendo que invalida las sesiones abiertas de esas cuentas.
4. Informá si el servidor quedó disponible, qué datos ficticios encontraste o creaste y los pasos que Pablo debe seguir para F17. F17 y la observación de la sesión vencida siguen pendientes hasta que Pablo las haga y registre.

No ejecutes pruebas, lint ni `bin/ci`. No hagas commit, push, PR, despliegue ni archivado.
````

## Resultado registrado (no forma parte del pedido)

- **M122:** primera línea de la respuesta final de Claude Code: «Dejé listo el entorno para que hagas F17. No ejecuté la comprobación ni la marqué como hecha.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
