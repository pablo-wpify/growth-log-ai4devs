# M277. Ajuste del candidato de GL-13 para que sea autosuficiente

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-13` (entrega final) |
| Tipo | documentación y candidato de publicación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `0cf0575e57cf07e0d51c452d5d9420cbea2b47479db1357d8fbde8b99cf442be` |
| Fecha y hora (UTC) | 2026-11-16 15:55:34 |

## Texto original

````text
En feature/entrega-final-pp, hacé este ajuste documental mínimo al candidato GL-13:

- Reescribí la viñeta de M260 en prompts.md para que explique por sí sola que fue una revisión de solo lectura, que el pedido prohibía editar archivos y que el registro quedó pendiente de autorización. Quitá la referencia a M248 y M249, que están excluidos del candidato.
- Comprobá si algún otro texto incluido conserva una referencia que dependa de contenido excluido; corregilo solo si hace falta para que sea autosuficiente.
- Registrá este pedido como M277, sin renumerar mensajes previos, y actualizá los índices de GL-13.
- Regenerá el patch y el resumen del candidato desde eabac8e. Confirmá que el patch aplica y que el índice real sigue intacto.

No cambies código, GL-14, la Entrega 2, CLAUDE.md ni el plan transversal. No corras pruebas, bin/ci ni auditorías. No hagas stage, commit, push, PR, merge, deploy ni archive.

Adjuntá el patch y el resumen para una revisión final. La publicación sigue sin autorización.
````

## Resultado registrado

**Numeración:** M277 coincide con la posición en la transcripción.

**Estado al empezar:** rama `feature/entrega-final-pp`, HEAD `eabac8e`,
stage vacío, índice real igual al de M276.

**Viñeta de M260 en `prompts.md`:** ya no dice «con el mismo motivo y la
misma condición», que remitía a la viñeta de M248 y M249, excluida del
candidato. Ahora dice por sí sola que fue una revisión de solo lectura,
que el pedido prohibía editar archivos y que su registro queda pendiente
de la autorización de Pablo.

**Otras referencias a contenido excluido.** Se revisaron los documentos
incluidos (ticket, OpenSpec, README y registros de GL-13):

- **Corregida:** la fila de M260 en el README de GL-13 terminaba en «como
  M248 y M249». Se quitó la comparación; el resto de la fila ya explicaba
  el motivo.
- **Sin cambios, porque se entienden solas:**
  - los registros de M274 y M276 nombran lo que quedó fuera del
    candidato, M248 y M249 incluidos; son registros históricos y
    describen la exclusión, no dependen de ella;
  - el diseño menciona decisiones de GL-14 (P-53, M258) como hechos
    ajenos a GL-13;
  - las referencias a `docs/plan-entrega-final.md` y a GL-14 son texto con
    la ruta, sin enlace.

**Validación:** `openspec validate --all --strict`, 22 de 22. No se
corrieron pruebas, `bin/ci` ni auditorías.

**Candidato:** regenerado desde `eabac8e` en `~/Descargas` como
`gl-13-candidato-publicacion-m277.patch` y
`gl-13-candidato-resumen-m277.txt`, con un índice temporal. Los hashes
están en el resumen y en la respuesta de este pedido. El índice real no
cambió.

Los registros M254 a M276 no cambiaron. Sin stage ni commit. La
publicación sigue sin autorización.
