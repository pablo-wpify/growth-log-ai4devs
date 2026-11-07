# M37. Implementar GL-05 «Personas»

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-05` |
| Tipo | pedido de implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `f4f66c5089b45707606a4ba091a8a103c0bcd49a6c7068aaa22ffccc99c8ed4e` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M37 | 2026-11-06 21:52:03 |

## Texto original

````text
Implementá GL-05 «Personas» en la rama local `feature/GL-05-personas`.

P-15, P-16 y P-17 están aprobadas. La implementación de GL-05 está autorizada.

Antes de cambiar archivos:
1. Leé `CLAUDE.md`, `docs/plan-entrega-2.md`, `docs/tickets/GL-05-personas.md` y el cambio OpenSpec de GL-05 completo.
2. Revisá la rama y el estado del árbol. Conservá todos los cambios existentes; no descartes, restaures ni limpies archivos.
3. Confirmá que las dependencias de GL-05 estén implementadas en esta rama. Si falta una o encontrás una contradicción con el ticket o las decisiones aprobadas, detenete y reportá el bloqueo antes de ampliar el alcance.

Trabajá una sola tarea: GL-05. El ticket, la propuesta, las specs, el diseño y las tareas ya existen; implementá ese alcance, sin volver a crear el plan.

Requisitos:
- Tras iniciar sesión, llegar a «Personas». En las páginas autenticadas, mostrar «Growth Log», «Personas» como navegación actual, «Sesión iniciada como <nombre>» y «Cerrar sesión». La pantalla de inicio de sesión no debe mostrar esa cabecera. «Personas» reemplaza la página provisoria, pasando por la autenticación.
- Usar las rutas `/personas` y `/personas/:id`.
- El listado muestra solo personas activas con una asignación activa para la cuenta, ordenadas por nombre, con rol y equipo. Si está vacío, mostrar un mensaje claro.
- La ficha muestra únicamente nombre, rol y equipo, con enlace para volver al listado. Si falta rol o equipo, mostrar «Sin rol indicado» o «Sin equipo indicado».
- Una persona ajena, inactiva, con asignación terminada o inexistente debe responder 404 con la misma página y sin revelar su nombre. Una administradora sin asignaciones ve el estado vacío y recibe 404 en cualquier ficha; con una asignación, solo ve esa persona.
- El único formulario de la interfaz es «Cerrar sesión». No agregar administración, feedback, resumen, captura rápida ni enlaces a esos flujos. No mostrar otros líderes.
- Incorporar las rutas nuevas a las pruebas de cobertura de GL-03 y a las pruebas de acceso sin sesión de GL-02, sin debilitar sus expectativas.
- Implementar y registrar las cuatro mutaciones ya definidas en el diseño de GL-05.

Pruebas primero: agregá o ajustá las pruebas del alcance, ejecutalas para confirmar que fallen por la razón esperada y después implementá el mínimo código necesario. Usá solo datos ficticios y no leas ni muestres `.env`, secretos, credenciales ni datos personales.

Verificá las pruebas pertinentes y `bin/ci` en local. No hagas commits, push, PR, archivado ni despliegue. No marques como realizada la comprobación manual de navegador de escritorio y 375 px: dejá una lista breve para que Pablo la haga y reporte como manual. Tampoco afirmes que pasó CI remoto si no se ejecutó.

Al terminar, informá:
- archivos modificados;
- pruebas y comandos ejecutados con sus resultados;
- mutaciones realizadas;
- pendientes, incluida la comprobación manual y cualquier CI remoto no ejecutado.
````

## Resultado registrado (no forma parte del pedido)

- **GL-05 ya estaba implementado** en `d9365c6` (pedido M35), con el mismo
  alcance que pide M37. No se reimplementó ni se rehízo el plan.
- Se comprobó que `CLAUDE.md`, el plan, el ticket, el cambio de OpenSpec y
  el código no cambiaron desde `d9365c6`. GL-02, GL-03 y GL-08 están
  archivados en la rama.
- Pruebas pertinentes: 63 ejemplos, 0 fallas.
- Mutaciones repetidas: las cuatro fallan como en M35 y cada archivo se
  restauró con su SHA-256 idéntico.
- `openspec validate --all --strict`: 15 de 15.
- **`bin/ci` con código 1.** Fallan solo los avisos de seguridad de gemas:
  `bin/bundler-audit update` incorporó 21 avisos nuevos contra Rails 8.1.4
  (`actionpack`, `actionview`, `activestorage`, `activesupport`,
  `actionmailbox`), corregidos en 8.1.4.1. El resto pasa: RuboCop,
  Brakeman y RSpec con 192 ejemplos y 0 fallas. Actualizar Rails queda
  fuera de GL-05 y se informa a Pablo sin aplicarlo.
- Sin commits, push, PR, archivado ni despliegue. CI remoto no ejecutado.
  Comprobación manual en navegador pendiente.
