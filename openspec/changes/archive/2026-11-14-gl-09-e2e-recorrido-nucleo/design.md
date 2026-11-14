# Design

> **Estado (14/11/2026): cerrado y archivado.** Integrado en
> `feature/entrega-2-pp` con el [PR #6](https://github.com/pablo-wpify/growth-log-ai4devs/pull/6) (merge commit `e0ceb4e`) y archivado
> como `2026-11-14-gl-09-e2e-recorrido-nucleo`. Pablo decidió P-4 (ADR-6) y autorizó la implementación
> local en M202; pidió una revisión de solo lectura del cambio y después
> autorizó la publicación. CI
> remoto exitoso (ver «CI remoto del 14/11/2026»). Lo ejecutado se
> registra en «Registro de la implementación».

## Context

El núcleo ya existe: inicio de sesión (GL-02), «Personas» y ficha
(GL-05), captura, completar y marcar como lista (GL-06), resumen,
cronología y conteo (GL-07). Sus pruebas son de peticiones: verifican
respuestas HTML y la base, pero no que los enlaces, formularios y botones
encadenen el recorrido en un navegador. La privacidad entre líderes de la
misma persona está probada por petición (GL-06 y GL-07, con mutaciones).
GL-09 agrega la herramienta E2E elegida en P-4 y dos pruebas en navegador.

## Goals / Non-Goals

**Goals:**

- Recorrido núcleo de L1 por la interfaz real, en Chrome sin interfaz.
- Rama negativa de L2 en el navegador: ficha y URL directa.
- Las pruebas en navegador en la misma suite, en `bin/ci` y en el CI.

**Non-Goals:**

- Invitaciones, administración, compartir, filtros, feed y despliegue.
- El E2E hasta compartir (C11; I4).
- Cambiar reglas de privacidad, rutas, vistas o modelos.
- Varios navegadores o tamaños de pantalla.

## Decisions

### 1. Herramienta (P-4, aprobada el 14/11/2026)

Pruebas de sistema de RSpec (`type: :system`) con Capybara y
`selenium-webdriver`, `driven_by :selenium, using: :headless_chrome`. Es
lo que trae Rails, mantiene una suite y no agrega Node. Alternativas
descartadas: Playwright y Cuprite (ver el registro de decisiones).

### 2. Configuración

- `spec/support/system_tests.rb`: antes de cada prueba de tipo `system`,
  `driven_by :selenium, using: :headless_chrome, screen_size: [1280, 900]`.
  Capybara levanta la aplicación con Puma en un hilo del mismo proceso.
- Transacciones: Rails comparte la conexión de la prueba con el hilo del
  servidor, así que `use_transactional_fixtures` sigue valiendo y las
  pruebas no dejan datos.
- Datos: correos `@example.test` y contraseñas generadas en cada prueba
  (`create_user`), como en las pruebas de peticiones. La contraseña se
  escribe en el campo del navegador, no en la URL.
- La cookie de sesión usa `secure: request.ssl?`, así que funciona sobre
  el HTTP local del servidor de pruebas sin cambiar la configuración.
- El 404 ya lo produce `render_not_found` con `public/404.html`, igual en
  test que en producción.

### 3. Pruebas

`spec/system/core_journey_spec.rb`, con L1 y L2 asignados a la misma
persona P (datos ficticios propios):

| Prueba | Recorrido | Criterios |
|---|---|---|
| Recorrido núcleo | L1: inicio de sesión → «Personas» → ficha de P → «Captura rápida» → «Guardar borrador» → borrador en la cronología y resumen vacío → detalle → «Editar»: señal y dimensión → «Guardar cambios» → «Marcar como lista» → ficha: fila de la dimensión en el resumen y «Lista · solo vos» en la cronología | E1 a E5 |
| Rama negativa | entrada lista y borrador de L1 creados en la base; L2: inicio de sesión → ficha de P → resumen y cronología vacíos, sin el texto de L1 → URL directa del detalle de cada entrada → página 404, sin el texto | N1 y N2 |

Las aserciones buscan textos visibles dentro de las secciones
`[data-summary]` y `[data-timeline]`; Capybara espera los elementos, sin
pausas fijas.

### 4. CI

El job `test` ya corre `bundle exec rspec` sobre `ubuntu-latest`, que trae
Chrome; Selenium Manager resuelve el `chromedriver`. Se agrega un paso
que, solo si el job falla, sube `tmp/screenshots` (donde rspec-rails
guarda la captura de cada prueba en navegador que falla) como artefacto,
igual que el workflow que genera Rails. Las capturas solo contienen datos
ficticios de prueba.

### 5. Texto fuera de los logs

Las peticiones del navegador pasan por el filtrado de parámetros de GL-06:
el texto de las entradas no se escribe en `log/test.log`.

## Verificación

### Pruebas primero

El comportamiento ya existe (GL-05 a GL-07). Por eso, la falla esperada
antes de implementar es la falta de la herramienta: sin Capybara, las
pruebas de tipo `system` no tienen navegador. Que las pruebas detectan
defectos se comprueba con las mutaciones.

### Mutaciones (con copia de seguridad y restauración comprobada)

| # | Mutación | Prueba que debe fallar | Criterio |
|---|---|---|---|
| M1 | «Marcar como lista» redirige sin cambiar el estado | recorrido núcleo | E5 |
| M2 | la cronología lee las entradas de la persona sin el alcance | rama negativa | N1 |
| M3 | el resumen lee las entradas de la persona sin el alcance | rama negativa | N1 |
| M4 | el detalle lee la entrada sin el alcance y `show?` no exige autoría | rama negativa | N2 |

### Evidencia que se registra aquí al implementar

#### Registro de la implementación (14/11/2026, local, sin commit)

Todo lo de esta sección se comprobó en **local**, en
`feature/GL-09-e2e-recorrido-nucleo` sobre `9034435`. No hay CI remoto:
no hubo commit ni push.

- **Pruebas primero.** `spec/system/core_journey_spec.rb` se escribió
  antes de la herramienta. Sin Capybara, la carga falló por la razón
  esperada: «capybara is not part of the bundle» (0 ejemplos, 1 error
  fuera de los ejemplos).
- **Herramienta:** `capybara` 3.40.0 y `selenium-webdriver` 4.52.0 en el
  grupo `:test`; el `Gemfile.lock` solo suma sus dependencias
  (`addressable`, `matrix`, `public_suffix`, `rubyzip`, `websocket`,
  `xpath`). Configuración en `spec/support/system_tests.rb`. Con Chrome
  157 local y el `chromedriver` de Selenium Manager (`~/.cache/selenium`),
  las 2 pruebas pasan en unos 8 segundos.
- **Mutaciones**, con copia de seguridad y restauración comprobada por
  SHA-256:

  | # | Prueba que falló | Dónde |
  |---|---|---|
  | M1 | recorrido núcleo | E5: el resumen no tiene la fila de la entrada |
  | M2 | rama negativa | N1: la cronología de L2 no está vacía |
  | M3 | rama negativa | N1: el resumen de L2 no muestra el mensaje vacío |
  | M4 | rama negativa | N2: el detalle por URL directa no es la página 404 |

  M4 conserva la llamada a `policy_scope` y lee del modelo, para que la
  falla se deba a la fuga y no a `verify_policy_scoped`.
- **CI:** paso que sube `tmp/screenshots` si falla el job `test`.
- **Logs:** antes de `bin/ci` se guardaron copias verificadas de
  `log/development.log` y `log/test.log`. En el `log/test.log` de las
  corridas en navegador, los textos de las entradas no aparecen y el
  parámetro `context` figura `[FILTERED]`.
- **Gate local:**
  - `bin/bundler-audit update`: código 0 (1362 avisos);
  - `bin/ci`: código 0, con 317 ejemplos y 0 fallos (315 antes de GL-09);
    RuboCop con 107 archivos sin infracciones, sin vulnerabilidades y
    Brakeman sin advertencias;
  - `openspec validate --all --strict`: 19 de 19.
- **Sin cambios** en el código del producto, rutas, migraciones ni reglas
  de privacidad.

**CI remoto del 14/11/2026:** [PR #6](https://github.com/pablo-wpify/growth-log-ai4devs/pull/6) desde
`feature/GL-09-e2e-recorrido-nucleo` contra `feature/entrega-2-pp`, con
los commits `258eab0` (implementación y documentación) y `2f192ab`
(registro de prompts). GitHub Actions, [ejecución 43634781960](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43634781960): **exitosa** sobre
`2f192abe0441553fe6df58fd0e55b1b65f115faf`, el head del PR, con
`scan_ruby`, `scan_js`, `lint` y `test` en verde. El job `test` corrió
317 ejemplos con 0 fallos, incluidas las 2 pruebas en navegador con el
Chrome de la imagen `ubuntu-latest`: fue su primera ejecución en GitHub
Actions. No hubo capturas, porque no hubo fallos. Vale solo para ese SHA.

**Integración y archivo (14/11/2026):** el [PR #6](https://github.com/pablo-wpify/growth-log-ai4devs/pull/6) se integró en
`feature/entrega-2-pp` con un merge commit, `e0ceb4e94cf66d42d99c4169368f056793d20358`, y el cambio se archivó
como `2026-11-14-gl-09-e2e-recorrido-nucleo`. Se actualizaron las specs vigentes `quality-pipeline` (dos
requisitos nuevos) y `development-environment` («Suite de pruebas única y
efectiva»). El merge tuvo su propio CI al llegar a `feature/entrega-2-pp`:
[ejecución 43635205495](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43635205495), **exitosa** sobre `e0ceb4e94cf66d42d99c4169368f056793d20358`, con los mismos cuatro jobs en verde y 317
ejemplos.

**Hito:** el plan lo fija en GL-09 en verde en el CI. Con eso se alcanza el hito «recorrido núcleo» del plan, que **no equivale** al «primer recorrido usable» del Anexo G (pendiente hasta GL-04) ni cubre el alcance diferido. La consigna
del curso no está en el repositorio y no se contrastó.

## Risks / Trade-offs

- **Inestabilidad del navegador** → esperas de Capybara, sin pausas fijas;
  un solo tamaño de pantalla.
- **Chrome en el CI** → la imagen `ubuntu-latest` lo trae; se comprueba en
  el CI remoto.
- **Pruebas más lentas** → dos pruebas; el resto de la cobertura sigue en
  pruebas de peticiones.
- **Pruebas que pasan siempre** → mutaciones M1 a M4.

## Migration Plan

Sin migraciones ni datos. `bundle install` agrega las gemas de prueba.

## Open Questions

Ninguna.
