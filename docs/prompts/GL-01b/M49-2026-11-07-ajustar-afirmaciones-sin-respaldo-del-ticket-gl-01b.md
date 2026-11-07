# M49. Ajustar las afirmaciones sin respaldo del ticket GL-01b

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-01b` |
| Tipo | pedido de corrección de la documentación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `d12d7d8eec3d825f092fcacd49aed9f0dbfd8e5037632ae5d545b4bb32ee112e` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M49 | 2026-11-07 13:09:27 |

## Texto original

````text
Ajustá las afirmaciones del ticket GL-01b que la revisión M48 dejó sin respaldo persistido. Trabajá en el worktree de GL-01b. No ejecutes pruebas ni actualizaciones; no cambies dependencias, código, OpenSpec ni el plan. No hagas commit, push, PR o merge.

En `docs/tickets/GL-01b-rails-8-1-4-1.md`, revisá:

1. **Línea base de `bin/bundler-audit`:** el log registra 21 avisos, pero no conserva el código de salida. Cambiá la afirmación para describir lo que muestra el log y marca el código como no registrado.
2. **`bundle update rails --conservative`:** el log muestra `Bundle updated!`, pero no guarda el código de salida. No afirmes que terminó con código 0; deja constancia de que el código no quedó registrado.
3. **`bin/ci`:** el log registra `Continuous Integration passed`; el código de salida no se guardó. Conservá el resultado del log y aclará que el código exacto no quedó persistido.
4. **`openspec validate --all --strict`:** `14 de 14` solo se observó en la sesión. Etiquetalo como observado, no respaldado por un log, o quitalo si el formato del ticket no admite esa distinción.

No cambies los resultados que sí están respaldados por logs ni vuelvas a correr comandos para reconstruirlos. Agregá el pedido como M49 y una fila en `docs/prompts/GL-01b/README.md`, sin modificar el texto literal de M38–M48 ni `prompts.md`.

Al terminar, mostrámelos cambios exactos del ticket y confirmá qué resultados siguen sin respaldo persistido. Dejá intactos todos los worktrees y cambios de GL-05.
````

## Resultado registrado (no forma parte del pedido)

- **Línea base:** la salida de `bin/bundler-audit` se describe como
  21 avisos y «Vulnerabilities found!» (`audit-antes.txt`); el código de
  salida figura como no registrado.
- **`bundle update rails --conservative`:** se describe con lo que muestra
  `bundle-update.log` («Bundle updated!»); el código de salida figura como
  no registrado.
- **B6:** se mantiene «Continuous Integration passed» de `bin-ci.log`, con
  la aclaración de que el código de salida exacto no quedó persistido.
- **OpenSpec:** «14 de 14» queda como observado en la sesión, sin respaldo
  en un log.
- No se volvieron a ejecutar comandos. Sin cambios en `Gemfile`,
  `Gemfile.lock`, M38–M48, OpenSpec, el plan, `prompts.md` ni el worktree
  principal; sin commit, push, PR ni merge.
