# M406. Instalación de Impeccable y conexión con Google Stitch

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | Revisión de UI de la entrega final |
| Tipo | herramientas de desarrollo |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `24643aff8c0a0cfa2f3071d746ffd338acfe7e7c364f31f734fa02f4cd8b8890` |
| Fecha y hora (UTC) | 2026-11-21 20:06:39 |

## Texto original

````text
Instalá Impeccable y prepará la conexión con Google Stitch para poder revisar la UI de Growlog.

- Instalá Impeccable solo para este proyecto con el método oficial para Claude Code.
- Configurá Stitch mediante su MCP oficial. Seguí la guía oficial y no pongas claves en archivos versionados, no las imprimas ni me pidas pegarlas en el chat. Si hace falta autenticación o una clave, dejame el paso listo para completarlo localmente.
- No subas capturas, código ni datos a Stitch todavía.
- No cambies código ni documentos del producto. No hagas stage, commit ni push.
- Al terminar, verificá que Impeccable aparezca en Claude Code y que la configuración de Stitch esté lista; informá qué quedó instalado, qué falta autenticar y el estado de Git.
````

## Resultado registrado

**Numeración:** M406, por posición en la transcripción (opción A, decidida
por Pablo en M366). M405, el mensaje anterior, se registró dentro de M404.

- **Impeccable 4.10.0:** se instaló con el instalador oficial del README
  de `pbakaus/impeccable` (`npx impeccable install`), solo para este
  proyecto y para Claude Code, sin el hook automático:
  `--providers=claude --scope=project --no-hooks`.
  - Escribió la skill en `.claude/skills/impeccable/` y cinco subagentes
    en `.claude/agents/`.
  - Instaló el motor 0.1.27 en `~/.impeccable/bin/`, fuera del
    repositorio; su SHA-256 coincide con `engine-checksums.txt`.
  - No cambió `.gitignore` ni el código del producto.
- **Stitch:** se configuró su MCP remoto (`https://stitch.googleapis.com/mcp`,
  HTTP, encabezado `X-Goog-Api-Key`) con alcance local de Claude Code, en
  `~/.claude.json`, fuera del repositorio.
  - El encabezado guarda solo la referencia `${STITCH_API_KEY}`; no hay
    claves en archivos versionados.
  - `claude mcp get stitch` lo informa conectado.
  - Falta que Pablo cree la clave en Stitch y defina `STITCH_API_KEY` en su
    entorno local.
  - La guía oficial de Stitch no se pudo leer automáticamente; los datos se
    tomaron de guías coincidentes.
- No se envió nada a Stitch. Sin stage, commit ni push.
