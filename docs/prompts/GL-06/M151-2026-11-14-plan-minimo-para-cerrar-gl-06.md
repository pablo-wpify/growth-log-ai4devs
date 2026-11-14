# M151. Plan mínimo para cerrar GL-06

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | plan (solo lectura) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `f566622dac17cb2508727f48d97fb2b9fbfc3021e2cf16269f219e041ebf6f50` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M151 | 2026-11-14 12:44:06 |

## Texto original

````text
Con la revisión actualizada de F17, prepará un plan mínimo para cerrar GL-06. No repitas el relevamiento general del checkout.

Separá:
1. Qué falta para completar y aceptar F17.
2. Qué hallazgos requieren una decisión de Pablo: criterio de «comprobado a mano por Pablo», emulación a 375 px, simulación sin cookie frente a vencimiento real, aviso de sesión y los 422 por CSRF.
3. Qué verificaciones y pasos de entrega quedan después: RuboCop, bin/ci, actualización del diseño y ticket, commit, push, CI remoto y archivo.

Mantené estas distinciones: el paso 16 fue una simulación sin cookie; la pérdida del texto no está confirmada; el paso 15 se emuló con iframe y solo se revisó de nuevo la página de edición. No conviertas recomendaciones en decisiones de Pablo.

Para cada punto, indicá si bloquea cerrar F17 o GL-06, qué evidencia concreta falta y cuál sería el siguiente paso más acotado. No edites archivos ni cambies código, datos o logs; no ejecutes pruebas, validadores ni uses el navegador. No marques tareas como completas ni hagas commit, push, CI remoto o archivo.
````

## Resultado registrado (no forma parte del pedido)

- **M151:** primera línea de la respuesta final de Claude Code: «Plan mínimo para cerrar GL-06»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
