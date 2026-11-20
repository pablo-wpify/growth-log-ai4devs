# M324. Opción B para el aviso al guardar como lista

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | decisión |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | sin marca de texto pegado en la transcripción; origen de la redacción no declarado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `83fddc4904fd4a268007b385e7e199cece846daea7a25b48aa30cb37d39c840b` |
| Fecha y hora (UTC) | 2026-11-18 10:59:52 |

## Texto original

````text
Aplico la opción B para GL-15. En la sección 4.3 del diseño y en la tarea 0.6, aclarà que el aviso «Feedback guardado como lista.» solo confirma que la operación se completó. No debe incluir el texto del feedback ni datos que revelen su contenido o a quién se refiere. El aviso no constituye una excepción al requisito de privacidad.

Actualizá solo la documentación de GL-15 necesaria para reflejarlo. No cambies código, el plan, GL-14 ni openspec/config.yaml. No hagas stage, commit, push, PR, merge, deploy ni archive. Mostrame el diff completo y el estado final de Git.
````

## Resultado registrado

**Numeración:** M324, por posición en la transcripción (opción A, decidida
por Pablo en M366).

Opción B aplicada en la documentación de GL-15, tal como quedó en ese
momento:

- el aviso al guardar como lista quedó documentado como «Feedback
  guardado como lista. Solo vos podés verlo.»: «Feedback guardado como
  lista.» solo confirma la operación, sin el texto del feedback ni datos
  que revelen su contenido o a quién se refiere, y «Solo vos podés
  verlo.» era el texto de ejemplo que acompañaba a la opción B;
- el requisito «Textos que separan "lista" de "compartida"» se conservó
  sin cambios, y por eso el aviso sumaba la frase de privacidad: no era
  una excepción a ese requisito;
- además de la sección 4.3 del diseño y la tarea 0.6, se ajustaron el
  encabezado, la sección 3, la sección 4.2 y el registro del diseño; en
  `tasks.md`, el párrafo de fases y la descripción de la tarea 1.2 (las
  pruebas de peticiones previstas, que pasaron a esperar el aviso
  completo, sin el texto del feedback ni el nombre de la persona y con
  «solo vos»; todavía no había archivos de prueba); el escenario «Guardar
  como lista» del delta de `feedback-capture`; el encabezado de la
  propuesta; y el estado, los criterios y un riesgo del ticket.

`openspec validate --all --strict`: 23 de 23. Sin commit. El texto
exacto del aviso cambió después, en M326.
