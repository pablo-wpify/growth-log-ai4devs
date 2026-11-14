# Tasks

Trabajo en dos fases:

- **Fase documental (grupo 0):** decisiones, ajustes de documentos,
  validación de OpenSpec y aprobación del cambio. No escribe pruebas, código
  ni migraciones.
- **Implementación (grupos 1 a 7):** **no empieza** hasta que Pablo apruebe
  explícitamente este cambio de OpenSpec (tarea 0.4). Antes de esa
  aprobación no se escriben pruebas de implementación, código ni
  migraciones. Cada grupo escribe primero sus pruebas y verifica que fallan
  por la razón esperada; después implementa hasta que pasan. Las pruebas
  preparan sus propios datos ficticios y no usan la base de desarrollo ni la
  tarea de GL-08.

P-1, P-2, P-3 y P-11 se aprobaron el 12/11/2026; P-19 a P-26 se
decidieron el 13/11/2026.

## 0. Fase documental (sin pruebas, código ni migraciones)

- [x] 0.1 Registrar las decisiones de Pablo P-19 a P-26 en el plan (sección 6, única fuente) y en `docs/decisiones/`. Evidencia: ocho filas «Decidida (13/11/2026)» en la sección 6 del plan y `docs/decisiones/2026-11-13-gl-06-captura.md`. Los números P-25 y P-26 quedaron definitivos con la aprobación (0.4)
- [x] 0.2 Ajustar ticket, proposal, design, specs y tasks a esas decisiones, separando decisiones, cambios documentales y verificaciones técnicas pendientes. Evidencia: ajustes del 13/11/2026 (M107), la revisión de PT-11 «con datos mínimos» y MVP-FE-1 del mismo día (M114) y la aclaración de que los números P-25 y P-26 son provisionales (M116)
- [x] 0.3 Ejecutar `openspec validate --all --strict` y registrar el resultado. Evidencia: 13/11/2026, 18:59 UTC, después de la revisión de PT-11 y MVP-FE-1, y 19:09 UTC, sobre el estado final con los números provisionales de P-25 y P-26: 16 elementos válidos, 0 fallidos en las dos ejecuciones
- [x] 0.4 Revisión humana y aprobación explícita del cambio por Pablo. Evidencia: aprobación del 13/11/2026 con el mensaje «Vamos para adelante», según el pedido M120 (`docs/prompts/GL-06/`)

## 1. Tabla y modelo

- [x] 1.1 Escribir las pruebas de base y de modelo de `feedback_entries`: autor, persona, fecha y contexto obligatorios; estado, señal, dimensión y confianza restringidos; lista sin dimensión o sin señal rechazada por la base; borrador incompleto aceptado; etiquetas de P-1 y P-2; verificar que fallan
- [x] 1.2 Agregar la migración reversible con sus restricciones e índices, `FeedbackEntry` y las asociaciones de `Person` y `User`; comprobar la reversión en la base de test; verificar que las pruebas pasan

## 2. Política y alcance

- [x] 2.1 Escribir `spec/policies/feedback_entry_policy_spec.rb` con L1, L2, L3, A sin asignación, A asignada, asignación terminada y persona inactiva, para lectura, creación, edición y marcar como lista (P-20); verificar que fallan
- [x] 2.2 Implementar `FeedbackEntryPolicy` y su alcance según el diseño; verificar que las pruebas pasan

## 3. Rutas, controlador y autorización

- [x] 3.1 Escribir `spec/requests/feedback_entries_spec.rb` con los escenarios de `feedback-capture` (incluidos la página de captura de P-22, «Marcar como lista» sobre una entrada ya lista de P-25 y el detalle sin acceso a la ficha de P-24), la matriz de privacidad y su trazabilidad (3.10, 4.14 y la lectura de entradas propias de la rama de lectura de PT-11, sin dar por resuelta «con datos mínimos»), y una petición de captura sin sesión válida que no crea la entrada; ajustar `route_protection_spec.rb` y `authorization_coverage_spec.rb` con las rutas nuevas; verificar que fallan
- [x] 3.2 Agregar las rutas de P-19 y `FeedbackEntriesController` con carga por alcance y `authorize`; verificar que las pruebas pasan y que `exceptions_spec.rb` no cambia

## 4. Ficha y vistas

- [x] 4.1 Ajustar `navigation_spec.rb` al delta de `people-browsing` y escribir las pruebas de la sección «Tus entradas» (incluido el orden de P-21) y de los textos (sin «Publicar», estados «solo vos»); verificar que fallan
- [x] 4.2 Escribir `PeopleController#show` con la consulta con alcance del diseño (sección 5) y la ficha con «Captura rápida» y la sección de entradas propias (P-21), la página de captura (P-22), el detalle (P-24), la edición y los estilos; verificar las pruebas de contenido

## 5. Fecha y logs

- [x] 5.1 Escribir la prueba de la fecha de hoy en `America/Argentina/Buenos_Aires` y la prueba de logs (petición y consultas) sin `context`, `evidence` ni `impact`; verificar que fallan. Verificar si el filtro alcanza al log de consultas, sin relajar F12; si no alcanza, informar con una propuesta antes de seguir
- [x] 5.2 Configurar `config.time_zone` (P-23) y `filter_parameters`; comprobar las pruebas que usan `Time.zone.local` sin debilitar sus expectativas; verificar que pasan y que la suite completa sigue pasando

## 6. Mutaciones

- [x] 6.1 Ejecutar y registrar las seis mutaciones del diseño con copia de seguridad y restauración comprobada

## 7. Documentación y verificación

- [x] 7.1 Actualizar `docs/desarrollo.md` con el recorrido de captura y la comprobación manual
- [x] 7.2 Ejecutar `bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`, y registrar en el diseño lo comprobado y lo pendiente (incluidas las verificaciones de logs, sesión vencida y zona horaria), sin declarar ejecutada la comprobación en navegador
- [x] 7.3 Actualizar el plan (estado de GL-06; 3.10 y 4.14 parciales), el README, el ticket y el registro de prompts

## Workflow follow-up

- Comprobación manual en navegador por Pablo (F17), registrada como manual, incluida la sesión vencida al enviar la captura.
- Con autorización, commit, push y verificación del CI remoto.
- Archivar `gl-06-captura-rapida` después del CI remoto, de la comprobación manual y de la revisión humana, con autorización.
