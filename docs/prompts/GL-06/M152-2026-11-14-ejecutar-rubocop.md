# M152. Ejecutar RuboCop

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | verificación local |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Escrito directamente en Claude Code. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `1e5844e541ac83586f37d1d833f3cfc3b963e8e7b60a4fc4440306c52a32822a` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M152 | 2026-11-14 12:48:30 |

## Texto original

````text
En el checkout actual de GL-06, ejecutá únicamente `bin/rubocop`, sin autocorrección.

Informá el comando, código de salida y cualquier infracción. No corras `bin/ci`, pruebas, migraciones ni validadores; no edites archivos, datos, logs o documentos. Si RuboCop propone o requiere cambios, detenete y reportalos. No hagas commit ni push.
````

## Resultado registrado (no forma parte del pedido)

- **M152:** primera línea de la respuesta final de Claude Code: «RuboCop pasó sin infracciones.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
