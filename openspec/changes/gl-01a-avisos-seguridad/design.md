# Design

## Context

Ver `proposal.md` y el ticket, que registra los 15 avisos con sus
identificadores, versiones afectadas y corregidas. Las cuatro gemas son
dependencias indirectas de Rails 8.1.4 y de sus componentes: `rack` (de
`actionpack`, `rackup`, `rack-session` y otros), `rails-html-sanitizer` (de
`actionpack`, `actionview` y `actiontext`), `loofah` (de
`rails-html-sanitizer`) y `nokogiri` (de `loofah`, `rails-dom-testing` y
otros). Ninguna está en el `Gemfile`.

## Goals / Non-Goals

**Goals:**
- Llegar a las versiones corregidas mínimas, con el menor diff posible en
  el lockfile.

**Non-Goals:**
- Llevar las gemas a su última versión o actualizar otras.
- Tocar la configuración de la auditoría.

## Decisions

1. **Versión corregida mínima, no la más reciente.** Para `nokogiri` hay
   1.19.6 y 1.19.7, pero no corrigen avisos ni problemas que afecten a
   CRuby 4.0.9 (ver el ticket). Para las otras tres, la mínima es la única
   corregida publicada en su serie.
2. **Cómo fijar `nokogiri` 1.19.5 sin cambiar el `Gemfile`.**
   `bundle update --conservative --patch` elegiría 1.19.7. Se agrega de
   forma temporal `gem "nokogiri", "1.19.5"` al `Gemfile`, se resuelve con
   `bundle lock --update` de las cuatro gemas y `--conservative` (no
   actualiza dependencias compartidas), se quita la línea y se vuelve a
   ejecutar `bundle lock` sin actualizar, que conserva lo resuelto. El
   `Gemfile` se respalda antes y se restaura por copia, verificado con
   `sha256sum`. *Alternativa descartada:* editar el lockfile a mano.
3. **Instalación local.** `bundle install` instala solo las versiones
   nuevas de esas gemas para Ruby 4.0.9; no cambia nada fuera del proyecto.

## Risks / Trade-offs

- [`nokogiri` 1.19.5 tiene una regresión conocida] → afecta solo a JRuby
  (corregida en 1.19.6); Growth Log usa CRuby.
- [Cambio de comportamiento del serializador HTML5 de `nokogiri` con
  `noscript`] → es parte de la corrección de GHSA-4p39-36wj-23h4; Growth Log
  todavía no sanitiza HTML propio. Se reevalúa cuando haya contenido
  generado por usuarios.
- [Dependencia adicional forzada] → si la resolución cambia otra gema, se
  detiene, se explica por qué la exige una dependencia declarada y, si
  amplía el alcance, se consulta antes de seguir.

## Registro de evidencia

Directorio de evidencias: `~/growth-log-evidencias/gl-01a.bOGpjrYL` (no
versionado).

| Criterio | Estado | Resultado | Fecha |
|---|---|---|---|
| S1 | Comprobado (local) | lockfile: `rack` 3.2.8, `loofah` 2.25.3, `rails-html-sanitizer` 1.7.2 y `nokogiri` 1.19.5 en sus 8 plataformas | 2026-11-02 |
| S2 | Comprobado (local) | el diff de especificaciones solo cambia esas cuatro gemas; ninguna otra línea del lockfile cambia fuera de ellas; `DEPENDENCIES`, `RUBY VERSION` (4.0.9) y `BUNDLED WITH` (4.0.20) iguales. Sin dependencias adicionales | 2026-11-02 |
| S3 | Comprobado (local) | `Gemfile` restaurado por `trap` e idéntico (`sha256sum -c`); `.ruby-version`, `.tool-versions`, `config/bundler-audit.yml`, `bin/bundler-audit` y `bin/brakeman` sin cambios | 2026-11-02 |
| S4 | Comprobado (local) | base de avisos `a58f1d0` (2026-11-02, 1329 avisos); `bin/bundler-audit`: «No vulnerabilities found», código 0; `bin/ci`: todos los pasos en verde, código 0 (RuboCop sin infracciones, importmap sin avisos, Brakeman 0 advertencias, RSpec 4 ejemplos y 0 fallos) | 2026-11-02 |
| S5 | Comprobado (local) | `openspec validate --all --strict`: 7 de 7 válidos | 2026-11-02 |
| G6 de GL-01 | Comprobado (local) | ver S4 | 2026-11-02 |
| G7 de GL-01 | Pendiente (remota) | sin push autorizado | — |
