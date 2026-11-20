# M328. Verificación local de GL-15

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | verificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `d8ba60b0697548363521c2448f650cf3474cc26694000d19e775426a9bf174a6` |
| Fecha y hora (UTC) | 2026-11-18 12:16:34 |

## Texto original

````text
Ahora autorizo ejecutar la verificación local de GL-15. No edites archivos.

1. Ejecutá primero los specs nuevos de request y sistema, junto con los specs de navegación, protección de rutas y cobertura de autorización que se modificaron.
2. Si pasan, ejecutá la suite completa y después bin/ci.
3. No ejecutes `bin/bundler-audit update`; usá la base de avisos que ya está instalada.
4. No hagas stage, commit, push, PR, merge, deploy ni archive.

No imprimas secretos ni valores de .env. Si falta configuración o algún paso requiere acceso que no tenés, detenete y reportalo. Informá cada comando y su resultado, incluidos fallos.
````

## Resultado registrado

**Numeración:** M328, por posición en la transcripción (opción A, decidida
por Pablo en M366).

Specs de GL-15 y relacionadas: 54 ejemplos, 0 fallos. Suite completa:
425 ejemplos, 0 fallos. `bin/ci` en código 0, sin
`bin/bundler-audit update`. Las variables locales se cargaron sin
mostrar valores. Solo local; sin edición de archivos.
