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

| Criterio | Estado | Comando o fuente | Fecha |
|---|---|---|---|
| G1 a G6, G8, G9, G11 a G16 | Pendiente | — | — |
| G7 | Pendiente (remota) | — | — |
| G10 | Pendiente; desde un clon limpio, Pendiente (clon limpio) | — | — |

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
