# M136. F17: privacidad con Tomás

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | verificación en navegador |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Escrito directamente en Claude Code. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `ac8a91dbfd2950c195f66370a7039a7729cd936f76536483a4001ec16763d22b` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M136 | 2026-11-14 11:45:45 |

## Texto original

````text
Ya inicié sesión como Tomás. Seguí con el paso 12 de F17: verificá que la ficha de Ada no muestre las entradas de Elena y compará /entradas/1, /entradas/1/editar, /entradas/2 y /entradas/2/editar con /entradas/999999. Registrá los códigos y observaciones. Si algún resultado difiere del 404 esperado, detenete y reportalo. No borres ni modifiques entradas o logs, no cambies documentos y no marques F17 completa.
````

## Resultado registrado (no forma parte del pedido)

- **M136:** primera línea de la respuesta final de Claude Code: «El paso 12 de F17 **pasa**: Tomás no ve ninguna entrada de Elena, y las URL directas de esas entradas dan el mismo 404 que una entrada que no existe. Hice solo pedidos GET; no se modificó ninguna entrada ni ningún log.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
