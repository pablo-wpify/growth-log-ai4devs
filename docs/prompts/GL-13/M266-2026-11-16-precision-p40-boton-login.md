# M266. Precisión de P-40: el botón y los campos del login

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-13` (entrega final) |
| Tipo | decisión y documentación, con una prueba |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `c44e5912b7bae73dbe98ea6ce554824ca2604ed653f1af187d0a883dff3df7b2` |
| Fecha y hora (UTC) | 2026-11-16 11:35:52 |

## Texto original

````text
Registrá esta precisión de P-40 en GL-13: el botón «Iniciar sesión» conserva el fondo y el borde del botón común, y hereda también su color de texto `#2b2320`. No es un botón principal y no se vuelve terracota. Los campos del login conservan el texto negro; solo comparten el borde y el foco acordados en M264.

Actualizá el plan, el ticket, el diseño y las tareas de GL-13 para que esta distinción quede clara. No reescribas M264; registrá esta decisión como M266, con el texto literal y su SHA-256, y actualizá los índices.

Agregá o ajustá una prueba para comprobar que el texto del botón de login usa el color del botón común y que su fondo no es el terracota principal. No cambies el CSS ni ningún otro comportamiento.

GL-13 sigue implementado en local y sin commit. No modifiques GL-14 ni la Entrega 2. Ejecutá la prueba pertinente y `openspec validate --all --strict`. No corras `bin/ci`, auditorías ni pruebas ajenas. No hagas commit, push, PR, merge, deploy ni archivo. Al final, mostrame el diff y el estado de Git.
````

## Resultado registrado (no forma parte del pedido)

**Precisión de P-40 registrada:**

- **Botón «Iniciar sesión»:** es un botón común, con su fondo, su borde y
  su color de texto `#2b2320`. No es principal ni terracota.
- **Campos del login:** conservan el texto negro. Con la captura rápida
  comparten solo el borde y el foco de M264.

Quedó en el plan (fila de GL-13, P-40 y sección 5), el ticket, el diseño
(secciones 2 y 9, y la nueva 14) y las tareas (3.6). M264 y M265 no se
reescribieron.

**Prueba:** se amplió la del login en `spec/system/visual_language_spec.rb`,
que ahora verifica:

- el color del texto del botón: `rgb(43, 35, 32)`;
- su borde: el del botón común.

Ya comprobaba que su fondo no es el terracota. La prueba pasa, porque el
CSS ya cumplía la precisión. El CSS no cambió.

**Validación (local):** `openspec validate --all --strict`, 22 de 22. No
se corrió `bin/ci`, ni las auditorías, ni otras pruebas, como pidió el
pedido.

**Sin cambios:** GL-14 y la Entrega 2.

Sin commit.

## Evidencia visual: capturas de M265 (agregado en M267)

**Estas capturas no son de M266.** Se tomaron para M265, el 16/11/2026,
después de sus correcciones. M266 solo precisa P-40 y amplía una prueba;
no cambió CSS ni la interfaz. Por eso estas capturas siguen mostrando el
estado de la interfaz que M266 deja sin cambios.

- **Ubicación:** `~/Descargas/gl-13-capturas/m265/`, en la máquina de
  Pablo, fuera del repositorio.
- **Versionado:** las capturas no están versionadas. Los enlaces `file://`
  solo funcionan en esa máquina.
- **Archivos:** se conservan los nombres y los archivos originales, sin
  copiarlos ni renombrarlos. El SHA-256 permite comprobar que son los
  mismos.
- **Cómo se tomaron:** en Chrome sin interfaz gráfica, con 900 px de alto.
  Cada captura muestra lo que se ve en la ventana, no la página entera.
- **Datos:** solo ficticios (`@example.test`).
- **Las que muestran lo que precisa M266:** `1280-login.png`,
  `375-login.png` y las dos con el aviso de fallo. En ellas, el botón
  «Iniciar sesión» es común y no terracota, y en las del aviso el correo
  escrito se ve en negro.

