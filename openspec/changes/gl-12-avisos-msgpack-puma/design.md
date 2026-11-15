# Design

> **Autorizado e implementado en local en M241 (15/11/2026), sin commit.**
> Fuente: `docs/tickets/GL-12-avisos-msgpack-puma.md`.

## Context

- **Lockfile antes del cambio** (`Gemfile.lock` en `6177aef`):
  - `msgpack (1.8.6)`, sin dependencias; lo pide `bootsnap (1.26.1)` con
    `msgpack (~> 1.5)`. Checksum `a148c24e…`, igual al de la variante
    `ruby` de 1.8.6 en RubyGems.
  - `puma (8.0.2)`, con `nio4r (~> 2.0)` resuelto a 2.7.5. El `Gemfile`
    pide `puma (>= 5.0)`. Checksum `c8ed871d…`, igual al de la variante
    `ruby` de 8.0.2.
  - Las dos gemas tienen una sola entrada, sin variantes por plataforma.
    `PLATFORMS` lista variantes `aarch64`, `arm`, `arm64-darwin`,
    `x86_64-darwin` y `x86_64-linux`, sin `java`. Ruby 4.0.9 y Bundler
    4.0.20.
- **Topología de Puma:**
  - `config/puma.rb` define 3 hilos (`RAILS_MAX_THREADS`), el puerto de
    `PORT`, el plugin `tmp_restart` y el `pidfile` opcional.
  - No define `ssl_bind`, `bind` con `ssl://`, `ssl_cipher_filter` ni
    `activate_control_app`, y no fija `workers` ni `force_shutdown_after`.
  - En local y en las pruebas, Puma corre en modo de un solo proceso.
  - En Render, el log del primer deploy de GL-10 (M235) muestra que Puma
    escucha en `http://0.0.0.0:10000` y arranca en modo cluster con un
    worker, porque Render fija `WEB_CONCURRENCY=1`. TLS termina antes de
    Puma (`assume_ssl`).
  - En producción, Rails sirve los archivos estáticos desde Puma. Entre
    ellos, `turbo.min.js` pesa 105 KB, más que los 64 KB del aviso
    GHSA-x646-wp7c-h9mg.

## Avisos verificados contra sus fuentes oficiales (15/11/2026)

Fuentes: GitHub Advisory Database para `msgpack`; avisos de seguridad del
repositorio `puma/puma` para Puma; y la base de `bundler-audit` (commit
`5755673f`, 15/11/2026).

| Aviso | Gema | Severidad | Corregido en | Aplicabilidad en Growth Log |
|---|---|---|---|---|
| CVE-2026-126366 / GHSA-73v3-wf97-vpgj | msgpack ≤ 1.8.6 | alta (CVSS 3.1: 7,5) | 1.8.7 | **No aplica en la práctica:** el aviso afecta al decoder de JRuby (plataforma `java`). La aplicación corre en CRuby 4.0.9 y el lockfile no tiene la variante `java`. `msgpack` lo usa `bootsnap` para su caché local, no para datos de clientes. Se actualiza igual, porque la auditoría lo marca por versión. |
| GHSA-rf6g-xhmp-gm7v | puma ≥ 8.0.0, < 8.0.3 | alta (CVSS 4.0: 8,7) | 7.2.2 y 8.0.3 | **Aplica:** el bucle de accept no pausa ante `EMFILE` y llena el log. Depende solo de poder abrir conexiones. No hay evidencia de que el proxy de Render lo mitigue. |
| GHSA-xw3h-pgr9-3vg7 | puma ≥ 3.8.0 | alta (8,2) | 7.2.2 y 8.0.3 | **Aplica:** el bloqueo en `100 Continue` no depende de TLS ni de la configuración. |
| GHSA-x646-wp7c-h9mg | puma ≥ 3.9.0 | alta (8,7) | 7.2.2 y 8.0.3 | **Aplica en parte:** la rama TLS no aplica, porque Puma no escucha por TLS. La rama de archivos de más de 64 KB sí, por `turbo.min.js`. |
| GHSA-86xc-wrr9-xmmq | puma ≥ 4.3.0 | alta (8,3) | 7.2.2 y 8.0.3 | **No aplica:** afecta a `pumactl` con una URL de control `ssl://`, y la aplicación no activa el servidor de control. |
| GHSA-m5xw-3hrw-qcmf | puma ≥ 5.0.3 | media (6,9) | 7.2.2 y 8.0.3 | **Aplica:** la cola de timeouts del reactor no depende de la configuración. |
| GHSA-jm4r-w4xx-qxw7 | puma ≥ 5.0.0 | media (6,9) | 7.2.2 y 8.0.3 | **Aplica en local y en pruebas** (modo de un solo proceso, sin `force_shutdown_after`). En Render, Puma corre en modo cluster y el aviso describe el modo de un solo proceso; no se da por mitigado sin evidencia. |
| GHSA-r885-m39c-939g | puma ≥ 3.12.0 | media (6,3) | 7.2.2 y 8.0.3 | **No aplica:** requiere `ssl_cipher_filter`, que la aplicación no usa. |

