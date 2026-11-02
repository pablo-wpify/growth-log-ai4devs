# Design

## Context

Ver `proposal.md` (Why). Estado de partida observado:

- El repositorio contiene solo la documentación de Growth Log (`README.md`,
  `prompts.md`, `anexos/`) y el ticket `ensayo/ticket-e1.md`; no hay código.
- Ruby 4.0.9 y Rails 8.1.4 están instalados con asdf solo para el ensayo; la
  versión global de Ruby sigue en 3.4.7 (`~/.tool-versions`).
- asdf 0.14 en esta máquina **no lee `.ruby-version`** (no existe
  `~/.asdfrc`): sin otra medida, el directorio del proyecto usaría Ruby
  3.4.7.
- PostgreSQL 18.6 corre en el contenedor `growthlog-ensayo-pg`, en
  `127.0.0.1:55432`, con autenticación por contraseña. Las credenciales
  locales están en `~/code/.ensayo-openspec-growth-log.env`, fuera del
  repositorio.
- La aplicación generada usa importmap (opción por defecto de Rails 8.1.4),
  así que el generador incluye la auditoría de importmap en `config/ci.rb` y
  el job `scan_js` en el workflow.
- Con `-T`, el generador **no crea** el job de tests del workflow ni los
  pasos de tests de `config/ci.rb`: hay que agregarlos para RSpec.

## Goals / Non-Goals

**Goals:**
- Una base generada por Rails con la menor cantidad posible de cambios
  manuales, para que el diff sea revisable.
- El mismo pipeline en `bin/ci` y en el workflow.

**Non-Goals:**
- Configuración de producción o de despliegue (ADR-7 sigue abierta).
- Ejecutar el workflow en GitHub Actions durante este cambio.

## Decisions

1. **Generar en la raíz con `rails new . --skip`.** Conserva el README y los
   anexos existentes. *Alternativa:* un subdirectorio; se descarta porque el
   repositorio está pensado para documentación y código juntos. Opciones:
   `--database=postgresql -T --skip-kamal --skip-thruster --skip-docker
   --skip-solid --skip-action-mailbox --skip-action-text
   --skip-active-storage --skip-jbuilder`.
2. **Versión de Ruby con una sola fuente.** `.ruby-version` se crea antes de
   generar la aplicación y es el único archivo con el número de versión. El
   `Gemfile` usa `ruby file: ".ruby-version"` y `ruby/setup-ruby` lee el
   mismo archivo, sin `ruby-version` explícito en el workflow.
   `Gemfile.lock` y otros metadatos generados pueden registrar la versión;
   no se editan para quitarla. En local, el archivo de entorno del ensayo exporta
   `ASDF_RUBY_VERSION` leyendo `.ruby-version`, sin escribir el número.
   *Alternativas descartadas:* un `.tool-versions` en el repositorio
   (segunda declaración) o `legacy_version_file` en `~/.asdfrc` (cambio
   global, no autorizado).
3. **Variables de conexión comunes.** `config/database.yml` lee
   `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USERNAME` y
   `DATABASE_PASSWORD` en desarrollo y en test (en local se preparan las
   dos bases; en el CI, solo la de test), con las bases
   `growth_log_ensayo_development` y `growth_log_ensayo_test`. En local, el
   archivo de entorno del ensayo define esas variables a partir de las
   credenciales que ya tiene. Producción queda con la configuración por
   `DATABASE_URL` que trae Rails, sin ajustar. *Alternativa:* `dotenv`; se
   descarta para no sumar una dependencia.
4. **PostgreSQL del CI.** Servicio `postgres:18.6` con `POSTGRES_USER` y
   `POSTGRES_PASSWORD` exclusivamente de prueba, escritos en el workflow y
   nombrados como tales (por ejemplo, `growthlog_ci` y
   `ci-only-test-password`). El job de tests exporta las mismas variables
   `DATABASE_*` hacia ese servicio. *Alternativas descartadas:*
   `POSTGRES_HOST_AUTH_METHOD: trust`, porque no ejercita la autenticación
   por contraseña que usa `database.yml`; y un secreto de GitHub, porque no
   protege nada en un servicio efímero y hace más difícil reproducir el CI.
