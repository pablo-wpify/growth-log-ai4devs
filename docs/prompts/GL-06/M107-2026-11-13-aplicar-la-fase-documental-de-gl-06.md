# M107. Aplicar la fase documental de GL-06

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | decisiones de Pablo (P-19 a P-24 y dos puntos sin número) y fase documental |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `24758303343baf79dec833a8143a0def0ef77498137dad90df081375a0028d52` (del texto del mensaje fuente; igual en los dos envíos) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M107 | 2026-11-13 17:44:17 |
| M108 | 2026-11-13 18:13:42 (mismo texto, enviado de nuevo después del resultado de M107) |

## Texto original

````text
Aplicá la fase documental de GL-06 con las decisiones explícitas de Pablo que siguen. GL-06 continúa **preparado y sin aprobar para implementación**.

## Decisiones confirmadas

- **P-19:** rutas propuestas: captura bajo `/personas/:person_id/entradas`; detalle, edición, actualización y marcar como lista bajo `/entradas/:id`.
- **P-20:** escribir exige autoría, asignación activa y persona activa. Leer las entradas propias sigue permitido aunque termine la asignación o la persona quede inactiva.
- **P-21:** sección «Tus entradas sobre <nombre>», ordenada por fecha del hecho descendente; en empate, primero la entrada creada después. GL-07 la reemplazará por la cronología mediante un cambio explícito.
- **P-22:** página propia para la captura, sin Turbo frame.
- **P-23:** `America/Argentina/Buenos_Aires` para toda la instancia.
- **P-24:** sin acceso a la ficha, mostrar solo el nombre de la persona y todos los campos de la entrada propia; acceso por URL directa, sin listado adicional en GL-06. Registrar que 3.10 y 4.14 quedan parciales.
- **Entrada ya lista:** marcarla de nuevo es idempotente; no cambia y vuelve al detalle sin error.
- **PT-11:** incluir la rama de lectura asignada a GL-06; dejar fuera la transición de reasignación que devuelve la edición.
- **Logs:** no cambiar el requisito de que contexto, evidencia e impacto no aparezcan en logs de petición ni de consultas. La verificación del log de consultas sigue pendiente para implementación.

P-1, P-2, P-3 y P-11 ya figuran aprobadas. No las reabras.

## Antes de editar

1. Capturá `git status` y verificá que el checkout siga en `feature/entrega-2-pp`. Preservá todos los cambios locales existentes. No limpies, reemplaces ni regeneres el diff de preparación.
2. Usá `docs/plan-entrega-2.md` como fuente de verdad para las decisiones y consultá la convención existente antes de crear o nombrar un registro en `docs/decisiones/`.
3. No inventes versiones, fechas históricas ni contenido ausente. Para el registro de esta resolución, usá la fecha actual y la convención del repo.

## Ajustes documentales

Alineá, según corresponda, el plan y el registro de decisiones, el ticket GL-06, la propuesta y el diseño OpenSpec, las specs afectadas y `tasks.md`. Actualizá README y registro de prompts solo si la convención del repo lo requiere.

Incorporá la trazabilidad de 4.14 y la rama de lectura de PT-11 sin ampliar GL-06 a compartir, revocar ni reasignar. Alineá `plan:300` con P-20 y deja clara la parcialidad de 3.10 y 4.14 bajo P-24. Mantén diferenciados:

- decisiones confirmadas;
- cambios documentales propuestos que aún esperan aprobación del cambio OpenSpec;
- verificaciones técnicas pendientes.

Para P-22, documentá la página propia. No presentes como verificado el comportamiento de una sesión vencida al enviar el formulario; si no puede establecerse leyendo el flujo actual, déjalo como punto por verificar, sin inventar una mitigación. Para P-23, registra la zona horaria global y deja la comprobación de pruebas con `Time.zone.local` para la implementación. Para logs, conserva F12 y deja la verificación de consultas pendiente.

Actualizá la puerta de `tasks.md` para que separe el trabajo documental previo de la implementación. No habilites pruebas de implementación, código ni migraciones antes de la aprobación explícita del cambio OpenSpec.

## Verificación y límites

Ejecutá únicamente `openspec validate --all --strict` después de los ajustes. No ejecutes pruebas de Ruby, lint, migraciones ni validaciones de implementación. Si la validación documental falla, reportá el error; no hagas cambios ajenos a GL-06 para corregirlo.

No hagas commits, push, PR, archivado ni despliegue. No marques el cambio OpenSpec como aprobado ni declares GL-06 implementado.

Al terminar, informá los archivos modificados, un resumen por documento, el resultado de la validación y cualquier duda que siga abierta. Dejá el diff local visible para revisión humana.
````

## Resultado registrado (no forma parte del pedido)

- Decisiones de Pablo registradas el 13/11/2026 en el plan (sección 6) y
  en `docs/decisiones/2026-11-13-gl-06-captura.md`: P-19 a P-24, y como
  P-25 («Marcar como lista» idempotente) y P-26 (reasignación de PT-11
  fuera de GL-06) los dos puntos que no tenían número. El plan alinea la
  regla de escritura de P-7 con P-20 y registra que 3.10 y 4.14 quedan
  parciales (P-24).
- Ajustados el ticket, la propuesta, el diseño, las specs
  `feedback-capture` y `authorization`, `tasks.md` (fase documental
  separada de la implementación), el README y `openspec/config.yaml`.
  `people-browsing` y `feedback-entries` sin cambios.
- `openspec validate --all --strict`: el primer intento falló por un
  requisito de más de 500 caracteres en `feedback-capture`; acortado, 16
  elementos válidos.
- Verificaciones técnicas pendientes para la implementación: log de
  consultas (F12, sin relajar), sesión vencida al enviar la captura y
  pruebas con `Time.zone.local`.
- Sin pruebas, código ni migraciones; sin tareas marcadas; sin commit ni
  push. El cambio de OpenSpec **no** está aprobado y la implementación no
  está autorizada.
- M86 a M106 (13/11/2026, esta sesión) no están registrados.
- **M108** repitió el texto de M107. Como los documentos ya estaban
  ajustados, no se volvieron a aplicar las ediciones: solo se registró el
  segundo envío y se repitió `openspec validate --all --strict`.
