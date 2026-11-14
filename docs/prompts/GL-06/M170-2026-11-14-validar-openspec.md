# M170. Validar OpenSpec

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | validación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Escrito directamente en Claude Code. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `80740e14d65b89cde3cdef47b4c616d6250fa20f8bd2da4b356f5595182cf7a1` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M170 | 2026-11-14 13:57:55 |

## Texto original

````text
Ejecutá únicamente `openspec validate --all --strict` sobre el estado actual. No edites nada.

Informá el resultado y cerrá el estado local como: implementación lista, gate local previo en verde, documentación actualizada y F17 parcial. Mantené explícitos como pendientes F17 y la interpretación de «con datos mínimos» de PT-11. No marques F17 completa ni cambies tareas, plan o README. Sin pruebas, commit, push, CI remoto ni archivo.
````

## Resultado registrado (no forma parte del pedido)

- **M170:** primera línea de la respuesta final de Claude Code: «`openspec validate --all --strict` pasó: código de salida 0, con 16 elementos válidos y 0 fallidos. Entre ellos está `change/gl-06-captura-rapida`, con el diseño ya actualizado.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
