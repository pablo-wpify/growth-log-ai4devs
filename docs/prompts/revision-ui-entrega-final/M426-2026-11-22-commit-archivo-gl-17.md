# M426. Commit local del archivo de GL-17

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | Revisión de UI de la entrega final |
| Tipo | publicación local (commit), sin push |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `bb49220c9584141c794342faa092a858337e0e6abf173e6c4c0fdbb76b877533` |
| Fecha y hora (UTC) | 2026-11-22 13:26:27 |

## Texto original

````text
Autorizo crear el commit local del archivo de GL-17 y sus documentos de cierre. No autorizo el push.

Antes de preparar el stage, verificá que la rama sea `feature/entrega-final-pp`, HEAD `1c2f513` y que el stage esté vacío. Conservá los cambios existentes.

Incluí los cambios del archivo de GL-17: specs principales, carpeta archivada, ticket, plan, tareas, diseño y registros M424 y M425 con sus índices. Registrá también este pedido y su resultado según la convención de `docs/prompts/` (siguiente número por posición).

En `prompts.md`, incluí las actualizaciones de GL-17 y el registro de este pedido, pero dejá la entrada de M403 fuera del stage y del commit. No agregues `.claude/agents/` ni `.claude/skills/impeccable/`.

Revisá la lista y el diff staged para confirmar que no entró M403 ni ningún archivo ajeno. Si coincide, creá el commit con un mensaje acorde a la convención del repositorio. La validación estricta posterior al archivo ya pasó 21/21; no corras pruebas ni `bin/ci`.

Al terminar, informá el SHA del commit y el estado de Git. No hagas push, PR, merge, deploy ni otro archive.
````

## Resultado registrado

**Numeración:** M426, por posición (opción A; ver M407).

- **Verificación previa:** rama `feature/entrega-final-pp`, HEAD `1c2f513`
  y stage vacío.
- **Stage del commit:**
  - el archivo de GL-17: la carpeta
    `openspec/changes/archive/2026-11-22-gl-17-presentacion-listado-personas`,
    con sus tareas y su diseño, y el borrado de la carpeta activa;
  - la spec principal `people-browsing`;
  - el ticket y el plan;
  - los registros M424, M425 y este, con el README de la etapa;
  - las líneas de GL-17 en `prompts.md`.
- **Fuera del stage y del commit:** la entrada de M403 en `prompts.md`,
  `.claude/agents/` y `.claude/skills/impeccable/`.
- **Commit local**, sin push. Este registro va dentro del commit, así que
  no puede contener su propio SHA; queda en la respuesta de M426.
- No se corrieron pruebas ni `bin/ci`. `openspec validate --all --strict`
  había pasado con 21 de 21 en M425. Sin push, PR, merge, deploy ni otro
  archivo.
