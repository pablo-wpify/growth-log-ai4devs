# Proposal

## Why

El recorrido núcleo necesita su tercer y cuarto paso: capturar una
observación como borrador privado y después completarla y marcarla como
lista. Hoy la ficha de GL-05 es de solo lectura y no existe ninguna entrada
de feedback; la regla de entradas que dejó definida GL-03 (lectura por
autoría, escritura con asignación activa) no está especificada ni probada,
y el aislamiento entre dos líderes de la misma persona sigue sin comprobar
desde GL-08. Fuente: `docs/tickets/GL-06-captura-rapida.md`, criterios 3.1,
3.2, 3.4 a 3.8, 2.3 a 2.6, 2.8 a 2.10, 4.8, 4.9 y 4.11 (parciales), y el
plan de la entrega 2.

## What Changes

- Tabla y modelo de entradas de feedback, con autor, persona, fecha del
  hecho, contexto, estado (`draft`, `ready`), señal, dimensión, evidencia,
  impacto y confianza, y restricciones en la base.
- Dimensiones fijas (P-1) y señales (P-2), aprobadas el 12/11/2026.
- Para marcar como lista hacen falta dimensión y señal (P-3, aprobada): se
  amplían 2.6 y 3.5.
- Captura rápida desde la ficha, en una página propia (P-22), que guarda
  un borrador privado pidiendo solo el texto, con la fecha de hoy en
  `America/Argentina/Buenos_Aires` (P-23).
- Detalle de una entrada propia, edición para completarla y acción
  «Marcar como lista», que la deja lista y privada; repetida sobre una
  entrada lista, no la cambia y vuelve al detalle (P-25).
- Sección con las entradas propias sobre la persona en la ficha, para
  reabrir un borrador (P-21).
- Política y alcance de entradas: lectura por autoría sin depender de la
  asignación ni del estado de la persona; escritura con autoría,
  asignación activa y persona activa (P-20). Ser administrador no da
  acceso. Sin acceso a la ficha, el detalle se lee por URL directa con
  todos los campos y solo el nombre de la persona (P-24): 3.10 y 4.14
  quedan parciales.
- Texto del feedback filtrado de los logs de la petición y de las
  consultas (el alcance del filtro sobre las consultas se verifica al
  implementar).
- Decisiones de Pablo del 13/11/2026: P-19 a P-26
  (`docs/decisiones/2026-11-13-gl-06-captura.md`).
- Rutas nuevas en las pruebas de protección y de cobertura.
- **No incluye:** el formulario completo «+ Feedback» (2.1, 2.2, 2.7;
  diferido por P-11), el resumen, la cronología y los conteos (GL-07),
  compartir, el feed, el listado del autor sin asignación, la transición
  de reasignación de PT-11 (P-26), entradas en los datos ficticios y la
  prueba automatizada en navegador (GL-09).

## Capabilities

### New Capabilities
- `feedback-entries`: datos de una entrada, estados, dimensiones, señales,
  campos opcionales, completitud para «lista» y texto fuera de los logs.
- `feedback-capture`: captura rápida, completar, marcar como lista, editar
  una entrada lista, detalle y entradas propias en la ficha.

### Modified Capabilities
- `authorization`: agrega las reglas de acceso a las entradas (lectura por
  autoría, escritura con asignación activa, aislamiento entre líderes), que
  GL-03 dejó definidas solo en su diseño.
- `people-browsing`: la ficha deja de ser solo de lectura; ofrece
  «Captura rápida» y las entradas propias. El listado no cambia.

## Impact

- Código: migración y `db/schema.rb`, modelo `FeedbackEntry` y
  asociaciones en `Person` y `User`, `FeedbackEntryPolicy`,
  `FeedbackEntriesController`, `PeopleController#show` (sección de P-21),
  rutas (P-19), vistas de la ficha y de entradas, CSS, `filter_parameters`
  y `config.time_zone` (P-23).
- Pruebas nuevas de modelo, base, política, peticiones, logs y privacidad;
  ajustes en `route_protection_spec`, `authorization_coverage_spec` y
  `navigation_spec`, enumerados en el diseño.
- Una migración reversible; sin dependencias nuevas.
- P-19 a P-26 decididas (13/11/2026). Cambio aprobado por Pablo el 13/11/2026 («Vamos para adelante», según M120).
