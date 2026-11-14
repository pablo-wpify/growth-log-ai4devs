# M102. Corregir los bloques documentales B0–F1

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | corrección de propuesta (sin editar el repositorio) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `1531fdf9cb2a353df89991708ce760ad0ca0d2475eafd031ec0ee9e4da3e6411` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M102 | 2026-11-13 14:51:33 |
| M103 | 2026-11-13 16:55:29 |

## Texto original

````text
Revisá y corregí el paquete de bloques documentales B0–B8, A1, C1–C7, D7, E1–E6 y F1 de GL-06, usando el análisis previo y estas observaciones. No repitas el relevamiento general.

GL-06 sigue preparado, sin aprobar y sin implementar. P-1, P-2, P-3 y P-11 figuran aprobadas; P-19 a P-24 siguen pendientes. No conviertas ninguna recomendación en aprobación.

TASK-012 de Pablo E pertenece a otro proyecto. Usala solo como referencia de calidad y detalle documental, nunca como fuente de requisitos.

## Correcciones necesarias

- **P-24:** no cierres por inferencia qué significa “datos mínimos”. Separá las opciones para los datos de la persona y el contenido de la entrada: campos completos, resumen mínimo u otra interpretación respaldada por los documentos. Dejá la elección y la descubribilidad —URL directa, listado mínimo u otra vista— como decisiones de Pablo.
- **P-22:** presentá el Turbo frame y la página propia como alternativas. El análisis original recomendaba el frame con aclaraciones de sesión vencida y foco; la página propia es una alternativa de menor alcance. No presentes `turbo-visit-control` ni otra solución técnica como validada. Expresá el comportamiento esperado como pendiente de decisión o verificación.
- **P-23:** no supongas que todas las cuentas usan la zona horaria de Argentina. Dejalo como supuesto que Pablo debe confirmar.
- **Reasignación de PT-11:** no agregues “vuelve a editar” a GL-06. El plan asigna la rama de lectura; explicá que la transición de escritura queda fuera salvo decisión explícita.
- **Entrada ya lista:** presentá el comportamiento de una segunda solicitud para marcarla como lista como decisión separada; no lo conviertas en requisito aprobado.
- **Logs:** conservá el requisito de que el texto no aparezca en logs de petición ni de consultas. Si el comportamiento de Rails no está comprobado, marcá la verificación pendiente sin proponer relajar el requisito.
- **RENAMED:** no incluyas esa sintaxis como cambio listo para aplicar sin evidencia de que esta versión de OpenSpec la admite; indicá la verificación pendiente.
- **Fechas y versiones:** no inventes versión, fecha de creación ni historial para el ticket. Citá la fuente o dejá esos campos como pendientes.
- **Puerta de tareas:** diferenciá el trabajo documental previo de la implementación. Las pruebas y el código no empiezan hasta que las decisiones y el cambio OpenSpec estén aprobados.
- **Trazabilidad:** conservá la propuesta para vincular 4.14 y la rama de lectura de PT-11 con los criterios y pruebas de GL-06, sin ampliar su alcance.

## Entrega

Devolvé los bloques corregidos listos para revisar, indicando su destino. Marcá cada bloque como:

- aplicable sin decisión;
- condicionado a una decisión de Pablo;
- pendiente de verificación técnica.

Incluí una tabla final de **bloque | estado | decisión o verificación pendiente**. Separá hechos de recomendaciones y no alteres el repositorio.

**Solo lectura:** no edites archivos ni regeneres o apliques diffs; no ejecutes pruebas, validadores, migraciones ni formateadores; no hagas fetch, commits, push ni archivado. No declares GL-06 aprobado ni autorices implementación.
````

## Resultado registrado (no forma parte del pedido)

- **M102:** primera línea de la respuesta final de Claude Code: «Bloques documentales de GL-06, corregidos»
- **M103:** primera línea de la respuesta final de Claude Code: «Este pedido ya lo había respondido con el paquete anterior. Al volver a compararlo con tus observaciones encontré cinco puntos donde todavía se cerraba algo por inferencia o se daba algo por verificado. Abajo van solo los bloques que cambian, con la tabla completa actualizada. Los demás quedan como estaban. No modifiqué ningún archivo, y GL-06 sigue preparado, sin aprobar y sin implementar.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
