# prompts.md — Growth Log

Índice de los registros de prompts. La entrega 2 se registra por etapa en
[docs/prompts/](docs/prompts/); la entrega 1 se conserva abajo sin cambios.

## Entrega final

Índice vivo de la entrega final. Usa el mismo procedimiento literal que la
entrega 2: un registro por etapa en [docs/prompts/](docs/prompts/). La
sección «Entrega 2» queda cerrada y no se modifica. La secuencia está en
el plan de la entrega final, `docs/plan-entrega-final.md`. Ese plan es
transversal: quedó fuera de los commits de GL-13 y se versiona en el mismo
cambio que este índice.

| Etapa | Mensajes | Resultado | Registro |
|---|---|---|---|
| GL-13. Dirección visual | M250–M257, M261–M287 | borrador SDD con el ticket, el cambio `gl-13-direccion-visual` (capability nueva `visual-language`) y el plan de la entrega final con P-34 a P-40 abiertas; M250 fue reemplazado por M254 (M254). Mejoras propuestas del listado «Personas», con deltas de `people-browsing`, `feedback-capture` y `authorization` y P-41 a P-45 abiertas; la referencia la confirmó M256 (M255 y M256). `openspec validate --all --strict` en verde; sin implementar y sin commit. Separado en M257: las mejoras funcionales del listado pasaron a GL-14, y P-36 y P-37 quedaron resueltas. P-34, P-35 y P-38 a P-40 decididas, con un delta `ADDED` de `people-browsing` para el aviso de la ficha y sin autorizar la implementación (M261). Diffs copiados a `~/Descargas` (M262). Redacción del aviso de la ficha corregida en `people-browsing` y `visual-language` (M263). Implementación autorizada; la contradicción entre P-40, P-34 y la spec de GL-11 se resolvió con Pablo y GL-13 quedó implementado en local, con `bin/ci` en código 0 y 400 ejemplos, sin commit (M264). Corregidos los hallazgos de la revisión visual: la cabecera a 375 px en dos filas, los radios internos en terracota y el color previo del texto de los campos del login, que GL-11 no comparte; sin commit (M265). P-40 precisada: «Iniciar sesión» es un botón común, con su color de texto `#2b2320`, y los campos del login conservan el texto negro; prueba ampliada, sin cambios de CSS (M266). El registro de M266 enlaza las 16 capturas de M265 (`~/Descargas/gl-13-capturas/m265/`, fuera del repositorio) como evidencia del estado sin cambios (M267). Pregunta sobre las capturas (M268) y revisión final de solo lectura (M269). `bin/ci` con código 0 después de M266: 403 ejemplos y 0 fallos, sin `bundler-audit update` y con el árbol intacto (M270, registrado en M271). Conformidad visual de Pablo sobre las capturas de M265 a 1280 y 375 px; tarea 3.3 cerrada (M272). Paquete de revisión en `~/Descargas` (M273). Estados de la propuesta, el diseño y las tareas actualizados; 0.4 sigue abierta por falta de evidencia; enlaces a GL-14 pasados a texto; candidato de publicación preparado sin el plan transversal (M274). Reenvío idéntico de M274, sin cambios (M275). Enlaces al plan pasados a texto, con el plan fuera del candidato; 0.4 cerrada con M264 como evidencia; candidato regenerado (M276). Viñeta de M260 y fila de M260 en el README de GL-13 reescritas sin remitir a M248 y M249; candidato regenerado (M277). Publicado: commit `c7d4165`, PR #8 y CI remoto en verde con 403 ejemplos y 0 fallos; sin merge ni archivo (M278). Reenvío idéntico de M278, sin cambios (M279). Cierre documental de la publicación (M280), publicado en el PR #8 con el commit `e45e1b8` y CI en verde (M281). PR #8 mergeado en `feature/entrega-2-pp` con `e6fce0b`; cambio archivado en local, con la spec nueva `visual-language` y el aviso de la ficha en `people-browsing`, sin commit (M282). Reenvío idéntico de M282, sin cambios (M283). Estados, tarea 4.2 y próximo paso del plan actualizados al merge y al archivo local; M280 a M283 registrados (M284). Fila de GL-13 del plan corregida y candidato del commit de cierre preparado como patch (M285). Archivo publicado: commit `68f74cc` en `feature/entrega-final-pp`, con push (M286). PR #9 hacia `feature/entrega-2-pp` para ejecutar el CI sobre `68f74cc`, en verde ([43939186173](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43939186173)) (M287). M285 a M287 todavía no tienen registro propio (ver abajo). El 17/11/2026, en pedidos todavía sin numerar, el merge de GL-13 se retiró de `feature/entrega-2-pp` con el revert `3dc4e90` y el PR #9 se cerró sin merge; GL-13 sigue en `feature/entrega-final-pp` | [GL-13](docs/prompts/GL-13/README.md) |
| GL-14. Mejoras del listado «Personas» | M257–M259, M383, M389, M391 y M395–M400 | separación de GL-13 y borrador SDD con el ticket y el cambio `gl-14-mejoras-listado-personas`, con deltas de `people-browsing`, `feedback-capture` y `authorization`; decisiones 1 a 9 aprobadas por Pablo (P-41 a P-45) y P-46 a P-53 abiertas (M257). P-46 a P-53 aprobadas, deltas ajustados y `CLAUDE.md` remitido al plan de cada entrega (M258). Interpretaciones de P-51 y P-53 confirmadas (M259). `openspec validate --all --strict` en verde; sin implementar. En la revisión de la tarea 0.4, Pablo decidió conservar los textos de GL-14 en los escenarios restaurados (M383) y dio su conformidad al borrador, con la 0.4 completada el 21/11/2026 (M389). Revisión de solo lectura para decidir la 0.6 (M391). Implementación autorizada para los grupos 1 a 3 (tarea 0.6) y hecha en local: 463 ejemplos y 0 fallos; `bin/ci` en código 1 solo por la versión de Brakeman; sin commit (M395). Desvío de la 3.1 aceptado y conformidad visual de Pablo (3.1 y 3.3 completas); Brakeman actualizado a 8.1.1, que marca Ruby 4.0.9 (CVE-2026-132825), y `bin/ci` sigue en código 1 (M396). Actualización de Ruby a 4.0.10 autorizada y detenida antes de aplicarla, porque necesita más alcance (M397). Ruby 4.0.10 en un cambio de OpenSpec independiente (`gl-16-ruby-4-0-10`), validación 23 de 23 y `bin/ci` en código 0; 3.2 completa (M398). Documentación conciliada con Ruby 4.0.10 y el cambio de Ruby registrado como GL-16, con su ticket y su lugar en el plan (M399; sus pedidos M397 a M400 se registran en esta etapa). Cambio renombrado a `gl-16-ruby-4-0-10` (M400). Estado vigente: implementado y verificado en local, con el grupo 4 abierto | [GL-14](docs/prompts/GL-14/README.md) |
| GL-15. Formulario completo «+ Feedback» | M318–M339, M343–M365 | antecedente: revisión de H1–H5 que propuso T2.1 (M318). Borrador SDD de GL-15 con validación 23 de 23 (M319). Decisiones de diseño, rutas, aviso, «Cancelar», fecha de hoy y opción B del aviso (M320 a M324; M321, reenvío). Implementación autorizada y corrección del aviso a «Feedback guardado como lista.» (M325 a M327). Verificación local, capturas, ajustes visuales y conformidad visual de Pablo (M328 a M331). Registros de verificación y correcciones previas al commit (M332 a M339; M333 y M338, reenvíos). Commit `bb5db27`, `bin/bundler-audit update` y `bin/ci` con 428 ejemplos, y commit `44d91b2` (M343 a M346). Push y CI habilitado en la rama final con `fda7c00`, en verde (M347 y M348). Registro del CI con `cebc659` (M349). Decisión de integración en `feature/entrega-final-pp`, sin PR ni merge, con `711ee6c` (M350 a M352). Archivo del cambio, ajuste de redacción y del delta de GL-14, publicado con `0472210` (M353 a M359). Revisión y conformidad de la tarea 0.3 y estado final, publicado con `07b464d`, CI en verde ([44525206311](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/44525206311)) (M360 a M364). Pedido de este registro (M365). M340 a M342, fuera del proyecto, sin registro. Estado vigente: implementado, integrado y archivado, con todas sus tareas completas | [GL-15](docs/prompts/GL-15/README.md) |

