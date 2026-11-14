# Design

> **Estado (14/11/2026): cerrado y archivado.** Integrado en
> `feature/entrega-2-pp` con el [PR #5](https://github.com/pablo-wpify/growth-log-ai4devs/pull/5) (merge commit `b835bde`) y archivado
> como `2026-11-14-gl-07-resumen-cronologia`. P-2 está aprobada
> (12/11/2026); Pablo aprobó P-10, decidió el alcance de 4.3, 4.4, 4.5 y
> 1.15 y confirmó los detalles el 14/11/2026, y aprobó el cambio ese mismo
> día (M194). CI remoto exitoso (ver «CI remoto del 14/11/2026»). Lo
> ejecutado se registra en «Registro de la implementación».

## Context

- **Entradas (GL-06, archivado):** `feedback_entries` con `status`
  (`draft`, `ready`), `signal`, `dimension`, `occurred_on`, `created_at`,
  `author_id` y `person_id`, el índice `(person_id, author_id)` y el filtro
  `FeedbackEntry.ready` del enum de estados. `FeedbackEntry::DIMENSIONS` y
  `FeedbackEntry::SIGNALS` traen las etiquetas de P-1 y P-2.
- **Alcance de entradas:** `FeedbackEntryPolicy::Scope` resuelve las
  entradas de la cuenta (`where(author: user)`), con borradores incluidos.
  El contrato de GL-06 con GL-07 (su diseño, sección 9) fija que GL-07
  recibe ese alcance ya resuelto, nunca el modelo; el plan (sección 6.1)
  dice lo mismo para el resumen, la cronología y los conteos.
- **Ficha hoy:** `PeopleController#show` arma la sección provisoria «Tus
  entradas» (P-21) con `policy_scope(FeedbackEntry).where(person:)`, en
  orden descendente. `verify_policy_scoped` ya se cumple con
  `policy_scope(Person)`: no detectaría una consulta de entradas sin
  alcance. La protección son la forma de la consulta y sus pruebas.
- **Listado hoy:** `PeopleController#index` muestra nombre y
  «rol · equipo»; no cuenta entradas.
- **Specs vigentes que chocan:** `people-browsing` prohíbe mostrar
  «resumen» y «cronología» como funciones inexistentes, y `feedback-capture`
  tiene la sección provisoria de P-21. Los dos se cambian con deltas
  explícitos.

## Goals / Non-Goals

**Goals:**

- Resumen por dimensión y cronología de las entradas propias en la ficha,
  y conteo de entradas listas propias en «Personas».
- Que ninguna de las tres lecturas incluya entradas de otro líder de la
  misma persona, con pruebas y mutaciones que lo demuestren.

**Non-Goals:**

- Entradas compartidas, el origen «compartida con vos» y la columna
  «Origen» (I4).
- Filtros y «Limpiar» (4.6, 4.7; I6) y un selector de orden.
- La prueba E2E en navegador y su herramienta (GL-09; P-4, ADR-6).
- Migraciones, rutas o dependencias nuevas.

## Decisions

### 1. Decisiones aprobadas o decididas

| # | Decisión | Dónde se aplica |
|---|---|---|
| P-2 (12/11/2026) | Columnas Positivos, A mejorar, Neutrales y Total | sección 3; `feedback-summary` |
| P-10 (14/11/2026) | Cronología ascendente por fecha del hecho; en empate, `created_at` e `id` ascendentes; borradores marcados «Borrador · solo vos · fuera del resumen», fuera del resumen y del conteo; reemplaza la sección de P-21 | sección 4; `feedback-summary`, `feedback-capture` |
| 4.3 parcial (14/11/2026) | Solo entradas propias, con «… · solo vos»; sin columna «Origen» | secciones 3 y 4 |
| 4.5 (14/11/2026) | «Solo entradas listas. No es un puntaje: reúne evidencia para la conversación» | sección 3 |
| 4.4 (14/11/2026) | «Todavía no hay entradas listas para el resumen» sin entradas propias listas; cronología vacía con «Todavía no registraste entradas sobre <nombre>»; sin filas para dimensiones sin datos | secciones 3 y 4 |
| 1.15 parcial (14/11/2026) | «N entradas listas» en cada fila de «Personas», también con 0, solo entradas propias listas | sección 5 |
| Detalles (14/11/2026, M193) | «1 entrada lista» para uno y «N entradas listas» para cero o más de uno; conteo después de «rol · equipo»; cronología con señal y dimensión, como el mock 1; filas del resumen en el orden de P-1; títulos del mock 1; cuatro mutaciones enumeradas | secciones 2 a 5 y «Mutaciones» |

Registro: `docs/decisiones/2026-11-14-gl-07-resumen-cronologia.md` y el
plan, sección 6.

### 2. Lecturas con alcance

Las tres lecturas parten de `policy_scope(FeedbackEntry)` en el
controlador y reciben esa relación; ninguna consulta `FeedbackEntry`
directamente.

- **Ficha:** `entries = policy_scope(FeedbackEntry).where(person: @person)`.
  - Cronología: `entries.order(occurred_on: :asc, created_at: :asc, id: :asc)`.
  - Resumen: `entries.ready.group(:dimension, :signal).count`, una sola
    consulta; las filas se arman en el orden de `FeedbackEntry::DIMENSIONS`,
    omitiendo las dimensiones sin datos.
- **Listado:** `policy_scope(FeedbackEntry).ready.where(person: @people).group(:person_id).count`,
  una sola consulta agrupada; una persona sin entradas muestra 0.

El armado del resumen (de los conteos agrupados a las filas con su total)
vive en un objeto sin consultas propias que recibe el resultado, para
probarlo aparte. Las filas siguen el orden de la lista de P-1 (Entrega,
Calidad técnica, Trabajo en equipo, Comunicación, Iniciativa), confirmado
por Pablo el 14/11/2026.

### 3. Resumen

- Título «Resumen por dimensión» (mock 1). Tabla con Dimensión,
  Positivos, A mejorar, Neutrales y Total; Total es la suma de las tres.
- Debajo, el texto de 4.5.
- Sin entradas propias listas: en lugar de la tabla y del texto de 4.5,
  «Todavía no hay entradas listas para el resumen» (4.4), aunque haya
  borradores.
- Sin columna «Origen» (4.3 parcial).

### 4. Cronología

- Título «Vista cronológica» (mock 1). Reemplaza la sección «Tus entradas
  sobre <nombre>» de P-21. Cada fila muestra la fecha del hecho
  (`dd/mm/aaaa`), el estado, la señal y la dimensión con sus etiquetas
  cuando las tiene (como el mock 1), el comienzo del contexto (los
  primeros 80 caracteres, como hoy) y el enlace al detalle.
- Estados: «Lista · solo vos» y «Borrador · solo vos · fuera del
  resumen». Las demás páginas mantienen «Borrador · solo vos».
- Sin entradas propias: «Todavía no registraste entradas sobre <nombre>».

### 5. Conteo en «Personas»

- Cada fila suma el conteo después de «rol · equipo», dentro del enlace a
  la ficha: «1 entrada lista» para uno y «N entradas listas» para cero o
  más de uno («0 entradas listas»).
- El conteo es de entradas propias listas; los borradores no cuentan (3.3).

### 6. Vistas y estilos

- Tabla accesible: encabezados de columna y de fila con su ámbito. Mismas
  reglas de GL-05 y GL-06: área táctil de 44 px, foco visible y estado en
  texto, sin depender del color.
- Ningún texto dice «Publicar»; no aparecen filtros, compartir ni «+
  Feedback».

### 7. Texto fuera de los logs

Las lecturas no reciben parámetros con texto y los `SELECT` agregados no
llevan valores del contexto, la evidencia ni el impacto. Se mantiene la
regresión de F12 de GL-06.

### 8. Pruebas existentes que cambian

| Archivo | Cambio | Por qué |
|---|---|---|
| `spec/requests/person_entries_spec.rb` (GL-06) | la sección pasa a ser la cronología: título, orden ascendente con desempate y marca «fuera del resumen» del borrador; se mantienen el aislamiento y el estado vacío | delta `REMOVED` y `MODIFIED` de `feedback-capture` |
| `spec/requests/navigation_spec.rb` (GL-05, GL-06) | la ficha deja de prohibir «resumen»; sigue sin «+ Feedback», compartir, filtros ni administración. El listado sigue con un solo formulario | delta `MODIFIED` de `people-browsing` |
| `spec/requests/people_spec.rb` (GL-05) | sin cambios esperados en sus aserciones; el conteo se prueba aparte. Si choca con una aserción, se informa antes de cambiarla | — |
| `route_protection_spec.rb`, `authorization_coverage_spec.rb` | sin cambios: no hay rutas nuevas | — |

Ninguna expectativa de GL-02, GL-03, GL-05 ni GL-06 se debilita sin un
delta explícito.

## Verificación

### Datos de prueba

L1 y L2, líderes asignados a la misma persona P; A, administradora
asignada a P sin entradas propias; Q, otra persona asignada a L1 sin
entradas. Cada prueba crea sus datos ficticios; no usa la base de
desarrollo.

### Matriz de privacidad (peticiones)

| Actor y página | Esperado |
|---|---|
| L2, ficha de P, con una entrada lista y un borrador de L1 | resumen sin la entrada de L1 (mensaje de 4.4 si L2 no tiene listas); cronología sin ninguna de las dos; la respuesta no contiene sus textos |
| L2, «Personas» | el conteo de P no incluye la entrada de L1 |
| L1, ficha de P | resumen con su lista y sin su borrador; cronología con las dos, el borrador marcado |
| L1, «Personas» | P con «1 entrada lista»; Q con «0 entradas listas» |
| A, ficha de P y «Personas» | mensaje de 4.4, cronología vacía y «0 entradas listas» |

### Mutaciones (con copia de seguridad y restauración comprobada)

| # | Mutación | Consulta que protege | Criterio | Prueba que debe fallar |
|---|---|---|---|---|
| M1 | `FeedbackEntry.where(person:)` en lugar de `policy_scope(FeedbackEntry).where(person:)` para el resumen | resumen (`PeopleController#show`) | P1: 4.2, 4.11, 4.12 parciales. Exigida por el plan | el resumen de L2 no cuenta la entrada lista de L1 |
| M2 | lo mismo para la cronología | cronología (`PeopleController#show`) | P1: 4.11, 4.13 parcial | la cronología de L2 no muestra las entradas de L1 ni su texto |
| M3 | `FeedbackEntry.ready` en lugar de `policy_scope(FeedbackEntry).ready` para el conteo | conteo (`PeopleController#index`) | N1 y P1: 1.15 parcial, 4.11 | el conteo de P para L2 no incluye la entrada lista de L1 |
| M4 | sin el filtro `ready` en el resumen | resumen | R2: 3.3 | un borrador con señal y dimensión no cuenta en el resumen de su autor |

Ninguna de las cuatro la detecta Pundit: las acciones ya cumplen
`verify_policy_scoped` con el alcance de personas. Cada una se aplica con
copia de seguridad y se restaura comprobando que la suite vuelve a pasar.

### Comprobación en navegador

El plan no exige una comprobación manual para GL-07; la prueba en
navegador del recorrido completo es de GL-09.

### Evidencia que se registra aquí al implementar

`bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`
locales; las mutaciones; y, con autorización de push, el CI remoto con su
enlace y su SHA.

#### Registro de la implementación (14/11/2026, local, sin commit)

Todo lo de esta sección se comprobó en **local**, en
`feature/GL-07-resumen-cronologia` sobre `fda2cec`. No hay CI remoto: no
hubo commit ni push.

- **Pruebas primero.** Cada grupo escribió sus pruebas y las vio fallar
  antes de implementar:
  - grupo 1: 5 de 6 fallaban (no había resumen ni conteo). La sexta, la
    cronología de L2 sin entradas de L1, ya pasaba: la sección provisoria
    de GL-06 leía con el alcance;
  - grupo 2: 9 de 11 fallaban (columnas de P-2, textos de 4.4 y 4.5,
    armado completo). Dos pasaban por el resumen mínimo de la tarea 1.2:
    el orden de P-1 y la omisión de dimensiones sin datos;
  - grupo 3: 6 de 10 fallaban (título, orden descendente, marca del
    borrador, señal y dimensión);
  - grupo 5: `navigation_spec` fallaba porque prohibía «resumen» en la
    ficha.
- **Desvío: grupo 4.** Sus 3 pruebas pasaron en la primera ejecución,
  porque la tarea 1.2 ya implementó el conteo: la matriz de privacidad del
  grupo 1 exigía «1 entrada lista» y «0 entradas listas». Para comprobar
  que detectan fallas, se ejecutaron contra tres implementaciones rotas a
  propósito, con copia y restauración: el conteo antes de «rol · equipo»,
  siempre en plural y una consulta por fila. Cada una hizo fallar una
  prueba.
- **Archivos:**
  - `PeopleController#index` (conteo agrupado) y `#show` (resumen y
    cronología), todo desde `policy_scope(FeedbackEntry)`;
  - `FeedbackSummary` (`app/models/`), sin consultas propias;
  - vistas `people/index` y `people/show` (la sección de P-21 se
    reemplazó por la cronología), ayudantes `ready_entries_count` y
    `timeline_status_label`, y CSS (tabla con desplazamiento propio);
  - pruebas nuevas: `feedback_summary_privacy_spec`,
    `feedback_summary_spec`, `people_counts_spec` y
    `models/feedback_summary_spec`; reescrita `person_entries_spec`;
    ajustada `navigation_spec`;
  - `docs/desarrollo.md`, sección 10.
- **Textos de la interfaz:** los mensajes de 4.4 y 4.5 terminan en punto
  en la pantalla, como los demás mensajes de la aplicación; la decisión
  los cita sin puntuación final.
- **Mutaciones**, con copia de seguridad y restauración comprobada por
  SHA-256:

  | # | Ejemplos que fallaron |
  |---|---|
  | M1 | 3: resumen de L2 sin la entrada de L1, resumen de L2 con solo la suya (4.12) y la administradora |
  | M2 | 5: privacidad de L2 (dos) y de la administradora, aislamiento 4.11 de la cronología y su estado vacío |
  | M3 | 3: conteo de L2, de la administradora y la prueba de conteo con otro líder |
  | M4 | 3: el resumen del autor, «no cuenta un borrador» (3.3) y «solo borradores» (4.4) |

  Después de restaurar, la suite completa: 315 ejemplos, 0 fallos.
- **Gate local:**
  - `bin/bundler-audit update`: código 0 (1362 avisos);
  - `bin/ci`: código 0, con 315 ejemplos y 0 fallos (291 antes de GL-07);
    RuboCop con 105 archivos sin infracciones, sin vulnerabilidades y
    Brakeman sin advertencias;
  - `openspec validate --all --strict`: 18 de 18.
  - Antes de `bin/ci` se guardaron copias verificadas de
    `log/development.log` y `log/test.log`, porque su paso «Setup» los
    vacía.
- **Sin comprobación en navegador:** el plan no la exige para GL-07; la
  prueba en navegador es de GL-09.

**CI remoto del 14/11/2026:** [PR #5](https://github.com/pablo-wpify/growth-log-ai4devs/pull/5) desde `feature/GL-07-resumen-cronologia`
contra `feature/entrega-2-pp`, con los commits `187cb6b` (implementación
y documentación) y `8f36845` (registro de prompts). GitHub Actions,
[ejecución 43631292881](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43631292881): **exitosa** sobre `8f36845057864205d4447403b5850c802071675f`, el
head del PR, con `scan_ruby`, `scan_js`, `lint` y `test` en verde. Vale
solo para ese SHA.

**Integración y archivo (14/11/2026):** el [PR #5](https://github.com/pablo-wpify/growth-log-ai4devs/pull/5) se integró en
`feature/entrega-2-pp` con un merge commit, `b835bdebc064bf1184a91fd7a7404705628dc12d`, y el cambio se archivó
como `2026-11-14-gl-07-resumen-cronologia`. La spec `feedback-summary`
pasó a las vigentes y se actualizaron `authorization`, `feedback-capture`
y `people-browsing`; los propósitos de `feedback-summary` y
`feedback-capture` se escribieron a mano (ver «Migration Plan»). El merge
tuvo su propio CI al llegar a `feature/entrega-2-pp`: [ejecución 43632097169](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43632097169), **exitosa**
sobre `b835bdebc064bf1184a91fd7a7404705628dc12d`, con los mismos cuatro jobs en verde.

**Pendiente:** la verificación E2E en navegador (GL-09).

## Risks / Trade-offs

- **Fuga por una lectura agregada sin alcance** → las lecturas reciben la
  relación con alcance; pruebas de privacidad y mutaciones 1 a 3.
- **Un borrador cuenta** → filtro `ready` en el resumen y el conteo;
  mutación 4.
- **Consultas por fila en «Personas»** → una sola consulta agrupada.
- **La cronología cambia el orden de la sección actual** → delta
  explícito de `feedback-capture` y prueba del orden con desempate.
- **4.2, 4.3, 4.12, 4.13 y 1.15 quedan parciales** → las compartidas
  siguen siendo requisito (I4).

## Migration Plan

Sin migraciones ni datos. Al archivar, el propósito de la spec vigente
`feedback-capture` menciona la sección de entradas propias: se actualiza a
mano, porque un delta no cambia el propósito.

## Open Questions

Ninguna. El texto del conteo con 1 se decidió el 14/11/2026 (M193): «1
entrada lista».
