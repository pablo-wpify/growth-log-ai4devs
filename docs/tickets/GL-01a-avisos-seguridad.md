# GL-01a. Corregir los avisos de seguridad que bloquean GL-01

> Ticket derivado de [GL-01](GL-01-base-producto.md), criterio **G6**.
> Cambio de OpenSpec:
> [`gl-01a-avisos-seguridad`](../../openspec/changes/gl-01a-avisos-seguridad/proposal.md).

## Problema

En GL-01, `bin/ci` falla en «Security: Gem audit»: con la base de avisos
actualizada el 02/11/2026 (commit `a58f1d0`, 1329 avisos), `bundler-audit`
encuentra 15 avisos en cuatro gemas indirectas. Los avisos se publicaron
después de la ejecución de CI del ensayo (28/10/2026). GL-01 no puede
completarse mientras la auditoría falle.

## Avisos (consultados el 02/11/2026)

| Gema | Versión | Aviso | Severidad | Corregida en |
|---|---|---|---|---|
| `rack` | 3.2.7 | GHSA-5v64-555j-wjxm | alta | `~> 2.2.25`, `~> 3.1.23`, `>= 3.2.8` |
| `rack` | 3.2.7 | GHSA-2j8w-xcrc-x985 | media | `~> 3.1.23`, `>= 3.2.8` |
| `rack` | 3.2.7 | GHSA-wvg4-6p58-3gh3 | media | `~> 2.2.25`, `~> 3.1.23`, `>= 3.2.8` |
| `rack` | 3.2.7 | GHSA-p8x9-v4hv-2w4g | baja | `~> 2.2.25`, `~> 3.1.23`, `>= 3.2.8` |
| `loofah` | 2.25.2 | GHSA-345x-3rq2-jfrm | media | `>= 2.25.3` |
| `loofah` | 2.25.2 | GHSA-h6v6-rg66-fqj4 | media | `>= 2.25.3` |
| `loofah` | 2.25.2 | GHSA-m3x9-938q-5767 | media | `>= 2.25.3` |
| `loofah` | 2.25.2 | GHSA-mf2j-8f84-cc9q | media | `>= 2.25.3` |
| `loofah` | 2.25.2 | GHSA-jcff-cj73-4w4f | sin clasificar | `>= 2.25.3` |
| `loofah` | 2.25.2 | GHSA-p9wj-w8xq-vjx6 | sin clasificar | `>= 2.25.3` |
| `nokogiri` | 1.19.4 | GHSA-3w22-6jfg-527w | sin clasificar | `>= 1.19.5` |
| `nokogiri` | 1.19.4 | GHSA-4p39-36wj-23h4 | sin clasificar | `>= 1.19.5` |
| `nokogiri` | 1.19.4 | GHSA-v995-44v6-5fqm | baja | `>= 1.19.5` |
| `rails-html-sanitizer` | 1.7.1 | GHSA-cpgf-5mjf-73p7 | media | `>= 1.7.2` |
| `rails-html-sanitizer` | 1.7.1 | GHSA-h7wh-q2qr-458c | media | `>= 1.7.2` |

Ningún aviso tiene CVE asignado en la base consultada.

## Versiones elegidas

La versión corregida **mínima** de cada gema, dentro de su misma serie:

| Gema | Antes | Después | Otras versiones publicadas | Por qué no más nueva |
|---|---|---|---|---|
| `rack` | 3.2.7 | 3.2.8 | ninguna posterior en 3.2.x | — |
| `loofah` | 2.25.2 | 2.25.3 | ninguna posterior en 2.25.x | — |
| `nokogiri` | 1.19.4 | 1.19.5 | 1.19.6 y 1.19.7 (02/11/2026) | 1.19.6 corrige una regresión solo de JRuby; 1.19.7, la compilación con Ruby 4.1.0-preview1. Growth Log usa CRuby 4.0.9 con la gema precompilada |
| `rails-html-sanitizer` | 1.7.1 | 1.7.2 | ninguna posterior en 1.7.x | — |

Dependencias declaradas de las versiones nuevas: `loofah` 2.25.3 exige
`nokogiri >= 1.19.5`; `rails-html-sanitizer` 1.7.2 exige
`loofah ~> 2.25, >= 2.25.3`. Las cuatro aceptan Ruby 4.0.9.

## Alcance

Actualizar solo esas cuatro gemas en `Gemfile.lock`, sin cambiar el
`Gemfile`, Ruby, Rails ni otras herramientas.

## Exclusiones

Ignorar avisos (`config/bundler-audit.yml`), cambiar la configuración o los
umbrales de la auditoría, actualizar otras gemas, push o ejecución remota del
CI, archivar GL-01.

## Criterios de aceptación

Este ticket no agrega requisitos: se cumple cuando GL-01 cumple **G6**, más
estas condiciones propias de la corrección.

| # | Criterio | Cómo se comprueba |
|---|---|---|
| S1 | Las cuatro gemas quedan en las versiones elegidas, en todas las plataformas del lockfile | lectura del lockfile con `Bundler::LockfileParser` |
| S2 | Ninguna otra gema cambia de versión, salvo las que exija una dependencia declarada, explicadas aquí | diff de las especificaciones del lockfile antes y después |
| S3 | `Gemfile`, `.ruby-version`, `.tool-versions`, `config/bundler-audit.yml` y los binstubs de la auditoría no cambian | `git diff` |
| S4 | Con la base de avisos actualizada, `bundler-audit` no informa avisos y `bin/ci` termina con código 0 | `bin/bundler-audit update`, `bin/ci` |
| S5 | `openspec validate --all --strict` pasa | comando |

G7 de GL-01 (CI en GitHub): comprobado en la ejecución 41528484840 sobre `2631edb`, con `scan_ruby` sin vulnerabilidades.
