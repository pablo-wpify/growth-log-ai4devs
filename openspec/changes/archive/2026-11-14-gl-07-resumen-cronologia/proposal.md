# Proposal

## Why

El recorrido núcleo termina cuando el líder ve su entrada lista en el
resumen y en la cronología de la persona. Hoy la ficha solo tiene la
sección provisoria de entradas propias de GL-06 (P-21), sin resumen por
dimensión ni orden cronológico, y el listado «Personas» no cuenta
entradas. Las lecturas agregadas (resumen, cronología y conteo) son el
lugar donde una entrada de otro líder de la misma persona podría filtrarse
sin que ninguna verificación de Pundit lo detecte. Fuente:
`docs/tickets/GL-07-resumen-cronologia.md`, criterios 3.3, 4.1, 4.4, 4.5 y
4.11; 4.2, 4.3, 4.12, 4.13 y 1.15 parciales (solo entradas propias), y el
plan de la entrega 2.

## What Changes

- **Resumen por dimensión** en la ficha, solo con entradas propias listas:
  una fila por dimensión con datos, con Positivos, A mejorar, Neutrales y
  Total (P-2, aprobada el 12/11/2026), y el texto «Solo entradas listas. No
  es un puntaje: reúne evidencia para la conversación» (4.5). Sin entradas
  propias listas, el mensaje «Todavía no hay entradas listas para el
  resumen» (4.4).
- **Cronología** en la ficha con todas las entradas propias, por fecha del
  hecho de la más antigua a la más reciente y, en empate, por `created_at`
  e `id` ascendentes (P-10, aprobada el 14/11/2026). Los borradores
  aparecen marcados «Borrador · solo vos · fuera del resumen». Cada
  entrada muestra fecha, estado, señal y dimensión (como el mock 1),
  comienzo del contexto y enlace al detalle. Reemplaza
  la sección provisoria «Tus entradas» de P-21, cuyo requisito se elimina
  de `feedback-capture`.
- **Conteo en «Personas»:** cada fila muestra, después de «rol · equipo»,
  «1 entrada lista» o «N entradas listas» (también «0 entradas listas»),
  contando solo las entradas propias listas (1.15 parcial).
- **Lecturas con alcance:** el resumen, la cronología y el conteo leen
  solo del alcance de entradas de la cuenta (`policy_scope(FeedbackEntry)`),
  nunca del modelo. Pruebas de privacidad con dos líderes de la misma
  persona y cuatro mutaciones registradas (M1 a M4 del diseño).
- **4.3 parcial:** todo lo que se muestra es propio y lleva su estado
  «… · solo vos»; sin columna «Origen».
- Decisiones de Pablo del 14/11/2026: P-10 y el alcance de 4.3, 4.4, 4.5 y
  1.15 (`docs/decisiones/2026-11-14-gl-07-resumen-cronologia.md`).
- **No incluye:** entradas compartidas y el origen «compartida con vos»
  (I4), los filtros 4.6 y 4.7 (I6), un selector de orden, el feed,
  compartir, la prueba E2E en navegador y su herramienta (GL-09, P-4,
  ADR-6), migraciones ni rutas nuevas.

## Capabilities

### New Capabilities
- `feedback-summary`: resumen por dimensión y cronología de las entradas
  propias en la ficha, con sus textos y estados vacíos.

### Modified Capabilities
- `feedback-capture`: se elimina la sección provisoria «Entradas propias
  en la ficha» (P-21), reemplazada por la cronología; los estados suman la
  marca «fuera del resumen» para los borradores en la cronología.
- `people-browsing`: el listado muestra el conteo de entradas listas
  propias; la ficha ofrece el resumen y la cronología, que dejan de ser
  funciones inexistentes.
- `authorization`: el resumen, la cronología y el conteo leen solo del
  alcance de entradas de la cuenta.

## Impact

- Código: `PeopleController#index` (conteo agrupado) y `#show` (resumen y
  cronología), vistas del listado y de la ficha, ayudantes de vista y CSS.
  Las consultas reciben el alcance ya resuelto. Sin migraciones, rutas ni
  dependencias nuevas.
- Pruebas nuevas de resumen, cronología, conteo y privacidad; ajustes en
  `person_entries_spec` (la sección provisoria pasa a ser la cronología) y
  en `navigation_spec` (la ficha ya puede decir «resumen»), enumerados en
  el diseño.
- P-10 aprobada y alcance decidido (14/11/2026). Cambio aprobado por Pablo
  el 14/11/2026 (M194).
