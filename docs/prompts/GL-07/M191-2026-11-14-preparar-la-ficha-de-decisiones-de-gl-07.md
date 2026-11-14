# M191. Preparar la ficha de decisiones de GL-07

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-07` |
| Tipo | ficha de decisiones (solo lectura) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `0ff85c732e2a688efac4ca6e71b20b309b83d3613918b03fbcb9c182d03fffe8` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M191 | 2026-11-14 16:07:05 |

## Texto original

````text
Prepará una ficha breve de decisiones para destrabar GL-07, usando solo las fuentes del checkout. No repitas la inspección general.

Concentrate en:
1. P-10: confirmar la recomendación del plan y sus efectos; proponer un desempate determinista para fechas iguales, respaldado por el esquema o el comportamiento existente.
2. Criterio 4.3: precisar qué puede cumplir GL-07 si solo incluye entradas propias y las compartidas están diferidas. Separá el alcance parcial de cualquier requisito futuro.
3. Criterios 4.4 y 4.5: identificar qué textos o comportamientos faltan definir.
4. Criterio 1.15: precisar dónde aparece el conteo en «Personas», según los documentos.

Para cada punto, incluí opciones documentadas, recomendación, impacto técnico y documental, y una respuesta concreta que yo pueda aprobar. Si las fuentes no respaldan una opción, indicá que falta información; no la inventes.

No incluyas ADR-6: corresponde a GL-09. No trates el feedback de los profes como prerrequisito. No edites archivos, no registres decisiones, no implementes ni ejecutes pruebas o validadores.```
````

## Resultado registrado (no forma parte del pedido)

- **M191:** primera línea de la respuesta final de Claude Code: «Ficha de decisiones para destrabar GL-07»
