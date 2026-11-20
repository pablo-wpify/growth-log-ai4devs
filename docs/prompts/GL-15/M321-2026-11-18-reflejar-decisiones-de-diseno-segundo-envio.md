# M321. Reenvío del pedido de decisiones de diseño

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | fase documental (reenvío) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `bd3f3c7b03aecf0a6b13d3cfe03402053aca0ecd16e6ee7ceba1eb43ca77f13a` |
| Fecha y hora (UTC) | 2026-11-18 10:38:47 |

## Texto original

````text
Revisá el borrador de GL-15 («+ Feedback») y actualizá solo su documentación para reflejar las decisiones de diseño acordadas.

Antes de editar:
- Confirmá rama, HEAD, stage y estado del árbol.
- Leé el borrador actual de GL-15 y las secciones relacionadas del plan y de GL-14.
- Conservá todos los cambios ajenos a GL-15. No reemplaces archivos completos si alcanza con ajustar secciones puntuales.

Criterios acordados para GL-15:
1. El formulario se presenta en la ficha de la persona. Usá Turbo Frames, con HTML renderizado por Rails, como mejora progresiva: con Turbo funciona dentro de la ficha; sin JavaScript, el enlace y el formulario funcionan como navegación y página normales.
2. Después de guardar correctamente, se vuelve a la ficha y se muestra un aviso de éxito. Si hay errores de validación, se vuelve a mostrar el formulario con los errores.
3. Las acciones se llaman «Guardar borrador» y «Guardar como lista».
4. En un borrador, señal y dimensión son opcionales. Para guardar como lista, ambas son obligatorias, conforme a P-3.
5. Un estado ausente puede seguir el comportamiento de borrador si eso ya está definido por el modelo vigente. Un valor de estado desconocido debe producir un error de validación; no lo conviertas silenciosamente en borrador.
6. «Captura rápida» conserva su jerarquía actual como acción principal; «+ Feedback» es una acción secundaria común.
7. GL-15 va antes que GL-14 en el orden propuesto. Documentá la superposición de ambos cambios en `people-browsing`: cuando se complete GL-15, ajustá el delta de GL-14 para que ambos requisitos queden compatibles. No edites ahora los documentos de GL-14, salvo que sea imprescindible para corregir un enlace o una afirmación que el propio cambio de GL-15 deje falsa.

Decisión técnica:
- Usá las capacidades de Hotwire/Turbo incluidas en la versión de Rails que ya tiene el proyecto. No actualices Rails ni agregues una SPA, JavaScript personalizado o dependencias nuevas.
- Turbo Frames alcanza para este flujo. No agregues Turbo Streams salvo que el diseño existente muestre una necesidad concreta y la justifiques en el documento.
- Presentá Turbo como decisión de implementación, sin convertirlo en un requisito de producto.

Alcance:
- Actualizá el ticket, proposal, design, tasks y los deltas OpenSpec de GL-15 donde corresponda.
- Conservá como pendientes las decisiones de alcance de bloques futuros; GL-15 no las resuelve.
- No inventes un número de registro para este pedido: la numeración posterior a M284 sigue pendiente.
- No edites `openspec/config.yaml`; informá aparte que está desactualizado, si sigue estándolo.

No implementes código. No ejecutes pruebas ni CI. No hagas stage, commit, push, PR, merge, deploy ni archive.

Al terminar:
- Mostrá el diff completo de los archivos modificados y resumí qué decisión quedó reflejada en cada uno.
- Informá rama, HEAD, stage y estado final de Git.
- Señalá cualquier contradicción o dependencia que no hayas podido resolver sin cambiar GL-14 o el plan.
````

## Resultado registrado

**Numeración:** M321, por posición en la transcripción (opción A, decidida
por Pablo en M366).

Reenvío idéntico de M320 (mismo SHA-256). Sin cambios: se comprobó que
la documentación ya reflejaba las decisiones y que
`openspec validate --all --strict` seguía en 23 de 23.
