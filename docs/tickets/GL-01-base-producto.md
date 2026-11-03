# GL-01. Base del producto: adaptar la base Rails del ensayo

> Primer ticket de la entrega 2 de Growth Log. Cambio de OpenSpec,
> archivado:
> [`2026-11-02-gl-01-base-producto`](../../openspec/changes/archive/2026-11-02-gl-01-base-producto/proposal.md).
> Secuencia: [plan de la entrega 2](../plan-entrega-2.md).
>
> **Estado (02/11/2026): cerrado y archivado.**
> La auditoría de gemas (G6) falló con 15 avisos y quedó corregida por
> [GL-01a](GL-01a-avisos-seguridad.md). G7: el CI de GitHub pasó en la
> [ejecución 41528484840](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41528484840)
> sobre `2631edb`. Resultados en el registro de evidencia de `design.md`.

## Problema

La rama `feature/entrega-2-pp` parte de la entrega 1 publicada (`3723f7f`) e
incorpora por avance rápido los tres commits del ensayo `e1-base-rails`
(`9ba209a`, `796148f`, `32759ef`). Esa base es la tarea habilitadora E1 del
[Anexo G](../../anexos/anexo-g-plan-incremental.md#g3-tareas-habilitadoras),
pero se generó como «copia aislada y descartable»: sus nombres, bases de
datos y contexto de OpenSpec dicen «ensayo», y sus verificaciones se
ejecutaron en otro repositorio y otro entorno.

## Resultado esperado

La misma base, sin cambiar versiones ni comportamiento, identificada como
Growth Log, con un PostgreSQL y bases de datos propios del producto,
contexto de OpenSpec del producto, una guía de desarrollo local sin
secretos y todas sus verificaciones ejecutadas de nuevo **en este
repositorio**.

## Decisiones de Pablo para GL-01 (02/11/2026)

- **Versiones:** se aceptan para el producto las versiones heredadas que
  enumera este ticket, sin actualizarlas en este cambio.
- **D-GL01-1. PostgreSQL propio:** contenedor, volumen y bases propios,
  separados del ensayo, en un puerto local libre enlazado solo a
  `127.0.0.1`, sin detener ni modificar servicios existentes.
- **D-GL01-2. CI:** no se crea `main` ni se abre un pull request solo para
  ejecutar el CI. Ajuste mínimo: el workflow también se dispara en push a
  `feature/entrega-2-pp`.
- **D-GL01-3. Documentación:** GL-01 se documenta en `docs/`; el README de
  la entrega 1 no cambia durante este cambio.
- **D-GL01-4. Ruby en local:** se versiona `.tool-versions` con Ruby 4.0.9;
  `.ruby-version` se conserva como referencia del `Gemfile` y del CI, y se
  verifica que ambas coincidan. Sin cambiar la configuración global de asdf.
- **Variables de base de datos:** en un archivo local ignorado, con una
  plantilla sin secretos e instrucciones.

## Procedencia y qué se hereda

| Artefacto | Origen | Qué se hace en GL-01 |
|---|---|---|
| Código de la base (Rails, RSpec, `bin/ci`, workflow) | ensayo, commit `796148f` | se adapta |
| `ensayo/ticket-e1.md` | ensayo, commit `9ba209a` | **se conserva sin cambios**, como procedencia |
| Cambio `e1-base-rails` | ensayo | se cierra aparte y se archiva sin reescribir su contenido (ver «Cierre de E1») |
| Verificaciones A1 a A8 de E1 | ejecutadas en el ensayo; A6 en `pablo-wpify/ensayo-openspec-growth-log`, ejecución 40779743471 | **no cuentan como verificaciones del producto**; GL-01 las repite aquí |

Inconsistencias heredadas, que no se corrigen para no alterar la
procedencia: `ensayo/ticket-e1.md` todavía dice que A6 está pendiente, y el
texto de la tarea 7.1 de E1 dice «queda sin marcar» aunque está marcada
con su evidencia.

## Versiones aceptadas (no cambian en GL-01)

| Componente | Versión | Fuente |
|---|---|---|
| Ruby | 4.0.9 | `.ruby-version` y `.tool-versions` |
| Bundler | 4.0.20 | `Gemfile.lock` (`BUNDLED WITH`) |
| Rails | 8.1.4 | `Gemfile.lock` |
| PostgreSQL | 18.6 | imagen `postgres:18.6` en local y en el CI |
| `pg` | 1.7.0 | `Gemfile.lock` |
| Puma | 8.0.2 | `Gemfile.lock` |
| `rspec-rails` | 8.0.4 (con `rspec-core` 3.13.6) | `Gemfile.lock` |
| `rubocop-rails-omakase` / `rubocop` | 1.1.0 / 1.92.1 | `Gemfile.lock` |
| `brakeman` | 8.1.0 | `Gemfile.lock` |
| `bundler-audit` | 0.9.3 | `Gemfile.lock` |
| `importmap-rails` / `turbo-rails` / `stimulus-rails` / `propshaft` | 2.2.3 / 2.0.23 / 1.3.4 / 1.3.2 | `Gemfile.lock` |
| Acciones de CI | `actions/checkout@v6`, `ruby/setup-ruby@v1`, `actions/cache@v4` | `.github/workflows/ci.yml` |
| OpenSpec CLI | 1.15.0 | instalación local |

### Dónde se declara la versión de Ruby

| Lugar | Antes de GL-01 | Después de GL-01 | Clima API (referencia) |
|---|---|---|---|
| `.ruby-version` | `4.0.9` | `4.0.9` (referencia del `Gemfile` y del CI) | `4.0.9` |
| `.tool-versions` | no existe | `ruby 4.0.9` (lo lee asdf) | `ruby 4.0.9`, `nodejs 24.8.0` |
| `Gemfile` | `ruby file: ".ruby-version"` | igual | igual |
| `Gemfile.lock` | `RUBY VERSION ruby 4.0.9` | igual | igual |
| CI | `ruby/setup-ruby@v1` sin `ruby-version`: lee `.ruby-version` | igual | igual |

En esta máquina asdf 0.14 no lee `.ruby-version` y el Ruby global es 3.4.7:
sin `.tool-versions`, el directorio del proyecto usaba Ruby 3.4.7. No se
versiona Node: Growth Log usa importmap.

**Gemas compartidas con versión distinta de Clima API** (no se actualizan
en GL-01): `rack` 3.2.7 (Clima 3.2.8), `rubocop` 1.92.1 (1.92.2),
`msgpack` 1.8.6 (1.8.7). Si la auditoría de G6 señala un aviso, se informa
y la actualización se decide en un cambio aparte.

## Experiencia de Clima API que se reutiliza

Clima API (`~/code/clima-api`, `main` en `0972b5a`) es una API Rails 8.1.4
sin base de datos, con tres cambios de OpenSpec archivados y CI verificado
en GitHub. Se reutilizan **prácticas de verificación**, no configuraciones
completas:

| Práctica de Clima | En GL-01 | Por qué, o por qué no |
|---|---|---|
| Comprobar que Bundler rechaza otro Ruby ejecutando código con `bundle exec`, no con `ruby -v` (V8) | G12 | `ruby -v` no carga Bundler; E1 no verificó este escenario |
| `.tool-versions` y `.ruby-version` coherentes (V6) y `Gemfile` sin literal (V7) | G13 | mismo esquema de dos archivos |
| Versiones resueltas registradas y sin prereleases (D4) | G3 | evita aceptar versiones sin revisarlas |
| Suite única (V13) que detecta un fallo, restaurando por copia y `sha256sum` (V12) | G14 | Growth Log ya usa `-T`; falta comprobarlo aquí |
| Inspección YAML de jobs y disparadores del workflow | G15 | Growth Log tiene `scan_js` y PostgreSQL |
| Instantánea `sha256sum` de archivos protegidos en un directorio de evidencias externo (D3) | G11 | protege la entrega 1 y la procedencia de E1 |
| Guía recorrida desde un clon limpio (V9) | G10 | la guía debe funcionar tal como está escrita |
| `bin/bundler-audit update` antes de auditar; `bin/brakeman` con `--ensure-latest` | G6 y guía | mismos binstubs |
| Estados de evidencia: local, inspección, clon limpio, remota | registro de evidencia | separa lo ejecutado de lo pendiente |
| `nodejs` en `.tool-versions` y `nvm deactivate` | no | Growth Log no usa Node |
| WebMock y `disable_net_connect!` | no, por ahora | no hay HTTP saliente; se reevalúa con el correo (ADR-8) |
| `use_active_record = false` y arranque sin base (V1, V2) | no; se invierte | Growth Log usa PostgreSQL: conexión real (G5) |

Todo lo de esta tabla se comprobó antes **en Clima API**; en Growth Log se
ejecuta como parte de GL-01.

## Alcance

1. **Identidad:** módulo `GrowthLog`; título, `application-name` y
   manifiesto PWA «Growth Log».
2. **Bases de datos:** `growth_log_development` y `growth_log_test` por
   variables `DATABASE_*`; producción `growth_log_production`, usuario
   `growth_log`, contraseña en `GROWTH_LOG_DATABASE_PASSWORD`;
   `channel_prefix` `growth_log_production`. La spec de conexión espera
   `growth_log_test`.
3. **PostgreSQL local propio:** contenedor `growthlog-pg`, volumen
   `growthlog-pgdata`, `postgres:18.6`, publicado en `127.0.0.1:55440`.
4. **Configuración local:** `.env` ignorado con las variables `DATABASE_*`;
   plantilla versionada `.env.example` sin secretos (excepción explícita en
   `.gitignore`).
5. **Ruby:** `.tool-versions` con `ruby 4.0.9`, coherente con
   `.ruby-version`.
6. **CI:** disparo también en push a `feature/entrega-2-pp`.
7. **Contexto de OpenSpec** del producto.
8. **Documentación:** `docs/desarrollo.md` y `docs/decisiones/`.

## Exclusiones

Cambios de versiones o de dependencias; autenticación (E2), políticas (E3),
controles previos a exponer el sistema (E4); funcionalidades de H1, H2 o
H4; modelos del dominio y pantallas; despliegue (ADR-7); herramienta E2E
(ADR-6); el README de la entrega 1; la rama entregada, el repositorio del
ensayo y Clima API.

## Criterios de aceptación

| # | Criterio | Cómo se comprueba | Dónde |
|---|---|---|---|
| G1 | Ningún archivo de código, configuración ni pruebas contiene «ensayo» ni `EnsayoOpenspec`. Quedan fuera la documentación de la entrega 1, que usa «Ensayo» como apellido ficticio en los mocks, y la procedencia y planificación (`ensayo/`, `docs/`, `openspec/`). Las specs base heredadas de E1 se corrigen al archivar GL-01 | `git grep -n -i -e ensayo -e EnsayoOpenspec` excluyendo `README.md`, `prompts.md`, `anexos/`, `ensayo/`, `docs/` y `openspec/`: código 1; después de archivar GL-01, la misma búsqueda sobre `openspec/specs/`: código 1 | local |
| G2 | La aplicación se llama `GrowthLog` y se presenta como «Growth Log» | `bin/rails runner 'puts Rails.application.class.module_parent_name'`; revisión del layout y del manifiesto | local |
| G3 | Versiones aceptadas, sin cambios de gemas ni prereleases | `ruby -v`, `bin/rails -v`; `git diff 32759ef -- Gemfile Gemfile.lock .ruby-version` vacío; versiones de `rspec-*` y prereleases con `Bundler::LockfileParser` | local |
| G4 | `bin/rails db:prepare` y `RAILS_ENV=test bin/rails db:prepare` crean o actualizan `growth_log_development` y `growth_log_test` en el PostgreSQL 18.6 del producto, y se pueden repetir | dos ejecuciones de cada uno; listado de bases del contenedor | local |
| G5 | La spec de conexión comprueba PostgreSQL 18 y `growth_log_test`, y falla sin servidor | `bundle exec rspec spec/db/postgresql_connection_spec.rb` con el servidor arriba y apuntando a un puerto sin servidor | local |
| G6 | `bin/ci` termina sin errores y falla ante una infracción de estilo temporal; la base de avisos se actualiza antes y no hay vulnerabilidades bloqueantes | `bin/bundler-audit update`, `bin/ci` | local |
| G7 | El workflow corre en verde en `pablo-wpify/growth-log-ai4devs` en un push a `feature/entrega-2-pp` | enlace a la ejecución y jobs en `success` | **solo GitHub Actions** |
| G8 | Sin secretos versionados: `config/master.key` y `.env` no versionados; la contraseña local no aparece; la única contraseña versionada es la de prueba del CI | `git ls-files`, `git check-ignore`, `git grep` | local |
| G9 | `openspec/config.yaml` describe el producto y `openspec validate --all --strict` pasa | revisión y comando | local |
| G10 | `docs/desarrollo.md` funciona tal como está escrita | en el árbol de trabajo; después del commit, desde un clon limpio con entorno, contenedor y bases de prueba separados | local |
| G11 | La documentación de la entrega 1, la procedencia de E1 y `.claude/` no cambian | `sha256sum` antes y `sha256sum -c` después, en un directorio de evidencias externo; `git diff 3723f7f -- README.md prompts.md anexos` vacío | local |
| G12 | Bundler rechaza un Ruby distinto del declarado al ejecutar código | `ASDF_RUBY_VERSION=3.4.7 bundle exec ruby -e 'puts RUBY_VERSION'` con código distinto de 0 y `Bundler::RubyVersionMismatch`; control con 4.0.9 | local |
| G13 | Ruby coherente: `.tool-versions` y `.ruby-version` declaran 4.0.9 e igual que el lockfile; el `Gemfile` no escribe el número; el CI obtiene la versión de `.ruby-version` o, si declara `ruby-version`, coincide con ella; asdf selecciona 4.0.9 en el proyecto sin variables; la configuración global de asdf no cambia | comparación de archivos; inspección de cada `setup-ruby` del workflow; `ruby -v` sin `ASDF_RUBY_VERSION`; `sha256sum` de `~/.tool-versions` antes y después; `RBENV_VERSION` y `rvm_ruby_string` vacías | local |
| G14 | Una sola suite, que detecta fallos | `test ! -e test`; `rails/test_unit/railtie` comentado; expectativa alterada con respaldo y restauración garantizada aunque la comprobación falle | local |
| G15 | El workflow declara `lint`, `scan_js`, `scan_ruby` y `test`; se dispara en `pull_request` y en push a `main` y a `feature/entrega-2-pp`; cada paso de `config/ci.rb` tiene equivalente | inspección con `ruby -ryaml` | inspección |
| G16 | El PostgreSQL del producto escucha solo en `127.0.0.1` y los servicios existentes siguen igual | `docker port growthlog-pg`; listado de contenedores y volúmenes antes y después | local |

G7 queda pendiente hasta un push autorizado. Mientras siga pendiente,
GL-01 no se declara completo ni se archiva su cambio.

## Cierre de E1 (previo a GL-01)

1. Revisar que las tareas y la evidencia de E1 sostengan su cierre.
2. `openspec archive e1-base-rails`, que crea las especificaciones base en
   `openspec/specs/`.
3. Un commit propio, solo con el cierre de E1.

No se marcan tareas nuevas en E1 ni se reescribe su evidencia.

## Relación con la entrega

Tarea habilitadora E1 del Anexo G; secciones 2.2 a 2.4 del README; Anexo B,
capas 5, 6 y 9. Primer ticket de la secuencia de la entrega 2, que vive
en el [plan de la entrega 2](../plan-entrega-2.md).
