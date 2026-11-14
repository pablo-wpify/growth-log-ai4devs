# GL-09. Verificación E2E del recorrido núcleo

> Noveno ticket de la entrega 2 de Growth Log. Lugar en la secuencia:
> [plan de la entrega 2](../plan-entrega-2.md). Cambio de OpenSpec:
> [`gl-09-e2e-recorrido-nucleo`](../../openspec/changes/gl-09-e2e-recorrido-nucleo/proposal.md).
> **Estado (14/11/2026): implementado en local, sin commit.** Pablo
> decidió P-4 (ADR-6) y autorizó la implementación local en M202. Gate
> local en verde: `bin/ci` con 317 ejemplos y 0 fallos; mutaciones M1 a M4
> detectadas. Faltan la revisión del cambio, el CI remoto y el archivo.
> Evidencia en el
> [diseño](../../openspec/changes/gl-09-e2e-recorrido-nucleo/design.md#registro-de-la-implementación-14112026-local-sin-commit).
>
> | Tipo | Qué | Registro |
> |---|---|---|
> | Decisiones aprobadas | P-4 (ADR-6) y las dependencias de prueba (14/11/2026, M202) | [14/11/2026](../decisiones/2026-11-14-gl-09-e2e.md) |
> | Cambio de OpenSpec | implementación autorizada en el mismo pedido (M202); revisión humana del cambio pendiente | tarea 0.4 |

## Problema

GL-05, GL-06 y GL-07 cubren el recorrido núcleo con pruebas de peticiones:
cada acción y cada regla de privacidad se prueban por separado, sin
navegador. Nada comprueba que un líder pueda hacer el recorrido completo
por la interfaz, con los enlaces, formularios y botones reales, ni que la
privacidad entre líderes de la misma persona se sostenga en un navegador.
El plan fija el hito «recorrido núcleo» en GL-09 en verde en el CI.

## Objetivo

Una prueba en navegador, en la misma suite y en el CI, que recorre el
núcleo de punta a punta, y una rama negativa en navegador que comprueba
que otro líder de la misma persona no ve la entrada privada, tampoco por
URL directa.

## Origen

| Fuente | Qué exige |
|---|---|
| Plan, sección 5 y fila 9 | resultado de GL-09: recorrido en navegador en el CI y rama negativa de L2; hito «recorrido núcleo» |
| Plan, sección 7 | «E2E en navegador del recorrido completo y rama negativa de L2»: el recorrido funciona por la interfaz |
| P-4 (ADR-6), 14/11/2026 | herramienta: pruebas de sistema de RSpec con Capybara y `selenium-webdriver`, en Chrome sin interfaz |
| README 2.6 (entrega 1) | al menos un recorrido completo en un navegador real. Su recorrido llega hasta compartir: diferido (C11, I4) |
| 4.11, PP-2, PP-3, PP-4 | acompañar a una persona no da acceso a las entradas privadas de otro líder |
| Spec `development-environment` | una única suite, ejecutable con un solo comando |

## Alcance

1. **Herramienta:** `capybara` y `selenium-webdriver` en el grupo `:test`;
   pruebas de tipo `system` de RSpec con Chrome sin interfaz, en
   `spec/system/`, ejecutadas por `bundle exec rspec`.
2. **Recorrido núcleo (L1):** iniciar sesión → «Personas» → elegir la
   persona asignada → «Captura rápida» → «Guardar borrador» → abrir la
   entrada desde la cronología → «Editar»: señal y dimensión → «Guardar
   cambios» → «Marcar como lista» → volver a la ficha y ver la entrada en
   el resumen y en la cronología.
3. **Rama negativa (L2):** con L1 y L2 asignados a la misma persona y una
   entrada lista y un borrador de L1, L2 inicia sesión, abre la ficha y no
   ve ninguna de las dos en el resumen ni en la cronología; por URL
   directa, el detalle de cada una responde la página 404, sin su texto.
4. **CI:** el job `test` de GitHub Actions ya corre `bundle exec rspec`;
   si una prueba en navegador falla, se suben las capturas de pantalla
   que guarda Rails.
5. **Documentación:** requisito de Chrome y cómo correr las pruebas en
   navegador en `docs/desarrollo.md`.

## Exclusiones

- Invitaciones, administración, compartir, filtros, feed y despliegue.
- El E2E hasta compartir y la lectura del destinatario (C11; I4).
- Cambios en reglas de privacidad, rutas, vistas o modelos: GL-09
  verifica lo existente. Si una prueba descubre un defecto, se informa y
  se propone el ajuste; no se corrige en silencio.
- Pruebas en varios navegadores o tamaños de pantalla.

## Criterios de aceptación

| ID | Criterio | Fuente |
|---|---|---|
| E1 | L1 inicia sesión con correo y contraseña en el navegador y llega a «Personas» | plan, GL-09 |
| E2 | Desde «Personas», L1 abre la ficha de una persona asignada y desde ahí la captura rápida | plan, GL-09 |
| E3 | Al guardar la captura, la ficha muestra la entrada en la cronología como «Borrador · solo vos · fuera del resumen», y el resumen todavía no la cuenta | plan, GL-09; 3.3 |
| E4 | L1 completa señal y dimensión y marca la entrada como lista desde su detalle | plan, GL-09 |
| E5 | De vuelta en la ficha, el resumen cuenta la entrada en su dimensión y su señal, y la cronología la muestra como «Lista · solo vos» con su texto | plan, GL-09; 4.1 |
| N1 | L2, asignado a la misma persona, abre la ficha: ni el resumen ni la cronología muestran las entradas de L1, y la página no contiene su texto | plan, GL-09; 4.11, PP-2, PP-4 |
| N2 | L2 abre por URL directa el detalle de la entrada lista y del borrador de L1: ve la página 404, sin su texto | plan, GL-09; 4.9, 4.11, PP-3 |
| S1 | Las pruebas en navegador corren con `bundle exec rspec`, en `bin/ci` y en el job `test` de GitHub Actions, sin Node ni segunda suite | P-4; spec `development-environment` |

## Dependencias

- **GL-05, GL-06 y GL-07 (cerrados):** «Personas», ficha, captura,
  completar, marcar como lista, resumen y cronología.
- **P-4 (14/11/2026, M202):** aprobada.
- **Chrome:** instalado en la máquina local; en GitHub Actions, el de la
  imagen `ubuntu-latest`.

## Riesgos

| Riesgo | Mitigación |
|---|---|
| Pruebas en navegador inestables (esperas, animaciones) | Capybara espera los elementos; las aserciones buscan textos visibles, sin pausas fijas |
| Una prueba en navegador que pasa siempre no verifica nada | mutaciones registradas: cada una rompe una pieza del recorrido o de la privacidad y debe hacer fallar una prueba |
| Chrome ausente o incompatible en el CI | la imagen de GitHub Actions trae Chrome y Selenium Manager resuelve el `chromedriver`; se comprueba en el CI remoto |
| El texto de las entradas en los logs | las peticiones del navegador pasan por el mismo filtrado de parámetros (GL-06) |

## Evidencia prevista

- Pruebas escritas antes de agregar la herramienta y vistas fallar por la
  razón esperada (sin Capybara no hay navegador).
- Mutaciones registradas, con restauración comprobada (ver el diseño).
- `bin/bundler-audit update`, `bin/ci` y `openspec validate --all
  --strict` locales, con los logs preservados antes de `bin/ci`.
- Con autorización de push: CI remoto con su enlace y su SHA.
