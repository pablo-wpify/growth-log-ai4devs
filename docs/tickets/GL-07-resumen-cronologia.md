# GL-07. Resumen por dimensión y cronología

> Octavo ticket de la entrega 2 de Growth Log. Lugar en la secuencia:
> [plan de la entrega 2](../plan-entrega-2.md). Cambio de OpenSpec:
> [`gl-07-resumen-cronologia`](../../openspec/changes/gl-07-resumen-cronologia/proposal.md).
> **Estado (14/11/2026): implementado en local, sin commit.** Pablo aprobó
> P-10, decidió el alcance de 4.3, 4.4, 4.5 y 1.15 y confirmó los detalles
> de presentación y las mutaciones el 14/11/2026, y aprobó el cambio de
> OpenSpec ese mismo día (M194). Gate local en verde: `bin/ci` con 315
> ejemplos y 0 fallos; mutaciones M1 a M4 detectadas. Faltan el CI remoto
> y el archivo. Evidencia en el
> [diseño](../../openspec/changes/gl-07-resumen-cronologia/design.md#registro-de-la-implementación-14112026-local-sin-commit).
>
> | Tipo | Qué | Registro |
> |---|---|---|
> | Decisiones aprobadas o decididas | P-2 (12/11/2026); P-10, alcance de 4.3, 4.4, 4.5 y 1.15, y detalles de presentación y mutaciones (14/11/2026) | [12/11/2026](../decisiones/2026-11-12-gl-06-feedback.md), [14/11/2026](../decisiones/2026-11-14-gl-07-resumen-cronologia.md) |
> | Cambio de OpenSpec | aprobado (14/11/2026, M194) | tarea 0.4 |

## Problema

Un líder ya registra entradas privadas sobre una persona y las marca como
listas (GL-06), pero no puede verlas reunidas: la ficha solo tiene una
lista provisoria de sus entradas (P-21), sin resumen por dimensión ni orden
cronológico, y el listado «Personas» no dice cuántas entradas tiene sobre
cada persona.

## Objetivo

Que en la ficha de una persona el líder vea un resumen por dimensión de
sus entradas listas y recorra sus entradas en orden cronológico, y que en
«Personas» vea cuántas entradas listas tiene sobre cada persona, siempre
solo con lo que puede ver: lo de otro líder de la misma persona no cuenta
ni aparece.

## Origen

| Fuente | Qué exige |
|---|---|
| H4 ([Anexo A](../../anexos/anexo-a-historias.md)): 4.1, 4.4, 4.5 | resumen por dimensión de las entradas listas; mensaje en lugar del resumen si no hay nada; aclarar que no es un puntaje |
| 4.2, 4.3, 4.12 y 4.13 (parciales) | resumen y cronología solo con lo que puedo ver; distinguir lo propio de lo compartido; resúmenes distintos para dos líderes; orden cronológico por fecha del hecho. Parciales: solo entradas propias, porque compartir está diferido |
| 3.3 | un borrador no cuenta en el resumen ni en el conteo |
| 1.15 (parcial) | el conteo de entradas de cada persona incluye solo las que puedo ver. Parcial: sin compartidas |
| 4.11 | acompañar a una persona no da acceso a las entradas privadas de otro líder |
| PP-2, PP-3, PP-4, PP-6 | reglas de privacidad aprobadas |
| P-2 (12/11/2026) | columnas del resumen: Positivos, A mejorar, Neutrales y Total; ajusta la presentación de 4.1 |
| P-10 y alcance de 4.3, 4.4, 4.5 y 1.15 (14/11/2026) | orden y desempate de la cronología, borradores marcados, textos del resumen y formato del conteo |
| Mock 1 ([Anexo E](../../anexos/anexo-e-mocks.md)) | resumen por dimensión, texto de 4.5 y cronología con el borrador «fuera del resumen» |
| Plan, secciones 5 y 7 | pruebas de privacidad obligatorias y mutación del alcance del resumen |
| Anexo G: T3.1, T3.2 y T3.3 | consulta con alcance común; resumen y cronología; conteo en «Personas» |

## Alcance

1. **Resumen por dimensión** en la ficha: una fila por dimensión con al
   menos una entrada lista propia, con Positivos, A mejorar, Neutrales y
   Total (P-2). Debajo, el texto «Solo entradas listas. No es un puntaje:
   reúne evidencia para la conversación» (4.5). Sin entradas propias
   listas, en lugar del resumen: «Todavía no hay entradas listas para el
   resumen» (4.4).
2. **Cronología** en la ficha: todas las entradas propias sobre la
   persona, por fecha del hecho de la más antigua a la más reciente y, en
   empate, por `created_at` y `id` ascendentes (P-10). Cada entrada
   muestra su fecha, su estado («Lista · solo vos» o «Borrador · solo vos ·
   fuera del resumen»), su señal y su dimensión si las tiene, como el mock
   1, el comienzo del contexto y un enlace a su detalle. Sin entradas
   propias: «Todavía no
   registraste entradas sobre <nombre>». Reemplaza la sección provisoria
   «Tus entradas» (P-21).
3. **Conteo en «Personas»:** cada fila muestra, después de «rol ·
   equipo», «1 entrada lista» para uno y «N entradas listas» para cero o
   más de uno, contando solo las entradas propias listas (1.15 parcial).
4. **Consultas con alcance:** el resumen, la cronología y el conteo leen
   solo a través del alcance de entradas de la cuenta; una entrada de otro
   líder no cuenta ni aparece, aunque los dos acompañen a la misma persona.
5. Pruebas de privacidad y mutaciones del alcance, escritas antes de
   implementar.

## Exclusiones

- Entradas compartidas conmigo y el origen «compartida con vos»: columna
  «Origen» y etiquetas de compartidas (4.2, 4.3 y 1.15 completos; I4).
- Filtros por estado, señal o dimensión y «Limpiar» (4.6 y 4.7; I6).
- Selector de orden de la cronología: ningún criterio lo pide.
- Feed, compartir, revocar y la transición de reasignación de PT-11.
- Prueba E2E en navegador y su herramienta (P-4, ADR-6): GL-09.
- Cambios en la tabla de entradas: no hay migraciones.

## Navegación

- **Ficha de una persona:** nombre, rol y equipo; «Captura rápida»;
  «Resumen por dimensión»; «Vista cronológica». Los títulos son los del
  mock 1. No aparecen «Publicar», «+ Feedback», compartir, filtros ni
  enlaces de administración.
- **«Personas»:** cada fila suma el conteo después de «rol · equipo»:
  «0 entradas listas», «1 entrada lista», «2 entradas listas».
- No hay rutas nuevas: todo se muestra en el listado y en la ficha
  existentes.

## Criterios de aceptación

| ID | Criterio | Fuente |
|---|---|---|
| R1 | El resumen tiene una fila por dimensión con al menos una entrada lista propia, en el orden de la lista de P-1, con Positivos, A mejorar, Neutrales y Total; Total es la suma de las tres columnas | 4.1, P-2 |
| R2 | Un borrador no cuenta en el resumen ni en el conteo, tampoco para su autor | 3.3 |
| R3 | Sin entradas propias listas, en lugar del resumen se muestra «Todavía no hay entradas listas para el resumen» | 4.4 |
| R4 | Con resumen, se muestra «Solo entradas listas. No es un puntaje: reúne evidencia para la conversación» | 4.5 |
| C1 | La cronología muestra las entradas propias, listas y borradores, de la más antigua a la más reciente por fecha del hecho; en empate, por `created_at` y `id` ascendentes | 4.13 parcial, P-10 |
| C2 | Un borrador aparece marcado «Borrador · solo vos · fuera del resumen» y una entrada lista, «Lista · solo vos»; cada entrada muestra su señal y su dimensión si las tiene, el comienzo del contexto y un enlace a su detalle | 3.3, 4.3 parcial, P-10, mock 1 |
| C3 | Sin entradas propias, la cronología muestra «Todavía no registraste entradas sobre <nombre>» | P-10, 4.4 |
| N1 | Cada fila de «Personas» muestra, después de «rol · equipo», «1 entrada lista» o «N entradas listas» (también «0 entradas listas»), contando solo las entradas propias listas | 1.15 parcial |
| P1 | Resumen, cronología y conteo de un líder no incluyen las entradas de otro líder de la misma persona, ni listas ni borradores | 4.2, 4.11, 4.12, PP-2, PP-4, PP-6 |
| P2 | Ser administrador no agrega entradas al resumen, la cronología ni el conteo | PP-8 |

## Escenarios de privacidad

Datos de prueba, como en GL-06: L1 y L2, líderes asignados a la misma
persona P; A, administradora con asignación activa con P.

| Situación | Resultado esperado |
|---|---|
| L1 tiene una entrada lista y un borrador sobre P; L2 abre la ficha de P | el resumen de L2 no cuenta la entrada de L1; la cronología de L2 no muestra ninguna de las dos; la respuesta no contiene el texto de L1 |
| L2 abre «Personas» | el conteo de P es el de sus propias entradas listas, sin las de L1 |
| L1 abre la ficha de P | su resumen cuenta su entrada lista y no su borrador; su cronología muestra las dos, el borrador marcado «fuera del resumen» |
| L1 abre «Personas» | el conteo de P cuenta solo su entrada lista |
| A abre la ficha de P y «Personas» | ve solo sus propias entradas y su propio conteo |
| Mutaciones M1 a M4 (ver «Evidencia prevista») | cada una hace fallar la prueba que protege su consulta |

## Dependencias

- **GL-06 (cerrado):** tabla de entradas, etiquetas de señales y
  dimensiones (P-1, P-2), alcance `FeedbackEntryPolicy::Scope` y la
  sección provisoria de la ficha, que este ticket reemplaza.
- **P-2 (12/11/2026) y P-10 (14/11/2026):** aprobadas.
- **No depende** de P-4 ni de ADR-6 (GL-09).

## Riesgos

| Riesgo | Mitigación |
|---|---|
| Una consulta del resumen, la cronología o el conteo sin el alcance mostraría entradas ajenas (RN-1) | las consultas reciben el alcance ya resuelto; pruebas de privacidad con L1 y L2 y mutaciones registradas. `verify_policy_scoped` no lo detecta, porque la ficha ya usa el alcance de personas |
| El conteo por persona hace una consulta por fila | una sola consulta agrupada sobre el alcance |
| Un borrador termina contando en el resumen o el conteo (3.3) | filtro por estado `ready` y mutación que lo quita |
| La cronología cambia el orden de la sección provisoria | delta explícito en `feedback-capture` y pruebas del orden ascendente con desempate |

## Evidencia prevista

- Pruebas de peticiones, privacidad y textos, escritas antes de
  implementar y vistas fallar por la razón esperada.
- Mutaciones registradas, con restauración comprobada:

  | # | Mutación | Consulta | Criterio que protege |
  |---|---|---|---|
  | M1 | el resumen lee las entradas de la persona sin el alcance | resumen | P1: 4.2, 4.11, 4.12 (exigida por el plan) |
  | M2 | la cronología lee las entradas de la persona sin el alcance | cronología | P1: 4.11, 4.13 |
  | M3 | el conteo lee las entradas listas sin el alcance | conteo en «Personas» | N1 y P1: 1.15, 4.11 |
  | M4 | el resumen no filtra por entradas listas | resumen | R2: 3.3 |
- `bin/bundler-audit update`, `bin/ci` y `openspec validate --all
  --strict` locales.
- Con autorización de push: CI remoto con su enlace y su SHA.

## Relación con la entrega

GL-07 completa el recorrido núcleo hasta ver la entrada lista en el
resumen y en la cronología. GL-09 lo verifica en navegador.