**Mensajes sin registro, con su motivo.**

- **M248 y M249** (15/11/2026, 18:41 y 19:44 UTC): diagnósticos de producto
  y UX de solo lectura para orientar la entrega final. Los pedidos
  prohibían editar archivos, así que no se registraron cuando se hicieron.
  Su registro queda pendiente de la autorización de Pablo.
- **M260** (16/11/2026, 00:12 UTC): revisión de solo lectura de las
  decisiones pendientes de GL-13. El pedido prohibía editar archivos, así
  que no se registró cuando se hizo. Su registro queda pendiente de la
  autorización de Pablo.
- **M285 a M287** (16/11/2026, 18:58, 19:10 y 19:25 UTC): pedidos de GL-13
  (fila del plan y candidato de cierre, commit y push del archivo, y PR #9
  para el CI). Cada pedido limitaba los cambios a su alcance, así que no se
  registraron cuando se hicieron. Su texto literal está en la transcripción;
  el registro queda pendiente de la autorización de Pablo.
- **M288 a M295** (17/11/2026, de 14:53 a 22:37 UTC): revisiones de solo
  lectura y propuestas sin registrar (estado para la entrega final,
  revisión de H1–H5, propuesta de decisiones de H1–H5, revisión de producto
  y su actualización, y correos de las cuentas demo). M290 y M292 son
  reenvíos idénticos de M289 y M291. Los pedidos prohibían editar
  archivos. Su texto literal está en la transcripción; el registro queda
  pendiente de la autorización de Pablo.
- **M296 a M317** (del 17/11/2026 22:39 al 18/11/2026 01:38 UTC): README
  de la demo en la entrega 2, verificación del acceso a la demo, revert de
  GL-13 y README en `feature/entrega-2-pp`, cierre del PR #9, limpieza de
  worktrees, integración experimental descartada, revisiones y la
  preparación del paquete documental de la entrega final. Numerados en
  M366 por posición (opción A de Pablo): no tienen número las respuestas
  breves («dale», «Listo», «Ya estoy logueado», «Listo»), la notificación
  del sistema, la interrupción ni lo enviado a mitad de un turno, que
  quedó encolado; sí lo tienen la corrección enviada
  después de la interrupción y el texto pegado del README. Su texto literal
  está en la transcripción; sin registro, porque Pablo pidió registrar
  solo GL-15.
- **M340 a M342** (18/11/2026, 19:57 a 20:01 UTC): pedidos fuera del
  proyecto, sin registro (ver la etapa GL-15).
- **M366** (19/11/2026, 13:19 UTC): decisión de la numeración y pedido del
  registro de GL-15; fuera del rango registrado (M318 a M365).
- **M367 a M371** (del 19/11/2026 13:26 al 20/11/2026 01:19 UTC): revisión,
  correcciones y verificación del registro de prompts de GL-15, y su
  publicación con `eade6a6`. Numerados por posición (opción A); sin
  registro propio.
- **M372 a M382, M384 a M388 y M390** (del 20/11/2026 02:09 al 21/11/2026
  14:27 UTC): pedidos de la revisión de GL-14 (relevamiento, revisión de
  la tarea 0.4, correcciones documentales, validaciones, precisión de
  escenarios, ajustes de redacción y copias de diffs a `~/Descargas`).
  M381 es un reenvío idéntico de M380. Numerados por posición (opción A).
  Su texto literal está en la transcripción; Pablo pidió registrar solo
  M383, M389 y M391.
- **M392** (21/11/2026, 14:37 UTC): pedido de este registro y de la
  alineación de «sin textos de pantalla» en el diseño y el plan; fuera de
  los registros creados.
- **M393 y M394** (21/11/2026, 15:08 y 15:14 UTC): copia del diff a
  `~/Descargas` y commit local del paquete documental de GL-14
  (`0662e70`). Sin registro propio.

## Entrega 2

**Fuente:** los mensajes originales de Pablo en la transcripción local de
la sesión de Claude Code (no publicada), copiados literalmente. No incluye
salidas de herramientas, respuestas del asistente, razonamientos internos
ni la transcripción completa. Cada archivo separa los metadatos, el texto
original y el resultado registrado.

**Herramientas.** Los pedidos se enviaron a **Claude Code (CLI)**, que los
ejecutó con **`claude-opus-5-5`** según el campo de modelo de las respuestas
en la transcripción. **Declaración de Pablo (03/11/2026):** los pedidos se
prepararon con ChatGPT en una conversación de acompañamiento y después se
pegaron en Claude Code. Esa conversación no está aportada como archivo y su
modelo no está verificado; no se reconstruye.

