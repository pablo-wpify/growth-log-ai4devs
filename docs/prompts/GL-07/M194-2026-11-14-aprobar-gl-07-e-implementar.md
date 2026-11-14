# M194. Aprobar el cambio de GL-07 e implementarlo

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-07` |
| Tipo | aprobación del cambio de OpenSpec e implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `8fe529421a8f8556c9d10e00aeffc48e0d38d10dd9b0e775bf26bd3dc3cb6984` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M194 | 2026-11-14 16:38:03 |

## Texto original

````text
Apruebo el cambio de OpenSpec GL-07 tal como quedó y autorizo empezar la implementación local en feature/GL-07-resumen-cronologia, basada en fda2cec.

Seguí tasks.md en orden y escribí cada prueba antes del código, comprobando que falle por la razón esperada. Mantené GL-09 y ADR-6 fuera de este trabajo. F17 de GL-06 y PT-11 conservan el estado documentado.

No hagas commit, push, CI remoto ni archivo del cambio. Si el checkout o la base no coinciden con lo indicado, detenete y reportalo.
````

## Resultado registrado (no forma parte del pedido)

- **Aprobación:** el cambio de OpenSpec quedó aprobado el 14/11/2026; tarea 0.4 marcada.
- **Implementación local** en `feature/GL-07-resumen-cronologia`, sobre `fda2cec`, sin commit, siguiendo los grupos 1 a 6 de `tasks.md`, con las pruebas escritas antes del código. Desvío: las pruebas del grupo 4 pasaron en la primera ejecución porque la tarea 1.2 ya implementó el conteo; se comprobó que fallan contra tres implementaciones rotas a propósito.
- **Mutaciones M1 a M4:** detectadas y restauradas.
- **Local:** `bin/bundler-audit update` y `bin/ci` con código 0 (315 ejemplos, 0 fallos); `openspec validate --all --strict` con 18 de 18.
- **Pendiente:** con autorización, commit, push, CI remoto y archivo del cambio.
