# M259. Confirmación de las interpretaciones de P-51 y P-53 en GL-14

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-14` (entrega final) |
| Tipo | fase documental (confirmación de decisiones) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `46ed7a285b8aa2895d22b95d7a67b9ea032c89a22c4421ac3274d62ed396945c` |
| Fecha y hora (UTC) | 2026-11-16 00:06:47 |

**Numeración.** Es el mensaje de Pablo siguiente a M258 en la
transcripción; entre los dos no hay otros pedidos.

## Texto original

````text
En la Entrega Final, registrá mi confirmación de las tres interpretaciones pendientes de GL-14. Antes, verificá que estás en `feature/entrega-final-pp` y revisá el estado de Git para no incluir cambios ajenos. No toques código ni ningún archivo de la Entrega 2.

Ajuste puntual: en P-51 y en los requisitos o documentos que la desarrollan, dejá explícito que búsqueda, filtro por equipo y orden se procesan en el navegador, sobre las personas autorizadas. La selección se pierde al recargar y no se guarda en la URL.

También dejá asentado que:

- El total «N personas que acompañás» cuenta las personas asignadas y no cambia al filtrar.
- El aviso de privacidad aparece una sola vez.
- En el estado sin personas asignadas, el mensaje vacío reemplaza el total y el aviso.

Conservá el resto de GL-14 y GL-13 sin cambios; no apruebes su implementación. Registrá este pedido como el siguiente mensaje libre en `docs/prompts/GL-14/`, actualizá sus índices y verificá que el texto literal y su SHA-256 coincidan.

Ejecutá únicamente `openspec validate --all --strict`. No corras pruebas, CI ni auditorías. No hagas stage, commit, push, PR, merge, deploy ni archivo. Al final, informá los archivos modificados, el resultado de la validación y el estado de Git.
````

## Resultado registrado (no forma parte del pedido)

**Comprobaciones previas:** rama `feature/entrega-final-pp`, HEAD
`eabac8e`; en el árbol solo estaban el borrador de GL-13 y GL-14, sus
registros, `CLAUDE.md` y `prompts.md` de M254 a M258, sin cambios ajenos.

**Confirmadas por Pablo** las tres interpretaciones registradas en M258:

- **P-51:** la búsqueda, el filtro por equipo y el orden se procesan en el
  navegador, sobre las personas autorizadas. La selección se pierde al
  recargar y no se guarda en la URL. Quedó así en el ticket, la propuesta,
  el diseño y el plan; el requisito «Búsqueda, filtro y orden en el
  navegador» de `people-browsing` ya lo decía.
- **P-53:** el total «N personas que acompañás» cuenta las personas
  asignadas y no cambia al filtrar; el aviso de privacidad aparece una
  sola vez; sin personas asignadas, el mensaje vacío reemplaza el total y
  el aviso. Se ajustó el requisito «Total de personas y aviso de
  privacidad» y sus menciones.

**Sin cambios:** el resto de GL-14 y GL-13, la Entrega 2 y el código.
Ninguno de los dos cambios queda aprobado para implementar.

**Validación:** `openspec validate --all --strict`, 22 de 22. Sin pruebas,
CI ni auditorías. Sin stage, commit, push ni archivo.
