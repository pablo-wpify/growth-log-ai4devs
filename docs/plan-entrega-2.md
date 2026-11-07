# Plan de la entrega 2 de Growth Log

> **Fuente única y vigente de la secuencia de trabajo de la entrega 2.**
> Cada ticket tiene su detalle en `docs/tickets/` y su cambio de OpenSpec;
> este documento decide **qué sigue, en qué orden y con qué alcance**. El
> README, la guía de desarrollo y los tickets remiten aquí; ningún otro
> documento mantiene una secuencia propia.
>
> Base: plan incremental de la entrega 1
> ([Anexo G](../anexos/anexo-g-plan-incremental.md), incrementos E1 a E4 e
> I1 a I9), que **no se modifica** y sigue siendo la referencia de todo el
> alcance del MVP. Aquí se registra en qué se aparta la entrega 2 y por qué.
>
> Actualizado: 02/11/2026, con el ajuste por el feedback de LIDR.

## 1. Decisión de producto (aprobada por Pablo, 02/11/2026)

- Se conservan GL-01, GL-01a y GL-02, ya cerrados y archivados.
- Se prioriza el **recorrido núcleo**:
  iniciar sesión → elegir una persona asignada → capturar una observación
  como borrador privado → completarla y marcarla como lista → consultar el
  resumen por dimensión y la cronología.
- En el primer lote, las cuentas, las personas y las asignaciones pueden
  prepararse con **datos ficticios** mediante semillas o consola.
- Se difieren: invitaciones por correo, administración completa de
  personas y cuentas, protección del último administrador y revocación
  administrativa. Compartir y revocar por parte del autor quedan para un
  incremento posterior al núcleo.
- **Lo diferido sigue siendo requisito pendiente:** no se elimina ni se
  declara implementado. Ninguna regla de privacidad (PP-1 a PP-9, D1, D2,
  D5, AM-1 a AM-5) se relaja.

Recomendaciones del feedback que este plan incorpora: denegar por defecto y
consultas con alcance (GL-03); probar que el borrador y la entrada lista
siguen privados (GL-06 y GL-07); una sola fuente de verdad para tickets y
secuencia (este documento); cerrar dimensiones, señales y herramienta E2E
(sección 6); mantener contexto de proyecto útil para la IA (sección 8).

## 2. Plan anterior frente al nuevo

**Plan anterior** (secuencia GL-01 a GL-07 propuesta antes de GL-01 en un
análisis de contraste que quedó fuera del repositorio; los tickets solo la
citaban por número):

| ID | Objetivo anterior | Origen en el Anexo G |
|---|---|---|
| GL-01 | Base del producto | E1 |
| GL-02 | Sesión y administrador inicial | E2 (+ límite de intentos de E4) |
| GL-03 | Denegar por defecto | E3 |
| GL-04 | Invitar líderes y asignar personas (vista de administración) | T1.1 a T1.3 |
| GL-05 | «Personas» y ficha del líder | T1.4 |
| GL-06 | Registrar feedback (formulario completo) | T1.5, T2.1, T1.7 |
| GL-07 | Resumen, cronología y E2E | T3.1 a T3.3, T1.8 |

**Plan nuevo:**

