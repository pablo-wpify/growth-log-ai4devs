# M111. Mostrar el diff real de la fase documental

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | pedido de diff (solo lectura) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `cde60e74630c5beee027482655dc2c27f4c6c895ca3297a7bf4970b96bdac658` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M111 | 2026-11-13 18:36:52 |

## Texto original

````text
Mostrá el **diff real** de la fase documental de GL-06 para revisión humana. El informe de estado anterior no alcanza: necesito ver el contenido exacto que quedó en el checkout.

## Decisiones ya confirmadas

No las vuelvas a preguntar:

- P-19 a P-24, incluida la interpretación elegida para P-24: solo el nombre de la persona, todos los campos de la entrada propia y acceso por URL directa.
- P-25: marcar como lista una entrada ya lista es idempotente.
- P-26: la reasignación de PT-11 queda fuera de GL-06.
- P-22: página propia.
- P-23: `America/Argentina/Buenos_Aires` para toda la instancia.
- El requisito de privacidad de logs se conserva; la verificación del log de consultas sigue pendiente.

Los números **P-25 y P-26** aún no están confirmados, aunque sí lo están sus decisiones. No los cambies ni los declares aprobados: solo informa si hay colisiones.

## Trabajo de solo lectura

1. Informá rama, HEAD y `git status`. No hagas `fetch`.
2. Si sigue disponible, identificá `~/Descargas/gl06-preparacion-v3.diff` y verificá si su SHA coincide con el reportado. No lo modifiques.
3. Separá claramente:
   - el diff actual del checkout frente a HEAD;
   - la diferencia de la fase documental de M107 respecto de la preparación v3.
4. Incluí los diffs de los archivos GL-06 modificados y el contenido de los archivos nuevos. `git diff` no incluye archivos sin seguimiento: incluilos también, sin agregarlos al índice.
5. Mostrá en particular el contenido actual de:
   - las filas pertinentes de `docs/plan-entrega-2.md`;
   - `docs/decisiones/2026-11-13-gl-06-captura.md`;
   - el encabezado, origen, criterios, riesgos y definición de terminado del ticket;
   - las secciones modificadas de proposal y design;
   - las specs modificadas;
   - el grupo 0 actual de `tasks.md`.

No vuelvas a ejecutar `openspec validate --all --strict`; el último resultado reportado fue 16 válidos y 0 fallidos.

## Revisiones puntuales

- Informá si P-25 y P-26 colisionan con otros identificadores; no decidas por Pablo.
- Comprobá la fuente y el estado de MVP-FE-1 antes de llamar a “sin salir de la página” un criterio incumplido. Si solo fue una propuesta, identificala como tal.
- Confirmá la numeración exacta del grupo 0; no uses una versión anterior como evidencia.
- Separá lo observado en los archivos de lo reportado en ejecuciones previas.

**No modifiques archivos; no marques tareas; no ejecutes pruebas, validadores ni migraciones; no hagas commits, push, archivado ni aprobación de OpenSpec.** Cerrá con los pendientes reales antes de la revisión humana.
````

## Resultado registrado (no forma parte del pedido)

- **M111:** primera línea de la respuesta final de Claude Code: «Diff real de la fase documental de GL-06 (revisión de solo lectura)»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
