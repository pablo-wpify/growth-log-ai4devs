# prompts.md — Growth Log

Índice de los registros de prompts. La entrega 2 se registra por etapa en
[docs/prompts/](docs/prompts/); la entrega 1 se conserva abajo sin cambios.

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
| GL-05. «Personas» y ficha del líder | M28, M33, M35–M37, M61–M79 | PR [#3](https://github.com/pablo-wpify/growth-log-ai4devs/pull/3), integrado en `8d0e854`; CI 42398717466; comprobación manual E10 (M75–M77) y archivo (M78) | [GL-05](docs/prompts/GL-05/README.md) |
| GL-01b. Rails 8.1.4.1 por avisos de seguridad | M38–M60 | PR [#2](https://github.com/pablo-wpify/growth-log-ai4devs/pull/2), integrado en `8ae8723`; CI 42380986492; archivado (M74) | [GL-01b](docs/prompts/GL-01b/README.md) |
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

**Mensajes posteriores al registro inicial.** M31 a M79 se registran en su
etapa, con el mismo procedimiento literal.

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

**Fidelidad y omisiones.** Cada texto es idéntico al mensaje fuente; solo se
quitaron las etiquetas de texto pegado que agrega Claude Code. La única
excepción es M42, omitido por ser una respuesta del asistente. No hubo que
omitir secretos ni datos personales en ningún pedido. Los pedidos contienen
rutas locales de proyecto (`~/code/...`) y el nombre de la cuenta pública
`pablo-wpify`, cuya publicación aprobó Pablo.

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
