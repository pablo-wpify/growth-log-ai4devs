# Tasks

Cada tarea indica el criterio del ticket (A1 a A8) que permite comprobar.
Antes de cada comando local, cargar el archivo de entorno del ensayo
(`source ~/code/.ensayo-openspec-growth-log.env`).

## 1. Entorno local y generación de la aplicación

- [x] 1.1 Crear `.ruby-version` con la versión de Ruby aceptada, como única declaración del número (A1)
- [x] 1.2 En el archivo de entorno del ensayo (fuera del repositorio), exportar `ASDF_RUBY_VERSION` leyendo `.ruby-version` y las variables `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USERNAME` y `DATABASE_PASSWORD` a partir de las credenciales locales; verificar que `ruby -v` en el proyecto coincide con `.ruby-version` y que `~/.tool-versions` no cambió (A1)
- [x] 1.3 Ejecutar `rails _8.1.4_ new . --skip` con las opciones del diseño y verificar que no se modificaron `README.md`, `prompts.md`, `anexos/` ni `.ruby-version` (`git diff` sin cambios en esos archivos)
- [x] 1.4 Agregar `ruby file: ".ruby-version"` al `Gemfile` y verificar que `bundle install` termina, que `bin/rails -v` informa 8.1.4, y que el `Gemfile`, el workflow y el archivo de entorno leen la versión de `.ruby-version` sin escribir el número; `Gemfile.lock` y otros metadatos generados pueden registrarla (A1)

## 2. Base de datos

- [x] 2.1 Configurar `config/database.yml` con las variables `DATABASE_*` y las bases `growth_log_ensayo_development` y `growth_log_ensayo_test`; verificar que no contiene contraseñas (A2, A8)
- [x] 2.2 En local, ejecutar `bin/rails db:prepare` y `RAILS_ENV=test bin/rails db:prepare`, repetirlos y verificar con `psql` dentro del contenedor que las dos bases existen y que la segunda ejecución no da errores (A2)
- [x] 2.3 Verificar que, sin `DATABASE_PASSWORD`, la preparación falla con un error de autenticación (escenario «Contraseña ausente»)

## 3. Tests con RSpec

- [x] 3.1 Agregar `rspec-rails`, ejecutar `rails generate rspec:install` y verificar que `bundle exec rspec` corre sin ejemplos y sin errores
- [x] 3.2 Escribir el spec de petición de `GET /up` (espera 200) y verificar que pasa; alterar temporalmente la ruta `/up` en `config/routes.rb`, verificar que el spec falla por esa alteración, restaurar el archivo y verificar que vuelve a pasar, sin modificar la expectativa del spec (A3)
- [x] 3.3 Escribir el spec de la consulta real a PostgreSQL en test (adaptador PostgreSQL, versión mayor 18) y verificar que pasa con el contenedor activo y falla con el contenedor detenido (A4)
- [x] 3.4 Mover la creación de datos a `DevelopmentSeeds.run` en `db/seeds/development.rb`, llamarla desde `db/seeds.rb` solo en desarrollo y escribir el spec que comprueba que en test no se invoca y que con el entorno de desarrollo se invoca una vez; verificar que el spec pasa y que falla si se quita la condición de entorno (A7)

## 4. Verificación local

- [x] 4.1 Ajustar `config/ci.rb` según el diseño (RuboCop, `bundler-audit`, auditoría de importmap, `brakeman`, preparación de la base de test y RSpec; sin `db:seed:replant`) y verificar que `bin/ci` termina sin errores (A5)
- [x] 4.2 Introducir de forma temporal una infracción de estilo, verificar que `bin/ci` falla e indica el paso, y revertirla (A5)
- [x] 4.3 Arrancar el servidor y verificar con `curl -i http://127.0.0.1:3000/up` que responde 200 (A3)

## 5. Workflow de GitHub Actions (definición)

- [x] 5.1 Agregar el job `test` a `.github/workflows/ci.yml` con el servicio `postgres:18.6`, `POSTGRES_USER` y `POSTGRES_PASSWORD` exclusivamente de prueba, las variables `DATABASE_*` hacia ese servicio, `db:prepare` solo de la base de test y `bundle exec rspec`; verificar por revisión que el disparo por pull request y los jobs `scan_ruby`, `scan_js`, `lint` y `test` corresponden a los pasos de `config/ci.rb`, según la tabla del diseño (A6, solo definición)
- [x] 5.2 Validar la sintaxis YAML del workflow con `ruby -ryaml -e 'YAML.load_file(".github/workflows/ci.yml")'` (A6, solo definición)

## 6. Secretos

- [x] 6.1 Verificar que `config/master.key` está en `.gitignore` y no figura en `git ls-files`, que `git grep` no encuentra la contraseña local del ensayo y que la única contraseña versionada es la de prueba del workflow (A8)

## 7. Ejecución en GitHub Actions (A6, pendiente)

- [x] 7.1 Ejecutar el workflow en GitHub Actions en un pull request y verificar que todos los jobs terminan en verde. **Requiere autorización explícita para publicar en un repositorio de GitHub; hasta entonces queda sin marcar y E1 no se declara completo**
  - Evidencia: ejecución https://github.com/pablo-wpify/ensayo-openspec-growth-log/actions/runs/40779743471 del workflow CI, disparada por el PR #1 sobre el commit `796148fb745d8ce33716caad1a336b10a574637c`. Los cuatro jobs terminaron en `success`: `scan_ruby`, `scan_js`, `lint` y `test`. En `test`, `ruby/setup-ruby` tomó Ruby 4.0.9 de `.ruby-version`, el servicio usó `postgres:18.6`, se creó `growth_log_ensayo_test` y RSpec dio 4 ejemplos, 0 fallos.

## Workflow follow-up

- No archivar el cambio mientras la tarea 7.1 siga pendiente.
- Archivar con `openspec archive e1-base-rails` solo después de que pase A6 y de la revisión humana del resultado.
