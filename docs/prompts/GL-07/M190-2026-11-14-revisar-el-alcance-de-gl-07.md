# M190. Revisar el alcance de GL-07

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-07` |
| Tipo | revisión de alcance (solo lectura) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `17a623be6ddb0601d42a0e4294148c4d575b6d8a2e20aeec9f8160a4c3486ff0` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M190 | 2026-11-14 15:56:46 |

## Texto original

````text
Empezamos GL-07 para la entrega 2. Hacé primero una revisión de alcance, solo lectura, desde el checkout actual.

Revisá el ticket, el plan y las specs de GL-07, además de ADR-6 y P-10. Informá:
- alcance y criterios exactos;
- qué depende de GL-06, P-2, P-10 y ADR-6;
- las opciones exactas pendientes de ADR-6 y P-10, con sus efectos documentales y técnicos;
- qué corresponde a GL-07 y qué queda para GL-09;
- pruebas y evidencia exigidas para GL-07.

El alcance conocido es resumen y cronología sobre entradas propias. Los criterios 4.2, 4.3 y 4.13 aplican solo a entradas propias; las pruebas E2E de navegador corresponden a GL-09. No trates el feedback de los profes como prerrequisito.

No inventes alternativas si los documentos no las especifican. No edites archivos, no implementes, no registres decisiones, no ejecutes pruebas ni validadores, y no hagas fetch, commit o push. Presentame los bloqueos y una recomendación antes de empezar a cambiar archivos.
````

## Resultado registrado (no forma parte del pedido)

- **M190:** primera línea de la respuesta final de Claude Code: «GL-07: revisión de alcance (solo lectura)»
