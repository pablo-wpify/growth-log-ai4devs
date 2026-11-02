# Decisiones de GL-01 (02/11/2026)

> Tomadas por Pablo al aprobar la implementación de
> [GL-01](../tickets/GL-01-base-producto.md). Completan los borradores de ADR
> del [Anexo D](../../anexos/anexo-d-decisiones-arquitectura.md), que no se
> modifica.

| # | Decisión | Estado | Consecuencia |
|---|---|---|---|
| ADR-1 | Monolito Rails con HTML del servidor, a partir de la base del ensayo E1 | **aprobada para el producto** | el producto reutiliza la base Rails del ensayo |
| Versiones | Ruby 4.0.9, Bundler 4.0.20, Rails 8.1.4, PostgreSQL 18.6, RSpec (`rspec-rails` 8.0.4) y el resto de las versiones heredadas que enumera el ticket | **aceptadas, sin actualizar en GL-01** | cualquier actualización va en un cambio propio |
| D-GL01-1 | PostgreSQL propio, separado del ensayo: contenedor `growthlog-pg`, volumen `growthlog-pgdata`, puerto `127.0.0.1:55440` | aprobada | no se usan el contenedor ni las bases del ensayo |
| D-GL01-2 | CI también en push a `feature/entrega-2-pp`; no se crea `main` ni se abre un pull request solo para ejecutarlo | aprobada | ajuste mínimo en `push.branches` del workflow |
| D-GL01-3 | GL-01 se documenta en `docs/`; el README de la entrega 1 no cambia durante este cambio | aprobada | guía en `docs/desarrollo.md` |
| D-GL01-4 | `.tool-versions` versionado con Ruby 4.0.9, coherente con `.ruby-version`, que sigue siendo la fuente del `Gemfile` y del CI; sin cambiar la configuración global de asdf | aprobada | el requisito «Fuente única» pasa a «Declaración coherente» |
| Variables | `DATABASE_*` en `.env` ignorado, con la plantilla `.env.example` sin secretos | aprobada | excepción `!/.env.example` en `.gitignore` |

Siguen abiertas: ADR-2 (autenticación), ADR-3 (políticas), ADR-5 (RLS),
ADR-6 (E2E), ADR-7 (despliegue y backups), ADR-8 (servicios externos), la
lista de dimensiones, D3 y D4.
