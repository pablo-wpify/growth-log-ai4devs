# M121. Informar la implementación y guiar F17

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | informe (solo lectura) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `8b6782bf4d6a1388a9ed1c963d5fd204bd4b3eb4902c0372ec212f775b00e7dc` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M121 | 2026-11-13 19:59:42 |

## Texto original

````text
No cambies archivos ni ejecutes pruebas. En el checkout actual de GL-06, prepará la revisión de la implementación local y la comprobación manual F17.

1. Entregá el informe completo de implementación: estado de Git, base/HEAD, archivos modificados, resumen por grupo, resultados de `bin/ci` y de las seis mutaciones. El informe anterior quedó truncado después del grupo 1; no omitas los grupos restantes ni los riesgos.
2. Prepará pasos concretos para que Pablo ejecute F17 en el navegador:
   - cómo acceder a la aplicación local y qué usuarios/datos de prueba disponibles usar;
   - el recorrido de captura, edición, marcado incompleto y completo, y segundo marcado de una entrada ya lista;
   - la comprobación de privacidad con Elena y Tomás, incluida la URL directa;
   - qué revisar en escritorio y a 375 px;
   - qué ocurre si vence la sesión antes de enviar.
3. Para cada paso, indica el resultado esperado y qué evidencia conviene registrar. Si no podés verificar las credenciales, datos o el estado del servidor leyendo el checkout, decláralo como pendiente; no los inventes.
4. No ejecutes F17 ni la marques como completada. No hagas commit, push, PR, despliegue ni archivado. No modifiques código, documentos ni datos.

Dejá explícito que el CI remoto requiere publicar el código y sigue pendiente de autorización.
````

## Resultado registrado (no forma parte del pedido)

- **M121:** primera línea de la respuesta final de Claude Code: «Informe de la implementación local de GL-06 y guía para la comprobación F17»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