| Archivo | Ancho | Pantalla | SHA-256 |
|---|---|---|---|
| [`1280-login.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/1280-login.png) | 1280 px | inicio de sesión | `375b3c2ecfa9b4bf30568ca0d85400d7a11af3c6f199210862ea398adeb89e93` |
| [`1280-login-aviso.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/1280-login-aviso.png) | 1280 px | inicio de sesión con el aviso de fallo | `59da2e96e5cdf53db855b3b4253ad39a75a92627a0517c2e680c780a9a4d658f` |
| [`1280-personas.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/1280-personas.png) | 1280 px | «Personas» con dos personas | `7dc036db3eaaeef3c1baa4e158e082e4fe1f5635f9137d039fec7053b465ad03` |
| [`1280-personas-vacio.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/1280-personas-vacio.png) | 1280 px | «Personas» sin personas | `2c919ec4fd3314cbb472c2c1757cc971dd2edc1eeb383e6beb1562552c8bcff5` |
| [`1280-ficha.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/1280-ficha.png) | 1280 px | ficha con borrador y entrada lista | `9814f462ba71dcfb39ebefac5ab7c30a0fb942ba965b309b5c7971f5e73b7e4c` |
| [`1280-captura-error.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/1280-captura-error.png) | 1280 px | captura rápida con error | `5968daea417614be93d2557b7d67082b11b2bb5f75b53425eac882f44509a449` |
| [`1280-detalle-borrador.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/1280-detalle-borrador.png) | 1280 px | detalle de un borrador | `471304bde803ec000b13a968a3f9a35af9e9ac548304d1a56a782ce77327bd2f` |
| [`1280-edicion.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/1280-edicion.png) | 1280 px | edición de un borrador | `2d281650a2bfb399c1ba020354a34fa0da5fb1c11fa3af4965984001d1be6f3f` |
| [`375-login.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/375-login.png) | 375 px | inicio de sesión | `fcc7b9b05a8a7f52ed8b92793b4aa836fbe3d3ffe76ede788f460a933e1e219a` |
| [`375-login-aviso.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/375-login-aviso.png) | 375 px | inicio de sesión con el aviso de fallo | `528db048c9d67c9b5316368c2dc0d952ca259b129c888b496583da26500cd597` |
| [`375-personas.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/375-personas.png) | 375 px | «Personas» con dos personas | `f1b80103c6bd86fdae06d7a9b401cd6121fcd531bb2e6e06ddf61d88b19da6a8` |
| [`375-personas-vacio.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/375-personas-vacio.png) | 375 px | «Personas» sin personas | `761f85bf01153a602719306ad9ff923cb9906f999a9525c4f14445ac329838cc` |
| [`375-ficha.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/375-ficha.png) | 375 px | ficha con borrador y entrada lista | `42d0c23f916f6a701c4c29b8fab283e83fa7d34ed5930fa8fe38bade4e0ef7f3` |
| [`375-captura-error.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/375-captura-error.png) | 375 px | captura rápida con error | `c1df6bde711dbef9cb5cc5d69cdff8ca4fdefca436a3ba5b69ac7e71260d5043` |
| [`375-detalle-borrador.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/375-detalle-borrador.png) | 375 px | detalle de un borrador | `b92d92db7848c70aaed985a860e1e1aa98b485b2c0331117feb80fda5555e6c9` |
| [`375-edicion.png`](file:///home/pablo/Descargas/gl-13-capturas/m265/375-edicion.png) | 375 px | edición de un borrador | `8c57c327e0d782ddd9be4d2e88d8f22b40f5fb96028f86376bbc069ca1ed9836` |

## Verificación posterior con `bin/ci` (agregado en M271)

Después de M266, `bin/ci` pasó con código 0 sobre el árbol actual, en
local. Lo pidió [M270](M270-2026-11-16-verificacion-bin-ci-despues-de-m266.md).

- **Setup y preparación de la base de pruebas:** correctos.
- **RuboCop:** 0 ofensas en 122 archivos.
- **Auditorías:** la de gemas, sin vulnerabilidades; la de importmap, sin
  paquetes vulnerables; Brakeman, sin avisos.
- **RSpec:** 403 ejemplos, 0 fallos. Incluye la prueba del login que
  amplió M266.

No se ejecutó `bin/bundler-audit update`, así que la auditoría de gemas
usó la base de avisos local. El árbol de trabajo y los SHA-256 de los
archivos modificados y sin seguimiento quedaron iguales antes y después
de la ejecución. No se comprobó nada en el CI remoto.
