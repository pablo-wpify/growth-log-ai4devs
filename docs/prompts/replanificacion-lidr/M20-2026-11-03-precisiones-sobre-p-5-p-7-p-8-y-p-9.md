# M20. Precisiones sobre P-5, P-7, P-8 y P-9

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `replanificacion-lidr` |
| Tipo | corrección |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `ee16339e1999e8eb5132761f4f5428259de4815785ae9992527c20002098c311` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M20 | 2026-11-03 01:35:22 |

## Texto original

````text
El nuevo orden del recorrido me parece adecuado. Antes de aprobar las decisiones de GL-03, precisemos lo siguiente:

1. Mostrá completos P-5, P-7, P-8 y P-9, con sus criterios de aceptación y referencias a requisitos existentes. La tabla del resumen llegó truncada.

2. Revisá P-7 contra PP-9 y AM-1:
   - Diferir la administración de asignaciones no implica cambiar el derecho del autor a consultar sus entradas.
   - Preferimos conservar la regla aprobada.
   - Explicá qué trabajo adicional concreto requiere cumplirla y si realmente bloquea el núcleo.
   - No des por aprobado «sin acceso hasta I5».

3. En P-8 distinguí una única asignación activa por par líder/persona de una única asignación total por persona. No introduzcas accidentalmente una restricción que impida varios líderes.

4. Separá en P-9 el estado activo de la persona del estado de su asignación y del estado de la cuenta del líder. Explicitá qué afecta cada uno.

5. Para P-5, precisá cómo Pundit y sus verificaciones detectarán una autorización o un alcance omitidos. No presentes la mera llamada a authorize o policy_scope como prueba de que la decisión es correcta.

Mantené las demás decisiones como propuestas. En particular, no hagas obligatoria la señal todavía ni amplíes requisitos de tickets posteriores.

No implementes ni hagas commits o push. Devolvé estas precisiones y la recomendación mínima para abrir el change de GL-03.
````

## Resultado registrado (no forma parte del pedido)

Precisiones en el plan y el ticket de GL-03, sin commit en este paso; versionadas en [`93b42ec`](https://github.com/pablo-wpify/growth-log-ai4devs/commit/93b42ec).
