# M159. Ficha para cerrar las decisiones de F17

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
| SHA-256 del texto | `35fc6be6785a76006c5f044167d1378cd43a1c6dd11d131d211fe29bafba1215` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M159 | 2026-11-14 13:10:09 |

## Texto original

````text
Prepará una ficha breve para que Pablo cierre las decisiones pendientes de F17 y GL-06. Usá la revisión actualizada de F17 y el estado reciente; no repitas el análisis del checkout.

Estado ya cerrado: `bin/bundler-audit update` y `bin/ci` pasaron (291 ejemplos, 0 fallos), RuboCop pasó, y las copias de logs están verificadas. No propongas repetir esas verificaciones mientras no cambie el código.

Presentá, para cada punto pendiente:
- opciones respaldadas por la evidencia;
- recomendación;
- efecto de cada opción;
- respuesta concreta que tiene que dar Pablo.

Incluí:
1. Si la comprobación asistida por Claude Code cumple «comprobado a mano por Pablo».
2. Si se acepta el iframe de 375 px o se repite con DevTools, y qué controles siguen pendientes.
3. Si alcanza la simulación sin cookie o se verifica un vencimiento real con un POST.
4. El aviso ausente y la conservación del texto, que sigue sin confirmarse; no afirmes que el texto se perdió.
5. Los dos 422 por CSRF: investigarlos o dejarlos como observación.
6. Qué hacer con las entradas ficticias y los logs originales conservados en copias.
7. Qué registrar en diseño y ticket, incluido el arreglo del formulario como desvío.

Separá los requisitos para aceptar F17 de los hallazgos que pueden quedar como seguimiento. No marques decisiones ni tareas como aprobadas.

Solo lectura: no edites archivos, no cambies código, datos o logs; no ejecutes pruebas, validadores ni uses el navegador. No hagas commit, push, CI remoto ni archivo del cambio.
````

## Resultado registrado (no forma parte del pedido)

- **M159:** primera línea de la respuesta final de Claude Code: «Ficha de decisiones pendientes: F17 y GL-06»
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
