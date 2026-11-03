# M30. Recuperar y versionar los pedidos

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `registro-prompts` |
| Tipo | aprobación e implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `585616b202612c5f0a9ae9a3324e93fa2b5977eeab5f7431c695d60906b274d6` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M30 | 2026-11-03 11:14:47 |

## Texto original

````text
Apruebo recuperar y versionar los pedidos literales disponibles, con la organización propuesta.

Acepto publicar las rutas de proyecto ~/code/... y el nombre público pablo-wpify que contienen esos pedidos. No autoriza publicar secretos ni transcripciones completas.

Confirmo como declaración de Pablo: los prompts se prepararon con ChatGPT en una conversación de acompañamiento y después se pegaron en Claude Code. Esa conversación no está aportada como archivo y su modelo no está verificado.

Antes de editar:
- Conservá intacto el trabajo pendiente de GL-05.
- Creá una rama documental docs/prompts-entrega-2 desde eacb16e, preferentemente en un worktree separado para no mover ni mezclar los cambios de GL-05.
- No uses reset ni descartes archivos.

Recuperación:
- Guardá únicamente los mensajes originales del usuario disponibles en la transcripción autorizada de esta sesión.
- No copies salidas de herramientas, contraseñas, razonamientos internos ni transcripciones completas.
- No uses el resumen automático como fuente literal.
- Conservá los textos originales y separalos claramente de metadatos y resultados.
- Registrá los envíos repetidos con sus fechas, sin fingir que fueron un único envío.
- Aclará la numeración: el informe menciona 28 pedidos y luego un pedido 29 de inventario. Distinguí los conteos y registrá también este pedido.
- Incluí el prompt de planificación de GL-05 como pedido enviado, sin incorporar sus cambios de implementación o planificación pendientes.

Actualizá prompts.md como índice sin alterar el contenido histórico de la entrega 1, y agregá la regla de registro a CLAUDE.md.

En adelante, guardá el prompt al comenzar y los resultados en una sección separada al terminar. No conviertas un texto redactado u omitido en «literal íntegro».

Comprobá fidelidad contra los mensajes fuente, enlaces, ausencia de secretos y git diff --check. Prepará por nombre y hacé un commit documental local.

No hagas push ni abras PR todavía. Informá la rama, commit, conteos recuperados, omisiones y estado intacto de GL-05. Después publicaremos esta rama mediante PR hacia feature/entrega-2-pp.
````

## Resultado registrado (no forma parte del pedido)

Esta rama, `docs/prompts-entrega-2`, creada desde `eacb16e`, con un commit documental local; ver su historial.
