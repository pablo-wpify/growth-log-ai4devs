# M28. Planificar GL-05 mediante SDD

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-05` |
| Tipo | pedido de planificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `fe3192af01dbb15637d9a4062374df2cf8b2f7ffd5960f24fb4100336783d221` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M28 | 2026-11-03 11:02:36 |

## Texto original

````text
Prepará GL-05 mediante SDD: listado y ficha de personas asignadas.

Trabajá en ~/code/ai4devs-entrega-1-pp, rama feature/entrega-2-pp. Confirmá árbol limpio y HEAD eacb16e487dfd9c8718c005c9d75f30c26397acc.

Leé CLAUDE.md, el plan vigente, los requisitos de origen y las specs de autorización, personas y asignaciones.

Prepará ticket, propuesta OpenSpec, specs, diseño y tareas.

Alcance:
- Tras iniciar sesión, acceso visible a «Personas».
- Listado limitado a personas activas con asignación activa para la cuenta actual.
- Ficha con los datos mínimos aprobados y navegación de vuelta al listado.
- Estado vacío claro para quien no tenga personas asignadas.
- Cierre de sesión accesible.
- Sin alta, edición, baja, asignación ni otras funciones administrativas.
- Sin formularios de feedback ni botones que anuncien funciones todavía inexistentes.

Autorización:
- Aplicá policy_scope y authorize conforme a GL-03.
- Una persona fuera del alcance debe responder 404, igual que una inexistente.
- Ser administrador no concede acceso adicional.
- Agregá las rutas reales a la prueba de cobertura.
- Incluí casos por URL directa para persona ajena, inactiva y asignación terminada.
- La mutación que sustituye la búsqueda por alcance por Person.find debe hacer fallar una prueba de comportamiento.

Presentación:
- Consultá los mocks existentes como referencia y proponé una interfaz sencilla, legible y adaptable a móvil.
- Usá el stack actual; no agregues un framework visual ni dependencias sin justificarlo.
- Separá las pruebas de peticiones de una comprobación real en navegador. Si esta requiere resolver ADR-6, señalalo; no la declares ejecutada.

Usá datos ficticios. Las pruebas automatizadas deben preparar sus propios datos, sin depender de la base de desarrollo ni de ejecutar GL-08.

Validá los artefactos y los enlaces. No implementes, instales dependencias, hagas commits, push ni despliegues.

Terminá con criterios de aceptación, datos visibles en la ficha, propuesta de navegación y decisiones pendientes antes de implementar.
````

## Resultado registrado (no forma parte del pedido)

Planificación de GL-05 **pendiente y sin commit** en `feature/entrega-2-pp`; no se incluye en esta rama.