| Orden | ID | Objetivo | Estado | Depende de | Decisiones que lo bloquean |
|---|---|---|---|---|---|
| 1 | GL-01 | Base del producto | **cerrado** (archivado) | — | — |
| 2 | GL-01a | Avisos de seguridad que bloqueaban GL-01 | **cerrado** (archivado) | GL-01 | — |
| 3 | GL-02 | Autenticación: sesión, administrador inicial, rutas protegidas | **cerrado** (archivado; CI [41551853981](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41551853981)) | GL-01 | — |
| 4 | [GL-03](tickets/GL-03-autorizacion-minima.md) | Autorización mínima del recorrido: denegar por defecto, personas y asignaciones mínimas, alcance por asignación | **cerrado** (archivado; CI [41571299236](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41571299236)) | GL-02 | ninguna (P-5, P-7, P-8 y P-9 aprobadas) |
| 5 | [GL-08](tickets/GL-08-datos-ficticios.md) | Datos ficticios reproducibles para desarrollo | **cerrado** (archivado; CI [41621619815](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41621619815)) | GL-03 | — |
| 5a | [GL-01b](tickets/GL-01b-rails-8-1-4-1.md) | Rails 8.1.4.1 por los avisos de seguridad del 04/11/2026 | **integrado** en `feature/entrega-2-pp` (PR [#2](https://github.com/pablo-wpify/growth-log-ai4devs/pull/2), `8ae8723`; CI [42380986492](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/42380986492)); cambio de OpenSpec [`gl-01b-rails-8-1-4-1`](../openspec/changes/gl-01b-rails-8-1-4-1/proposal.md) sin archivar | GL-01 | ninguna (P-18 no lo bloquea) |
| 6 | [GL-05](tickets/GL-05-personas.md) | «Personas» y ficha del líder: elegir una persona asignada | **en curso**: implementado e integrado con GL-01b en `feature/GL-05-personas` (`a60fb8e`); faltan la comprobación manual, el CI remoto y el archivo | GL-03, GL-08, GL-01b | ninguna (P-15, P-16 y P-17 aprobadas) |
| 7 | GL-06 | Captura rápida, completar y marcar como lista | pendiente | GL-05 | P-1, P-2, P-3, P-11 |
| 8 | GL-07 | Resumen por dimensión y cronología | pendiente | GL-06 | P-2, P-10 |
| 9 | GL-09 | Verificación E2E del recorrido núcleo | pendiente | GL-07 | P-4 (ADR-6) |
| — | GL-04 | Invitaciones y administración de cuentas, personas y asignaciones | **diferido** | GL-03 | ADR-8 para la entrega real del correo |

Los IDs identifican tickets; no indican orden. El orden lo da la primera
columna.

**Hito «recorrido núcleo»:** se alcanza con GL-09 en verde en el CI. **No
equivale** al hito «primer recorrido usable» del Anexo G (I1), que exige
que el administrador habilite cuentas y asigne personas por la interfaz:
ese hito sigue pendiente hasta GL-04. El Anexo G dice que «un recorrido que
solo funciona con datos preparados no cuenta como funcional»; el núcleo usa
datos preparados solo para las cuentas, las personas y las asignaciones, y
todo lo demás se hace por la interfaz. Se declara así, sin presentarlo como
el hito del Anexo G.

## 3. Cambios de alcance registrados

| ID | Cambio | Por qué |
|---|---|---|
| GL-03 | **Mismo objetivo** (denegar por defecto, E3), alcance precisado: incorpora las tablas mínimas de personas y asignaciones, sin interfaz de administración, porque el alcance por asignación las necesita | sin personas ni asignaciones no hay nada que proteger con alcance |
| GL-04 | **Mismo objetivo, diferido.** Las asignaciones ya no llegan con GL-04: sus tablas llegan con GL-03 y los datos con GL-08. GL-04 conserva invitaciones, establecer contraseña, vista de administración, crear y editar personas, y asignar y terminar asignaciones por la interfaz | decisión de producto: el núcleo primero |
| GL-05 | Mismo objetivo; los datos los prepara GL-08 en lugar de la vista de administración | — |
| GL-06 | Mismo objetivo (registrar feedback), **por otro camino**: captura rápida, completar y marcar como lista (H3). El formulario completo «+ Feedback» (2.1, 2.2, 2.7) se difiere si se aprueba P-11 | el recorrido priorizado empieza en la captura rápida |
| GL-07 | Mismo objetivo; **el E2E sale de GL-07** y pasa a GL-09 | el E2E verifica todo el recorrido y depende de ADR-6 |
| GL-08 | **ID nuevo**: preparación reproducible de datos ficticios | no existía; no se reutiliza GL-04 para esto |
| GL-09 | **ID nuevo**: verificación E2E del recorrido núcleo | separado de GL-07 |

Ningún ID se reutilizó para un objetivo distinto.

## 4. Contradicciones con los requisitos vigentes y ajustes propuestos

Ninguna se resuelve en silencio. Las que cambian un requisito necesitan
aprobación (sección 6) y un delta explícito en el cambio de OpenSpec del
ticket.

| # | Requisito vigente | Qué choca | Ajuste propuesto | ¿Relaja privacidad? |
|---|---|---|---|---|
| C1 | Spec `initial-administrator`, escenario «Repositorio sin credenciales»: no hay «contraseñas o cuentas predefinidas, incluidos los seeds». AM-5 y PP-1: cuentas solo por invitación | preparar cuentas ficticias con semillas o una tarea crea cuentas predefinidas | **Modificar el escenario de forma explícita** en GL-08 (delta `MODIFIED`): siguen prohibidas las contraseñas y los hashes versionados; se admiten cuentas ficticias (`@example.test`) solo en desarrollo, sin contraseña utilizable hasta que alguien la establece sin eco. La invitación (PP-1, AM-5) sigue pendiente en GL-04 y bloquea cargar datos reales. Requiere P-6 | no: no hay credenciales versionadas y el entorno es solo de desarrollo |
| C2 | Anexo G, G.2: los datos preparados no cuentan como recorrido funcional | el núcleo usa datos preparados | hito propio «recorrido núcleo», distinto de «primer recorrido usable» (sección 2); el Anexo G no se modifica | no |
| C3 | PP-9 y AM-1: el autor sin asignación sigue leyendo sus entradas, incluidos los borradores, con datos mínimos de la persona, y puede revocar | diferir la administración de asignaciones no cambia ese derecho; en el núcleo, una asignación solo se termina por consola | **se conserva la regla aprobada:** la lectura de una entrada propia depende de la autoría y de la cuenta activa, no de la asignación. Ver P-7 (sección 6.1) | no |
| C4 | PP-5, D2, 4.2, 4.3, 4.12, 4.13: el resumen y la cronología incluyen lo compartido conmigo | compartir está diferido | resumen y cronología solo con las entradas propias; 4.2, 4.3, 4.12 y 4.13 quedan **parciales**, no completos | no: es un subconjunto más privado |
| C5 | PP-8, 1.10, 1.21: el administrador no lee entradas ni resúmenes; administra desde una vista propia | no hay vista de administración | el rol de administrador **no da ningún acceso** en las vistas del líder; una cuenta administradora ve como líder solo las personas que tiene asignadas. Se prueba en GL-03 y GL-06/GL-07 | no |
| C6 | AM-4 y PT-9: nunca queda la instancia sin administrador activo | protección diferida | sin interfaz que cambie roles o desactive cuentas, solo la consola puede violarlo; la guía lo advierte. Sigue pendiente (I7) y bloquea datos reales | no |
| C7 | AM-3, PT-10: revocación administrativa | diferida | sin comparticiones no hay nada que revocar. Compartir **no puede publicarse** antes que la revocación del autor (D2); antes de cargar datos reales siguen haciendo falta I7, I8 e I9 (Anexo G, G.6) | no |
| C8 | README 1.2 y criterio 2.4: señales «positivo, mejora o neutral». Mock 1: «Positivo», «A mejorar». Criterio 4.1: el resumen muestra «positivos, mejoras y total» | etiquetas distintas; la señal neutral no tiene columna | decidir valores internos, etiquetas y columnas (P-2) | no |
| C9 | 2.4: dimensión «de una lista fija», **[Por confirmar]** | sin lista no se puede marcar como lista (2.6) | decidir la lista (P-1) | no |
| C10 | 2.6 y 3.5: para marcar como lista solo se exige la dimensión | el resumen cuenta por señal; una entrada lista sin señal solo sumaría al total | decidir si la señal es obligatoria al marcar como lista (P-3) | no |
| C11 | README 2.6: el E2E llega hasta compartir y la lectura del destinatario | compartir está diferido | GL-09 cubre el núcleo; el E2E con compartición sigue pendiente (I4) | no |
| C12 | `openspec/config.yaml`: ADR-2 «abierta» y plan en el Anexo G | desactualizado tras GL-02 | actualizar el contexto (hecho en este paso, solo texto) | no |
| C13 | GL-02 y `docs/desarrollo.md` remiten las asignaciones y las siguientes cuentas a GL-04 | GL-04 queda diferido | remitir a este plan, a GL-03 y a GL-08 (hecho en este paso) | no |

## 5. Tickets del recorrido núcleo

Los criterios son los del [Anexo A](../anexos/anexo-a-historias.md).
«Parcial» indica que falta una rama diferida, que se nombra.

### GL-03. Autorización mínima del recorrido

Detalle en [el ticket](tickets/GL-03-autorizacion-minima.md). Protege el
recorrido núcleo **sin adelantar la compartición ni construir una
plataforma genérica de permisos**: dos reglas (acceso a la persona por
asignación activa; lectura y edición de entradas solo por su autor) y el
mecanismo que hace fallar una prueba si una acción del producto queda sin
autorización.

### GL-08. Datos ficticios reproducibles

Detalle en [el ticket](tickets/GL-08-datos-ficticios.md): datos propuestos,
credenciales y criterios D1 a D11. Tarea explícita solo en desarrollo, sin
duplicar, sobrescribir ni borrar, sin adoptar cuentas ajenas, sin
contraseñas ni hashes versionados; la administradora sigue creándose con
`growth_log:crear_administrador`. Delta de spec explícito: C1. Deja
preparado, sin comprobarlo, el caso de dos líderes de la misma persona, cuyo
aislamiento sobre el feedback prueba GL-06.

### GL-05. «Personas» y ficha del líder

- **Criterios:** 1.14 (completo, con P-9), 1.16, 1.17, 1.19 por la
  interfaz; 1.21 parcial (sin vista de administración). 1.18 (nombres de
  los otros líderes) se difiere con la compartición: no mostrarlos es más
  restrictivo.
- **Fuera de alcance:** conteo de entradas (GL-07), administración (GL-04).

### GL-06. Captura rápida, completar y marcar como lista

- **Criterios:** 3.1, 3.2, 3.4 a 3.8; 2.3 a 2.6, 2.8, 2.9 y 2.10 a través
  del formulario de completar; 4.8, 4.9 y 4.11 parciales (sin entradas
  compartidas ni feed). 3.9 se cumple porque no existe compartir.
- **Requisitos no funcionales:** el texto de las entradas no aparece en los
  logs (README 2.5); ningún texto dice «Publicar» (RN-2).
- **Pruebas de privacidad obligatorias:** el **borrador y la entrada lista**
  de L1 no son accesibles para L2 (asignado a la misma persona), L3 (sin
  asignación) ni la administradora, en detalle, edición, marcar como lista
  y URL directa, con la misma respuesta que un recurso inexistente.
- **Diferido (P-11):** formulario completo «+ Feedback» (2.1, 2.2, 2.7).

### GL-07. Resumen por dimensión y cronología

- **Criterios:** 3.3, 4.1, 4.4, 4.5; 4.2, 4.3, 4.12 y 4.13 parciales (solo
  entradas propias); 1.15 parcial (conteo en «Personas» sin compartidas).
- **Pruebas de privacidad obligatorias:** una entrada **lista** de L1 no
  cuenta en el resumen ni aparece en la cronología ni en el conteo de L2,
  aunque los dos acompañen a la misma persona; un borrador no cuenta ni
  para su autor.
- **Diferido:** filtros 4.6 y 4.7 (I6), origen «compartida con vos».

### GL-09. Verificación E2E del recorrido núcleo

- **Resultado:** una prueba en navegador, en el CI, que recorre: iniciar
  sesión → elegir una persona asignada → captura rápida → completar →
  marcar como lista → ver la entrada en el resumen y en la cronología; y
  una rama negativa en navegador: otro líder asignado a la misma persona no
  ve la entrada y su URL directa no la muestra.
- **Bloquea:** P-4 (ADR-6). Agrega dependencias de prueba, que se aprueban
  en el ticket.

### Diferido: sigue siendo requisito pendiente

| Qué | Criterios y casos | Dónde estaba en el Anexo G | Ticket |
|---|---|---|---|
| Invitaciones y establecer contraseña | 1.1 a 1.3; PT-7, PT-8 | I1 (T1.2), I9 (T9.2) | GL-04 |
| Vista de administración: personas, cuentas y asignaciones | 1.4 a 1.8, 1.10, 1.20, 1.21 (resto) | I1 (T1.3) | GL-04 |
| Terminar asignaciones y reasignar; autor sin asignación | 1.9, 3.10, 4.14, 5.10, 5.12; PT-4, PT-11 | I4 (T4.5), I5 | sin ID |
| Compartir y revocar por el autor; nombres de otros líderes | 1.18, 4.10, 5.6, 5.7, 5.9; PT-2, PT-3, PT-12; ramas compartidas de 4.2, 4.3, 4.8, 4.9, 4.12, 4.13 | I4 | sin ID |
| Feed y filtros | 4.6, 4.7, 4.11 (feed), 5.1 a 5.5, 5.8 | I6 | sin ID |
| Baja de personas, desactivar cuentas, último administrador, doble función | 1.6, 1.7, 1.11, 1.12, 1.21; PT-5, PT-6, PT-9 | I7 | sin ID |
| Revocación administrativa | 1.13; PT-1 completo, PT-10 | I8 | sin ID |
| Despliegue, correo real, backups, errores; HTTPS forzado y CSP | 1.1 (entrega real); E4 | I9, E4 | sin ID |

Los IDs de lo diferido sin ticket se asignan cuando se planifique cada uno,
sin reutilizar números.

**Datos reales:** ninguna parte del núcleo habilita cargar datos reales.
Siguen haciendo falta, como dice el Anexo G (G.6), E4, I7, I8 e I9, y
además GL-04.

## 6. Decisiones pendientes de aprobación

Aprobadas por Pablo: **P-5, P-7, P-8, P-9 y P-12** (02/11/2026), en los
términos de la sección 6.1 y la sección 8, y **P-6, P-13, P-14, P-15, P-16 y P-17** (03/11/2026). Las demás siguen siendo
recomendaciones, **sin aprobar**.

| # | Decisión | Bloquea | Recomendación | Alternativas |
|---|---|---|---|---|
| P-1 | Lista de dimensiones (2.4, Anexo C, C.4) | GL-06 | cinco dimensiones fijas, en código y con una restricción en la base: `delivery` «Entrega», `technical_quality` «Calidad técnica», `teamwork` «Trabajo en equipo», `communication` «Comunicación», `initiative` «Iniciativa». Cambiarla después exige una migración y una decisión | las tres del mock 1 («Trabajo en equipo», «Claridad», «Entrega»); lista configurable por el administrador (no cumple «lista fija» y requiere administración) |
| P-2 | Señales: valores internos, etiquetas y columnas del resumen | GL-06, GL-07 | valores `positive`, `improvement`, `neutral`; etiquetas «Positivo», «A mejorar», «Neutral»; el resumen muestra Positivos, A mejorar, Neutrales y Total, para que el total sea la suma visible. **Ajusta la presentación de 4.1**, que hoy nombra solo positivos, mejoras y total | etiqueta «Mejora» (README) en lugar de «A mejorar» (mock); mantener 4.1 literal, con la señal neutral solo dentro del total |
| P-3 | ¿La señal es obligatoria para marcar como lista? | GL-06 | sí: dimensión y señal obligatorias para «lista»; en borrador, ambas opcionales. **Amplía 2.6 y 3.5** | solo la dimensión, como dicen 2.6 y 3.5 hoy |
| P-4 | ADR-6: herramienta E2E | GL-09 | pruebas de sistema de RSpec con Capybara y `selenium-webdriver` con Chrome sin interfaz: es lo que trae Rails, mantiene una sola suite y no agrega Node | Playwright (agrega Node y otro ejecutor); Cuprite (más rápido, otra gema y menos estándar) |
| P-5 | ADR-3: mecanismo de políticas y respuesta ante un acceso no autorizado | GL-03 | **Aprobada.** Pundit 2.5.2 con políticas que deniegan por defecto, verificaciones como red ante omisiones y pruebas de comportamiento como evidencia; 404 sin revelar existencia. Detalle en 6.1 | objetos de política propios; Action Policy; 403 |
| P-6 | Preparación de datos ficticios (C1) | GL-08 | **Aprobada (03/11/2026):** tarea explícita solo en `development`; cuentas, personas y asignaciones suficientes para varios líderes y aislamiento; sin contraseñas ni hashes fijos versionados; contraseñas sin eco o generadas y entregadas localmente sin exponerlas; nada al arrancar ni al migrar | — |
| P-7 | Qué cambia cuando termina la asignación del autor (C3) | GL-03 | **Aprobada.** Conservar PP-9 y AM-1 en las reglas desde GL-03; no bloquea el núcleo. Detalle en 6.1 | diferir todo a I5 sin acceso para el autor (incumpliría PP-9; descartado) |
| P-8 | Unicidad de asignaciones | GL-03 | **Aprobada.** Una sola asignación **activa por par líder y persona**; nunca una sola por persona. Detalle en 6.1 | validación solo en el modelo |
| P-9 | Estados de la persona, de la asignación y de la cuenta | GL-03, GL-05 | **Aprobada.** Tres estados independientes, con efectos separados; `people.active` desde el inicio. Detalle en 6.1 | posponer `active` hasta I7 |
| P-10 | Cronología | GL-07 | por fecha del hecho, de la más antigua a la más reciente (como el mock 1), y los borradores propios aparecen marcados «Borrador · solo vos · fuera del resumen» | solo entradas listas en la cronología |
| P-11 | Formulario completo «+ Feedback» (2.1, 2.2, 2.7) | GL-06 | diferirlo: el recorrido priorizado empieza en la captura rápida, y los campos y validaciones de H2 se cubren al completar | incluirlo en GL-06 |
| P-12 | Contexto del proyecto para la IA (sección 8) | — | **Aprobada:** creado `CLAUDE.md`. Crear `CLAUDE.md` en la raíz con el contenido mínimo propuesto | no crearlo y mantener solo `openspec/config.yaml` |
| P-13 | Cómo se distinguen los registros del conjunto ficticio | GL-08 | **Aprobada (03/11/2026).** Tabla `sample_data_records` con una marca por registro creado; sin marca no se adopta nada, aunque coincida el correo ([diseño](../openspec/changes/archive/2026-11-03-gl-08-datos-ficticios/design.md#3-marcas-tabla-sample_data_records-p-13-aprobada-el-03112026)) | columna en las tablas del dominio; reconocer por correo (adopta cuentas ajenas) |
| P-14 | Entrega de las contraseñas de las cuentas ficticias | GL-08 | **Aprobada (03/11/2026).** Cuentas creadas con una contraseña aleatoria descartada; `growth_log:contrasena_ficticia` la pide dos veces sin eco, una cuenta por vez; el agente no la ejecuta con contraseñas visibles | generarlas y guardarlas en un archivo local 0600 (deja un secreto en disco) |
| P-15 | Página de inicio tras iniciar sesión | GL-05 | **Aprobada (03/11/2026).** El listado «Personas» reemplaza la página provisoria de GL-02; se eliminan `HomeController` y `HomePolicy`, y «Sesión iniciada como» pasa a la cabecera | mantener la página provisoria con un enlace a «Personas» |
| P-16 | Rutas de personas | GL-05 | **Aprobada (03/11/2026).** `/personas` y `/personas/:id`, en español como la interfaz; el listado responde también en `/` | `/people` |
| P-17 | Datos de la ficha | GL-05 | **Aprobada (03/11/2026).** Nombre, rol y equipo; «Sin rol indicado» o «Sin equipo indicado» si falta uno; sin otros líderes (1.18 diferido), fechas ni estado | omitir la línea si falta el dato |
| P-18 | ¿Fijar Rails 8.1.4.1 como mínimo en el `Gemfile`? | — | no cambiar el `Gemfile`: `~> 8.1.4` ya admite 8.1.4.1 y el diff queda en el lockfile ([GL-01b](tickets/GL-01b-rails-8-1-4-1.md)) | `gem "rails", "~> 8.1.4", ">= 8.1.4.1"`, que impide volver a una versión vulnerable con un `bundle update` |

### 6.1. Detalle de las decisiones que abren GL-03

#### P-5. Mecanismo de políticas (ADR-3) y respuesta

**Recomendación:** Pundit 2.5.2 (última versión publicada, 24/09/2025; se
revisa como `bcrypt` en GL-02), sin roles ni permisos configurables.

| Pieza | Qué hace | Qué detecta y qué **no** |
|---|---|---|
| `ApplicationPolicy` que devuelve `false` en toda consulta y un `Scope` que devuelve `scope.none` | una política nueva o una acción sin regla propia deniega | **detecta** la falta de una regla: se deniega. **No** detecta una regla escrita mal |
| `after_action :verify_authorized` en todos los controladores del producto | lanza `Pundit::AuthorizationNotPerformedError` si la acción no llamó a `authorize` | **detecta** la omisión de `authorize`. **No** comprueba que se autorizó el objeto correcto, con la consulta correcta, ni que la regla sea correcta. Corre **después** de la acción: no impide efectos ya hechos; es una red para las pruebas, no un control en producción |
| `after_action :verify_policy_scoped` en toda acción que lee registros (`index`, y `show`, `edit`, `update` y las acciones de miembro que cargan por id) | lanza `Pundit::PolicyScopingNotPerformedError` si no se llamó a `policy_scope` | **detecta** que no se llamó. **No** detecta una consulta sin alcance hecha además en la misma acción (por ejemplo, `Entry.find(params[:id])` junto a un `policy_scope` sin usar) |
| Carga por alcance en las acciones de miembro: `policy_scope(Modelo).find(params[:id])` y después `authorize` sobre ese registro | lo que está fuera del alcance no se encuentra: 404 | la lectura queda acotada por construcción; la acción concreta (editar, marcar como lista) la decide `authorize` |
| `rescue_from Pundit::NotAuthorizedError` → la misma respuesta 404 que `ActiveRecord::RecordNotFound` | no revela si el recurso existe | — |
| Excepciones declaradas: solo `SessionsController` y el chequeo de salud omiten las verificaciones, en una lista fija | evita `skip_authorization` o `skip_after_action` sueltos | una prueba compara la lista de controladores sin verificación con la lista declarada |
| Consultas fuera de controladores (resumen, cronología, conteos) | reciben el alcance ya resuelto, nunca el modelo | ninguna verificación de Pundit lo cubre: solo las pruebas de comportamiento |

**Qué prueba que la decisión es correcta.** La llamada a `authorize` o a
`policy_scope` **no** es evidencia de que la decisión sea correcta. La
evidencia son:

1. pruebas de política por regla y por actor (permitido y denegado), con
   L1, L2, L3 y la administradora A;
2. pruebas de peticiones con la matriz de actores, también por URL directa:
   404, sin el contenido ajeno en la respuesta y sin cambios en la base;
3. una prueba que recorre todas las rutas del producto con un usuario sin
   permisos: cada una responde 404 o redirige, nunca 200 con contenido ni
   un error por verificación omitida;
4. mutaciones registradas: quitar `authorize` hace fallar la prueba 3;
   cambiar `policy_scope(Modelo).find` por `Modelo.find` hace fallar la
   prueba 2; invertir una condición de la política hace fallar la prueba 1.

**Criterios de aceptación** (GL-03): B1, B2 y B3 del
[ticket](tickets/GL-03-autorizacion-minima.md). **Requisitos:** README 2.5
(denegar por defecto, consultas con alcance, URL directa), ADR-3, E3 y
RN-1.

#### P-7. Asignación terminada del autor (PP-9, AM-1)

**Recomendación:** conservar la regla aprobada. Se descarta «sin acceso
hasta I5».

Reglas que GL-03 deja definidas (PP-2, PP-3, PP-4, PP-9, AM-1):

| Acción | Condición |
|---|---|
| Abrir la ficha de una persona | asignación activa con ella (y persona activa, P-9) |
| Leer una entrada | ser su autor, con cuenta activa; **no** depende de la asignación |
| Crear, editar o marcar como lista | ser el autor y tener asignación activa con la persona |
| Leer entradas ajenas | nunca en el núcleo (compartir está diferido) |

**Trabajo adicional concreto para cumplirla:**

| Trabajo | Dónde | ¿Es nuevo? |
|---|---|---|
| Separar el predicado de lectura (autoría) del de escritura (autoría y asignación) | política de entradas, GL-06 | no: es la forma natural de escribir la política |
| Que el detalle de una entrada propia funcione sin asignación, sin enlace a la ficha ni otros datos de la persona salvo los mínimos | vista de detalle de GL-06 | sí, poco: una condición en la vista y dos pruebas |
| Qué datos mínimos se muestran (Anexo C propone: nombre de la persona, fecha del hecho, estado y su propio texto) | decisión | sí: **detalle de AM-1 no decidido** |
| Un lugar donde el autor sin asignación encuentre esas entradas (sin la ficha ni el feed) | listado mínimo | sí: una consulta y una sección; sin él solo se llega por URL directa |
| Pruebas de 3.10 y 4.14 y de la rama de lectura de PT-11 | GL-06 | sí |

**¿Bloquea el núcleo?** No. En el núcleo ninguna pantalla termina una
asignación; solo la consola puede hacerlo. Las reglas quedan correctas
desde el principio sin costo relevante. Lo que queda pendiente, y se
registra así, es **dónde encuentra el autor** sus entradas cuando no tiene
asignación y **qué datos mínimos** ve. Mientras falten, 3.10 y 4.14 son
**parciales**: el permiso existe, pero la interfaz para usarlo no. No se
agrega a GL-06 ni a GL-07 sin una decisión aparte. La revocación de PP-9
llega con compartir.

**Criterios de aceptación** (GL-03, sobre personas): B2 y B5. La regla de
entradas se especifica en el diseño de GL-03 y se aplica en GL-06.
**Requisitos:** PP-2, PP-9, AM-1; criterios 1.9, 1.19, 3.10, 4.14; PT-11
(parcial).

#### P-8. Unicidad de asignaciones

**Recomendación:** índice único **parcial** sobre `(leader_id, person_id)`
donde `ended_at IS NULL`. Restringe un par líder y persona; **no** limita
cuántos líderes tiene una persona ni cuántas personas tiene un líder.
Además: claves foráneas obligatorias y `ended_at` posterior o igual a
`started_at`.

| Situación | Resultado esperado |
|---|---|
| L1 y L2 con asignación activa con P al mismo tiempo | se permite (1.8, D1) |
| L1 con asignación activa con P y con Q | se permite |
| Una segunda asignación activa de L1 con P | la base la rechaza, también con inserciones simultáneas |
| L1 termina su asignación con P y se crea otra | se permite: reasignar crea una fila nueva (README 3.2) |
| Una sola asignación por persona | **no existe** esa restricción |

**Criterio de aceptación:** B4 (los cuatro primeros casos, con una prueba
concurrente del tercero). **Requisitos:** D1, 1.8, README 3.1 y 3.2.

#### P-9. Estados de la persona, de la asignación y de la cuenta

Tres estados independientes; ninguno modifica a los otros.

| Estado | Columna | Qué afecta | Qué no afecta |
|---|---|---|---|
| Persona activa | `people.active`, verdadero por defecto | si es falso: no aparece en «Personas» (1.14) y no se registra feedback nuevo sobre ella; conserva su historial (1.6) | las asignaciones ni las cuentas; la autoría de las entradas |
| Asignación activa | `assignments.ended_at` nulo | da acceso a la ficha y a crear, editar y marcar como lista (PP-2); al terminar se pierden, pero el autor sigue leyendo lo propio (PP-9) | la persona ni la cuenta; las entradas existentes |
| Cuenta activa | `users.deactivated_at` nulo (ya existe, GL-02) | si está desactivada no inicia sesión y sus sesiones se rechazan (GL-02, AM-2): no accede a nada | sus asignaciones y entradas no se borran ni cambian de autor (PP-7, D5) |
| Administrador | `users.admin` | nada en las vistas del líder (PP-8) | — |

**Hueco en los requisitos:** ningún criterio dice si un líder con
asignación activa puede abrir la ficha de una persona **dada de baja**. 1.6
solo dice que desaparece de los listados y conserva su historial.
**Propuesta mínima, para aprobar:** en el núcleo, la ficha de una persona
inactiva responde 404 y el autor conserva la lectura de sus entradas por
autoría (P-7). La baja por interfaz sigue en I7.

**Criterio de aceptación** (GL-03): B2 cubre persona inactiva y asignación
terminada; el estado de la cuenta ya está comprobado por GL-02 (A8).
**Requisitos:** 1.6, 1.14, PP-2, PP-7, AM-2, D5.

#### Aprobación para abrir el cambio de GL-03

Aprobado por Pablo el 02/11/2026, con estas precisiones: las verificaciones
de Pundit detectan omisiones y las pruebas de comportamiento comprueban las
reglas; el acceso desde la interfaz del autor sin asignación queda
explícitamente pendiente; la ficha de una persona inactiva responde 404 y
se conserva la lectura de las entradas propias. Puntos aprobados:

1. **P-5:** Pundit 2.5.2, denegación por defecto, verificaciones como red,
   carga por alcance, 404 y las cuatro pruebas de comportamiento.
2. **P-7:** conservar PP-9 y AM-1 en las reglas; dejar pendientes, sin
   adelantarlos, el listado del autor sin asignación y sus datos mínimos.
3. **P-8:** índice único parcial por par líder y persona.
4. **P-9:** tres estados separados, `people.active` desde el inicio y 404
   para la ficha de una persona inactiva.

Lo demás (P-1 a P-4, P-6, P-10 y P-11) sigue como propuesta y no bloquea
GL-03.

## 7. Evidencia del recorrido y del aislamiento entre líderes

### Ya comprobado: autenticación (GL-02)

Sin sesión, ninguna ruta del producto responde; sesión con vencimiento;
límites de intentos; cuentas desactivadas rechazadas. Evidencia: criterios
A1 a A14 de GL-02, CI
[41551853981](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41551853981)
y spec `authentication`. **Autenticación no es autorización:** GL-02 no
prueba nada sobre qué puede ver un líder con sesión.

### Comprobado: mecanismo de autorización y acceso a personas (GL-03)

Denegación por defecto, verificaciones de autorización y alcance con
excepciones por acción, 404 idéntico ante acceso denegado, política y
alcance de personas con varios líderes y una administradora, y unicidad de
la asignación activa por par bajo concurrencia. Evidencia: criterios B1 a
B9 de GL-03, CI [41571299236](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41571299236) y specs `authorization`, `people` y
`assignments`. **Límites:** el mecanismo se probó con un controlador solo
de prueba y la regla de personas a nivel de política y alcance; ninguna
ruta real de personas ni de feedback existe todavía.

### Pendiente: autorización de las funcionalidades (GL-05 a GL-09)

Cerrar GL-03 **no** verifica la autorización de GL-05, GL-06 ni GL-07: cada
uno la prueba con sus rutas y datos reales, y agrega sus rutas a la prueba
de cobertura de GL-03.

Datos de prueba de cada ticket: L1 y L2, líderes asignados a la misma
persona P; L3, líder sin asignación con P; A, administradora sin
asignación; y una persona Q sin asignaciones.

| Evidencia | Qué demuestra | Ticket |
|---|---|---|
| Prueba que recorre todas las rutas del producto con sesión y falla si una acción no verifica autorización o alcance | denegar por defecto (RN-1) | **comprobado en GL-03**; cada ticket agrega sus rutas |
| Mutación registrada: quitar la verificación de una acción hace fallar esa prueba | que la prueba detecta el hueco | **comprobado en GL-03** (mutación 1) |
| L3 y A piden la ficha de P y la de Q por URL directa: 404 | acceso a la persona solo por asignación activa (1.19, PP-2); administrar no da acceso (PP-8) | regla comprobada en GL-03 a nivel de política; **URL directa pendiente en GL-05** |
| Matriz de peticiones sobre el **borrador** y sobre la **entrada lista** de L1: detalle, edición, marcar como lista, por L2, L3 y A, con URL directa: 404 y sin cambios en la base | borrador y lista privados (PP-3, PP-4, 4.9, 4.11) | GL-06 |
| Las respuestas a L2 no contienen el texto de la entrada de L1 | no hay fuga en el cuerpo | GL-06, GL-07 |
| Resumen, cronología y conteo de L2 sobre P no incluyen la entrada lista de L1; los de L1 sí; un borrador no cuenta | consultas con alcance (4.11, 4.12 parcial, 3.3, 1.15 parcial) | GL-07 |
| Mutación registrada: quitar el alcance de la consulta del resumen hace fallar la prueba | que la prueba detecta la fuga | GL-07 |
| E2E en navegador del recorrido completo y rama negativa de L2 | el recorrido funciona por la interfaz | GL-09 |
| Log de pruebas sin el texto de las entradas | feedback fuera de los logs | GL-06 |
| `bin/ci` local y CI remoto en verde sobre el SHA publicado | integración | cada ticket |

Cada ticket registra lo ejecutado en su diseño, distinguiendo local y
remoto, como en GL-02. PT-1 queda **parcial** (sin vista de administración
ni feed) y no se declara completo.

## 8. Contexto del proyecto para la IA

[`CLAUDE.md`](../CLAUDE.md), en la raíz, creado con P-12 (02/11/2026): stack,
comandos verificados, dónde está cada cosa y reglas de trabajo. Remite a
este plan, a los tickets y a las specs en lugar de copiar requisitos.
`openspec/config.yaml` conserva el contexto de los artefactos de OpenSpec.
No hay configuraciones personales ni permisos nuevos.

## 9. Próximo paso

GL-05 está en curso ([ticket](tickets/GL-05-personas.md), cambio
[`gl-05-personas`](../openspec/changes/gl-05-personas/proposal.md)).
P-15, P-16 y P-17 están aprobadas (03/11/2026). La implementación está
hecha y, desde el 07/11/2026, integrada con GL-01b (Rails 8.1.4.1) en
`feature/GL-05-personas` (`a60fb8e`); en ese árbol `bin/ci` pasó con 192
ejemplos. Faltan la comprobación manual en navegador, el CI remoto y el
archivo. GL-01b está integrado en `feature/entrega-2-pp`; quedan su
archivo y P-18, que no bloquea. La prueba automatizada en
navegador sigue bloqueada por P-4 (ADR-6) y queda para GL-09; en GL-05 hay
una comprobación manual. El aislamiento del feedback entre líderes de la
misma persona sigue pendiente para GL-06.