| Etapa | Mensajes | Resultado | Registro |
|---|---|---|---|
| Análisis de alcance previo a los tickets | M01–M06 | respuestas en la conversación y dos archivos en `~/Descargas`, no versionados | [00-analisis-alcance](docs/prompts/00-analisis-alcance/README.md) |
| GL-01. Base del producto (y cierre de E1) | M07–M09, M11, M12 | `cf44c0c` a `39d18c3`; CI 41528484840 y 41532204969 | [GL-01](docs/prompts/GL-01/README.md) |
| GL-01a. Avisos de seguridad | M10 (cierre en M12) | `2631edb` | [GL-01a](docs/prompts/GL-01a/README.md) |
| GL-02. Autenticación | M13–M15, M17, M18 | `2286d62` a `94e40a1`; CI 41551853981 y 41557336838 | [GL-02](docs/prompts/GL-02/README.md) |
| Replanificación por el feedback de LIDR | M19–M21 | `93b42ec` | [replanificacion-lidr](docs/prompts/replanificacion-lidr/README.md) |
| GL-03. Autorización mínima | M22–M24 (cambio pedido en M21) | `7263efd` a `092b548`; CI 41571299236 y 41571768783 | [GL-03](docs/prompts/GL-03/README.md) |
| GL-08. Datos ficticios de desarrollo | M25–M27 | `5025694` a `eacb16e`; CI 41621619815 y 41621897764 | [GL-08](docs/prompts/GL-08/README.md) |
| GL-05. «Personas» y ficha del líder | M28, M33, M35–M37, M61–M81 | PR [#3](https://github.com/pablo-wpify/growth-log-ai4devs/pull/3), integrado en `8d0e854`; CI 42398717466; comprobación manual E10 (M75–M77), archivo (M78) y cierre publicado en `6b9577f` (M80); CI 42419660424; registro de M80 en `4bac6e4` (M81) | [GL-05](docs/prompts/GL-05/README.md) |
| GL-01b. Rails 8.1.4.1 por avisos de seguridad | M38–M60 | PR [#2](https://github.com/pablo-wpify/growth-log-ai4devs/pull/2), integrado en `8ae8723`; CI 42380986492; archivado (M74) | [GL-01b](docs/prompts/GL-01b/README.md) |
| GL-06. Captura rápida, completar y marcar como lista | M83–M90, M94, M96–M124, M128–M131, M133–M140, M144–M177 | decisiones P-1, P-2, P-3 y P-11 aprobadas (M85) y P-19 a P-24, más P-25 y P-26 con números provisionales, decididas (M107; M108 repitió el texto); ajustes de revisión y tareas 0.1 a 0.3 marcadas (M114); números provisionales (M116; M117 repitió el texto); cambio aprobado e implementado (M120); PR [#4](https://github.com/pablo-wpify/growth-log-ai4devs/pull/4), integrado en `8c2f2ad`; CI 43609790733 y 43610547250; archivado (cierre en M178 a M189, sin registro) | [GL-06](docs/prompts/GL-06/README.md) |
| GL-07. Resumen por dimensión y cronología | M190–M194 | P-10 aprobada y alcance de 4.3, 4.4, 4.5 y 1.15 decidido (M192); detalles confirmados (M193); cambio aprobado e implementado, con 315 ejemplos en `bin/ci` (M194); PR [#5](https://github.com/pablo-wpify/growth-log-ai4devs/pull/5), integrado en `b835bde`; CI 43631292881 y 43632097169; archivado | [GL-07](docs/prompts/GL-07/README.md) |
| GL-09. Verificación E2E del recorrido núcleo | M202 | P-4 aprobada; cambio preparado e implementado, con 317 ejemplos en `bin/ci` (M202); PR [#6](https://github.com/pablo-wpify/growth-log-ai4devs/pull/6), integrado en `e0ceb4e`; CI 43634781960 y 43635205495; archivado | [GL-09](docs/prompts/GL-09/README.md) |
| Revisión de la entrega 2 | M206–M209 | auditoría de solo lectura (M206), correcciones documentales para la revisión externa (M207) y cambio de OpenSpec `gl-01b-runtime-toolchain-rails-8-1-4-1`, preparado (M208) y aprobado y archivado como `2026-11-14-gl-01b-runtime-toolchain-rails-8-1-4-1` (M209); publicado en `e5d678f` (M210, sin registro); CI 43639579889 | [revision-entrega-2](docs/prompts/revision-entrega-2/README.md) |
| GL-10. Demo temporal en Render | M211–M217, M237 | M211 detenido antes de editar (faltaba el archivo de partida); borrador documental del ticket y del cambio `gl-10-demo-temporal-render`, P-27 decidida y P-28 a P-31 abiertas (M212); P-28 y P-31 como recomendaciones y datos de la base actualizados (M213); P-28, P-29 y P-31 decididas, rama `feature/entrega-2-pp` con despliegue manual y conjunto demo aceptado (M214); implementación autorizada sin Render ni deploy e implementada en local, con 368 ejemplos en `bin/ci` (M215); revisión de solo lectura (M216) y correcciones de tres hallazgos (M217); publicado, integrado en `6177aef` (PR [#7](https://github.com/pablo-wpify/growth-log-ai4devs/pull/7); CI 43660072168 y 43660510488) y desplegado en Render (M218 a M235, sin registro); documentación reconciliada, con la comprobación manual parcial y la aclaración de que las variables de contraseña no se retiran (M237); P-30 pendiente; sin archivar | [GL-10](docs/prompts/GL-10/README.md) |
| GL-11. Presentación de la página de inicio de sesión | M236, M238–M240 | verificación previa sin bloqueos y borrador documental del ticket y del cambio `gl-11-presentacion-inicio-sesion`, con la capability nueva `sign-in-presentation` y P-32 abierta (M236); revisión de solo lectura sin contradicciones bloqueantes (M238); ajustes de redacción H1 a H7 y P-33 (ancho del formulario) registrada, pendiente (M239); P-32 y P-33 aprobadas e implementación autorizada, implementado en local con 15 pruebas nuevas y RSpec con 383 ejemplos y 0 fallos, y `bin/ci` bloqueado por avisos nuevos de gemas ajenos a GL-11 (M240); sin commit | [GL-11](docs/prompts/GL-11/README.md) |
| GL-12. Avisos de seguridad de `msgpack` y Puma | M241 | ticket y cambio `gl-12-avisos-msgpack-puma` (`skip_specs: true`); `msgpack` 1.8.7 y `puma` 8.0.3 con `bundle update --conservative --patch`; `bin/ci` con código 0 (383 ejemplos); sin commit | [GL-12](docs/prompts/GL-12/README.md) |
| Publicación de GL-10, GL-11 y GL-12 | M242 | verificación final, commits por ticket, push a `feature/entrega-2-pp`, CI remoto y deploy manual en Render, con la comprobación visual de `/session/new`; sin PR, merge ni archivo | [publicacion-gl-10-a-gl-12](docs/prompts/publicacion-gl-10-a-gl-12/README.md) |
| Cierre de la entrega 2 | M243–M245 | GL-10 y GL-12 archivados (GL-10 con CA8 parcial y P-30 abierta), GL-11 sin archivar hasta la comprobación manual de Pablo, README y plan actualizados; commit local y rama `feature/entrega-final-pp`, sin push (M243); la tarea 3.3 de GL-11 sigue sin cubrir con la evidencia aportada y GL-11 no se archiva (M244); su comprobación manual se difiere al cierre de la entrega final (M245) | [cierre-entrega-2](docs/prompts/cierre-entrega-2/README.md) |
| Registro de prompts | M29–M32 | PR [#1](https://github.com/pablo-wpify/growth-log-ai4devs/pull/1), integrado en `925e2ee`; CI 41629470056 | [registro-prompts](docs/prompts/registro-prompts/README.md) |

**Conteos.** La transcripción tiene 30 mensajes del usuario hasta este
registro, numerados por posición de M01 a M30:

- **M16** no es un pedido: es el resumen automático de contexto que genera
  Claude Code al continuar la sesión. No se registra ni se usa como fuente.
- Quedan **29 pedidos** de Pablo. El inventario anterior contaba 28 porque
  terminaba en M29, el pedido de inventario; M30 es el pedido que aprobó
  este registro.
- **M03, M04 y M05** son tres envíos del mismo texto. Por eso hay
  **27 textos distintos**, guardados en 27 archivos; el de M03 a M05 lista
  los tres envíos con su hora.

**Mensajes posteriores al registro inicial.** M31 a M177, M190 a M194, M202,
M206 a M209, M211 a M217 y M236 a M245 se registran en su etapa, con el mismo procedimiento literal, salvo M82, que
no está registrado, y las excepciones de GL-06 (M91 a M93, fuera del
proyecto; respuestas operativas; el comando `/chrome` y su salida; M96 con
el texto omitido). Ver las etapas GL-06, GL-07, GL-09, revisión de la
entrega 2, GL-10, GL-11, GL-12, la publicación de GL-10 a GL-12 y el cierre de la entrega 2.

**Mensajes sin registro, con su motivo.** Comprobado por posición, fecha y
texto en la transcripción del 14/11/2026 (hora UTC):

- **M178 a M189** (14:50 a 15:42): cierre, publicación, integración y
  archivo de GL-06. M178 indicó tomar M177 como cierre del registro de
  GL-06.
- **M195 a M201** (18:57 a 19:25): revisión del diff, ajustes de
  presentación, copia del diff a `~/Descargas`, publicación, integración y
  archivo de GL-07.
- **M203 a M205** (19:53 a 20:00): revisión de solo lectura, publicación,
  integración y archivo de GL-09.
- **M210** (20:49): publicación de las correcciones documentales de la
  entrega 2 (commit `e5d678f`, CI 43639579889).
- **M218 a M235** (15/11/2026, 00:48 a 03:21): publicación, integración
  y primer deploy de GL-10 en Render. Incluyen el PR #7, el merge
  `6177aef`, la inspección de solo lectura de Render y las
  indicaciones para el formulario del servicio web.

M195 a M201, M203 a M205, M210 y M218 a M235 no tienen una indicación de Pablo para omitirlos:
quedan sin registro, **pendiente de confirmación** si se agregan. Lo que
produjeron (commits, PR, CI y archivos) está en los tickets y en los
diseños archivados.

- **M34**, como M16, es el resumen automático de contexto que genera Claude
  Code al continuar la sesión: no es un pedido y no se registra.
- M31 y M32 se registraron después de su ejecución, a pedido de M35.
- **M42** es una copia pegada de una respuesta del asistente, sin pedido
  nuevo. Se registra con el texto omitido y no se declara literal.
- **M53 y M54**, y también **M58 y M59**, son dos envíos del mismo texto.
  Cada envío tiene su archivo.
- Un mensaje enviado a mitad de un turno («espera», 07/11/2026) quedó
  encolado en la transcripción, no como mensaje propio. No tiene número ni
  registro; se menciona en M52.
- **M75 y M76** son dos envíos del mismo pedido de E10: el primero quedó
  bloqueado porque la extensión de Chrome no se conectó, y el segundo se
  hizo en una sesión nueva de Claude Code, con otra transcripción. Cada
  envío tiene su archivo.
- **Respuestas operativas.** Durante M75 y M76, Pablo envió catorce
  respuestas breves y dos capturas de pantalla para avanzar los pasos. Por
  ejemplo, «ahora?» o «listo», y «1» para elegir entre opciones que había
  planteado el asistente. No contienen un pedido nuevo: no tienen número
  ni registro, igual que el mensaje encolado «espera». Se resumen en el
  resultado del pedido al que responden.
- M78 se registró primero como M75; M79 corrigió la numeración.
- **M82** (07/11/2026, en otra sesión) pidió versionar aparte el registro
  de M81. No está registrado: queda pendiente en la etapa GL-05.
- **M83 y M84** fueron pedidos de solo lectura que prohibían modificar
  archivos; se registraron después, al ejecutar M85, según la regla de `CLAUDE.md`. El comando `/chrome`
  enviado antes de M83 y el resumen automático de contexto de esa sesión no
  tienen número.

**Fidelidad y omisiones.** Cada texto es idéntico al mensaje fuente; solo se
quitaron las etiquetas de texto pegado que agrega Claude Code. Las
excepciones son M42, omitido por ser una respuesta del asistente, y M83,
que tiene un correo personal reemplazado por «[omitido: correo personal]» y
por eso no se declara literal íntegro. También M96 (GL-06), con el texto
omitido por ser material de referencia de otro proyecto con datos
personales. No hubo que omitir secretos en ningún pedido. Los pedidos contienen
rutas locales de proyecto (`~/code/...`) y el nombre de la cuenta pública
`pablo-wpify`, cuya publicación aprobó Pablo.

## Prompts clave de la entrega 2

Selección de cinco flujos entre los pedidos registrados en
[docs/prompts/](docs/prompts/), uno por etapa central del recorrido núcleo.
Cada uno enlaza su registro completo, con el texto literal.

**Herramientas, en todos los flujos:** ejecución en **Claude Code (CLI)**
con **`claude-opus-5-5`**, según el campo de modelo de las respuestas en la
transcripción. Preparación del pedido: con ayuda de **ChatGPT**, según la
declaración de Pablo; esa conversación no está aportada y su modelo no
está verificado. Objetivo, decisiones y aprobaciones: **Pablo**.

| # | Flujo | Pedidos | Sección de la plantilla | Resultado |
|---|---|---|---|---|
| 1 | Replanificación por el feedback de LIDR | M19, M21 | 1.2, 9, 10 | plan único de la entrega 2, recorrido núcleo, tickets GL-03 a GL-09, `CLAUDE.md` |
| 2 | Autorización mínima con pruebas primero | M22 | 2.5, 2.6, 3 | Pundit, denegar por defecto, personas y asignaciones, mutaciones |
| 3 | Captura rápida: decisiones y SDD de GL-06 | M85, M120 | 1.2, 3, 4, 2.6 | tabla `feedback_entries`, captura, completar y marcar como lista, matriz de privacidad |
| 4 | Resumen y cronología: decisiones de GL-07 | M192 | 1.3, 5 | resumen por dimensión, cronología y conteo, solo con entradas propias |
| 5 | E2E del recorrido núcleo | M202 | 2.2, 2.6 | pruebas en navegador con Capybara y `selenium-webdriver`, en el CI |

### Contexto avanzado y herramientas utilizadas en la entrega 2

Según los registros de [docs/prompts/](docs/prompts/), los archivos del
repositorio y la transcripción de la sesión:

| Elemento | ¿Se usó? | Evidencia |
|---|---|---|
| `CLAUDE.md` del proyecto | **sí**, desde el 03/11/2026 (P-12) | [CLAUDE.md](CLAUDE.md); creado con M21 y versionado en `93b42ec` |
| Contexto de OpenSpec y SDD | **sí** | [`openspec/config.yaml`](openspec/config.yaml); cada ticket con propuesta, specs, diseño y tareas; `openspec validate --all --strict` en cada etapa |
| Skills y comandos de OpenSpec | **presentes**, uso **pendiente de confirmación** | están versionados en `.claude/` (generados por OpenSpec); en los registros consta el uso directo del CLI `openspec`, no la invocación de esos skills |
| Servidores MCP | **sí**: Claude in Chrome | comprobaciones manuales en navegador E10 (GL-05, M75 y M76) y F17 (GL-06, M124) |
| Memoria persistente | **sí**, una nota | publicar siempre con la cuenta `pablo-wpify` (07/11/2026) |
| Subagentes | **no consta** | ningún registro los menciona |
| Instrucciones de la cuenta | **sí** | instrucciones generales de la cuenta, no específicas de este proyecto; no se publican |
| Herramientas del asistente | **sí** | terminal, lectura y edición de archivos, `git`, `gh` (PR y CI), Docker, OpenSpec CLI y Chrome sin interfaz (pruebas de sistema) |

---

### Flujo 1. Replanificación por el feedback de LIDR

*Secciones 1.2, 9 y 10 de la plantilla.*

| Campo | Detalle |
|---|---|
| Fase | planificación |
| Pedidos | [M19](docs/prompts/replanificacion-lidr/M19-2026-11-03-ajustar-el-plan-por-el-feedback-de-lidr.md) (03/11/2026) y [M21](docs/prompts/replanificacion-lidr/M21-2026-11-03-aprobacion-de-p-5-p-7-p-8-p-9-y-p-12-readme.md) (aprobación) |
| Contexto | plan anterior, anexos de la entrega 1 y feedback de LIDR |

**Extracto literal (M19):**

> Elegí un único documento como fuente vigente de la secuencia de trabajo.

**Resultado:** [plan de la entrega 2](docs/plan-entrega-2.md) como fuente
única, con el recorrido núcleo, los tickets GL-03 a GL-09, el alcance
diferido y una tabla de decisiones pendientes; README breve y `CLAUDE.md`
(M21). Versionado en `93b42ec`.

**Criterio humano (Pablo):** priorizar el recorrido núcleo; preparar
cuentas, personas y asignaciones con datos ficticios; diferir invitaciones,
administración y compartir, sin eliminarlos como requisito; aprobar P-5,
P-7, P-8, P-9 y P-12 (M21), después de precisarlas en M20.

### Flujo 2. Autorización mínima con pruebas primero

*Secciones 2.5, 2.6 y 3 de la plantilla.*

| Campo | Detalle |
|---|---|
| Fase | implementación (GL-03) |
| Pedido | [M22](docs/prompts/GL-03/M22-2026-11-03-aprobacion-documental-e-implementacion-de-gl-03.md) (03/11/2026) |
| Contexto | `CLAUDE.md`, cambio de OpenSpec `gl-03-autorizacion-minima` |

**Extracto literal:**

> Definí las excepciones de autorización por acciones concretas. Una nueva
> acción del controlador de sesiones no debe quedar exceptuada
> automáticamente.

**Resultado:** Pundit con política base que deniega, verificaciones de
autorización y alcance en cada acción, modelos de personas y asignaciones
con sus restricciones, y mutaciones registradas. Commits `93b42ec` y
`7263efd`; CI 41571299236.

**Criterio humano (Pablo):** revisar los archivos reales antes de corregir
un resumen pegado; distinguir en `CLAUDE.md` cargar `.env` de mostrar su
contenido; no agregar rutas, semillas ni permisos configurables; separar el
commit documental del de implementación.

### Flujo 3. Captura rápida: decisiones y SDD de GL-06

*Secciones 1.2, 3, 4 y 2.6 de la plantilla.*

| Campo | Detalle |
|---|---|
| Fase | decisiones de producto, SDD e implementación (GL-06) |
| Pedidos | [M85](docs/prompts/GL-06/M85-2026-11-13-aprobar-decisiones-y-preparar-gl-06.md) (decisiones y preparación) y [M120](docs/prompts/GL-06/M120-2026-11-13-aprobar-gl-06-e-implementar.md) (aprobación e implementación) |
| Contexto | `CLAUDE.md`, plan, cambio de OpenSpec `gl-06-captura-rapida`; extensión Claude in Chrome para la comprobación F17 |

**Extracto literal (M120):**

> Detenete e informa si una decisión documentada resulta insuficiente o
> contradictoria; no la resuelvas por inferencia.

**Resultado:** tabla `feedback_entries`, captura rápida en página propia,
completar y «Marcar como lista», con lectura por autoría y 404 por URL
directa; seis mutaciones detectadas. Integrado con el
[PR #4](https://github.com/pablo-wpify/growth-log-ai4devs/pull/4).

**Criterio humano (Pablo):** aprobar las dimensiones, las señales y sus
etiquetas (P-1, P-2), exigir señal y dimensión para «lista» (P-3) y diferir
el formulario completo (P-11) en M85; decidir P-19 a P-26; no dar por
resuelto PT-11; cerrar la comprobación en navegador F17 como **parcial**.

### Flujo 4. Resumen y cronología: decisiones de GL-07

*Secciones 1.3 y 5 de la plantilla.*

| Campo | Detalle |
|---|---|
| Fase | decisiones de producto y SDD (GL-07) |
| Pedido | [M192](docs/prompts/GL-07/M192-2026-11-14-confirmar-decisiones-y-preparar-gl-07.md) (14/11/2026); detalles en M193 y aprobación en M194 |
| Contexto | `CLAUDE.md`, plan, mock 1 del Anexo E, cambio de OpenSpec `gl-07-resumen-cronologia` |

**Extracto literal:**

> Presentame los documentos para revisión antes de implementar.

**Resultado:** resumen por dimensión solo con entradas propias listas,
cronología ascendente con los borradores marcados «fuera del resumen» y
conteo en «Personas», con cuatro mutaciones del alcance detectadas.
Integrado con el [PR #5](https://github.com/pablo-wpify/growth-log-ai4devs/pull/5).

**Criterio humano (Pablo):** decidir P-10 (orden y desempate de la
cronología), los textos de 4.4 y 4.5, el alcance parcial de 4.3 y 1.15, y
mantener diferidos los filtros y el origen «compartida con vos».

### Flujo 5. E2E del recorrido núcleo

*Secciones 2.2 y 2.6 de la plantilla.*

| Campo | Detalle |
|---|---|
| Fase | decisión de herramienta e implementación (GL-09) |
| Pedido | [M202](docs/prompts/GL-09/M202-2026-11-14-implementar-gl-09-e2e.md) (14/11/2026) |
| Contexto | `CLAUDE.md`, plan, specs vigentes, cambio de OpenSpec `gl-09-e2e-recorrido-nucleo`, GitHub Actions |

**Extracto literal:**

> No agregues requisitos de entrega que no estén en el plan; señalá aparte
> cualquier diferencia que encuentres con la consigna del curso.

**Resultado:** dos pruebas en Chrome sin interfaz (recorrido núcleo y rama
negativa de privacidad), escritas antes de la herramienta y verificadas con
cuatro mutaciones; 317 ejemplos en verde en local y en el CI remoto.
Integrado con el [PR #6](https://github.com/pablo-wpify/growth-log-ai4devs/pull/6).

**Criterio humano (Pablo):** elegir la herramienta (P-4: pruebas de sistema
de RSpec con Capybara y `selenium-webdriver`); fijar el alcance y dejar
fuera lo diferido; pedir una revisión de solo lectura antes de autorizar la
publicación y el cierre.

### Secciones de la plantilla en la entrega 2

Las secciones 1.2, 1.3, 2.2, 2.5, 2.6, 3, 4, 5, 9 y 10 tienen al menos un
flujo arriba. La sección 7 (pull requests) no tiene un flujo propio: cada
PR se abrió con un pedido de publicación. Los de los PR #1 a #3 están
registrados en sus etapas (M31, GL-01b y M70); los de los PR #4 a #6
quedaron en los tramos sin registro (M178 a M189, M200 y M204).

## Entrega 1 (registro histórico)

> Flujos de trabajo con asistentes de IA en la preparación de la primera
> entrega de Growth Log, con su herramienta, modelo, fase, resultado y
> criterio humano. El texto de cada prompt está en el [Anexo F](anexos/anexo-f-registro-prompts.md). La
> plantilla pide hasta 3 prompts por sección; cada flujo indica a qué
> sección corresponde.

## Quién hizo qué

En la preparación de esta entrega, **Pablo definió el objetivo y tomó
decisiones; los pedidos se prepararon con ayuda de ChatGPT y se ejecutaron
con Claude Code.** Cada parte se atribuye solo hasta donde llega la
evidencia:

| Parte del trabajo | Quién o qué | Evidencia |
|---|---|---|
| Objetivo y decisiones | **Pablo** | reflejados en los pedidos y en la elección entre las opciones que presentó el asistente |
| Preparación de los pedidos | con ayuda de **ChatGPT** | solo lo declarado por Pablo el 27/10/2026. No se conservan esas conversaciones, no consta el modelo y no se puede distinguir qué parte de cada texto aportó ChatGPT |
| Ejecución | **Claude Code (CLI)** con **Claude Opus 5.5** (`claude-opus-5-5`) | comprobado en la transcripción local de la sesión del 27/10/2026 (no se comparte): texto literal, herramienta y modelo de cada flujo |

## Contexto avanzado y herramientas utilizadas

Lo que se usó realmente en la preparación de esta entrega, según la
transcripción de la sesión y los archivos de configuración:

| Elemento | ¿Se usó? | Evidencia |
|---|---|---|
| Skills | **no** | ninguna invocación en la transcripción |
| Subagentes | **sí, uno**: `web-fetch`, para leer la publicación de LinkedIn que inspira la matriz de confiabilidad (27/10/2026) | transcripción |
| `CLAUDE.md` del proyecto o del usuario | **no** | no existe en las carpetas de trabajo ni en la configuración del usuario |
| Rules | **no** | no hay archivos de reglas |
| Memoria persistente | **no** | el directorio de memoria del proyecto está vacío |
| Servidores MCP | **no** | ninguna llamada a herramientas MCP |
| Instrucciones de la cuenta | **sí** | el entorno tenía instrucciones generales configuradas en la cuenta, no específicas de este proyecto, sobre cómo organizar y delegar el trabajo. No se publican. |
| Herramientas del asistente | **sí** | terminal, lectura y edición de archivos y una pregunta al usuario. Con ellas: scripts de Python para generar y verificar la documentación, Chrome sin interfaz para renderizar los diagramas y los mocks, y `gh` en modo lectura para obtener la plantilla del curso. |

## Qué se publica

Este registro publica **cuatro flujos** de la preparación de la entrega. Otros
flujos de la misma preparación (por ejemplo, la elaboración de los mocks y
las revisiones de la documentación) **no se incluyen** en esta versión
pública. Dentro de los prompts publicados, los fragmentos omitidos están
marcados como «[fragmento omitido]»; el resto es literal.

## Resumen

| # | Flujo | Fase | Sección de la plantilla | Resultado |
|---|---|---|---|---|
| 1 | Política de privacidad para varios líderes | diseño de producto | 1.2, 2.5, 3, 5 | PP-1 a PP-7 propuestas, criterios y decisiones D1 a D5 |
| 2 | La presentación como fuente de la visión | producto | 1.1 | problema, destinatarios e hipótesis de valor HV-1 a HV-6 |
| 3 | Arquitectura, modelo de datos y stack | diseño técnico | 2, 3, 4, 6 | arquitectura, modelo conceptual, stack con alternativas, tickets y ADR |
| 4 | Decisiones de administración, compartición y salida de un autor | decisiones de producto | 1.2, 2.5, 2.6, 3, 4, 5, 6 | D1, D2, D5 y AM-1 a AM-5 registradas, H1 separada, modelo, ticket MVP-BE-2 y casos PT-1 a PT-12 |

---

## Flujo 1. Política de privacidad para varios líderes

*Secciones 1.2, 2.5, 3 y 5 de la plantilla.*

| Campo | Detalle |
|---|---|
| Fase | diseño de producto: privacidad y autorización |
| Herramientas | Ejecución: Claude Code (CLI) con Claude Opus 5.5 (`claude-opus-5-5`), comprobado en la transcripción. Preparación del pedido: con ayuda de ChatGPT, según lo declarado por Pablo; sin registro propio. Objetivo y decisiones: Pablo. |
| Fecha | 27/10/2026 |

**Extracto literal:**

> La regla general es privacidad por defecto y compartición explícita:
>
> Diferenciá «lista» de «compartida»: el estado indica que la entrada
> está preparada; la visibilidad determina quién puede verla.

Texto completo: [Anexo F, flujo 1](anexos/anexo-f-registro-prompts.md#flujo-1-política-de-privacidad-para-varios-líderes).

**Resultado:** política propuesta PP-1 a PP-7, criterios propuestos en las
cinco historias (entre ellos 3.9, 4.11 y 4.12), el ticket de base de datos
condicionado a las decisiones y los riesgos asociados.

**Criterio humano (Pablo):**

- Growth Log es para varios líderes en una misma instancia;
- privacidad por defecto y compartición explícita;
- «lista» no es «compartida»;
- dejar abiertas D1 a D5, sin anticipar el diseño de tablas.

---

## Flujo 2. La presentación como fuente de la visión

*Sección 1.1 de la plantilla.*

| Campo | Detalle |
|---|---|
| Fase | producto: visión, problema e hipótesis |
| Herramientas | Ejecución: Claude Code (CLI) con Claude Opus 5.5 (`claude-opus-5-5`), comprobado en la transcripción. Preparación del pedido: con ayuda de ChatGPT, según lo declarado por Pablo; sin registro propio. Objetivo y decisiones: Pablo. |
| Fecha | 27/10/2026 |

**Extracto literal:**

> En particular, no presentes como resultados medidos la captura en
> 30 segundos, la reducción de sesgos o la mejora de las evaluaciones.
>
> Integrá estas conclusiones a la propuesta de documentación y citá
> el PDF como fuente de la visión.

Texto completo: [Anexo F, flujo 2](anexos/anexo-f-registro-prompts.md#flujo-2-la-presentación-como-fuente-de-la-visión).

**Resultado:** el problema, los destinatarios y el supuesto de adopción
tomados de la presentación «El problema de evaluar de memoria», y la tabla
de hipótesis de valor HV-1 a HV-6.

**Criterio humano (Pablo):**

- usar la presentación como fuente de la visión, sin publicarla;
- tratar la captura en unos 30 segundos, la reducción del sesgo y la mejora
  de las evaluaciones como hipótesis, no como resultados;
- distinguir la privacidad efectiva y el acceso de la persona acompañada
  entre propuesta y decisión abierta.

---

## Flujo 3. Arquitectura, modelo de datos y stack

*Secciones 2, 3, 4 y 6 de la plantilla.*

| Campo | Detalle |
|---|---|
| Fase | diseño técnico del MVP |
| Herramientas | Ejecución: Claude Code (CLI) con Claude Opus 5.5 (`claude-opus-5-5`), comprobado en la transcripción. Preparación del pedido: con ayuda de ChatGPT, según lo declarado por Pablo; sin registro propio. Objetivo y decisiones: Pablo. |
| Fecha | 27/10/2026 |

**Extracto literal:**

> Tomá esto como propuesta inicial, no como una decisión irrevocable ni
> como una descripción de lo que ya está construido.
>
> No afirmes que los permisos, el CI, los backups o el despliegue existen:
> son requisitos o propuestas hasta que se implementen y verifiquen.

Texto completo: [Anexo F, flujo 3](anexos/anexo-f-registro-prompts.md#flujo-3-arquitectura-modelo-de-datos-y-stack).

**Resultado:** la arquitectura propuesta, el modelo conceptual con cinco
entidades, la tabla de stack y alternativas, las rutas propuestas, los
tickets MVP-DB-1, MVP-BE-1 y MVP-FE-1, la matriz de confiabilidad y los
borradores de ADR (Anexo D).

**Criterio humano (Pablo):**

- partir de un monolito Rails con PostgreSQL como propuesta a evaluar, no
  como decisión, y no fijar versiones sin verificar;
- al revisar el resultado: incluir en H4 la consulta cronológica de la
  evidencia, tratar la calibración como un uso posible sin puntaje calculado
  y presentar la desactivación de autores y las filas de compartición como
  alternativas sujetas a D5 y D2.

---

## Flujo 4. Decisiones de administración, compartición y salida de un autor

*Secciones 1.2, 2.5, 2.6, 3, 4, 5 y 6 de la plantilla.* Dos pedidos: 4a
registra D1, D2 y D5; 4b, las reglas que cierran sus ambigüedades.

| Campo | Detalle |
|---|---|
| Fase | decisiones de producto y alineación de la documentación |
| Herramientas | Ejecución: Claude Code (CLI) con Claude Opus 5.5 (`claude-opus-5-5`), comprobado en la transcripción. Preparación del pedido: con ayuda de ChatGPT, según lo declarado por Pablo; sin registro propio. Objetivo y decisiones: Pablo. |
| Fecha | 27/10/2026 |

**Extracto literal:**

> - Ser administrador no permite leer todo el feedback. Para consultar
>   entradas se aplican las mismas reglas de autoría y compartición.
>
> No inventes decisiones adicionales. Si aparece una ambigüedad que afecte
> permisos, señalala y proponé una resolución sin darla por aceptada.

**Extracto literal del pedido 4b:**

> AM-3. Revocación administrativa
> - El administrador puede revocar una compartición concreta sin leer
>   el contenido de la entrada.
>
> No amplíes el alcance con otras funciones. Si aparece una contradicción,
> explicala y proponé el ajuste mínimo; no inventes decisiones de producto.

Texto completo: [Anexo F, flujo 4](anexos/anexo-f-registro-prompts.md#flujo-4-decisiones-de-administración-compartición-y-salida-de-un-autor).

**Resultado del pedido 4a:** la política PP-1 a PP-8 con D1, D2 y D5 como decisiones de
Pablo, H1 separada entre administrador y líder (59 criterios en total), el
modelo con capacidad de administrador, asignaciones con inicio y fin y
comparticiones ligadas a la asignación, el ticket MVP-BE-2, los casos de
prueba PT-1 a PT-6 y las ambigüedades AM-1 a AM-5 con resoluciones
propuestas. Con el pedido 4b: las reglas AM-1 a AM-5 como decisiones, la
regla PP-9 de lectura por autoría, la entidad de invitaciones, el registro
de revocación, 67 criterios y los casos PT-7 a PT-12.

**Criterio humano (Pablo):**

- aceptar D1, D2 y D5 con las condiciones del pedido;
- conservar cinco historias sin forzar el conteo de criterios;
- pedir que las ambigüedades se señalen con una resolución propuesta, sin
  darlas por aceptadas;
- después, aceptar las reglas AM-1 a AM-5, la visibilidad de los nombres de
  otros líderes y los criterios 3.9, 4.11 y 4.12, sin ampliar el alcance.

### Caso concreto: reasignar a un líder sin reactivar comparticiones

Reconstruido con los pedidos 4a y 4b ([Anexo F](anexos/anexo-f-registro-prompts.md#flujo-4-decisiones-de-administración-compartición-y-salida-de-un-autor)),
los commits de la rama de entrega y el
[ADR-4](anexos/anexo-d-decisiones-arquitectura.md#adr-4-cómo-se-registra-una-compartición).
No agrega pasos ni intervenciones que no estén registrados.

- **Situación inicial.** Antes del flujo 4 (commit `ee84919`), el modelo
  registraba cada compartición con el usuario destinatario
  (`recipient_id`), como alternativa sujeta a D2, que estaba abierta. No
  estaba definido qué pasaba con una compartición si terminaba la
  asignación del destinatario y después volvían a asignarlo.
- **Decisión de Pablo** (pedido 4a): la reasignación no recupera permisos
  anteriores.

  > - Si vuelve a ser asignado, las comparticiones anteriores no recuperan
  >   vigencia automáticamente: el autor debe compartir nuevamente.

  El pedido dejó el cómo al asistente: «Asegurar que una nueva asignación
  no reactive permisos antiguos».
- **Propuesta técnica del asistente** (resultado del pedido 4a, commit
  `fc00bc4`): ligar cada compartición a una asignación concreta del
  destinatario (`assignment_id` en lugar de `recipient_id`) y, al
  reasignar, crear una asignación nueva en lugar de reabrir la anterior.
  Una compartición vale solo mientras su asignación esté activa, y la
  asignación nueva empieza sin comparticiones. Está en el
  [modelo de datos](README.md#31-diagrama-del-modelo-de-datos).
- **Revisión y ajustes.**
  - El mecanismo sigue registrado como **propuesta, no como decisión**:
    ADR-4 lo presenta como «propuesta adicional, no decidida».
  - En el pedido 4b, Pablo decidió AM-1, que aplica la misma regla a un
    líder que vuelve a ser asignado: «Volver a estar asignado no reactiva
    comparticiones que hayan perdido vigencia como destinatario». Se
    reflejó en el caso PT-11.
  - Al precisar la nulabilidad del modelo (commit `dd94528`) quedó
    explícito que `assignment_id` es obligatorio y que una asignación
    activa tiene `ended_at` vacío.
- **Especificación resultante:**
  - el criterio [5.10](anexos/anexo-a-historias.md#h5-explorar-y-compartir-feedback-feed);
  - el caso de prueba propuesto [PT-4](anexos/anexo-a-historias.md#casos-de-prueba-de-permisos-pt);
  - la regla «una compartición vale mientras su asignación esté activa» de
    las [reglas que cruzan entidades](README.md#32-descripción-de-entidades-principales);
  - un criterio de [MVP-DB-1](README.md#mvp-db-1-modelo-de-administración-asignaciones-autoría-y-compartición-base-de-datos):
    terminar una asignación y crear otra para el mismo líder y la misma
    persona no deja vigente ninguna compartición anterior.
- **Verificación prevista:** tests de modelo de MVP-DB-1 y tests de
  peticiones de MVP-BE-1 que cubran PT-4, incluida la petición directa por
  URL.

**Estado:** se revisó la coherencia de la documentación entre el modelo, los
criterios, los casos de prueba y los tickets, con scripts de verificación
de enlaces, referencias y conteos. **El comportamiento todavía no está
implementado ni probado: PT-4 es un caso propuesto, no un test
ejecutado.**

---

## Secciones de la plantilla sin prompts registrados

| Sección | Estado |
|---|---|
| 2.6. Tests | **Pendiente:** no hay tests ni prompts que los generen todavía. |
| 7. Pull requests | **Pendiente:** corresponde a entregas siguientes. |
