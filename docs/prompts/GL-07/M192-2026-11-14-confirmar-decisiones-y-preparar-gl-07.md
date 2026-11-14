# M192. Confirmar decisiones y preparar GL-07

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-07` |
| Tipo | decisiones de Pablo y fase documental |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `ebbd1b473ee697b804357ce06aabf14e26412f43baa31c694084b62c53d773c2` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M192 | 2026-11-14 16:12:15 |

## Texto original

````text
Confirmo estas decisiones para GL-07:

- P-10: cronología por fecha del hecho, de la más antigua a la más reciente. Si coinciden, ordenar por created_at e id, ambos ascendentes. Mostrar los borradores propios como «Borrador · solo vos · fuera del resumen»; excluirlos del resumen y del conteo. La cronología reemplaza la sección provisoria «Tus entradas» de P-21.
- Criterio 4.3, parcial: mostrar solo entradas propias y usar el estado existente «… · solo vos». No agregar la columna «Origen»; distinguir las entradas compartidas queda para I4.
- Criterio 4.5: usar el texto «Solo entradas listas. No es un puntaje: reúne evidencia para la conversación».
- Criterio 4.4: mostrar «Todavía no hay entradas listas para el resumen» cuando no haya entradas propias listas. Para una cronología sin entradas, reutilizar «Todavía no registraste entradas sobre <nombre>». Omitir las dimensiones sin datos.
- Criterio 1.15, parcial: cada fila de «Personas» muestra «N entradas listas», incluido «0 entradas listas», contando solo las entradas propias listas.

Registrá las decisiones y prepará el ticket y la propuesta OpenSpec de GL-07, con escenarios de privacidad y la mutación del alcance. Conservá como diferidos los filtros y el origen «compartida con vos»; la prueba E2E y ADR-6 pertenecen a GL-09. Presentame los documentos para revisión antes de implementar.

No escribas código ni pruebas. No ejecutes validadores, no hagas commit ni push.
````

## Resultado registrado (no forma parte del pedido)

- **M192:** primera línea de la respuesta final de Claude Code: «Registré tus decisiones y preparé el ticket y el cambio de OpenSpec de GL-07 para que los revises. El cambio **no está aprobado**: no escribí código ni pruebas, no ejecuté validadores y no hice commit ni push.»
- Quedó una pregunta abierta (el texto del conteo con 1), respondida en M193.
