# M278. Publicación de GL-13

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-13` (entrega final) |
| Tipo | publicación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `d8c4225f311f5fff7b69237def4187f93a3021bd8ff5927d05c391edf048afc9` |
| Fecha y hora (UTC) | 2026-11-16 16:05:15 |

## Texto original

````text
Pablo autoriza avanzar con la publicación de GL-13 usando el candidato M277. El plan transversal queda fuera para una publicación documental posterior.

En feature/entrega-final-pp:

1. Antes de actuar, verificá rama, HEAD e índice. Esperá eabac8e y stage vacío. Confirmá que ~/Descargas/gl-13-candidato-publicacion-m277.patch tenga SHA-256 46f87f63e23dcdbe4798f8098bad4d8fefd66e219a27671677c88edfde37e4be.
2. Aplicá al stage únicamente ese candidato, incluida su selección parcial de prompts.md. Sumá por separado app/assets/fonts/noto-serif-display/NotoSerifDisplay-Regular.ttf, verificando SHA-256 bcdc596729c24044e28c54815ecbe6004f83b10169a49a51160b22f59116249f.
3. Revisá el diff staged completo y confirmá que no incluya GL-14, CLAUDE.md, docs/plan-entrega-final.md, la Entrega 2 ni archivos ajenos. Si hay cualquier discrepancia, detenete antes del commit.
4. Si coincide, hacé el commit de GL-13, push de feature/entrega-final-pp y creá el PR. No incluyas el plan transversal.
5. Esperá el CI remoto y reportá el SHA del commit, el enlace del PR y el resultado/enlace del CI. Si falla, informá el fallo y detenete.

No hagas merge, deploy ni archive. No vuelvas a correr bin/ci local: pasó en M270 y desde entonces solo cambiaron documentos. No actualices dependencias ni bundler-audit.
````

## Resultado registrado

**Registro posterior:** se registró en M280, después de la publicación,
porque el pedido no pedía registrarlo y el commit ya estaba hecho.

**Comprobaciones previas:** rama `feature/entrega-final-pp`, HEAD
`eabac8e`, stage vacío. SHA-256 del candidato de M277:
`46f87f63e23dcdbe4798f8098bad4d8fefd66e219a27671677c88edfde37e4be`, el
esperado. SHA-256 de la fuente:
`bcdc596729c24044e28c54815ecbe6004f83b10169a49a51160b22f59116249f`, el
esperado.

**Stage:** se aplicó el candidato con `git apply --cached`, incluida la
parte de GL-13 de `prompts.md`, y se sumó aparte la fuente. Quedaron 31
archivos, iguales uno por uno al candidato verificado en M277 más la
fuente. El diff no incluía GL-14, `CLAUDE.md`, el plan, la Entrega 2 ni
archivos ajenos.

**Publicación:**

- **Commit:** `c7d41654dc6549602d6f99ade854ad16efd42bc9`, «feat: GL-13
  dirección visual de la aplicación».
- **Push:** `feature/entrega-final-pp` a `growth-log-publico`
  (`pablo-wpify/growth-log-ai4devs`), con la cuenta `pablo-wpify`.
- **PR:** [#8](https://github.com/pablo-wpify/growth-log-ai4devs/pull/8),
  con base `feature/entrega-2-pp`, la única rama remota que apuntaba a
  `eabac8e`. Así el PR muestra solo GL-13.
- **CI remoto:**
  [run 43903787327](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43903787327),
  en verde: 403 ejemplos y 0 fallos, con los cuatro jobs aprobados
  (`test`, `lint`, `scan_ruby` y `scan_js`).

No se corrió `bin/ci` local ni se actualizaron dependencias. Quedaron
fuera, en el árbol: `CLAUDE.md`, el plan transversal, GL-14 y, de
`prompts.md`, la fila de GL-14 y la viñeta de M248 y M249. Sin merge,
deploy ni archivo.
