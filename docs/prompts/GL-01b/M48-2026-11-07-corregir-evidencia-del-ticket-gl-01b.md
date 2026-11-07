# M48. Corregir la evidencia del ticket GL-01b

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
| SHA-256 del texto | `f3d69bfeee59b3b1fce8fd39f9d70a13eea10e934a8269d5851fe49e4703c433` |
| Numeración | El pedido indica registrarlo como M46. Se numera **M48** por su posición en la transcripción, la convención del registro. M46 y M47 son dos pedidos de revisión de solo lectura que prohibían editar archivos y no están registrados |

| Envío | Fecha y hora (UTC) |
|---|---|
| M48 | 2026-11-07 12:25:25 |

## Texto original

````text
Corregí solo los tres detalles señalados en `docs/tickets/GL-01b-rails-8-1-4-1.md`. Trabajá en `~/code/ai4devs-entrega-1-pp-gl01b`. No ejecutes pruebas ni actualizaciones; no cambies dependencias, código, OpenSpec ni `docs/plan-entrega-2.md`; no hagas commit, push, PR o merge.

1. **SHA-256 de la línea base:** recuperá los valores completos de `sha-antes.txt`. Reemplazá las abreviaturas del ticket. Si ese archivo no está disponible, no inventes valores: marcá los hashes como no verificables y decime qué evidencia falta.
2. **Secciones del lockfile:** corregí la tabla para que no presente `DEPENDENCIES` como sección modificada si `git diff` confirma que no cambió. Conservá la explicación de que la restricción de `rails` en el `Gemfile` sigue igual y de que cambió el requisito de `rails-html-sanitizer` dentro de la especificación de `actionview`.
3. **Evidencia de B5 y B7:** consultá únicamente los logs ya existentes. Ajustá cada afirmación a lo que esos logs prueban. No atribuyas un código de salida si no quedó registrado. Para `/up`, podés referir el `200 OK` registrado en `server.log`; distinguí eso de la respuesta de `curl` si esta no se guardó. Si el resultado de `bin/rails runner` solo quedó en la sesión, identificalo como observado pero no persistido en un log.

Dejá intactos `Gemfile.lock`, el `Gemfile`, todos los registros M38–M45 y los cambios del worktree principal. Registrá este pedido como M46 y actualizá solo el README local de GL-01b según sus convenciones; no toques `prompts.md`. Al terminar, mostrame el diff exacto del ticket y confirmá qué evidencia quedó como no verificable.
````

## Resultado registrado (no forma parte del pedido)

- **SHA-256 de partida:** se reemplazaron las abreviaturas del ticket por los
  valores completos de `sha-antes.txt`.
- **`DEPENDENCIES`:** sale de la lista de secciones modificadas y tiene su
  propia fila «sin cambios», que indica que `rails (~> 8.1.4)` sigue igual.
  Se conserva la fila de la restricción de `rails-html-sanitizer` dentro de
  `actionview`.
- **B5 y B7:** se ajustaron a lo que prueban los logs (`audit-despues.txt`,
  `bin-ci.log`, `brakeman.txt` y `server.log`).
  - Quedan marcados como no registrados: los códigos de salida de
    `bin/bundler-audit` y `bin/brakeman`, las opciones de `bin/brakeman` y la
    respuesta de `curl`.
  - La salida de `bin/rails runner` queda como observada en la sesión, no
    persistida en un log.
- Sin cambios en `Gemfile`, `Gemfile.lock`, M38–M45, OpenSpec, el plan,
  `prompts.md` ni el worktree principal; sin pruebas, actualizaciones,
  commit, push, PR ni merge.
