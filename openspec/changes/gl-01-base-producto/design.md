# Design

## Context

Ver `proposal.md` (Why). Estado de partida observado en `feature/entrega-2-pp`
(`32759ef`):

- La base viene del ensayo E1 sin cambios: módulo `EnsayoOpenspecGrowthLog`;
  título, `application-name` y manifiesto con el nombre del ensayo.
- `config/database.yml`: desarrollo `growth_log_ensayo_development`, test
  `growth_log_ensayo_test`, ambas por variables `DATABASE_*`; producción
  `ensayo_openspec_growth_log_production`, usuario
  `ensayo_openspec_growth_log`, contraseña en
  `ENSAYO_OPENSPEC_GROWTH_LOG_DATABASE_PASSWORD`. `config/cable.yml`:
  `channel_prefix: ensayo_openspec_growth_log_production`.
- `spec/db/postgresql_connection_spec.rb` espera `growth_log_ensayo_test`.
- `openspec/config.yaml` describe una copia descartable.
- El workflow se dispara en `pull_request` y en `push` a `main`. En el
  remoto solo existe `feature/entrega-1-pp`, la rama entregada.
- `.gitignore` ignora `/.env*`.
- En esta máquina: asdf 0.14, sin `~/.asdfrc`, Ruby global 3.4.7 en
  `~/.tool-versions`; asdf no lee `.ruby-version`. Contenedores de otros
  proyectos usan los puertos 5433, 5434, 54410 y 54411; el del ensayo,
  `growthlog-ensayo-pg`, está detenido. Imagen `postgres:18.6` disponible.
- No hay `test/` y `rails/test_unit/railtie` está comentado.
- Clima API (`~/code/clima-api`, `0972b5a`) comparte versiones, binstubs,
  `.rubocop.yml` y `dependabot.yml`; usa `.tool-versions` con Ruby y Node.

## Goals / Non-Goals

**Goals:**
- Un diff de adaptación acotado y revisable, sin cambios de comportamiento
  ni de versiones.
- Verificaciones repetidas en el producto, con evidencia propia.
- La procedencia de E1 y la documentación de la entrega 1 intactas.

**Non-Goals:**
- Cambiar versiones, dependencias o la configuración de producción más allá
  de los nombres (ADR-7 sigue abierta).
- Autenticación, políticas o funcionalidades de H1, H2 o H4.
- Corregir los artefactos heredados de E1.

## Decisions

1. **Adaptar a mano, sin regenerar la aplicación.** Se editan los archivos
   del contexto. *Alternativa descartada:* volver a correr `rails new`, que
   reescribiría archivos ya ajustados por E1.
2. **Nombres de las bases.** `growth_log_development`, `growth_log_test` y
   `growth_log_production`; en producción, usuario `growth_log` y
   contraseña en `GROWTH_LOG_DATABASE_PASSWORD`, la convención que genera
   Rails. `DATABASE_URL` sigue teniendo precedencia en producción.
3. **Contexto de OpenSpec del producto.** El repositorio es Growth Log; la
   documentación de la entrega 1 (`README.md`, `prompts.md`, `anexos/`) es
   de solo lectura salvo pedido explícito; la fuente de cada cambio es su
   ticket en `docs/tickets/`; `ensayo/` y el cambio archivado de E1 son
   procedencia; se listan las decisiones aprobadas y abiertas; se mantienen
   las restricciones de secretos, de criterios remotos pendientes y de
   distinguir lo decidido, lo propuesto y lo verificado.
4. **Documentación en `docs/` (D-GL01-3).** `docs/desarrollo.md` (guía
   local) y `docs/decisiones/` (aprobaciones de GL-01). El README de la
   entrega 1 no cambia.
5. **PostgreSQL propio (D-GL01-1).** Contenedor `growthlog-pg`, volumen
   `growthlog-pgdata` montado en `/var/lib/postgresql` (ruta de datos de la
   imagen desde PostgreSQL 18), imagen `postgres:18.6`, publicado solo en
   `127.0.0.1:55440`, libre al momento de elegirlo. Usuario `growth_log`.
   La contraseña se genera localmente y solo vive en `.env`; se pasa al
   contenedor por variable de entorno, no en la línea de comandos.
6. **Archivo local de variables.** `.env` en la raíz, ignorado por
   `/.env*`, con `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USERNAME` y
   `DATABASE_PASSWORD`. Se carga con `set -a; . ./.env; set +a`, sin sumar
   dependencias. Plantilla versionada `.env.example`, con la excepción
   `!/.env.example` en `.gitignore`. *Alternativa:* un archivo fuera del
   repositorio, como en el ensayo; se prefiere el local ignorado porque la
   guía y el clon limpio quedan autocontenidos.
