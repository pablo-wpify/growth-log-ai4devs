# M274. Preparación de GL-13 para la revisión final de publicación

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-13` (entrega final) |
| Tipo | documentación y paquete de revisión |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `3f02392dfdbe41546f085c283511e3b04e5454764d7eea39f3defc84d1fe4cec` |
| Fecha y hora (UTC) | 2026-11-16 13:26:03 |

## Texto original

````text
En feature/entrega-final-pp, prepará GL-13 para una revisión final de publicación. Antes, confirmá rama, HEAD y estado de Git.

Corregí solo documentación de GL-13:

1. Actualizá los estados obsoletos de proposal.md, design.md y tasks.md para reflejar que Pablo autorizó la implementación en M264, GL-13 quedó implementado y verificado localmente, la conformidad visual se registró en M272 y la publicación sigue pendiente de autorización.
   - En tasks.md, los grupos 1–3 ya no deben figurar como no autorizados.
   - Revisá la tarea 0.4. Marcala completa solo si los registros prueban que Pablo revisó el borrador; si no, explicá qué evidencia falta.
   - Conservá como pendientes las tareas de publicación y archivo.
   - No cambies el sentido histórico de los registros M254–M272.

2. En los documentos de GL-13, resolvé los enlaces a archivos de GL-14 que quedarían rotos en un cambio GL-13 aislado. No modifiques ni incluyas archivos de GL-14. Conservá la referencia como texto claro si el destino debe seguir fuera del cambio.

3. Prepará un diff candidato que represente los archivos reales, no extractos:
   - No incluyas un `docs/plan-entrega-final.md` parcial. Dejalo fuera del candidato GL-13 y señalá que el archivo completo es transversal y requiere una decisión aparte.
   - No presentes como archivo completo un `prompts.md` que omita contenido del árbol real. Si corresponde incluir solo hunks de GL-13, preparalos con un índice temporal y dejá intacto el stage real.
   - Incluí el código, las pruebas, los deltas OpenSpec y la documentación propia de GL-13 que hagan falta para revisar ese candidato.
   - Indicá por separado la fuente binaria, que no va en el patch textual.

Ejecutá `openspec validate --all --strict` solo si los cambios documentales lo requieren. No corras pruebas, `bin/ci` ni auditorías.

No modifiques código, GL-14, la Entrega 2 ni `CLAUDE.md`. No hagas stage, commit, push, PR, merge, deploy ni archive.

Al terminar, informá los archivos y hunks incluidos y excluidos, los enlaces que queden pendientes, el resultado de la validación si la ejecutaste y el estado de Git. No infieras autorización para publicar.
````

## Resultado registrado (no forma parte del pedido)

**Comprobaciones previas:** rama `feature/entrega-final-pp`, HEAD
`eabac8e`, stage vacío y el mismo estado que en M273.

**Estados actualizados:**

- **Propuesta y diseño:** implementado y verificado en local, sin publicar.
  Se citan la autorización de M264, M265, M266, `bin/ci` en M270 y la
  conformidad de M272.
- **Tareas:** los grupos 1 a 3 ya no figuran como no autorizados. El
  grupo 4 sigue pendiente.
- **Ticket:** el estado del cambio de OpenSpec.
- **Propuesta, otra corrección:** ya no dice que las pruebas existentes no
  cambian, porque en M264 cambió el color de foco esperado de GL-11.

Los registros M254 a M272 no cambiaron.

**Tarea 0.4: sigue abierta.** Hay revisiones parciales:

- M261, que responde a la revisión de solo lectura de M260;
- M263, «a partir de la revisión de los parches»;
- M264, la autorización «según su documentación».

Ninguna dice explícitamente que Pablo revisó el borrador completo. La
tarea explica qué evidencia falta.

**Enlaces a GL-14:** los cuatro de los documentos de GL-13 pasaron a
texto, con la ruta en código:

- en el ticket, dos;
- en el diseño, uno;
- en el `README.md` de GL-13, uno, a M257.

No se modificó ningún archivo de GL-14.

**Validación:** `openspec validate --all --strict`, 22 de 22. No se
corrieron pruebas, `bin/ci` ni auditorías.

**Candidato:** se preparó en `~/Descargas` con un índice temporal fuera
del repositorio. El stage real no cambió. El candidato contiene los
archivos reales de GL-13 y deja fuera:

- `docs/plan-entrega-final.md`, porque es transversal y requiere una
  decisión aparte;
- de `prompts.md`, el hunk de GL-14 y la viñeta de M248 y M249;
- `CLAUDE.md`;
- todo GL-14.

La fuente binaria se informa por separado.

**Numeración:** M273, el paquete de revisión anterior, prohibía modificar
el repositorio y figura en el README sin archivo propio.

Sin stage ni commit. No se infiere autorización para publicar.