La aplicabilidad sale de la configuración del repositorio y del log del
primer deploy. **No se asume ninguna mitigación de Render:** su proxy está
delante de Puma, pero no hay evidencia de que filtre `Expect: 100-continue`,
limite conexiones ociosas o corte respuestas lentas.

## Decisions

### 1. Versiones de parche: `msgpack` 1.8.7 y `puma` 8.0.3

- Se usó `bundle update msgpack puma --conservative --patch`.
  - `--conservative` no actualiza las dependencias compartidas.
  - `--patch` prefiere la versión de parche más alta dentro de la misma
    versión menor.
- Bundler eligió `msgpack` 1.8.7 y `puma` 8.0.3, las correcciones
  publicadas para las líneas en uso.
- **Puma 8.1.0 y 8.1.1** (14 y 15/11/2026) no se eligieron: son una
  versión menor nueva, no hacen falta para corregir los avisos y se
  publicaron hace menos de dos días. Pasar a 8.1.x sería ampliar la
  actualización sin pedido.
- No hubo conflictos.

### 2. Sin cambios en el `Gemfile` ni en la configuración de Puma

`puma (>= 5.0)` ya admite 8.0.3 y `bootsnap` admite `msgpack` 1.8.7. No se
agregan límites de versión. Tampoco se cambia `config/puma.rb`: no se
agrega `force_shutdown_after` ni se fija `workers`, porque la corrección
viene de la versión.

## Verificación

**Ejecutado el 15/11/2026, local, sin commit:**

- **Línea base:** con la base de avisos actualizada, `bin/ci` terminó con
  código 1 en M240, solo por los ocho avisos.
- **Diff de `Gemfile.lock`:** 4 líneas cambiadas, la versión y el checksum
  de `msgpack` y de `puma`. Ninguna dependencia transitiva cambió (`nio4r`
  sigue en 2.7.5). El `Gemfile` no cambió.
- **Checksums:** los nuevos coinciden con la API de RubyGems para la
  variante `ruby`: `msgpack` 1.8.7 `dfefec76…` y `puma` 8.0.3 `6383a60b…`.
- **Carga:** `bundle exec` carga Puma 8.0.3 y `msgpack` 1.8.7.
- `bin/bundler-audit update` terminó con código 0, y `bin/bundler-audit`
  informó «No vulnerabilities found».
- **`bin/ci` con código 0:**
  - RuboCop, con 120 archivos y sin ofensas;
  - auditoría de gemas sin vulnerabilidades;
  - Importmap sin paquetes vulnerables;
  - Brakeman, con 0 avisos;
  - RSpec, con 383 ejemplos y 0 fallos.
- Las pruebas de sistema levantan la aplicación con Puma (Capybara), así
  que Puma 8.0.3 la sirvió durante la suite.
- `openspec validate --all --strict`: 21 de 21, con el cambio de GL-12.
- Los cambios locales de GL-10 y GL-11 no se modificaron: se comprobó con
  sus SHA-256.

**Pendiente, con su autorización:**

- commit, CI remoto y merge;
- deploy manual en Render, que hace Pablo; hasta entonces, la demo sigue
  con Puma 8.0.2;
- archivo del cambio.

## Risks / Trade-offs

- **Demo de GL-10 expuesta hasta el deploy:** los avisos que aplican siguen
  vigentes en Render hasta que Pablo despliegue la versión corregida.
- **Parche de Puma:** puede cambiar detalles de los timeouts. La suite
  completa pasó, pero no se probaron escenarios de carga.

## Migration Plan

Sin migraciones ni datos. Se revierte restaurando el `Gemfile.lock`
anterior.

## Open Questions

Ninguna.
