# M173. Preparar el cierre para revisión

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | revisión de Git (solo lectura) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `196b39076190d7a41c7c815ab57abd94eeb00b07039494d46d61b564bbad34b1` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M173 | 2026-11-14 14:14:58 |

## Texto original

````text
Prepará el cierre para revisión, en solo lectura. Trabajá desde la raíz del checkout real.

Inspeccioná la rama y todo el estado local de Git: cambios staged, unstaged y archivos sin seguimiento. Revisá los diffs completos y separá GL-06 de cualquier cambio ajeno. No incluyas secretos en la salida.

Informá:
- raíz del repo y rama actual;
- archivos de GL-06 que entrarían en un commit y archivos ajenos;
- archivos sin seguimiento y su propósito;
- resumen del diff completo de GL-06;
- propuesta de mensaje de commit.

Mantené F17 como parcial y «con datos mínimos» de PT-11 como pendiente. No edites ni registres prompts. No hagas stage, commit, fetch, push, CI remoto, pruebas, validadores, auditorías ni archivo. Esperá mi autorización antes de publicar.
````

## Resultado registrado (no forma parte del pedido)

- **M173:** primera línea de la respuesta final de Claude Code: «Cierre de GL-06 para revisión»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
