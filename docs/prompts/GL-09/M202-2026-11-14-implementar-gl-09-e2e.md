# M202. Implementar GL-09: E2E del recorrido núcleo

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-09` |
| Tipo | decisión de P-4, fase documental e implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `bd8fa836a4f97acd99ac6988a74ad1300d5c7fb5202323ba03e2f88b419f271b` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M202 | 2026-11-14 19:41:16 |

## Texto original

````text
Implementá GL-09 completo según el plan de entrega 2.

Usá la recomendación de P-4: pruebas de sistema RSpec con Capybara y selenium-webdriver, en Chrome sin interfaz. El alcance es:
1. E2E en navegador: iniciar sesión, elegir una persona asignada, capturar un borrador, completarlo, marcarlo como listo y comprobar que aparece en el resumen y la cronología.
2. Rama negativa de privacidad: con la sesión de L2, comprobar que no ve la entrada privada de L1 sobre la misma persona.
Primero verificá la rama base y el estado del repositorio. Creá una rama propia desde la versión actual de feature/entrega-2-pp. Revisá el plan, las specs vigentes y las implementaciones de GL-05, GL-06 y GL-07. Prepará el ticket, el registro de la decisión P-4 y el cambio OpenSpec; luego implementá con pruebas primero.

Mantené fuera del alcance invitaciones, administración, compartir, filtros, feed y despliegue. No cambies las reglas de privacidad existentes. Usá datos ficticios para las pruebas.

Antes de bin/ci, preservá los logs que deban conservarse: el Setup de CI los vacía. Corré bin/bundler-audit update, bin/ci y openspec validate --all --strict. Al terminar, informá qué cubre cada prueba, los resultados y cualquier bloqueo.

No hagas commit, push, PR, merge ni archivo del cambio todavía. No agregues requisitos de entrega que no estén en el plan; señalá aparte cualquier diferencia que encuentres con la consigna del curso.
````

## Resultado registrado (no forma parte del pedido)

- **Decisión:** P-4 aprobada (ADR-6); dependencias de prueba `capybara` y `selenium-webdriver` aprobadas con la herramienta. Registro: `docs/decisiones/2026-11-14-gl-09-e2e.md`.
- **Fase documental:** ticket `docs/tickets/GL-09-e2e-recorrido-nucleo.md` y cambio de OpenSpec `gl-09-e2e-recorrido-nucleo` (deltas de `quality-pipeline` y `development-environment`).
- **Implementación local** en `feature/GL-09-e2e-recorrido-nucleo`, sobre `9034435`, sin commit: `spec/system/core_journey_spec.rb` escrita antes de la herramienta (falló por «capybara is not part of the bundle»), configuración en `spec/support/system_tests.rb` y paso de capturas en el CI.
- **Mutaciones M1 a M4:** detectadas y restauradas.
- **Local:** `bin/bundler-audit update` y `bin/ci` con código 0 (317 ejemplos, 0 fallos); `openspec validate --all --strict` con 19 de 19.
- **Pendiente:** revisión humana del cambio; con autorización, commit, push, PR, CI remoto y archivo.