7. **Ruby en local (D-GL01-4).** `.tool-versions` con `ruby 4.0.9`; asdf lo
   prioriza sobre la configuración global sin tocarla. `.ruby-version`
   sigue siendo la fuente del `Gemfile` (`ruby file:`) y del CI
   (`ruby/setup-ruby` sin `ruby-version`). Coherencia comprobada en G13.
   No se agrega Node.
8. **CI en push a la rama de entrega (D-GL01-2).** Ajuste mínimo:
   `push.branches: [ main, feature/entrega-2-pp ]`. No se crea `main` ni se
   abre un pull request. *Alternativas descartadas:* `workflow_dispatch`
   (el workflow tiene que estar en la rama por defecto para dispararlo a
   mano) y un patrón `feature/**` (más amplio de lo pedido). La ejecución
   queda pendiente hasta un push autorizado (G7).
9. **Prácticas de verificación de Clima API.** Se adoptan las que no
   dependen de la ausencia de base de datos (ver el ticket). No se copian
   archivos de configuración de Clima.
10. **Fallo deliberado con restauración garantizada.** El spec se copia al
    directorio de evidencias con su `sha256sum`; la alteración y la corrida
    se ejecutan con un `trap` que restaura la copia al salir, también si la
    comprobación falla; después se verifica con `sha256sum -c` y `cmp`.
11. **Clon limpio con entorno separado.** El clon se crea con `mktemp -d` y
    usa un contenedor temporal `growthlog-pg-clon` con `--rm` y datos en
    `tmpfs`, en `127.0.0.1:55441`, con su propio `.env` y contraseña. No
    crea volúmenes ni toca las bases del producto; al detenerlo desaparece.

**Comprobaciones durante la implementación:** G1 a G16 del ticket, cada una
registrada abajo con su resultado; ninguna se marca por haber pasado en el
ensayo o en Clima API.

## Registro de evidencia

Se completa durante la implementación. El directorio de evidencias, creado
con `mktemp -d` fuera del repositorio, no se versiona.

Directorio de evidencias: `~/growth-log-evidencias/gl-01.Vw4rmY14`
(fuera del repositorio, no versionado). Base `cf44c0c` más los cambios de
GL-01 en el árbol de trabajo.

