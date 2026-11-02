# Tasks

D-GL02-1 a D-GL02-7 aprobadas (02/11/2026). Cada grupo escribe primero sus
pruebas y verifica que fallan por la razón esperada; después implementa
hasta que pasan. Datos ficticios y contraseñas generadas en las pruebas;
nunca contraseñas literales reutilizables ni datos reales.

## 1. Dependencia y generador

- [ ] 1.1 Descomentar `bcrypt` en el `Gemfile` con `~> 3.1.22`, ejecutar `bundle install` y verificar con `git diff Gemfile.lock` que solo se agrega `bcrypt` y con `bin/bundler-audit` que no hay avisos
- [ ] 1.2 Ejecutar `bin/rails generate authentication`, guardar su salida y el diff en el directorio de evidencias y verificar que solo crea los archivos esperados del diseño
- [ ] 1.3 Eliminar la recuperación de contraseña, la conexión de Action Cable y los archivos de prueba generados que no correspondan, y `resources :passwords`; verificar con `bin/rails routes` que no queda ninguna ruta de contraseñas

## 2. Cuentas

- [ ] 2.1 Escribir `spec/models/user_spec.rb` (normalización y unicidad del correo, nombre, límites de contraseña con caracteres multibyte, hash bcrypt, `active?`) y verificar que falla
- [ ] 2.2 Ajustar la migración de `users` (`name`, `admin`, `deactivated_at`, índice único) y el modelo `User`; verificar que la prueba pasa y que la migración se revierte en la base de test

## 3. Sesiones, vencimiento y cuenta activa

- [ ] 3.1 Escribir `spec/models/session_spec.rb` y `spec/requests/session_expiry_spec.rb` y verificar que fallan
- [ ] 3.2 Agregar `last_active_at` a `sessions`, la comprobación en el servidor de los dos vencimientos y de la cuenta activa, la actualización con un único `UPDATE` como mucho cada 5 minutos y la cookie con sus atributos; verificar que las dos pruebas pasan

## 4. Inicio y cierre de sesión

- [ ] 4.1 Escribir `spec/requests/sessions_spec.rb` y `spec/requests/csrf_spec.rb` y verificar que fallan
- [ ] 4.2 Adaptar `SessionsController` y las vistas en español: `reset_session` al iniciar, 422 con mensaje genérico también para cuentas desactivadas, retorno solo para `GET`, cierre con `DELETE` y 303; verificar que las pruebas pasan
- [ ] 4.3 Crear la página de inicio provisoria (`root`) con el nombre y el botón «Cerrar sesión»; verificar con `spec/requests/sessions_spec.rb`

## 5. Limitación de intentos

- [ ] 5.1 Escribir `spec/requests/rate_limit_spec.rb` y verificar que falla
- [ ] 5.2 Configurar `config.x.rate_limit_store` (`FileStore` en `tmp/rate_limits/<entorno>`), el límite por IP con clave SHA-256, el contador de fallos por correo normalizado con clave SHA-256 y su reinicio tras un éxito, y vaciar el almacén antes de cada ejemplo; verificar que la prueba pasa

## 6. Rutas protegidas

- [ ] 6.1 Escribir `spec/requests/route_protection_spec.rb` (rechazo antes de la acción con doble que falla si se ejecuta, sin efectos en la base, sin rutas de registro ni de contraseñas) y verificar que falla por las rutas de Turbo y `/cable`
- [ ] 6.2 Configurar `config.turbo.draw_routes = false` y `config.action_cable.mount_path = nil`; verificar que la prueba pasa y que `bin/rails routes` muestra solo las rutas esperadas
- [ ] 6.3 Escribir `spec/requests/parameter_filtering_spec.rb` y verificar que pasa

## 7. Administrador inicial

- [ ] 7.1 Escribir `spec/tasks/crear_administrador_spec.rb` (creación, contraseñas distintas, contraseña corta, repetición, concurrencia en conexiones distintas, salida sin la contraseña) y verificar que falla
- [ ] 7.2 Implementar el servicio y la tarea `growth_log:crear_administrador` (contraseña sin eco o por entrada estándar, nunca por argumentos ni variables; bloqueo consultivo en una transacción; negativa si hay un administrador activo); verificar que la prueba pasa
- [ ] 7.3 Ejecutar la tarea en desarrollo dentro de una pseudoterminal con una cuenta ficticia y una contraseña generada, comprobar que la contraseña no aparece en la salida e iniciar sesión con esa cuenta en el servidor local

## 8. Documentación y verificación integral

- [ ] 8.1 Documentar en `docs/desarrollo.md` la creación del administrador inicial, el inicio de sesión y el almacén de los límites, y registrar en `docs/decisiones/` ADR-2 y D-GL02-2 a D-GL02-7; verificar los comandos tal como están escritos
- [ ] 8.2 Verificar que `git grep` no encuentra contraseñas ni cuentas predefinidas y que `db/seeds/development.rb` no crea cuentas (A13)
- [ ] 8.3 Ejecutar `bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`, y verificar que pasan (A14, local)

## Workflow follow-up

- Con autorización, push de `feature/entrega-2-pp` y verificación del CI remoto (A14, remota).
- Archivar `gl-02-autenticacion` después del CI remoto y de la revisión humana.
