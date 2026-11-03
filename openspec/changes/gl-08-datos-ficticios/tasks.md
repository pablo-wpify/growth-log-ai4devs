# Tasks

P-6, P-13 y P-14 aprobadas (03/11/2026). Cada grupo escribe primero sus
pruebas y verifica que fallan por la razón esperada; después implementa
hasta que pasan. Solo la tarea 5.4 ejecuta `growth_log:datos_ficticios`
contra la base local de desarrollo. Ninguna tarea ejecuta
`growth_log:contrasena_ficticia` contra esa base: las contraseñas las
establece Pablo en su terminal.

## 1. Marcas

- [x] 1.1 Escribir `spec/models/sample_data_record_spec.rb` (clave duplicada, sin referencia, dos referencias, prefijo que no coincide, registro ya marcado, borrar un registro marcado) y verificar que falla
- [x] 1.2 Crear la migración de `sample_data_records` y el modelo; verificar que la prueba pasa y que la migración se revierte en la base de test

## 2. Conjunto ficticio

- [x] 2.1 Escribir `spec/services/development_sample_data_spec.rb` (creación exacta, sin administradoras, repetición sin escrituras, cambios manuales conservados sin reactivar, conflictos sin escrituras, reversión completa ante un error a mitad, entornos distintos de desarrollo, hash distinto por creación, alcance de GL-03) y verificar que falla
- [x] 2.2 Implementar `DevelopmentSampleData` con la comprobación de entorno, el bloqueo consultivo, la revisión previa de conflictos y la creación sin actualizaciones; verificar que la prueba pasa
- [x] 2.3 Escribir `spec/services/development_sample_data_concurrency_spec.rb` determinista y verificar que pasa con el bloqueo y falla sin él (mutación 4)

## 3. Tareas y contraseñas

- [x] 3.1 Escribir `spec/tasks/datos_ficticios_spec.rb`, `spec/tasks/contrasena_ficticia_spec.rb` (incluida la cuenta desactivada y las sesiones), `spec/tasks/sample_data_process_spec.rb` (procesos reales con `RAILS_ENV=test` y `production` sobre la base de test) y el ejemplo nuevo de `crear_administrador_spec.rb`, y verificar que fallan
- [x] 3.2 Extraer `SecretPrompt` de `InitialAdministratorCommand` sin cambiar su comportamiento; verificar que las pruebas de GL-02 pasan sin modificarse
- [x] 3.3 Implementar las tareas `growth_log:datos_ficticios` y `growth_log:contrasena_ficticia` y el comando de contraseña; verificar que las pruebas pasan

## 4. Mutaciones

- [x] 4.1 Ejecutar y registrar las cinco mutaciones del diseño con copia de seguridad y restauración comprobada

## 5. Documentación y verificación

- [x] 5.1 Documentar en `docs/desarrollo.md` la preparación de datos ficticios, la contraseña sin eco y los conflictos; cambiar el comentario de `db/seeds/development.rb` para remitir a la tarea
- [x] 5.2 Registrar P-6, P-13 y P-14 en `docs/decisiones/`
- [x] 5.3 Verificar con `git grep` que no hay contraseñas ni hashes versionados
- [x] 5.4 Ejecutar la tarea en la base local de desarrollo dos veces, comparando antes y después los registros que ya existían, sin mostrar credenciales ni establecer contraseñas
- [x] 5.5 Ejecutar `bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`, y registrar en el diseño lo comprobado y lo pendiente, sin dar por comprobado el aislamiento del feedback

## Workflow follow-up

- Con autorización, push y verificación del CI remoto.
- Con autorización de Pablo, ejecución manual de la tarea en desarrollo y establecimiento de contraseñas en su terminal.
- Archivar `gl-08-datos-ficticios` después del CI remoto y de la revisión humana.
