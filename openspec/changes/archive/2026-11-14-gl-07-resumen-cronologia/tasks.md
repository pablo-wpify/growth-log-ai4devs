# Tasks

Trabajo en dos fases:

- **Fase documental (grupo 0):** decisiones, ticket, propuesta, specs y
  diseño, validación de OpenSpec y aprobación del cambio. No escribe
  pruebas ni código.
- **Implementación (grupos 1 a 6):** **no empieza** hasta que Pablo apruebe
  explícitamente este cambio de OpenSpec (tarea 0.4). Cada grupo escribe
  primero sus pruebas y verifica que fallan por la razón esperada; después
  implementa hasta que pasan. Las pruebas preparan sus propios datos
  ficticios y no usan la base de desarrollo.

P-2 se aprobó el 12/11/2026; P-10 y el alcance de 4.3, 4.4, 4.5 y 1.15 se
decidieron el 14/11/2026.

## 0. Fase documental (sin pruebas ni código)

- [x] 0.1 Registrar P-10 y el alcance de 4.3, 4.4, 4.5 y 1.15 en el plan (sección 6, única fuente) y en `docs/decisiones/`. Evidencia: 14/11/2026, M192; `docs/decisiones/2026-11-14-gl-07-resumen-cronologia.md`
- [x] 0.2 Preparar el ticket, la propuesta, el diseño, las specs y estas tareas, con los detalles confirmados. Evidencia: 14/11/2026, M192 y M193
- [x] 0.3 Ejecutar `openspec validate --all --strict` y registrar el resultado. Evidencia: 14/11/2026, 16:33 UTC, 18 de 18 válidos, con el cambio de GL-07 y los detalles de M193
- [x] 0.4 Revisión humana y aprobación explícita del cambio por Pablo. Evidencia: aprobación del 14/11/2026 (2026-11-14 16:38:03 UTC), pedido M194 (`docs/prompts/GL-07/`)

## 1. Lecturas con alcance

- [x] 1.1 Escribir las pruebas de privacidad de la matriz del diseño (L1, L2, A, P, Q) para el resumen, la cronología y el conteo, incluida la ausencia del texto de L1 en las respuestas a L2; verificar que fallan. Evidencia: `feedback_summary_privacy_spec`; 5 de 6 fallaban (ver el diseño)
- [x] 1.2 Implementar las tres lecturas a partir de `policy_scope(FeedbackEntry)`, con el resumen y el conteo en una consulta agrupada cada uno; verificar que pasan. Evidencia: 6 de 6 pasan

## 2. Resumen

- [x] 2.1 Escribir las pruebas del armado del resumen y de la ficha: filas por dimensión en el orden de P-1, columnas de P-2, Total como suma, dimensiones sin datos omitidas, borrador fuera, texto de 4.5 y mensaje de 4.4 (también con solo borradores); verificar que fallan. Evidencia: `feedback_summary_spec` y `models/feedback_summary_spec`; 9 de 11 fallaban
- [x] 2.2 Implementar el objeto de armado, la vista y los estilos; verificar que pasan. Evidencia: 17 de 17 pasan con los grupos 1 y 2

## 3. Cronología

- [x] 3.1 Ajustar `person_entries_spec.rb` y escribir las pruebas de la cronología: orden ascendente con desempate por `created_at` e `id`, estados «Lista · solo vos» y «Borrador · solo vos · fuera del resumen», señal y dimensión cuando las tiene, comienzo del contexto, enlaces al detalle y estado vacío; verificar que fallan. Evidencia: `person_entries_spec` reescrita; 6 de 10 fallaban
- [x] 3.2 Reemplazar la sección de P-21 por la cronología; verificar que pasan. Evidencia: 27 de 27 pasan con los grupos 1 a 3

## 4. Conteo en «Personas»

- [x] 4.1 Escribir las pruebas del conteo: después de «rol · equipo», «1 entrada lista», «N entradas listas» y «0 entradas listas», sin borradores ni entradas ajenas, y sin una consulta por fila; verificar que fallan. Evidencia: `people_counts_spec`. **Desvío:** pasaron en la primera ejecución porque la 1.2 ya implementó el conteo; cada una falla contra una implementación rota a propósito (ver el diseño)
- [x] 4.2 Implementar el conteo en el listado; verificar que pasan. Evidencia: implementado en la 1.2; 3 de 3 pasan

## 5. Navegación y mutaciones

- [x] 5.1 Ajustar `navigation_spec.rb` al delta de `people-browsing` (la ficha puede decir «resumen»; siguen prohibidos «+ Feedback», compartir, filtros y administración); verificar. Evidencia: fallaba por la prohibición de «resumen»; 7 de 7 pasan
- [x] 5.2 Ejecutar y registrar las mutaciones M1 a M4 del diseño (resumen, cronología y conteo sin el alcance, y resumen sin `ready`), cada una con la prueba que debe fallar, copia de seguridad y restauración comprobada. Evidencia: M1 a M4 detectadas y restauradas (ver el diseño); suite completa 315 de 315

## 6. Documentación y verificación

- [x] 6.1 Actualizar `docs/desarrollo.md` con el resumen, la cronología y el conteo. Evidencia: `docs/desarrollo.md`, sección 10
- [x] 6.2 Ejecutar `bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`, y registrar en el diseño lo comprobado y lo pendiente. Evidencia: 14/11/2026; `bin/bundler-audit update` y `bin/ci` con código 0 (315 ejemplos, 0 fallos); OpenSpec 18 de 18; registrado en el diseño
- [x] 6.3 Actualizar el plan (estado de GL-07), el README, el ticket y el registro de prompts. Evidencia: 14/11/2026; estado «implementado en local, sin commit» en el plan, el README, el ticket, la propuesta y el diseño; M194 registrado

## Workflow follow-up

- Con autorización, commit, push y verificación del CI remoto.
- Archivar `gl-07-resumen-cronologia` después del CI remoto y de la revisión humana, con autorización, actualizando a mano el propósito de la spec vigente `feedback-capture`.
