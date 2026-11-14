# GL-06. Captura rápida, completar y marcar como lista

> Séptimo ticket de la entrega 2 de Growth Log. Lugar en la secuencia:
> [plan de la entrega 2](../plan-entrega-2.md). Cambio de OpenSpec:
> [`gl-06-captura-rapida`](../../openspec/changes/archive/2026-11-14-gl-06-captura-rapida/proposal.md).
> **Estado (14/11/2026): cerrado y archivado.** Integrado en `feature/entrega-2-pp` con el [PR #4](https://github.com/pablo-wpify/growth-log-ai4devs/pull/4) (merge commit `8c2f2ade1ad1324c7eaeacbcfebc067eb9fa3d3f`) y archivado como [`2026-11-14-gl-06-captura-rapida`](../../openspec/changes/archive/2026-11-14-gl-06-captura-rapida/proposal.md). Cambio de OpenSpec aprobado por Pablo el 13/11/2026 («Vamos para adelante», según M120). Gate local en verde el 14/11/2026 (`bin/bundler-audit update` y `bin/ci`, con 291 ejemplos y 0 fallos). F17 está **parcial**: asistida por Claude Code (no «a mano por Pablo»), 375 px solo con `iframe` y controles pendientes, y el paso 16 en el navegador solo como simulación sin cookie, no un vencimiento real. Por decisión de Pablo (14/11/2026), no se hacen más comprobaciones manuales: el trabajo local se cierra con F17 parcial. La prueba automatizada de sesión vencida (reloj adelantado) se describe aparte, en «Verificaciones técnicas». CI remoto exitoso sobre `b5665aa` ([ejecución 43608171520](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43608171520)) y sobre `d65a66aa4c77436e9b9e1d27930c0be385264f3d`, el head final del PR ([ejecución 43609790733](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43609790733)); esa ejecución no corresponde al SHA de merge, que tuvo su propio CI exitoso sobre `8c2f2ade1ad1324c7eaeacbcfebc067eb9fa3d3f` ([ejecución 43610547250](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43610547250)). «Con datos mínimos» quedó aclarado (14/11/2026) para la rama de lectura de PT-11, que no está completo: compartir, revocar y reasignación siguen fuera y el listado de AM-1 sigue pendiente. Evidencia en el [diseño](../../openspec/changes/archive/2026-11-14-gl-06-captura-rapida/design.md#registro-de-la-implementación-13112026-local-sin-commit).
>
> | Tipo | Qué | Registro |
> |---|---|---|
> | Decisiones aprobadas o decididas | P-1, P-2, P-3 y P-11 (12/11/2026); P-19 a P-26 (13/11/2026) | [12/11/2026](../decisiones/2026-11-12-gl-06-feedback.md), [13/11/2026](../decisiones/2026-11-13-gl-06-captura.md) |
> | Cambio de OpenSpec | aprobado (13/11/2026) | tarea 0.4 |
> | Verificaciones técnicas | pruebas con `Time.zone.local` (P-23): verificadas en local; log de consultas (F12): fallaba en desarrollo (etiquetas de consulta); corregido con una regresión y **verificado en el servidor de desarrollo** el 14/11/2026; sesión vencida al enviar la captura: la prueba de peticiones «captura con la sesión vencida» adelanta el reloj 2 horas y 1 segundo y verifica la redirección al inicio de sesión, que no se crea la entrada y que no se recuerda la URL del `POST`; en F17, el navegador solo se probó con una simulación sin cookie, y allí **no se comprobó** un vencimiento real ni si el texto se conserva | diseño, «Registro de la implementación» |
> | Interpretación aclarada (14/11/2026) | «con datos mínimos» en la rama de lectura de PT-11: la interpretación de P-24 también se aplica; datos mínimos de la persona (solo el nombre), la entrada propia completa, incluidos los borradores, por URL directa. Resuelve la rama de lectura; PT-11 no queda completo | [13/11/2026, aclaración del 14/11/2026](../decisiones/2026-11-13-gl-06-captura.md) |

## Problema

Un líder ya elige una persona asignada (GL-05), pero no puede registrar
nada sobre ella: la ficha es de solo lectura y no existen entradas. La
regla de entradas que dejó GL-03 (lectura por autoría, escritura con
asignación activa) está escrita solo en su diseño, y el aislamiento del
feedback entre dos líderes de la misma persona, preparado por GL-08, no se
comprobó nunca.

## Objetivo

Que un líder con asignación activa anote una observación en el momento
como borrador privado, la complete después y la marque como lista, y que
la entrada siga siendo solo suya, también por URL directa.

## Origen

| Fuente | Qué exige |
|---|---|
| H3 ([Anexo A](../../anexos/anexo-a-historias.md)): 3.1, 3.2, 3.4 a 3.8 | acceso visible a la captura; borrador privado con la fecha de hoy y solo el texto; completar; marcar como lista indicando qué falta; sigue privada; editar una lista la deja lista; borrador solo del autor |
| H2 a través de completar: 2.3 a 2.6, 2.8 a 2.10 | contexto y fecha obligatorios; señal y dimensión de listas fijas; campos opcionales; autor registrado; privada; solo con asignación activa |
| 4.8, 4.9 y 4.11 (parciales) | detalle con autor, fecha y campos; sin acceso a lo ajeno; acompañar no da acceso a lo privado de otro líder. Falta la rama de compartidas y el feed |
| 3.9 | se cumple porque compartir no existe |
| 3.10 (parcial) | lee sus entradas y borradores sin asignación y no puede editarlos ni marcarlos como listos. Parcial: solo por URL directa, sin listado (P-24) |
| 4.14 (parcial) | sin asignación, no abre la ficha ni entradas ajenas; su entrada se muestra sin enlace a la ficha. El plan (sección 6.1, P-7) asigna sus pruebas a GL-06. Parcial: solo por URL directa, sin listado; de la persona, solo el nombre (P-24) |
| PT-11, rama de lectura (PT-11 parcial) | sigue leyendo sus entradas propias, también los borradores; no las edita ni las marca como listas; no abre la ficha ni entradas ajenas (plan, sección 6.1). «Con datos mínimos» quedó **aclarado por Pablo el 14/11/2026**: de la persona solo el nombre y la entrada propia completa, incluidos los borradores, por URL directa (P-24); con eso esta rama queda resuelta en GL-06. Compartir y revocar están diferidos; la reasignación queda fuera (P-26) |
| PP-2, PP-3, PP-4, PP-8, PP-9; AM-1 | reglas de privacidad aprobadas |
| P-7, P-9 (GL-03) y su diseño, sección 9 | regla de entradas definida, para especificar aquí |
| P-1, P-2, P-3, P-11 (12/11/2026) | dimensiones, señales, completitud de «lista» y alcance sin «+ Feedback» |
| P-19 a P-26 (13/11/2026) | rutas, escritura con persona activa, sección de entradas propias, captura en página propia, zona horaria, detalle sin acceso a la ficha, «Marcar como lista» idempotente y reasignación fuera de GL-06 |
| Plan, secciones 5 y 7 | matriz de privacidad obligatoria; texto fuera de los logs; nunca «Publicar» (RN-2) |
| Anexo G: T1.5, T1.6, T1.7 y T2.2 | migración de entradas, captura y reapertura, pruebas negativas, completar y marcar como lista. T2.1 queda fuera (P-11) |

## Alcance

1. Tabla `feedback_entries` con restricciones en la base para autor,
   persona, fecha, contexto, estado, señal, dimensión, confianza y
   completitud de «lista».
2. «Captura rápida» desde la ficha, en una página propia (P-22): solo el
   texto, borrador privado con la fecha de hoy en
   `America/Argentina/Buenos_Aires` (P-23), vuelta a la ficha con un aviso.
3. Detalle de una entrada propia, edición para completarla y «Marcar como
   lista», que indica qué falta o la deja lista y privada; sobre una
   entrada ya lista no cambia nada y vuelve al detalle (P-25).
4. Sección «Tus entradas sobre <nombre>» en la ficha, por fecha del hecho
   descendente y, en empate, primero la creada después (P-21).
5. Política y alcance de entradas: lectura por autoría, aunque termine la
   asignación o la persona quede inactiva; escritura con autoría,
   asignación activa y persona activa (P-20); administrar no da acceso.
   Detalle sin acceso a la ficha por URL directa (P-24).
6. Texto del feedback fuera de los logs.
7. Rutas nuevas en las pruebas de protección y de cobertura.

## Exclusiones

- Formulario completo «+ Feedback»: 2.1, 2.2 y 2.7, y la tarea T2.1
  (P-11). Siguen siendo requisito pendiente.
- Resumen, cronología y conteos en «Personas» (GL-07); 3.3 es de GL-07.
- Compartir, revocar, nombres de otros líderes, feed y filtros.
- Listado y datos mínimos del autor sin asignación (AM-1, P-7): solo se
  admite el detalle por URL directa (P-24). **Limitación aceptada por
  P-24:** sin asignación activa o con la persona inactiva, la ficha
  responde 404 y la sección «Tus entradas» no sirve para encontrar esas
  entradas; por eso 3.10 y 4.14 quedan parciales. En el núcleo, una
  asignación solo termina y una persona solo se desactiva por consola.
- PT-11: las ramas de compartir y revocar (diferidas) y la transición de
  reasignación («al reasignarlo vuelve a editar»), que es de escritura
  (P-26).
- Captura dentro de la ficha (Turbo frame): GL-06 elige una página propia
  (P-22) y no adopta la interacción sin navegación propuesta en MVP-FE-1
  (ticket propuesto en la entrega 1).
- Volver a borrador y borrar entradas (backlog de H3).
- Entradas en los datos ficticios de GL-08.
- Prueba automatizada en navegador (GL-09, P-4).
- Dependencias nuevas.

## Datos de una entrada

| Campo | Captura rápida | Completar | Para «lista» | Fuente |
|---|---|---|---|---|
| Contexto («¿Qué pasó?») | sí, obligatorio | editable, obligatorio | sí | 2.3, 3.2 |
| Fecha del hecho | hoy, automática | editable, obligatoria | sí | 2.3, 3.2, P-23 |
| Señal | — | opcional | **obligatoria** | 2.4, P-2, P-3 |
| Dimensión | — | opcional | **obligatoria** | 2.4, 2.6, P-1, P-3 |
| Evidencia, impacto | — | opcionales | no | 2.5 |
| Confianza 1 a 5 | — | opcional | no | 2.5 |
| Autor, persona | automáticos | no editables | — | 2.8, 2.10 |
| Estado | borrador | no editable | lo cambia «Marcar como lista» | 3.2, 3.6 |

## Navegación

```
┌──────────────────────────────────────────────────────────┐
│ ← Volver a Personas                                      │
│ Ada Ejemplo                                              │
│ Desarrolladora · Equipo Faro                             │
│ [Captura rápida]                                         │
│ Tus entradas sobre Ada Ejemplo                           │
│  12/11/2026  Borrador · solo vos  Resolvió el incid…     │
│  05/11/2026  Lista · solo vos     Presentó la demo…      │
└──────────────────────────────────────────────────────────┘
       │ «Captura rápida»                 │ clic en una entrada
       ▼                                  │
┌──────────────────────────────────────┐  │
│ ← Volver a Ada Ejemplo               │  │
│ Captura rápida sobre Ada Ejemplo     │  │
│ ¿Qué pasó? ______________________    │  │
│ Fecha: hoy, 12/11/2026               │  │
│ [Guardar borrador]                   │  │
└──────────────────────────────────────┘  │
       │ guardar: vuelve a la ficha       │
       │ con el aviso                     ▼
┌──────────────────────────────────────────────────────────┐
│ ← Volver a Ada Ejemplo                                   │
│ Entrada sobre Ada Ejemplo · Borrador · solo vos          │
│ Escrita por vos (Elena Boceto) · 12/11/2026              │
│ Contexto, señal, dimensión, evidencia, impacto, confianza│
│ [Editar]  [Marcar como lista]                            │
└──────────────────────────────────────────────────────────┘
```

La captura se abre en una página propia, sin Turbo frame (P-22); al
guardar, vuelve a la ficha con el aviso. Detalle en el
[diseño](../../openspec/changes/archive/2026-11-14-gl-06-captura-rapida/design.md).

## Criterios de aceptación

| # | Criterio | Origen |
|---|---|---|
| F1 | La base rechaza una entrada sin autor, sin persona, sin fecha o con el contexto vacío; con un estado, una señal o una dimensión fuera de las listas; con una confianza fuera de 1 a 5; y una entrada lista sin dimensión o sin señal. Acepta un borrador sin señal ni dimensión. La migración se revierte en la base de test | T1.5, 2.3 a 2.6, P-1 a P-3 |
| F2 | La ficha de una persona asignada muestra «Captura rápida», que lleva a la página de captura de esa persona (`/personas/:person_id/entradas/nueva`), con el texto, la fecha de hoy y «← Volver a <nombre>» | 3.1, P-19, P-22 |
| F3 | Guardar una captura con texto crea un borrador del autor sobre esa persona, con la fecha de hoy en `America/Argentina/Buenos_Aires`, y vuelve a la ficha con un aviso de que solo su autor lo ve; sin texto, 422 y nada guardado | 3.2, 2.8, 2.9, 2.10, P-23 |
| F4 | El autor completa su borrador (fecha, contexto, señal, dimensión, evidencia, impacto y confianza) y sigue como borrador; sin fecha o sin contexto, 422 y la entrada no cambia; autor, persona y estado no se cambian por la edición | 3.4, 2.3, 2.5 |
| F5 | Marcar como lista un borrador con dimensión y señal lo deja lista y privada, con un aviso que lo dice | 3.6, 2.9, P-3 |
| F6 | Marcar como lista un borrador incompleto responde 422, dice qué falta (dimensión, señal o las dos) y la entrada queda igual | 2.6, 3.5, P-3 |
| F7 | Editar una entrada lista la deja lista; quitarle la señal o la dimensión se rechaza y la entrada no cambia | 3.7, P-3 |
| F8 | El detalle muestra al autor, la fecha, el estado y todos los campos con sus etiquetas, y las acciones que corresponden; sin acceso a la ficha (asignación terminada o persona inactiva), el autor sigue viendo por URL directa todos los campos de su borrador o de su entrada lista, y de la persona solo el nombre, sin enlace a la ficha ni acciones de escritura | 2.8, 4.8 parcial, 3.10 parcial, 4.14 parcial, PT-11 (lectura de entradas propias; «con datos mínimos» aclarado el 14/11/2026: de la persona, solo el nombre), P-24 |
| F9 | La ficha lista las entradas propias sobre la persona, con fecha, estado y comienzo del texto, por fecha del hecho descendente y, en empate, primero la creada después, y nunca las de otro líder; sin entradas, un mensaje | P-21, 4.11 |
| F10 | Matriz de privacidad: sobre el borrador y la entrada lista de L1, L2 (misma persona), L3 (sin asignación) y A (sin asignación y asignada) reciben 404, igual que para una entrada inexistente, en detalle, formulario de edición, edición y marcar como lista, por URL directa, sin el texto en la respuesta y sin cambios en la base | 2.9, 3.8, 4.9, 4.11, PP-3, PP-4, PP-8 |
| F11 | Crear, editar y marcar como lista sin asignación activa o sobre una persona inactiva responde 404 sin cambios; el autor conserva la lectura | 2.10, 3.10 parcial, 4.14 parcial, PT-11 (lectura: no edita ni marca como lista), PP-9, P-9, P-20 |
| F12 | El contexto, la evidencia y el impacto no aparecen en el log de la petición ni en el de las consultas. Que el filtro alcance al log de consultas está **sin verificar**: se comprueba al implementar, sin relajar el criterio | plan sección 5, RN-5 |
| F13 | Ninguna página de entradas dice «Publicar»; los estados dicen «solo vos» | RN-2 |
| F14 | El listado sigue sin formularios ni funciones de feedback; en la ficha, el único acceso para registrar feedback es «Captura rápida», sin «+ Feedback», resumen ni compartir | delta de `people-browsing`, P-11 |
| F15 | Las rutas nuevas están en la prueba sin sesión de GL-02 y en la de cobertura de GL-03; la lista de excepciones no cambia | GL-02, GL-03 |
| F16 | Mutaciones registradas: las seis del diseño hacen fallar la prueba esperada | GL-03 |
| F17 | La captura en su página, completar y marcar como lista se ven y funcionan en escritorio y a 375 px, con Elena y Tomás, comprobado **a mano** por Pablo y registrado como manual. Se registra también qué ve el autor si su sesión vence antes de enviar la captura | alcance, P-22 |
| F18 | `bin/ci` y el CI remoto pasan | GL-01 |
| F19 | Marcar como lista una entrada que ya está lista no la cambia y vuelve al detalle sin error | P-25 |

## Escenarios de privacidad

Actores: L1 y L2 asignados a la persona P; L3 sin asignación; A
administradora, sin asignación y, en otra prueba, asignada a P; I persona
inactiva con asignación de L1.

| Situación | Resultado |
|---|---|
| L2 pide el borrador o la lista de L1 (detalle, editar, guardar, marcar como lista) | 404 igual que inexistente, sin el texto, sin cambios |
| L3 o A (asignada o no) hacen lo mismo | ídem |
| L3 o A envían una captura sobre P | 404, ninguna entrada creada |
| L1 envía una captura sobre I | 404, ninguna entrada creada |
| Termina la asignación de L1 con P | L1 lee por URL directa su borrador y su entrada lista, con todos sus campos y solo el nombre de la persona (P-24); editar y marcar como lista dan 404 sin cambios. La ficha da 404, así que no las encuentra por «Tus entradas» (3.10 y 4.14 parciales; PT-11, rama de lectura, sin dar por resuelta «con datos mínimos») |
| P pasa a inactiva | ídem (P-9, P-20, P-24) |
| L2 abre la ficha de P | no ve las entradas de L1 en la sección |
| Una entrada pasa a lista | nadie más gana acceso (PP-4) |

## Dependencias

- GL-05 cerrado y archivado (`8d0e854`), con GL-03 y GL-08.
- P-1, P-2, P-3 y P-11 aprobadas (12/11/2026); P-19 a P-26 decididas
  (13/11/2026).
- Cambio de OpenSpec aprobado por Pablo el 13/11/2026 («Vamos para adelante», según M120).
- Para GL-07: el modelo, las etiquetas y el alcance de entradas, y el
  ajuste de P-2 al resumen, registrado en el plan y en el diseño.

## Riesgos

| Riesgo | Mitigación |
|---|---|
| Una acción carga una entrada sin el alcance y la expone (RN-1) | carga por `policy_scope`, matriz por URL directa, cobertura y mutaciones 1 y 2 |
| La sección de la ficha muestra entradas ajenas | alcance por autor y mutación 4 |
| «Lista» confundida con «compartida» (RN-2) | estados «solo vos», avisos y ninguna palabra «Publicar» |
| El texto llega a los logs (RN-5) | filtro de parámetros y prueba sobre el log de la petición y de las consultas. En desarrollo no alcanzaba (etiquetas de consulta); se corrigió sin relajar el filtro y se verificó el 14/11/2026 |
| Fecha de «hoy» desplazada por UTC | P-23 y una prueba con una hora cercana a la medianoche |
| El cambio de zona horaria altera otras pruebas | **sin verificar:** al implementar se comprueban las pruebas que usan `Time.zone.local` y la suite completa, incluidas las de vencimiento de sesión |
| La sesión vence antes de enviar la captura | la prueba de peticiones «captura con la sesión vencida» adelanta el reloj 2 horas y 1 segundo y verifica la redirección al inicio de sesión, que no se crea la entrada y que no se recuerda la URL del `POST`. En el navegador (F17, paso 16) solo hubo una simulación sin cookie, no una prueba manual de vencimiento: redirigió al inicio de sesión, no creó una entrada y el inicio de sesión no mostró ningún aviso (observación). **Sin comprobar en el navegador:** el vencimiento real y la conservación del texto. No se diseña ninguna mitigación por ahora |
| El autor sin acceso a la ficha no encuentra sus entradas | aceptado por P-24: solo por URL directa; 3.10 y 4.14 quedan parciales; en el núcleo solo ocurre por consola |
| El recorrido de la captura no tiene prueba automatizada en navegador | comprobación manual F17; GL-09 la automatiza |

## Evidencia prevista

- Pruebas de base, modelo, política, peticiones, privacidad, logs y textos,
  escritas antes de implementar y vistas fallar por la razón esperada.
- Las seis mutaciones del diseño, con copia de seguridad y restauración.
- `bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`
  locales.
- Comprobación manual F17, registrada como manual.
- Con autorización de push: CI remoto con su enlace y su SHA.

## Relación con la entrega

Tercer y cuarto paso del recorrido núcleo: «capturar una observación como
borrador privado → completarla y marcarla como lista». Tareas T1.5, T1.6,
T1.7 y T2.2 del Anexo G, sin T2.1 (P-11).