5. **RSpec.** `rspec-rails` en los grupos de desarrollo y test, con
   `rails generate rspec:install`. Specs:
   - de petición: `GET /up` responde 200. Su comprobación negativa altera
     temporalmente la ruta en `config/routes.rb` y restaura el archivo; la
     expectativa del spec no se toca;
   - de base: `ActiveRecord::Base.connection` ejecuta
     `SHOW server_version_num` contra la base de test y comprueba el
     adaptador PostgreSQL y la versión mayor 18, sin modelos;
   - de seeds (ver la decisión 6).
6. **Seeds con un punto de entrada comprobable.** La creación de datos vive
   en `db/seeds/development.rb`, que define `DevelopmentSeeds.run` (hoy
   vacío, sin modelos). `db/seeds.rb` lo requiere y llama a
   `DevelopmentSeeds.run` solo si el entorno es desarrollo. El spec carga
   `db/seeds.rb`:
   - en test, con la expectativa de que `DevelopmentSeeds.run` **no** se
     invoque;
   - con el entorno simulado como desarrollo, con la expectativa de que se
     invoque una vez, para demostrar que la condición es lo que lo impide.

   Así se comprueba directamente que fuera de desarrollo la ejecución no
   alcanza la parte que crea datos (A7). *Alternativa descartada:* comparar
   filas de las tablas internas de Rails, que no demuestra nada mientras no
   haya modelos.
7. **`bin/ci` (`config/ci.rb`).** Pasos, en orden: preparación
   (`bin/setup --skip-server`), RuboCop, `bundler-audit`, auditoría de
   importmap, `brakeman`, `RAILS_ENV=test bin/rails db:prepare` y
   `bundle exec rspec`. Se quita el paso `db:seed:replant` que genera Rails:
   el spec de seeds de la decisión 6 carga `db/seeds.rb` en test y cubre A7
   de forma directa.
8. **Workflow.** Se conservan los jobs generados `scan_ruby`
   (`brakeman` y `bundler-audit`), `scan_js` (auditoría de importmap) y
   `lint` (RuboCop), y se agrega un job `test` con el servicio de la
   decisión 4, `db:prepare` en test y `bundle exec rspec`.

**Correspondencia del pipeline:**

| Verificación | `bin/ci` | Workflow | Criterio |
|---|---|---|---|
| Estilo (RuboCop) | paso de estilo | job `lint` | A5, A6 |
| Gemas vulnerables (`bundler-audit`) | paso de seguridad | job `scan_ruby` | A5, A6 |
| Paquetes de importmap (`bin/importmap audit`) | paso de seguridad | job `scan_js` | A5, A6 |
| Análisis estático (`brakeman`) | paso de seguridad | job `scan_ruby` | A5, A6 |
| Base de test preparada | paso de tests | job `test` | A2, A5, A6 |
| RSpec: `/up`, consulta real y seeds | paso de tests | job `test` | A3, A4, A7, A5, A6 |

## Risks / Trade-offs

- [Ruby 4.0.9 publicado el 23/10/2026] → `ruby/setup-ruby` podría no
  reconocerlo todavía y alguna gema nativa podría fallar. Mitigación: la
  verificación local lo detecta; en el CI solo se sabrá al ejecutarlo (A6).
- [Contraseña de prueba versionada en el workflow] → aceptable porque el
  servicio es efímero, solo accesible dentro del job y la contraseña no se
  reutiliza en ningún otro lugar; A8 lo explicita.
- [Spec de seeds con un doble de prueba] → comprueba la condición y el
  punto de entrada, no el contenido de los datos, que hoy no existen.
- [Red] → `bundler-audit`, la auditoría de importmap y la instalación de
  gemas necesitan acceso a internet.

## Migration Plan

No aplica: es la primera versión del código. Para descartar el ensayo:
borrar el directorio de la copia, el contenedor `growthlog-ensayo-pg`, el
volumen `growthlog-ensayo-pgdata` y el archivo de entorno.

## Open Questions

- Cuándo y en qué repositorio se ejecutará el workflow para cerrar A6. No
  cambia las especificaciones ni las tareas: A6 queda pendiente hasta
  entonces.
