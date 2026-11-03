# Tasks

P-5, P-7, P-8 y P-9 aprobadas (02/11/2026). Cada grupo escribe primero sus
pruebas y verifica que fallan por la razón esperada; después implementa
hasta que pasan. Datos ficticios y contraseñas generadas en las pruebas.

## 1. Dependencia

- [x] 1.1 Agregar `gem "pundit", "~> 2.5.2"`, ejecutar `bundle install` y verificar con `git diff Gemfile.lock` que solo se agrega `pundit` y con `bin/bundler-audit` que no hay avisos

## 2. Personas y asignaciones

- [x] 2.1 Escribir `spec/models/person_spec.rb`, `spec/models/assignment_spec.rb` y `spec/models/assignment_concurrency_spec.rb` (nombre obligatorio, activa por defecto, fin no anterior al inicio, varios líderes por persona, varias personas por líder, segunda asignación activa del mismo par rechazada también en simultáneo, reasignación, estados independientes) y verificar que fallan
- [x] 2.2 Crear las migraciones de `people` y `assignments` con el índice único parcial y la restricción de fechas, y los modelos; verificar que las pruebas pasan y que las migraciones se revierten en la base de test

## 3. Mecanismo de autorización

- [x] 3.1 Escribir `spec/policies/application_policy_spec.rb`, `spec/requests/authorization_mechanism_spec.rb` (controlador solo de prueba con rutas temporales), `spec/requests/authorization_coverage_spec.rb` y `spec/authorization/exceptions_spec.rb`, y verificar que fallan
- [x] 3.2 Incluir Pundit en `ApplicationController` con `verify_authorized`, `verify_policy_scoped` y el 404; agregar `ApplicationPolicy`, `HomePolicy` y `SessionPolicy`, y las omisiones declaradas por acción (`SessionsController#new` y `#create`; alcance de `#destroy` y de la página de inicio); verificar que las pruebas pasan y que `route_protection_spec` sigue pasando

## 4. Acceso a personas

- [x] 4.1 Escribir `spec/policies/person_policy_spec.rb` con L1 y L2 asignados a una persona, L3 sin asignación, una administradora sin asignación, una administradora asignada a otra persona, una persona inactiva y una asignación terminada, y verificar que falla
- [x] 4.2 Implementar `PersonPolicy` y su alcance, con la regla en el alcance; verificar que la prueba pasa

## 5. Mutaciones

- [x] 5.1 Ejecutar y registrar las cinco mutaciones del diseño con copia de seguridad y restauración comprobada; cada una tiene que hacer fallar la prueba indicada

## 6. Documentación y verificación

- [x] 6.1 Registrar en `docs/decisiones/` ADR-3 y P-5, P-7, P-8 y P-9
- [x] 6.2 Registrar en el diseño qué se comprobó y qué queda para GL-05 y GL-06, sin dar por comprobada la autorización del feedback
- [x] 6.3 Ejecutar `bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`, y verificar que pasan (local)

## Workflow follow-up

- Con autorización, push de `feature/entrega-2-pp` y verificación del CI remoto.
- Archivar `gl-03-autorizacion-minima` después del CI remoto y de la revisión humana.