| Criterio | Estado | Resultado | Fecha |
|---|---|---|---|
| G1 | Comprobado (local) | `git grep` con las exclusiones del ticket: código 1. Las specs base heredadas de E1 todavía mencionan el ensayo; se corrigen al archivar GL-01 | 2026-11-02 |
| G2 | Comprobado (local) | `module_parent_name` → `GrowthLog`; layout y manifiesto «Growth Log» por revisión | 2026-11-02 |
| G3 | Comprobado (local) | Ruby 4.0.9, Rails 8.1.4, Bundler 4.0.20, `pg` 1.7.0, `rspec-rails` 8.0.4, `rspec-core` 3.13.6, `rspec-expectations` 3.13.5, `rspec-mocks` 3.13.8, `rspec-support` 3.13.7; sin prereleases; `Gemfile`, lockfile y `.ruby-version` sin cambios desde `32759ef` | 2026-11-02 |
| G4 | Comprobado (local) | `db:prepare` dos veces en desarrollo y en test, código 0; existen `growth_log_development` y `growth_log_test` en `growthlog-pg` | 2026-11-02 |
| G5 | Comprobado (local) | spec de conexión: 1 ejemplo, 0 fallos; con un puerto sin servidor (55449), código 1; con contraseña incorrecta, `password authentication failed` | 2026-11-02 |
| G6 | **Falla (local)** | base de avisos actualizada (`a58f1d0`, 2026-11-02, 1329 avisos). `bin/ci`: estilo, importmap, Brakeman (0 advertencias), base de test y RSpec pasan; **`bundler-audit` falla con 15 avisos**: `rack` 3.2.7 (1 alto, 2 medios, 1 bajo), `loofah` 2.25.2 (4 medios, 2 sin clasificar), `nokogiri` 1.19.4 (1 bajo, 2 sin clasificar) y `rails-html-sanitizer` 1.7.1 (2 medios). Con una infracción de estilo temporal, `bin/ci` falla en «Style: Ruby» (código 1) y el archivo se restaura idéntico | 2026-11-02 |
| G7 | Pendiente (remota) | sin push autorizado. Con los avisos de G6, `scan_ruby` también fallaría | — |
| G8 | Comprobado (local) | `config/master.key` y `.env` no versionados; la contraseña local no aparece (`git grep -F`, código 1); las únicas contraseñas versionadas son las de prueba del CI | 2026-11-02 |
| G9 | Comprobado (local) | `openspec validate --all --strict`: todo válido | 2026-11-02 |
| G10 | Comprobado (local) en el árbol de trabajo; Pendiente (clon limpio) | pasos 1 y 3 a 7 de la guía ejecutados tal como están escritos, salvo el servidor, levantado con `-d` para automatizar; los pasos 2 y 3 (crear `.env` y el contenedor) se hicieron con las tareas 1.6 y 1.7. `bin/ci` falla por G6 | 2026-11-02 |
| G11 | Comprobado (local) | `sha256sum -c` de 36 archivos protegidos sin cambios; `git diff 3723f7f -- README.md prompts.md anexos` vacío | 2026-11-02 |
| G12 | Comprobado (local) | con `ASDF_RUBY_VERSION=3.4.7`, `bundle exec ruby -e …` termina con código 1 y `Bundler::RubyVersionMismatch: Your Ruby version is 3.4.7, but your Gemfile specified 4.0.9`; sin la variable imprime `4.0.9`, código 0 | 2026-11-02 |
| G13 | Comprobado (local) | `.tool-versions`, `.ruby-version` y lockfile en 4.0.9; `Gemfile` sin literal; los cuatro `setup-ruby` sin `ruby-version` (leen `.ruby-version`); sin `.tool-versions`, el proyecto usaba Ruby 3.4.7, y con él asdf selecciona 4.0.9; `~/.tool-versions` sin cambios y sin `~/.asdfrc`; `RBENV_VERSION` y `rvm_ruby_string` vacías | 2026-11-02 |
| G14 | Comprobado (local) | no existe `test/`; railtie comentado; con la expectativa de `/up` en 201, 1 fallo y código 1; restaurado por `trap`, `sha256sum -c` y `cmp` idénticos; nueva corrida 4 ejemplos, 0 fallos | 2026-11-02 |
| G15 | Comprobado (inspección) | jobs `lint`, `scan_js`, `scan_ruby`, `test`; disparadores `pull_request` y push a `main` y `feature/entrega-2-pp`; cada paso de `config/ci.rb` tiene equivalente (Setup lo cubre `setup-ruby` con caché) | 2026-11-02 |
| G16 | Comprobado (local) | `growthlog-pg` publica solo `127.0.0.1:55440`; los únicos cambios en contenedores y volúmenes son `growthlog-pg` y `growthlog-pgdata` | 2026-11-02 |

**Antecedentes, que no cuentan como evidencia de GL-01:** E1 en el ensayo
(A1 a A8; A6 en la ejecución 40779743471 de
`pablo-wpify/ensayo-openspec-growth-log`) y las verificaciones V1 a V25 de
Clima API registradas en su cambio archivado `add-rails-api-base`.

## Risks / Trade-offs

- [Renombrado incompleto] → G1, con exclusiones explícitas.
- [Cambio de nombre del módulo] → cambia derivados como la clave de la
  cookie de sesión; sin sesiones ni datos todavía, no afecta a nadie.
- [`.env` con la contraseña real en el árbol de trabajo] → ignorado por
  Git, comprobado con `git check-ignore` y `git grep` (G8); nunca se
  imprime en la salida de los comandos.
- [Dos declaraciones de Ruby] → G13 compara `.tool-versions`,
  `.ruby-version`, lockfile y CI.
- [`bin/bundler-audit` con base de avisos vieja] → `update` antes de
  auditar; necesita red.
- [`bin/brakeman --ensure-latest`] → una versión nueva hace fallar el
  análisis hasta actualizar la gema; se documenta y se resuelve fuera de
  GL-01.
- [Gemas un parche por detrás de Clima] → si la auditoría marca un aviso,
  se informa y GL-01 no se declara completo.
- [Rama de entrega fija en el workflow] → la próxima entrega agrega su rama
  con el mismo ajuste mínimo.

## Migration Plan

Solo entornos locales: crear el contenedor del producto y preparar las
bases nuevas. Las bases y el volumen del ensayo no se tocan. Para revertir
GL-01 basta con revertir su commit; el contenedor y el volumen del producto
se pueden conservar.
