# GL-01b. Rails 8.1.4.1 por los avisos de seguridad del 04/11/2026

> Ticket separado de GL-05, como [GL-01a](GL-01a-avisos-seguridad.md).
> **Estado (07/11/2026): publicado en el PR abierto
> [#2](https://github.com/pablo-wpify/growth-log-ai4devs/pull/2), sin merge.** El commit de implementación
> `d4c61ebde4bd1b812d8115e01d498f9d26e76566` se publicó en
> `feature/GL-01b-rails-8-1-4-1`, creada desde `feature/entrega-2-pp`
> (`925e2ee`) en el worktree `~/code/ai4devs-entrega-1-pp-gl01b`. El PR
> apunta a `feature/entrega-2-pp`, y el CI remoto
> [42376879636](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/42376879636) pasó sobre ese SHA. Siguen
> pendientes el merge y la integración en `feature/GL-05-personas`. P-18
> sigue sin aprobar.

## Problema

El 04/11/2026 Rails publicó 8.0.5.2 y 8.1.4.1, que corrigen 21 avisos:
1 crítico, 4 altos, 13 medios y 3 bajos. Growth Log usa Rails 8.1.4.

El 06/11/2026, después de `bin/bundler-audit update`, `bin/bundler-audit`
informa esos 21 avisos y `bin/ci` falla sobre `d9365c6`
(rama `feature/GL-05-personas`): el log
`~/growth-log-evidencias/gl-05-bin-ci-2026-11-06.log` registra «Continuous
Integration failed», pero el código de salida exacto no quedó guardado. El resto de `bin/ci` pasa: RuboCop,
Brakeman y RSpec. El código no cambió desde que `bin/ci` pasaba el
03/11/2026. El CI remoto fallaría en el job `scan_ruby` por la misma razón;
no se ejecutó.

## Estado actual (inspeccionado el 06/11/2026, sin modificar nada)

| Elemento | Valor |
|---|---|
| `Gemfile` | `gem "rails", "~> 8.1.4"`, que admite 8.1.4.1 |
| `Gemfile.lock` | `rails` y los 12 componentes que fija con `=` en 8.1.4 (`actioncable`, `actionmailbox`, `actionmailer`, `actionpack`, `actiontext`, `actionview`, `activejob`, `activemodel`, `activerecord`, `activestorage`, `activesupport`, `railties`), con su sección `CHECKSUMS` |
| Cadena del sanitizador | `rails-html-sanitizer` 1.7.2, `loofah` 2.25.3 y `nokogiri` 1.19.5 |
| Bundler | `BUNDLED WITH 4.0.20` |
| Ruby | 4.0.9 |
| Componentes cargados (`config/application.rb`) | Active Model, Active Job, Active Record, Action Controller, Action Mailer, Action View y Action Cable. **No se cargan** Active Storage, Action Mailbox ni Action Text; sus gemas se instalan porque las trae `rails` |
| Action Cable | cargado, pero sin ruta: `config.action_cable.mount_path = nil`, sin `app/channels`. La lista exacta de rutas de GL-02 no incluye `/cable` |
| Sesión | almacén por defecto (`CookieStore`); sin `config.session_store`. La cookie propia `session_id` usa `same_site: :lax` |
| `config/bundler-audit.yml` | solo la línea de ejemplo `CVE-THAT-DOES-NOT-APPLY` |
| CI (`.github/workflows/ci.yml`) | se ejecuta con `pull_request` y con push a `main` o `feature/entrega-2-pp`. Jobs: `scan_ruby` (Brakeman y `bin/bundler-audit`), `scan_js`, `lint`, `test` |

## Dependencias que exige la versión objetivo

Comparadas en la API de RubyGems
(`/api/v2/rubygems/<gema>/versions/<versión>.json`), las dependencias de
ejecución de las 13 gemas en 8.1.4 y en 8.1.4.1:

- Entre las 13 gemas, solo cambian sus versiones exactas, de `= 8.1.4` a
  `= 8.1.4.1`.
- **Única dependencia externa nueva:** `actionview` 8.1.4.1 pide
  `rails-html-sanitizer (~> 1.6, >= 1.7.2)`; en 8.1.4 pedía `~> 1.6`. El
  advisory GHSA-2p2f-4rq4-gjwc lo explica: la corrección exige
  `rails-html-sanitizer` 1.7.2, que a su vez exige `loofah` 2.25.3 y
  `nokogiri` 1.19.5.
- **El lockfile ya cumple ese requisito:** tiene `rails-html-sanitizer`
  1.7.2, `loofah` 2.25.3 y `nokogiri` 1.19.5, actualizados en GL-01a.

Por lo tanto, **se espera** que solo cambien las 13 gemas de Rails. Igual
se admite lo que Bundler necesite estrictamente para resolver (ver B2).

## Alcance mínimo

1. Llevar `rails` y sus 12 componentes a 8.1.4.1 en `Gemfile.lock` con
   `bundle update rails --conservative`. `--conservative` evita subir
   dependencias compartidas que no hacen falta.
2. Admitir la actualización de `rails-html-sanitizer` a 1.7.2 o posterior y
   de cualquier dependencia transitiva **solo si Bundler la necesita
   estrictamente** para resolver los requisitos de 8.1.4.1. Cada cambio de
   ese tipo se documenta en este ticket con:
   - la versión anterior y la nueva;
   - el requisito que lo obliga, es decir, qué gema y qué restricción.
3. Las dependencias que no hacen falta para resolver quedan intactas.
4. Registrar el resultado en este ticket, en el diseño del cambio y en el
   plan.

**Fuera de alcance:**

- otras gemas sin una exigencia de resolución que lo justifique;
- Ruby, Bundler (`BUNDLED WITH`) y las plataformas del lockfile;
- `actions/*` y la configuración de CI;
- ignorados en `config/bundler-audit.yml`;
- cargar o configurar Active Storage, Action Mailbox o Action Text;
- cualquier cambio de GL-05.

## Aplicabilidad de los avisos

Clasificados con el **advisory de cada uno en `rails/rails`** (sección
«Impact», consultada el 06/11/2026), no con el resumen del anuncio. Se
contrastaron con el código y la configuración de la rama actual
(`config/`, `app/`, `lib/`).

### Conteo

Las tablas siguientes listan cada uno de los 21 GHSA una sola vez:
19 + 1 + 1 = 21. Al leer cada advisory, ocho avisos que la versión anterior
daba como «aplica» o «no confirmable» pasan a «no aplica»; los motivos están
en las tablas.

### No aplican a Growth Log (19)

| Aviso | Sev. | Condición del advisory | Por qué no se cumple en Growth Log |
|---|---|---|---|
| GHSA-f3w6-w445-fwh9 | crítica | procesar adjuntos de Active Storage con ImageMagick | Active Storage no se carga; no hay adjuntos ni `storage.yml` |
| GHSA-v924-7rp8-4mxh | alta | previews, análisis o procesamiento de imagen o video de Active Storage | ídem |
| GHSA-3f4q-8x5m-76v8 | baja | aceptar subidas de usuarios y generar previews o analizar video o audio con FFmpeg (`VideoPreviewer`, `VideoAnalyzer`, `AudioAnalyzer`) | ídem; tampoco hay subidas |
| GHSA-3w93-6hmw-whh4 | media | servicio GCS con `cache_control` y subidas directas | ídem; sin servicios de almacenamiento |
| GHSA-hfr4-8rjc-97m2 | media | GCS con subidas directas | ídem |
| GHSA-4v2w-w6g6-f8f8 | media | servicio que transmite en varias peticiones y rutas por defecto de Active Storage | ídem; no hay rutas de Active Storage |
| GHSA-p2pm-g2h6-7j5j | media | nombres de archivo con NUL; el advisory excluye PostgreSQL | Active Storage no se carga, y Growth Log usa PostgreSQL |
| GHSA-x6mj-8jx9-qhqv | media | controladores proxy de Active Storage con rotación de cookies o serializador `:hybrid`, detrás de una caché | Active Storage no se carga; sin `cookies_rotations` |
| GHSA-5957-c7qm-m469 | baja | recibir correo por el ingreso Mailgun de Action Mailbox | Action Mailbox no se carga |
| GHSA-2586-8ghr-69fj | media | `config.session_store :cache_store`; el advisory excluye `CookieStore` | se usa `CookieStore` |
| GHSA-gmj8-hvj3-49mw | baja | almacenes de sesión distintos de `CookieStore` | ídem. **La versión anterior lo daba como probable: era un error** |
| GHSA-rwvh-fw6r-pwvp | media | respuestas con `ActionController::Live` o `send_stream` | no se usan |
| GHSA-wm3x-v3qw-4jh3 | alta | pasar el resultado de `Parameters#each_key` a asignación masiva | no se usa `each_key` ni asignación masiva desde `params` (solo `params[:x].to_s`) |
| GHSA-r9jg-fmfx-2gv6 | media | respuestas negociadas marcadas `public` (`expires_in ..., public: true`) detrás de una caché compartida | no hay caché HTTP pública; los `expires_in` del código son de los contadores de intentos |
| GHSA-2w9f-fxwj-w2qf | media | serializador MessagePack configurado en cookies, `Rails.cache` o `MessageVerifier`/`MessageEncryptor` | no hay configuración de serializadores; `msgpack` está instalado solo como dependencia de `bootsnap` |
| GHSA-2p2f-4rq4-gjwc | media | texto no confiable en `highlight` o en `simple_format` con `html_options` | no se usan |
| GHSA-v6rj-xm57-3p59 | media | `highlight` con un `:highlighter` que pone el texto dentro de un atributo | no se usa |
| GHSA-rq8q-p985-fjq7 | media | salida de `strip_tags` con datos no confiables dentro de un atributo | no se usa |
| GHSA-68p9-83h6-5wpj | media | permitir que los usuarios definan nombres de atributos HTML | los nombres de atributos están fijos en las vistas. **La versión anterior lo daba como probable: era un error** |

### Condicional, pendiente de validar (1)

**GHSA-2gff-2mmg-m73p** (alta). Que el código afectado está en uso está
comprobado; que Growth Log quede expuesto, no.

**Lo comprobado en el código:**

- desde 8.1.0, `request.remote_ip` prefiere la cabecera `Forwarded`;
- Growth Log lo usa en el límite de intentos por IP de GL-02
  (`sessions_controller.rb:15`) y lo guarda en `sessions.ip_address`
  (`authentication.rb:66`);
- el advisory menciona los `rate_limit` por dirección del cliente.

**Lo que no se conoce:** la exposición depende de cómo el proxy que esté
delante de la aplicación trate `Forwarded` y `X-Forwarded-For`. Según el
advisory, hay exposición cuando el proxy agrega la dirección del cliente a
`X-Forwarded-For` pero deja pasar sin cambios un `Forwarded` enviado por el
cliente. Growth Log no tiene despliegue ni proxy definidos: no hay
`Dockerfile`, `config/deploy.yml`, Kamal ni Thruster, y tampoco
`trusted_proxies` configurado.

**Evidencia que falta para confirmarlo o descartarlo:**

1. qué proxy o balanceador queda delante de Puma en el despliegue;
2. si ese proxy elimina o reemplaza un `Forwarded` recibido del cliente, o
   lo deja pasar;
3. cómo arma `X-Forwarded-For`: si agrega la dirección real o la
   reemplaza;
4. si la dirección con la que el proxy llega a Puma (`REMOTE_ADDR`) está
   entre los proxies de confianza de `ActionDispatch::RemoteIp`. Por
   defecto lo están el loopback y las redes privadas;
5. una prueba contra ese despliegue que envíe un `Forwarded` falso y
   compare `request.remote_ip` con la dirección real.

Hasta tener esa evidencia, el aviso queda **pendiente de validar**. La
actualización lo corrige de todos modos.

### No confirmable sin revisión adicional (1)

| Aviso | Sev. | Qué se sabe y qué falta |
|---|---|---|
| GHSA-8474-xrp6-wh69 | alta | ver el detalle abajo |

**Búsquedas hechas el 06/11/2026** (lectura estática, sin ejecutar la
aplicación):

1. **Código propio:** `git grep -nE "safe_constantize|constantize" -- app
   config lib` no tiene resultados.
2. **Action Cable**, el vector que describe el advisory:
   `action_cable/connection/subscriptions.rb:39` pasa el `channel` de cada
   `subscribe`. En Growth Log, Action Cable se carga pero no tiene ruta
   (`config.action_cable.mount_path = nil`, sin `app/channels`), y la lista
   exacta de rutas de GL-02 no incluye `/cable`.
3. **Gemas de Rails cargadas:** `grep -rn safe_constantize` sobre `lib/` de
   `actionpack`, `actionview`, `activesupport`, `activerecord`,
   `activemodel`, `activejob`, `actionmailer`, `actioncable` y `railties`
   8.1.4. Llamadas encontradas y su origen:

   | Llamada | Origen del valor | ¿Dato externo? |
   |---|---|---|
   | `action_dispatch/middleware/actionable_exceptions.rb:20` | `request.params[:error]` de un `POST /rails/actions` | **sí**. El middleware solo se instala con `consider_all_requests_local = true`, que en Growth Log está en `development` y `test` y no en `production`. Actúa antes de la autenticación |
   | `action_cable/connection/subscriptions.rb:39` | `channel` del cliente | sí, pero Action Cable no tiene ruta |
   | `action_controller/metal/params_wrapper.rb:170` | nombre derivado del controlador | no |
   | `active_record/inheritance.rb:254` y `:264` | columna `type` de STI | no: no hay columnas `type` en `db/schema.rb` |
   | `active_job/core.rb:70`, `active_job/serializers.rb:44` | datos de la cola | no desde la petición; no hay trabajos |
   | asociaciones, fixtures, `rescuable`, `delegation`, `test_case`, `constant_lookup`, comando `unused_routes`, adaptador SQLite | nombres definidos en código o herramientas de prueba | no |
4. **Otras gemas del `Gemfile`:** `pundit` 2.5.2 no llama a
   `safe_constantize`. No se revisaron `turbo-rails`, `stimulus-rails`,
   `importmap-rails` ni `propshaft`.

**Resultado:** hay un camino con datos externos **en desarrollo y en
pruebas**: `ActionableExceptions` con `POST /rails/actions`, alcanzable por
quien llegue al servidor de desarrollo. **No se pudo confirmar** que no
exista un camino en producción: la búsqueda fue por texto y no siguió las
llamadas indirectas (`String#safe_constantize` invocado desde otro método).
El aviso queda **no confirmable**.

**Comprobación pendiente:**

- repetir la búsqueda sobre las gemas no revisadas (`turbo-rails`,
  `stimulus-rails`, `importmap-rails`, `propshaft`, `bootsnap`);
- revisar las llamadas indirectas a `constantize` y `safe_constantize` en
  los middlewares y controladores cargados en producción, partiendo de
  `bin/rails middleware` con `RAILS_ENV=production`;
- confirmar en ese entorno que `ActionableExceptions` no está en la pila.

**Total:** 19 no aplican + 1 condicional, pendiente de validar + 1 no
confirmable = 21. Ninguno queda como aplicable confirmado.

La clasificación describe el estado actual. Cambiaría si se agregan, por
ejemplo:

- Active Storage, si se suben archivos;
- `simple_format`, si se usa para el texto del feedback en GL-06;
- otro almacén de sesión o un despliegue detrás de un proxy.

La actualización cierra los 21 avisos de todos modos.

## Contradicciones y ampliaciones a señalar

- **Ninguna contradice la versión objetivo:** `~> 8.1.4` admite 8.1.4.1;
  la única dependencia nueva ya está satisfecha; Ruby 4.0.9 no cambia.
- **Orden de ramas:**
  - GL-05 vive en `feature/GL-05-personas` y no puede pasar `bin/ci` hasta
    que llegue esta corrección.
  - **Recomendación:** GL-01b en su propia rama desde
    `feature/entrega-2-pp` (`925e2ee`), integrada primero.
  - Después habría que traer el cambio a GL-05, con un merge o rebase que
    requiere autorización.
  - Aplicarlo dentro de la rama de GL-05 mezclaría tareas, contra
    `CLAUDE.md`.
- **CI remoto:** una rama nueva no ejecuta el CI con un simple push; hace
  falta un PR o integrar en `feature/entrega-2-pp`. Pablo autorizó el push
  y el PR en M51, y el CI del PR #2 pasó (ver B9).
- **Plan:** agregar GL-01b a `docs/plan-entrega-2.md`, la única fuente de
  la secuencia, también requiere autorización.

## Decisión pendiente

| # | Decisión | Recomendación | Alternativa | Estado |
|---|---|---|---|---|
| P-18 | ¿Fijar 8.1.4.1 como mínimo en el `Gemfile`? | no cambiar el `Gemfile`: `~> 8.1.4` ya admite 8.1.4.1 y el diff queda en el lockfile | `gem "rails", "~> 8.1.4", ">= 8.1.4.1"`, que impide volver a una versión vulnerable con un `bundle update` | **sin aprobar** |

## Criterios de aceptación

| # | Criterio |
|---|---|
| B1 | `rails` y sus 12 componentes quedan en 8.1.4.1 en `Gemfile.lock`, con sus entradas en `CHECKSUMS` |
| B2 | Cualquier otro cambio en `Gemfile.lock` lo exige estrictamente la resolución de 8.1.4.1, como `rails-html-sanitizer >= 1.7.2` o una dependencia transitiva necesaria. Cada uno está documentado en este ticket con la versión anterior, la nueva y el requisito que lo obliga. Las demás dependencias no cambian, ni las plataformas, ni `RUBY VERSION`, ni `BUNDLED WITH` |
| B3 | Los checksums de cada gema nueva o cambiada coinciden con el SHA-256 que publica RubyGems para esa versión, y Bundler instala el lockfile con su verificación de integridad sin errores |
| B4 | El `Gemfile` no cambia, salvo que Pablo apruebe la alternativa de P-18 |
| B5 | `bin/bundler-audit update` y después `bin/bundler-audit` terminan sin vulnerabilidades y sin ignorados nuevos |
| B6 | `bin/ci` termina con código 0 en local |
| B7 | La aplicación arranca en desarrollo con Rails 8.1.4.1 y `/up` responde 200 |
| B8 | Sin cambios de código ni de configuración; las pruebas de GL-02, GL-03 y GL-05 pasan sin ajustes |
| B9 | El CI remoto pasa en los cuatro jobs sobre el SHA publicado, con enlace a la ejecución. **Requiere una autorización posterior de push y PR**; hasta entonces queda pendiente |

## Plan de verificación

1. **Antes de actualizar:** registrar `bin/bundler-audit` con los 21 avisos,
   y el SHA-256 de `Gemfile` y de `Gemfile.lock`.
2. **Actualizar** con `bundle update rails --conservative`.
3. **Revisar el diff del lockfile:**
   - `git diff --stat Gemfile.lock` y `git diff Gemfile.lock`;
   - con un script, listar cada gema cuya versión o checksum cambió, y
     separar las 13 de Rails de las demás;
   - para cada gema fuera de las 13, identificar en el lockfile qué
     dependencia la exige (`bundle info <gema>` y la sección `specs`), y
     documentarlo según B2. Si no se puede justificar, **detenerse e
     informar**; no se acepta;
   - confirmar que no cambian las plataformas, `RUBY VERSION` ni
     `BUNDLED WITH`, y que `git diff --exit-code Gemfile` termina en 0.
4. **Integridad de los checksums**, sin usar el anuncio de Rails como
   fuente:
   - comparar el `sha256=` de cada gema cambiada en `CHECKSUMS` con el
     campo `sha` de `https://rubygems.org/api/v2/rubygems/<gema>/versions/<versión>.json`,
     consultado en el momento de la verificación;
   - instalar con Bundler, por ejemplo `bundle install` con una ruta de
     instalación temporal. Bundler compara cada `.gem` descargado con
     `CHECKSUMS` y falla si no coincide.
5. **Seguridad:** `bin/bundler-audit update`, después `bin/bundler-audit`,
   y `bin/brakeman` con `--ensure-latest`, como en `bin/ci`.
6. **Verificación completa** con `bin/ci` y `openspec validate --all
   --strict`.
7. **Arranque:**
   - `bin/rails runner 'puts Rails.version'`, que debe imprimir 8.1.4.1;
   - `bin/rails server` y `curl -i http://localhost:3000/up`.
8. **Si algo cambia el comportamiento** y rompe pruebas: detenerse e
   informar sin ajustarlas.
9. **CI remoto:** se ejecuta en el PR, con la autorización de push y PR que
   Pablo dio en M51 (ver B9).

## Riesgos de compatibilidad

- **Cambios de comportamiento que anuncian los advisories:**
  - `RemoteIp` cambia el tratamiento de `Forwarded`, que afecta al límite
    por IP de GL-02. Lo cubren `rate_limit_spec` y `sessions_spec`;
  - `strip_tags` y `highlight` escapan comillas, pero no se usan;
  - `SameSite` en almacenes distintos de `CookieStore`, que no se usan.
- **Arrastre de dependencias:** si Bundler necesita subir otra gema, se
  documenta según B2. Si el cambio no es estrictamente necesario, no se
  acepta.
- **Brakeman con `--ensure-latest`** puede fallar si sale una versión
  nueva; eso no forma parte de esta remediación y se informaría aparte.
- **Traer la corrección a GL-05:** puede haber un conflicto en
  `Gemfile.lock`. Es poco probable, porque GL-05 no lo modifica.

## Ejecución (07/11/2026, local)

**Aislamiento.** El worktree principal está en `feature/GL-05-personas`,
con cambios sin commit de GL-05 que difieren de la base, así que cambiar
de rama en ese directorio los habría arrastrado. Por eso se trabajó en un
worktree aparte, creado con `git worktree add -b
feature/GL-01b-rails-8-1-4-1 ../ai4devs-entrega-1-pp-gl01b
feature/entrega-2-pp`:

- `feature/entrega-2-pp` local y remota estaban en `925e2ee`;
- el ticket y los registros M38 a M41 se **copiaron**, no se movieron;
- la huella del worktree principal (estado, diff, hashes de los archivos
  sin versionar y HEAD) es idéntica antes y después.

**Línea base.** Después de `bin/bundler-audit update`, la salida de
`bin/bundler-audit` (`audit-antes.txt`) registra 21 avisos y termina con
«Vulnerabilities found!». **El código de salida no quedó registrado.**
SHA-256 de partida, registrados en `sha-antes.txt`:

- `Gemfile`: `31cac26e1761112dd8d4f869fc4aae0f8bd17c87d3606b96cf895fb4afee5e22`;
- `Gemfile.lock`: `27e16e5313ece1a91c315860cc2301269e294c383de8c3fc14109bea41b25658`.

**Actualización.** `bundle update rails --conservative`. El log
(`bundle-update.log`) registra la descarga e instalación de las 13 gemas en
8.1.4.1 y termina con «Bundle updated!». **El código de salida no quedó
registrado.**

**Diff de `Gemfile.lock`:** 67 líneas agregadas y 67 eliminadas.

| Cambio | Detalle | Justificación |
|---|---|---|
| Versión de 13 gemas | `actioncable`, `actionmailbox`, `actionmailer`, `actionpack`, `actiontext`, `actionview`, `activejob`, `activemodel`, `activerecord`, `activestorage`, `activesupport`, `rails` y `railties`: de 8.1.4 a 8.1.4.1, en `specs` (incluidas las restricciones `(= …)` entre ellas) y en `CHECKSUMS` | remediación (B1) |
| Restricción declarada por `actionview` | `rails-html-sanitizer (~> 1.6)` pasa a `(~> 1.6, >= 1.7.2)` | requisito de `actionview` 8.1.4.1, publicado en RubyGems. **No cambia ninguna versión:** `rails-html-sanitizer` sigue en 1.7.2 con el mismo checksum |
| Otras gemas | ninguna | — |
| `DEPENDENCIES` | sin cambios: la restricción de `rails` en el `Gemfile`, `rails (~> 8.1.4)`, sigue igual | — |
| `PLATFORMS`, `RUBY VERSION`, `BUNDLED WITH` | sin cambios | — |
| `Gemfile` | sin cambios (`git diff --exit-code Gemfile`) | P-18 sin aprobar |

Bundler no propuso ningún cambio fuera de alcance, así que no hizo falta
detenerse.

**Resultados por criterio:**

| # | Resultado |
|---|---|
| B1 | **cumple:** las 13 gemas están en 8.1.4.1, con sus entradas en `CHECKSUMS` |
| B2 | **cumple:** fuera de las 13 gemas, solo cambia la restricción ya justificada; ninguna otra versión |
| B3 | **cumple:** los 13 checksums nuevos coinciden con el campo `sha` de la API de RubyGems (consulta del 07/11/2026 00:05 UTC). Además, `bundle install` con `BUNDLE_PATH` temporal y `BUNDLE_FROZEN=true` instaló las 101 gemas sin errores de integridad, y el directorio temporal se borró |
| B4 | **cumple:** el `Gemfile` no cambió |
| B5 | **cumple, según los logs.** `audit-despues.txt` registra «No vulnerabilities found», la salida de `bin/bundler-audit` después de `bin/bundler-audit update`. `bin-ci.log` registra lo mismo en el paso «Security: Gem audit». `config/bundler-audit.yml` no cambió, así que no hay ignorados nuevos. `brakeman.txt` registra `Security Warnings: 0` y «No warnings found». **No quedaron registrados** los códigos de salida de `bin/bundler-audit` ni de `bin/brakeman`, ni las opciones con que se ejecutó `bin/brakeman` para `brakeman.txt` |
| B6 | **cumple, según `bin-ci.log`:** el log termina con «Continuous Integration passed»; **el código de salida exacto no quedó persistido.** RuboCop no tiene ofensas en 87 archivos, las auditorías de gemas e importmap pasan, Brakeman no tiene avisos y RSpec da 164 ejemplos y 0 fallas, que es la suite de la base sin GL-05 |
| B7 | **cumple, según `server.log`:** `bin/rails server -p 3011` registró «Rails 8.1.4.1 application starting in development», dos `GET "/up"` con `Completed 200 OK` y el cierre (`Exiting`). **La respuesta de `curl` (`HTTP/1.1 200 OK`) no se guardó:** se observó en la sesión y no está en un log. `bin/rails runner 'puts Rails.version'` imprimió 8.1.4.1: **observado en la sesión, no persistido en un log** |
| B8 | **cumple en la base:** sin cambios de código ni de configuración; las pruebas de GL-02 y GL-03 pasan sin ajustes. **Pendiente:** las de GL-05, que no están en esta rama, se comprueban al traer la corrección a `feature/GL-05-personas` |
| B9 | **cumple:** el CI remoto [42376879636](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/42376879636), disparado por el PR [#2](https://github.com/pablo-wpify/growth-log-ai4devs/pull/2) sobre `d4c61ebde4bd1b812d8115e01d498f9d26e76566`, terminó en success con los cuatro jobs: `scan_ruby`, `scan_js`, `lint` y `test` |

**OpenSpec.** `openspec validate --all --strict` dio 14 de 14 en la base,
sin GL-05 en esta rama. **Observado en la sesión, no respaldado por un
log.** **No se creó un cambio de OpenSpec para GL-01b,
porque M45 no lo autorizó;** queda pendiente.

**Desvíos y observaciones:**

- No hubo fallos ajenos a la actualización.
- El worktree principal conserva sus copias sin versionar del ticket (en la
  versión previa a esta ejecución) y de M38 a M41, sin M45. La versión
  vigente es la de este worktree. Unificarlas requiere una decisión
  de Pablo.
- `docs/plan-entrega-2.md` no se actualizó, porque requiere autorización.

## Pendiente de autorización

- aprobar P-18, que sigue sin aprobar;
- crear el cambio de OpenSpec de GL-01b y agregarlo al plan;
- el merge del PR #2 en `feature/entrega-2-pp`;
- traer la corrección a `feature/GL-05-personas`.
