# Tasks

Las verificaciones que pasaron en el ensayo o en Clima API no cuentan aquí:
cada una se vuelve a ejecutar en este repositorio y se registra en el
registro de evidencia de `design.md`. Requisito: E1 cerrado. Ante un
fallo: detenerse, registrarlo y no corregir fuera del alcance.

## 1. Evidencias, Ruby y PostgreSQL local

- [x] 1.1 Crear el directorio de evidencias con `mktemp -d` fuera del repositorio; guardar `sha256sum` de `README.md`, `prompts.md`, `anexos/`, `ensayo/`, `openspec/changes/archive/*e1-base-rails/`, `.claude/` y `~/.tool-versions`, y el listado de contenedores y volúmenes; verificar que los archivos no están vacíos (G11, G13, G16)
- [x] 1.2 Crear `.tool-versions` con `ruby 4.0.9` y verificar sin `ASDF_RUBY_VERSION` que `ruby -v` informa 4.0.9 y `bin/rails -v` informa 8.1.4; que `RBENV_VERSION` y `rvm_ruby_string` están vacías (G3, G13)
- [x] 1.3 Verificar que Bundler rechaza otro Ruby: `ASDF_RUBY_VERSION=3.4.7 bundle exec ruby -e 'puts RUBY_VERSION'` termina con código distinto de 0 y `Bundler::RubyVersionMismatch`, y sin la variable imprime `4.0.9` con código 0 (G12)
- [x] 1.4 Verificar la coherencia: `.tool-versions` y `.ruby-version` declaran 4.0.9, igual que `RUBY VERSION` del lockfile; el `Gemfile` no escribe el número; ninguna preparación de Ruby del workflow declara otra versión (G13)
- [x] 1.5 Registrar las versiones resueltas de Rails, Bundler y cada `rspec-*` y comprobar con `Bundler::LockfileParser` que no hay prereleases (G3)
- [x] 1.6 Agregar `!/.env.example` a `.gitignore` y crear `.env.example` sin secretos; crear `.env` con una contraseña generada localmente, sin imprimirla; verificar con `git check-ignore .env` que `.env` está ignorado y que `.env.example` no lo está (G8)
- [x] 1.7 Crear el contenedor `growthlog-pg` con el volumen `growthlog-pgdata`, `postgres:18.6` y el puerto `127.0.0.1:55440`, pasando la contraseña por variable de entorno; verificar con `docker port growthlog-pg` que solo escucha en `127.0.0.1` y que los demás contenedores y volúmenes siguen como en 1.1 (G16)

## 2. Identidad de la aplicación

- [x] 2.1 Renombrar el módulo a `GrowthLog` en `config/application.rb` y verificar con `bin/rails runner 'puts Rails.application.class.module_parent_name'` que imprime `GrowthLog` (G2)
- [x] 2.2 Cambiar el título y `application-name` del layout y el nombre y la descripción del manifiesto a «Growth Log»; verificar por revisión (G2)

## 3. Bases de datos

- [x] 3.1 Renombrar las bases en `config/database.yml` y `channel_prefix` en `config/cable.yml`; verificar que `database.yml` no contiene contraseñas (G8)
- [x] 3.2 Ejecutar dos veces `bin/rails db:prepare` y `RAILS_ENV=test bin/rails db:prepare` y verificar en el contenedor que existen `growth_log_development` y `growth_log_test` (G4)
- [x] 3.3 Cambiar la expectativa de `spec/db/postgresql_connection_spec.rb` a `growth_log_test`; verificar que pasa y que falla apuntando a un puerto sin servidor (G5)
- [x] 3.4 Verificar que con una contraseña incorrecta la conexión falla con un error de autenticación (escenario «Contraseña ausente»)

## 4. CI, contexto de OpenSpec y documentación

- [x] 4.1 Agregar `feature/entrega-2-pp` a `push.branches` del workflow y verificar con `ruby -ryaml` los jobs, los disparadores y la correspondencia con `config/ci.rb` (G15)
- [x] 4.2 Reescribir el `context` de `openspec/config.yaml` según la decisión 3 y verificar que `openspec validate --all --strict` pasa (G9)
- [x] 4.3 Registrar en `docs/decisiones/` las decisiones de GL-01 con fecha y origen; verificar que enlaza al ticket
- [x] 4.4 Escribir `docs/desarrollo.md` y verificar ejecutando cada comando tal como está escrito en el árbol de trabajo (G10)

## 5. Verificación local integrada

- [x] 5.1 Verificar con `bundle exec rspec spec/db/seeds_spec.rb` que la creación de datos sigue limitada a desarrollo
- [x] 5.2 Verificar la suite única (`test ! -e test`, railtie comentado) y el fallo deliberado con respaldo, `trap` de restauración, `sha256sum -c`, `cmp` y una nueva corrida en verde (G14)
- [x] 5.3 (Primero falló por 15 avisos; corregido por GL-01a, ver G6 en design.md.) Ejecutar `bin/bundler-audit update` y registrar la fecha de la base; ejecutar `bin/ci` y verificar que termina sin errores; introducir una infracción de estilo temporal, verificar que falla e indica el paso, y revertirla (G6)
- [x] 5.4 Verificar que `git grep -n -i -e ensayo -e EnsayoOpenspec -- . ':!README.md' ':!prompts.md' ':!anexos/' ':!ensayo/' ':!docs/' ':!openspec/'` termina con código 1 (G1)
- [x] 5.5 Verificar que no cambiaron versiones (`git diff 32759ef -- Gemfile Gemfile.lock .ruby-version`), la documentación de la entrega 1, la procedencia, `.claude/` ni `~/.tool-versions` (`sha256sum -c`), y que los servicios existentes siguen igual (G3, G11, G13, G16)
- [x] 5.6 Verificar que `config/master.key` y `.env` no están en `git ls-files`, que `git grep` no encuentra la contraseña local y que la única contraseña versionada es la de prueba del workflow (G8)

## 6. CI en el repositorio del producto

- [x] 6.1 Con autorización explícita para push, hacer push de `feature/entrega-2-pp` a `growth-log-publico` y verificar que `scan_ruby`, `scan_js`, `lint` y `test` terminan en `success`; registrar el enlace y el commit (G7). Hasta entonces, GL-01 no se declara completo

## Workflow follow-up

- Después del commit de GL-01: recorrer `docs/desarrollo.md` desde un clon limpio con entorno, contenedor y bases de prueba separados, y registrar G10 (clon limpio).
- Archivar `gl-01-base-producto` solo después de G7, de G10 desde un clon limpio y de la revisión humana; después, verificar que `git grep -n -i ensayo -- openspec/specs/` termina con código 1 (G1, specs base).
