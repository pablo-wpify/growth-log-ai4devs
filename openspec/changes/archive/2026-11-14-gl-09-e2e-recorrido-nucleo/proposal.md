# Proposal

## Why

El plan de la entrega 2 fija el hito «recorrido núcleo» en GL-09 en verde
en el CI. GL-05, GL-06 y GL-07 prueban cada acción y cada regla de
privacidad con pruebas de peticiones, pero nada recorre el núcleo por la
interfaz real ni comprueba en un navegador que otro líder de la misma
persona no vea una entrada privada. ADR-6 (herramienta E2E) estaba
abierta; Pablo decidió P-4 el 14/11/2026 (M202). Fuente:
`docs/tickets/GL-09-e2e-recorrido-nucleo.md` y el plan de la entrega 2
(secciones 5 y 7).

## What Changes

- **Herramienta (P-4):** `capybara` y `selenium-webdriver` en el grupo
  `:test`; pruebas de tipo `system` de RSpec en `spec/system/`, con Chrome
  sin interfaz, dentro de la misma suite (`bundle exec rspec`), sin Node.
- **Recorrido núcleo en navegador:** L1 inicia sesión, elige una persona
  asignada, guarda una captura rápida, la completa con señal y dimensión,
  la marca como lista y la ve en el resumen y en la cronología.
- **Rama negativa en navegador:** L2, asignado a la misma persona, no ve
  la entrada lista ni el borrador de L1 en el resumen ni en la
  cronología, y por URL directa el detalle responde la página 404 sin su
  texto.
- **CI:** el job `test` ya corre la suite; si falla, sube las capturas de
  pantalla de las pruebas en navegador como artefacto.
- **Mutaciones registradas** que rompen el recorrido o el alcance y deben
  hacer fallar las pruebas (M1 a M4 del diseño).
- Decisión de Pablo del 14/11/2026: P-4
  (`docs/decisiones/2026-11-14-gl-09-e2e.md`).
- **No incluye:** invitaciones, administración, compartir, filtros, feed,
  despliegue, el E2E hasta compartir (C11, I4), cambios de reglas de
  privacidad, rutas, vistas ni modelos.

## Capabilities

### New Capabilities
<!-- Ninguna: GL-09 verifica capacidades existentes. -->

### Modified Capabilities
- `quality-pipeline`: la suite incluye el recorrido núcleo y la rama
  negativa de privacidad en navegador.
- `development-environment`: las pruebas en navegador son parte de la
  suite única, con Capybara y `selenium-webdriver` sobre Chrome sin
  interfaz.

## Impact

- Dependencias de prueba nuevas: `capybara` y `selenium-webdriver`
  (aprobadas con P-4 en M202).
- Pruebas: `spec/system/core_journey_spec.rb` y la configuración en
  `spec/support/system_tests.rb`.
- CI: paso de capturas de pantalla ante una falla en
  `.github/workflows/ci.yml`.
- Requisito local: Google Chrome instalado (`docs/desarrollo.md`).
- Sin cambios en el código del producto, migraciones ni rutas.
- Implementación autorizada por Pablo en M202, en el mismo pedido que
  preparó este cambio; la revisión humana del cambio queda pendiente
  antes del commit.
