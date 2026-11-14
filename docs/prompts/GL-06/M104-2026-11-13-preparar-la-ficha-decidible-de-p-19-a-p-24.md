# M104. Preparar la ficha decidible de P-19 a P-24

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | ficha de decisiones (solo lectura) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `9197f3dd8054e94bca0653af5811cc3f2fae131504bf35926c1009496056f607` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M104 | 2026-11-13 17:11:13 |

## Texto original

````text
Prepará una ficha **breve y decidible** con lo que Pablo necesita resolver antes de consolidar los documentos de GL-06. Usá los análisis previos y el archivo más reciente como base; no repitas la inspección general.

GL-06 sigue preparado, sin aprobar y sin implementar. P-1, P-2, P-3 y P-11 figuran aprobadas; P-19 a P-24 siguen pendientes. No modifiques el repo.

Para cada decisión, indicá opciones documentadas, recomendación, consecuencia en criterios y archivos, y una respuesta corta que Pablo pueda elegir:

1. **P-19, rutas:** propuesta actual y motivo documentado para no anidar todo bajo la persona.
2. **P-20, autorización:** autoría, asignación activa y persona activa para escribir; lectura propia tras perder la asignación. Señalá la diferencia entre el plan y el diseño de GL-03.
3. **P-21, lista temporal:** agregarla para reabrir borradores; orden más reciente primero o el de P-10; relación con el reemplazo de GL-07.
4. **P-22, captura:** Turbo frame o página propia. Aclaración: el frame era la recomendación original; la página propia es la alternativa de menor alcance. No afirmes cómo se comporta la sesión vencida ni propongas una mitigación técnica como verificada.
5. **P-23, zona horaria:** Argentina para toda la instancia o mantener UTC. Pedí confirmar si todas las cuentas registran hechos en una única zona; menciona las pruebas con `Time.zone.local` como pendientes de verificación.
6. **P-24, lectura sin ficha:** separá tres elecciones: datos mostrados de la persona; campos del contenido propio de la entrada; descubribilidad (a) URL directa, (b) listado mínimo o (c) otra vista. Conservá la ambigüedad entre 4.14, PT-11, plan:308 y Anexo C; no la resuelvas por inferencia.
7. **Entrada ya lista:** segunda solicitud idempotente que vuelve al detalle o rechazo.
8. **Reasignación en PT-11:** mantener fuera de GL-06 la transición “vuelve a editar” —escritura— o incorporarla mediante decisión explícita; el plan asigna la rama de lectura.
9. **Logs:** el requisito de privacidad no se negocia en esta ficha. Indica que falta verificar el log de consultas, sin ofrecer como opción relajar el requisito.

Cerrá con un formulario de respuesta que Pablo pueda completar en una línea por decisión. Separá las decisiones de las verificaciones técnicas. No marques nada como aprobado, no edites archivos, no ejecutes pruebas ni validadores, y no autorices implementación.
````

## Resultado registrado (no forma parte del pedido)

- **M104:** primera línea de la respuesta final de Claude Code: «Decisiones pendientes de GL-06»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
