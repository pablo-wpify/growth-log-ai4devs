# M263. Correcciones documentales del aviso de privacidad de la ficha en GL-13

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-13` (entrega final) |
| Tipo | corrección documental |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `fc3203a4bd6d4d14dcc8e217582d4689b0782180e05fc4cc0ca28dd224c73430` |
| Fecha y hora (UTC) | 2026-11-16 00:43:40 |

**Numeración.** Entre M261 y este pedido está M262, que pidió copiar los
diffs a `~/Descargas` (ver el índice).

## Texto original

````text
Hacé dos correcciones documentales puntuales en GL-13 a partir de la revisión de los parches. Antes, confirmá que estás en `feature/entrega-final-pp`, en `eabac8e` o en un commit posterior que solo contenga los borradores esperados. Revisá `git status`; si hay cambios ajenos, frená.

1. En el delta `people-browsing` de GL-13, limitá el requisito a mostrar una sola vez el aviso breve de privacidad y a no mostrar el panel expandible «Quién ve qué». No prohíbas otros textos de privacidad: deben conservarse las etiquetas por entrada que ya exige la aplicación, como «Lista · solo vos» y «Borrador · solo vos · fuera del resumen».
2. En `visual-language`, aclarà que la presentación no cambia por sí sola las acciones ni los textos existentes, con una excepción explícita: el aviso nuevo exigido por el delta de `people-browsing`. Ajustá su escenario para que esa excepción no contradiga la comparación antes/después.

Actualizá solo las referencias necesarias en los documentos de GL-13 para mantenerlos coherentes. No reabras ni cambies las decisiones P-34 a P-40. GL-14 y la Entrega 2 deben permanecer intactos; no toques código.

Registrá este pedido como el siguiente mensaje libre de GL-13, con el texto literal y su SHA-256, y actualizá los índices correspondientes. Conservá M261 como registro histórico, sin reescribirlo; M260 sigue pendiente de autorización.

Ejecutá únicamente `openspec validate --all --strict`. No corras pruebas, CI ni auditorías. No hagas stage, commit, push, PR, merge, deploy ni archivo. Al final, mostrame el diff actualizado y el estado de Git; la implementación de GL-13 y GL-14 sigue sin autorizarse.
````

## Resultado registrado (no forma parte del pedido)

**Comprobaciones previas:** rama `feature/entrega-final-pp`, HEAD
`eabac8e`, con solo el borrador de GL-13 y GL-14 en el árbol.

**Correcciones:**

- **Delta de `people-browsing` (GL-13), «Aviso de privacidad en la
  ficha»:** exige el aviso breve una sola vez y prohíbe solo el panel
  expandible «Quién ve qué». Ya no prohíbe otros textos de privacidad, y
  exige conservar las etiquetas por entrada («Lista · solo vos» y
  «Borrador · solo vos · fuera del resumen»), con un escenario nuevo.
- **`visual-language`, «La presentación no cambia el comportamiento»:**
  la presentación no cambia por sí sola las acciones ni los textos
  existentes, con una única excepción: el aviso de la ficha. El escenario
  antes y después lo admite como único texto nuevo.
- **Referencias:** CA9 y CA10 del ticket, la propuesta, el diseño (7.3 y
  registro) y las tareas (1.3 y 0.6b).

**Sin cambios:** P-34 a P-40, M261, GL-14, la Entrega 2 y el código.
M260 sigue pendiente de autorización.

**Validación:** `openspec validate --all --strict`, 22 de 22. Sin pruebas,
CI ni auditorías. Sin stage, commit, push ni archivo. La implementación
de GL-13 y GL-14 sigue sin autorizarse.
