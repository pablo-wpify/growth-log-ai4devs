# M361. Corrección de la propuesta antes de la conformidad

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | documentación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | sin marca de texto pegado en la transcripción; origen de la redacción no declarado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `22654cb47e06bc9b926a2cee44512411e564bdbf3cbbc8ac5167a308a8fed7f6` |
| Fecha y hora (UTC) | 2026-11-19 12:23:04 |

## Texto original

````text
Antes de pedirme conformidad con la tarea 0.3, corregí solo las tres imprecisiones señaladas en proposal.md: el estado obsoleto, la frase sobre el modelo y la sección Impact. Aclar á que no cambió el esquema ni la semántica de los estados, aunque se ajustó el mensaje de validación; completá el impacto de las refactorizaciones y cambios de vista/layout/CSS. Conservá la propuesta técnica original y dejá los desvíos de implementación en design.md, sección 8.

Luego mostrame el diff y el contenido íntegro de proposal.md, sin resúmenes, elipsis ni tablas truncadas. No marques la 0.3, no cambies otros archivos y no hagas commit ni push.
````

## Resultado registrado

**Numeración:** M361, por posición en la transcripción (opción A, decidida
por Pablo en M366).

`proposal.md` archivado: estado vigente; en el modelo no cambian el
esquema ni la semántica de los estados, solo el mensaje de validación;
«Impact» completo con las refactorizaciones y los cambios de vista,
layout y estilos. Sin commit.
