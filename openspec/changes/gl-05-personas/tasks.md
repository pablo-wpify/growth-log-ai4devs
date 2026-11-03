# Tasks

P-15, P-16 y P-17 se aprobaron el 03/11/2026. Cada grupo
escribe primero sus pruebas y verifica que fallan por la razón esperada;
después implementa hasta que pasan. Las pruebas preparan sus propios datos
ficticios y no usan la base de desarrollo ni la tarea de GL-08.

## 1. Rutas, controlador y autorización

- [ ] 1.1 Escribir `spec/requests/people_spec.rb` y ajustar `route_protection_spec.rb` y `authorization_coverage_spec.rb` con las rutas nuevas; verificar que fallan
- [ ] 1.2 Agregar las rutas, `PeopleController` con `policy_scope` y `authorize`, y `PersonPolicy#index?`; verificar que las pruebas pasan

## 2. Página de inicio y navegación

- [ ] 2.1 Escribir `spec/requests/navigation_spec.rb` y ajustar `exceptions_spec.rb` y el controlador de prueba de `authorization_mechanism_spec.rb`; verificar que fallan
- [ ] 2.2 Cambiar la página de inicio al listado, eliminar `HomeController`, `HomePolicy` y su vista, y agregar la cabecera al layout; verificar que las pruebas pasan y que las de GL-02 siguen pasando

## 3. Vistas y estilos

- [ ] 3.1 Escribir las vistas del listado, el estado vacío y la ficha, y los estilos en `application.css`; verificar las pruebas de contenido

## 4. Mutaciones

- [ ] 4.1 Ejecutar y registrar las cuatro mutaciones del diseño con copia de seguridad y restauración comprobada

## 5. Documentación y verificación

- [ ] 5.1 Actualizar `docs/desarrollo.md` con la navegación y la comprobación manual
- [ ] 5.2 Registrar P-15 a P-17 en `docs/decisiones/`
- [ ] 5.3 Ejecutar `bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`, y registrar en el diseño lo comprobado y lo pendiente, sin declarar ejecutada la comprobación en navegador

## Workflow follow-up

- Comprobación manual en navegador por Pablo (E10), registrada como manual.
- Con autorización, push y verificación del CI remoto.
- Archivar `gl-05-personas` después del CI remoto, de la comprobación manual y de la revisión humana.
