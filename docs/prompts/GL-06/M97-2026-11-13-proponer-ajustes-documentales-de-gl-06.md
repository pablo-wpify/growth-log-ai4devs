# M97. Proponer ajustes documentales de GL-06

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | propuesta (solo lectura) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `fd8c46019b264fab03d9abbd7526828ac00c378227149cfa580639c65c9a740d` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M97 | 2026-11-13 13:20:46 |

## Texto original

````text
Prepará una propuesta de ajustes documentales para GL-06 usando el estado actual del checkout y el análisis de P-19 a P-24 como evidencia.

La tarea sigue **sin aprobar y sin implementar**. P-1, P-2, P-3 y P-11 figuran aprobadas; P-19 a P-24 siguen pendientes. Las recomendaciones que siguen son candidatas para que Pablo las decida, no aprobaciones:

- P-19: rutas propuestas.
- P-20: escritura solo con autoría, asignación activa y persona activa.
- P-21: sección de entradas propias para reabrir borradores; falta fijar el orden y su relación temporal con GL-07.
- P-22: se recomendó página propia para evitar el comportamiento de Turbo aún no definido.
- P-23: zona horaria de Argentina, pendiente confirmar que la aplicación usa una única zona horaria.
- P-24: detalle de la entrada propia accesible por URL; se recomendó la alternativa (a), sin listado adicional hasta resolver AM-1.

## Alcance

1. Verificá en el plan qué criterios de **4.14** y qué rama de lectura de **PT-11** se asignan a GL-06. Localizá el texto exacto y proponé cómo trazarlo en ticket, proposal, design, specs y tasks, sin ampliar el alcance por inferencia.
2. Prepará propuestas de texto para resolver las contradicciones y vacíos detectados:
   - las dependencias de F1–F18 respecto de P-19 a P-24;
   - la consulta de entradas propias en `PeopleController#show` y su alcance;
   - sesión vencida y foco, si P-22 conserva el Turbo frame;
   - zona horaria asumida por P-23;
   - significado de “datos mínimos” frente al contenido propio de la entrada y la descubribilidad de P-24;
   - orden de P-21 y su reemplazo por GL-07;
   - escenarios que faltan en las specs;
   - tareas y definición de terminado.
3. Contrastá la organización y profundidad de ticket/specs/tasks con el patrón de calidad de **TASK-012 de Pablo E**, que pertenece a otro proyecto. Usalo solo para estructura y nivel de detalle; no copies sus requisitos, decisiones ni diseño técnico.

## Forma de trabajo y salida

No edites archivos ni el repositorio. No regeneres ni apliques diffs; no ejecutes pruebas, validadores, migraciones ni formateadores; no hagas fetch, commits, push ni archivado.

Entregá:

- una tabla de **hallazgo | documento afectado | propuesta de texto | decisión que Pablo debe tomar**;
- bloques de texto completos listos para revisar, con su destino exacto;
- una lista de propuestas condicionadas a cada decisión pendiente;
- dudas que requieran evidencia o decisión de Pablo.

Mantené P-19 a P-24 como pendientes. No registres ninguna como aprobada, no declares listo el cambio y no autorices implementación.
````

## Resultado registrado (no forma parte del pedido)

- **M97:** primera línea de la respuesta final de Claude Code: «No modifiqué ningún archivo. P-19 a P-24 siguen pendientes, y todo lo que sigue es una propuesta para que la revises.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
