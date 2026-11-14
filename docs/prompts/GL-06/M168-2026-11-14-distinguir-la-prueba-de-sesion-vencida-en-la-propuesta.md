# M168. Distinguir la prueba de sesión vencida en la propuesta

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
| SHA-256 del texto | `5530cc3623527b84f70c76e0b9c2187ee85123b6a603de9cd14c8c7ffb83f0b7` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M168 | 2026-11-14 13:46:01 |

## Texto original

````text
Actualizá únicamente la propuesta del ticket en scratchpad y regenerá ticket.diff. No edites el ticket del repositorio, la copia de Descargas ni otros documentos.

En «Verificaciones técnicas», distinguí estos dos resultados:
- La prueba de peticiones «captura con la sesión vencida» adelanta el reloj 2 horas y 1 segundo y verifica la redirección al inicio de sesión, que no se crea la entrada y que no se recuerda la URL del POST.
- En F17, el navegador solo se probó con una simulación sin cookie. No se comprobó allí un vencimiento real ni si el texto se conserva.

Ajustá también el riesgo «La sesión vence antes de enviar la captura» para expresar esa distinción. Conservá como no comprobados en navegador el vencimiento real y la conservación del texto; no presentes la simulación sin cookie como prueba manual de vencimiento.

Dejá todo lo demás intacto. Compará el resultado con el original, informá el diff y confirmá que solo cambió esa redacción. No ejecutes pruebas ni validadores; no hagas commit, push ni archivo.
````

## Resultado registrado (no forma parte del pedido)

- **M168:** primera línea de la respuesta final de Claude Code: «Actualicé la propuesta del ticket en el scratchpad y regeneré `ticket.diff`. Frente a la propuesta anterior solo cambiaron las dos líneas pedidas; el resto quedó intacto.»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
