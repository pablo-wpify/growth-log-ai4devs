# M156. Preservar copias de los logs

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | preservación de evidencia |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Escrito directamente en Claude Code. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `c58187a95d92776e7882a5a48453ae66a09ad2ae54eec5e54d8bf4e25939aaf6` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M156 | 2026-11-14 12:55:16 |

## Texto original

````text
Preservá copias completas de `log/development.log` y `log/test.log` en el directorio de evidencia de F12. Registrá tamaño y SHA-256 de originales y copias, sin mostrar el contenido de los logs.

No ejecutes `bin/ci`, `bin/setup`, `log:clear`, pruebas, migraciones ni seeds. No alteres los logs originales, las bases ni otros archivos. Cuando termines, informá las rutas, tamaños y hashes, y detenete para que Pablo decida si autoriza correr `bin/ci`.
````

## Resultado registrado (no forma parte del pedido)

- **M156:** primera línea de la respuesta final de Claude Code: «Las copias completas de los dos logs quedaron preservadas en el directorio de evidencia de F12 y son idénticas a los originales: mismo tamaño, mismo SHA-256 y `cmp` sin diferencias.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
