# M414. Numeración de M410 en el diseño de GL-17

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | Revisión de UI de la entrega final |
| Tipo | corrección del registro de prompts |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `eb5b5c98fc76eaefc436c3b6ad93cabf3515265dcd3c7bc50c33a979154d56f5` |
| Fecha y hora (UTC) | 2026-11-21 21:41:16 |

## Texto original

````text
Corregí la referencia de numeración en openspec/changes/gl-17-presentacion-listado-personas/design.md, donde M410 todavía figura como provisional.

Dejala como numeración por posición, confirmada por Pablo en M412 y M413, en coherencia con M407, M408, M409 y M410. No cambies ninguna otra decisión ni el contenido del diseño.

Registrá este pedido y el resultado como M414, y actualizá el README de la etapa y prompts.md. Verificá que no queden referencias que presenten M410 como provisional o la numeración como pendiente.

Informá rama, HEAD y estado de Git antes y después. No corras validaciones ni pruebas, y no hagas stage, commit, push, PR, merge, deploy ni archive.
````

## Resultado registrado

**Numeración:** M414, por posición (opción A; ver M407).

- **Estado antes y después:** rama `feature/entrega-final-pp`, HEAD
  `63b86d0`, stage vacío y los mismos siete cambios sin commit.
- **Diseño de GL-17**
  (`openspec/changes/gl-17-presentacion-listado-personas/design.md`,
  sección «Registro», entrada M410): la viñeta que decía que M410 era un
  número provisional ahora dice que la numeración es por posición,
  confirmada por Pablo en M412 y M413, como en M407 a M410. No cambió
  ninguna otra parte del diseño.
- **Verificación:** no quedan referencias que presenten M410 como
  provisional ni la numeración como pendiente. Solo quedan en los textos
  originales de M410 y M413, que son literales y no se tocan.
- Sin validaciones ni pruebas, y sin stage, commit, push, PR, merge,
  deploy ni archivo.
