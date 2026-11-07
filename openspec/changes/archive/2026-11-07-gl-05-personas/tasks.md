# Tasks

P-15, P-16 y P-17 se aprobaron el 03/11/2026. Cada grupo
escribe primero sus pruebas y verifica que fallan por la razón esperada;
después implementa hasta que pasan. Las pruebas preparan sus propios datos
ficticios y no usan la base de desarrollo ni la tarea de GL-08.

## 1. Rutas, controlador y autorización

- [x] 1.1 Escribir `spec/requests/people_spec.rb` y ajustar `route_protection_spec.rb` y `authorization_coverage_spec.rb` con las rutas nuevas; verificar que fallan
- [x] 1.2 Agregar las rutas, `PeopleController` con `policy_scope` y `authorize`, y `PersonPolicy#index?`; verificar que las pruebas pasan

## 2. Página de inicio y navegación

- [x] 2.1 Escribir `spec/requests/navigation_spec.rb` y ajustar `exceptions_spec.rb` y el controlador de prueba de `authorization_mechanism_spec.rb`; verificar que fallan
- [x] 2.2 Cambiar la página de inicio al listado, eliminar `HomeController`, `HomePolicy` y su vista, y agregar la cabecera al layout; verificar que las pruebas pasan y que las de GL-02 siguen pasando

## 3. Vistas y estilos

- [x] 3.1 Escribir las vistas del listado, el estado vacío y la ficha, y los estilos en `application.css`; verificar las pruebas de contenido

## 4. Mutaciones

- [x] 4.1 Ejecutar y registrar las cuatro mutaciones del diseño con copia de seguridad y restauración comprobada

## 5. Documentación y verificación

- [x] 5.1 Actualizar `docs/desarrollo.md` con la navegación y la comprobación manual
- [x] 5.2 Registrar P-15 a P-17 en `docs/decisiones/`
- [x] 5.3 Ejecutar `bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`, y registrar en el diseño lo comprobado y lo pendiente, sin declarar ejecutada la comprobación en navegador

## Workflow follow-up

- Comprobación manual en navegador por Pablo (E10), registrada como manual: hecha el 07/11/2026 por Pablo y con asistencia de Claude Code; resultados en el diseño.
- Con autorización, push y verificación del CI remoto: PR #3, CI 42398717466 sobre `8d0e854`.
- Archivar `gl-05-personas` después del CI remoto, de la comprobación manual y de la revisión humana: autorizado por Pablo el 07/11/2026.
