# M98. Preparar la ficha de decisiones pendientes

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | ficha de decisiones (solo lectura) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `2fddf4b4430fd7e97bd9b8d479f5f4b307e5017a9a3a3608ee9a14021cc74bb1` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M98 | 2026-11-13 13:49:26 |
| M99 | 2026-11-13 14:01:40 |

## Texto original

````text
Prepará una **ficha breve de decisiones pendientes** de GL-06 para que Pablo pueda resolverlas. Usá como base el análisis ya realizado; no repitas la inspección completa.

Estado conocido: checkout `feature/entrega-2-pp`, HEAD `bc0195b23eb2b6859fc8a5c6c6472f7b2d51e320`; preparación local sin commit, idéntica a `gl06-preparacion-v3.diff`. GL-06 sigue preparado, sin aprobar y sin implementar. P-1, P-2, P-3 y P-11 figuran aprobadas; P-19 a P-24 siguen pendientes. No modifiques ni regeneres esos archivos.

TASK-012 de Pablo E pertenece a otro proyecto y ya se usó solo como referencia de calidad documental. No la uses como fuente de requisitos.

## Decisiones que debe presentar

Para cada punto, resumí las opciones, recomendá una, explicá el efecto en los documentos y dejá claro qué tiene que responder Pablo:

- **P-19:** rutas propuestas. Indicá si hay alguna razón concreta para ajustarlas.
- **P-20:** autoría, asignación activa y persona activa para escribir; lectura propia después de terminar la asignación.
- **P-21:** orden de la sección temporal de entradas propias y cómo se reemplaza por GL-07. Compará orden más reciente primero con el de P-10.
- **P-22:** Turbo frame o página propia. Conservá la distinción correcta: el análisis original recomendaba el frame con aclaraciones sobre sesión vencida y foco; la recomendación posterior de página propia fue una alternativa de menor alcance. No presentes como comprobada ninguna solución técnica para recuperar una sesión vencida dentro del frame.
- **P-23:** zona horaria única de Argentina frente a mantener UTC. Indicá qué supuesto de uso hace falta confirmar y qué pruebas existentes podrían verse afectadas.
- **P-24:** significado de “datos mínimos” y descubribilidad. Separá cuánto se muestra de la persona de cuánto se muestra de la entrada propia; compará (a) acceso solo por URL, (b) listado mínimo que requiere resolver AM-1 y (c) otra vista accesible. Indicá qué criterios seguirían parciales.
- **Entrada ya lista:** qué responde una segunda solicitud para marcarla como lista: operación idempotente que vuelve al detalle o rechazo.
- **PT-11:** no agregues a GL-06 el retorno a edición tras una reasignación sin decisión explícita. El plan asigna la rama de lectura; explicá por separado que la reasignación es una transición de escritura.
- **Privacidad de logs:** mantené como requisito que el texto no aparezca en logs de petición ni de consultas. Si la evidencia indica que las consultas podrían registrarlo, no propongas relajar el requisito: señalá la incertidumbre y las opciones técnicas para investigarla después.

Incluí también una fila para P-19 y P-20 aunque parezcan estar suficientemente sustentadas, para que quede visible que su aprobación final corresponde a Pablo.

## Formato de salida

Entregá una tabla compacta:

`decisión | opciones | recomendación | impacto en criterios/documentos | respuesta de Pablo`

Después, listá solo las contradicciones o hechos que requieran verificación antes de editar la documentación. No inventes opciones que no estén respaldadas por los archivos o por este pedido.

**Solo lectura:** no edites archivos ni el repositorio; no regeneres ni apliques diffs; no ejecutes pruebas, validadores, migraciones ni formateadores; no hagas fetch, commits, push ni archivado. No marques decisiones como aprobadas y no autorices implementación.
````

## Resultado registrado (no forma parte del pedido)

- **M98:** primera línea de la respuesta final de Claude Code: «Decisiones pendientes de GL-06»
- **M99:** primera línea de la respuesta final de Claude Code: «Este pedido es idéntico al anterior, y la ficha ya está en mi respuesta inmediatamente anterior. El estado no cambió: HEAD sigue en `bc0195b23eb2b6859fc8a5c6c6472f7b2d51e320`, `git status` muestra las mismas 8 entradas y `gl06-preparacion-v3.diff` mantiene su hash (`605cc651…`). Así que esa ficha sigue vigente y no la repito.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
