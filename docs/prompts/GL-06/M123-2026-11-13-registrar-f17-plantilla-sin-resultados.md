# M123. Registrar F17 (plantilla sin resultados)

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | pedido de registro sin resultados |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `a0747c908a0f44d022041d97129e98c1ecc78575b7e67a565550b1e73e50eb18` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M123 | 2026-11-13 20:22:38 |

## Texto original

````text
Registrá en GL-06 la comprobación manual F17 que hice. Usá solo los resultados que pego abajo; no completes pasos por inferencia ni marques como exitoso algo que no comprobé.

[Pegá fecha, pasos realizados, resultado observado, URLs, anchos usados y capturas. No incluyas contraseñas.]

Actualizá únicamente el registro de evidencia de `design.md` y el estado correspondiente en el ticket GL-06. Indica que la comprobación fue manual y que los 375 px se emularon. Para la sesión vencida, registra el método utilizado y qué pasó con el texto; si borré la cookie, aclara que simulé una petición sin sesión.

Si algún paso falla o no se pudo comprobar, déjalo explícito y no declares F17 completa. No ejecutes pruebas, lint ni migraciones. No hagas commit, push, CI remoto ni archivado.
````

## Resultado registrado (no forma parte del pedido)

- **M123:** primera línea de la respuesta final de Claude Code: «No registré nada: el pedido trae la plantilla, pero no los resultados. Donde tendrían que estar aparece solo el marcador:»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
