# M167. Ajustar la propuesta del ticket

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | ajuste de propuesta (scratchpad) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `cc5d45ef05a246b91718aef404dba6c816fffd9c0ae8a76abe4f9297b1cef76e` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M167 | 2026-11-14 13:43:04 |

## Texto original

````text
Ajustá únicamente la propuesta del ticket de GL-06 en scratchpad y regenerá su diff. No edites el ticket del repositorio ni otros documentos.

En «Verificaciones técnicas», reemplazá la referencia a «sesión vencida al enviar la captura: verificada en el servidor» por:

«Petición sin sesión válida: en una simulación sin cookie, el servidor redirigió al inicio de sesión y no creó una entrada. El vencimiento real y la conservación del texto siguen sin comprobarse.»

En el riesgo «La sesión vence antes de enviar la captura», ajustá la descripción para que exprese esos mismos hechos y límites. No la presentes como prueba de vencimiento real. No digas «prueba de peticiones» ni «verificada en el servidor» salvo que identifiques evidencia concreta que respalde esa afirmación.

Conservá el resto del contenido. Compará la propuesta con su original para confirmar que solo cambió esa redacción; informá el diff resultante. No ejecutes pruebas ni validadores y no hagas commit, push ni archivo.
````

## Resultado registrado (no forma parte del pedido)

- **M167:** primera línea de la respuesta final de Claude Code: «Ajusté la propuesta del ticket en el scratchpad y regeneré su diff. Respecto de la versión anterior de la propuesta, solo cambiaron las dos líneas que pediste; el resto quedó igual. El ticket del repositorio no lo toqué.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
