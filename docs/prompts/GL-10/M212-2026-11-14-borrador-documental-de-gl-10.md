# M212. Borrador documental de GL-10: demo temporal en Render

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-10` |
| Tipo | fase documental |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `c40830a379af0c198766bd08b4a3c859081062f0665bdc52035f801d06f0fb7a` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M212 | 2026-11-14 22:59:34 |

## Texto original

````text
Prepará el borrador documental de GL-10 para una demo temporal de Growth Log en Render. Usá este pedido como fuente de verdad; no busques otro archivo de borrador fuera del repositorio.

Seguí CLAUDE.md y el flujo SDD. Antes de editar, comprobá rama, HEAD y `git status`. Si hay cambios ajenos o inesperados, detenete e informá. No leas `.env`, secretos ni credenciales.

Alcance documental:
- Proponé GL-10 como nuevo ticket y actualizá `docs/plan-entrega-2.md`, la única fuente de la secuencia.
- Prepará el ticket, `proposal.md`, `design.md`, `tasks.md` y el delta de OpenSpec necesario.
- Registrá el pedido según las reglas de `docs/prompts/` y actualizá el índice correspondiente.
- Proponé una capability nueva para la demo temporal; no cambies la tarea ni relajes la spec de datos ficticios de GL-08, que sigue siendo solo para development.
- Registrá que Pablo acepta que la demo sea editable; no agregues modo de solo lectura.
- El conjunto propuesto tendrá datos exclusivamente ficticios: dos líderes asignados a la misma persona, con ejemplos de borrador y entrada lista para mostrar el recorrido.
- Proponé una tarea explícita e idempotente para preparar esos datos en una base dedicada. Evaluá que pueda ejecutarse en el build de Render después de las migraciones, ya que el servicio Free no ofrece SSH ni trabajos puntuales y el pre-deploy requiere un plan pago. Si la conexión a Postgres durante el build no puede garantizarse, dejalo como riesgo o pregunta abierta; no inventes una solución.
- La tarea debe fallar de forma segura fuera de la instancia demo o si detecta registros ajenos; no debe sobrescribir, adoptar ni borrar datos. No debe ejecutarse al arrancar Puma ni mediante los seeds generales.
- No pongas contraseñas en archivos, prompts, logs ni salidas. Dejá pendiente cómo se compartirán las credenciales con quienes revisen la demo.
- ReflejÁ que la base `growth-log-entrega-2-db` ya fue creada en Render Free, en Virginia, y vence a los 30 días; el formulario de la app quedó sin desplegar. No cambies servicios ni configuración de Render.
- Verificá en documentación oficial de Render las limitaciones vigentes y el riesgo de posibles cargos por exceder la cuota gratuita; registra los límites y fuentes en el diseño.

No escribas código ni pruebas. No configures ni despliegues la app. No hagas stage, commit, push, PR, merge ni archivo. Ejecutá únicamente `openspec validate --all --strict` si está disponible. Dejá la aprobación de Pablo para implementar claramente pendiente.

Al terminar, informá el diff documental completo, las preguntas abiertas, el resultado de validación y el estado de Git.
````

## Resultado registrado (no forma parte del pedido)

- **Fase documental de GL-10, sin aprobar:** ticket `docs/tickets/GL-10-demo-temporal-render.md` y cambio de OpenSpec `gl-10-demo-temporal-render` (propuesta, diseño, tareas, capability nueva `temporary-demo` y delta `MODIFIED` de `initial-administrator`). Plan actualizado en las secciones 2, 3, 4 (C14), 5, 6 (P-27 a P-31) y 9.
- **Decisión registrada:** P-27, demo editable con datos exclusivamente ficticios, sin modo de solo lectura.
- **Abiertas:** P-28 (build de Render después de las migraciones, con el riesgo de la conexión a la base durante el build), P-29 (contraseñas de las cuentas demo), P-30 (cómo se comparten las credenciales, la decide Pablo) y P-31 (marcas propias); fecha de creación de la base, plan y medio de pago del espacio de trabajo, rama desplegada.
- **Render:** límites y riesgo de cargos verificados en la documentación oficial y registrados con sus fuentes en el diseño. Sin cambios en servicios ni configuración de Render.
- **Validación:** `openspec validate --all --strict`, 19 de 19 válidos, con el cambio de GL-10. No se ejecutaron pruebas, CI ni auditorías.
- Sin código, pruebas, datos ni contraseñas. Sin stage, commit, push, PR, merge ni archivo.
- **Pendiente:** revisión y aprobación de Pablo antes de implementar.
