# M265. Correcciones de la revisión visual de GL-13

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-13` (entrega final) |
| Tipo | implementación (corrección dentro de la autorización de M264) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `7dc4624888a1a6f4975f5f10e00a47bb1dc4ae4e635fe1b692c359b74e1dd31c` |
| Fecha y hora (UTC) | 2026-11-16 10:50:16 |

## Texto original

````text
Corregí los hallazgos de la revisión visual de GL-13. Es una continuación de la implementación local ya autorizada en M264. Antes, confirmá la rama `feature/entrega-final-pp`, HEAD y estado de Git; si hay cambios ajenos o el estado no coincide con lo esperado, frená y reportalo.

1. **Cabecera a 375 px:** la spec permite como máximo dos filas, pero la captura muestra tres y la prueba actual permite hasta tres. Conservá el nombre de la cuenta y «Cerrar sesión», ajustá el layout para que entren en dos filas y cambiá la prueba para verificar explícitamente ese límite.
2. **Radios de los formularios internos:** en las capturas aparecen azules, fuera de la paleta aprobada. Aplicá el token terracota de GL-13 a los radios dentro de `body.app`, conservá un foco visible y agregá una prueba que verifique el color calculado. No alteres el login por este cambio.
3. **Texto de los campos del login:** compará el cambio de color con la spec y las pruebas vigentes de GL-11. Si GL-11 exige que todo el estilo del campo coincida con la captura rápida, documentá que ese color también forma parte del estilo compartido y probá esa igualdad. Si no lo exige, conservá el color previo del texto en el login. No amplíes P-40 por inferencia; si la evidencia de GL-11 no resuelve esto, frená y explicá la contradicción.

Actualizá las tareas y la documentación de GL-13 para reflejar la solución, sin alterar M264 como registro histórico. Registrá este pedido como M265 con texto literal y SHA-256, y actualizá los índices.

No cambies GL-14 ni ningún archivo de la Entrega 2. No hagas cambios de contenido o alcance adicionales. Regenerá las capturas afectadas a 375 y 1280 px y revisá que correspondan a los estados correctos.

Ejecutá las pruebas pertinentes, `bin/ci` y `openspec validate --all --strict`. Al final, informá el diff, resultados y estado de Git. No hagas commit, push, PR, merge, deploy ni archivo.
````

## Resultado registrado (no forma parte del pedido)

**Comprobaciones previas:** rama `feature/entrega-final-pp`, HEAD
`eabac8e`, con el mismo árbol que dejó M264 y ningún cambio ajeno.

**Correcciones** (detalle en el diseño, sección 13):

1. **Cabecera a 375 px:** pasa de tres filas a dos. Por debajo de 30 rem
   es una grilla: arriba el nombre y «Personas»; abajo la cuenta y
   «Cerrar sesión», los dos visibles. La prueba ahora exige como máximo
   dos filas.
2. **Radios de los formularios internos:** usan
   `accent-color: var(--accent)`, solo dentro de `body.app`. El foco
   común queda igual. La prueba verifica el color calculado y el foco con
   el teclado.
3. **Texto de los campos del login:** la spec de GL-11 y su prueba
   comparten borde, radio y tipografía (`fontFamily` y `fontSize`), no el
   color. Por eso el login conserva su color previo, `rgb(0, 0, 0)`.
   P-40 no se amplía.

**Pruebas primero:** fallaron 6 ejemplos por las razones esperadas, y
después pasaron.

**Verificación (local):**

- `bin/bundler-audit update`: código 0;
- `bin/ci`: código 0, con 403 ejemplos y 0 fallos, 0 ofensas y Brakeman
  sin avisos;
- `openspec validate --all --strict`: 22 de 22.

Nada se comprobó en el CI remoto.

**Capturas:** se repitieron a 1280 y 375 px, fuera del repositorio.

**Sin cambios:** GL-14, la Entrega 2 y el registro de M264.

**Observación para Pablo:** el texto del botón común del login sigue en
`#2b2320` desde M264, cuando antes era `#1f2328`. M265 no lo pidió y no
se tocó.

**Pendiente:**

- la comprobación manual de Pablo (tarea 3.3);
- commit, push, PR y CI remoto, cada uno con su autorización.

Sin commit.
