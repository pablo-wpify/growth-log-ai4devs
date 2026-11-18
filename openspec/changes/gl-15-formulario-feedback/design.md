# Design

> **Estado (18/11/2026): implementado en local, sin commit.** Decisiones
> de diseño cerradas; verificación local (specs y `bin/ci` en código 0) y
> conformidad visual de Pablo registradas (diseño, sección 8). Sin
> publicar, integrar ni archivar.
> Borrador documental del 17/11/2026; criterios de diseño acordados y
> cerrados el 18/11/2026 (sección 4).

## 1. Fuentes

- **Criterios:** 2.1, 2.2 y 2.7 de H2 (`anexos/anexo-a-historias.md:108`,
  `:109` y `:114`). La tarea T2.1 incluye además 2.3, 2.4, 2.5 y 2.10
  (`anexos/anexo-g-plan-incremental.md:81`).
- **Tarea:** T2.1, «formulario completo "+ Feedback" en la ficha»,
  depende de T1.6, con «tests de validación y de sistema».
- **Decisiones vigentes:**
  - P-1, P-2 y P-3: listas fijas, y dimensión y señal obligatorias para
    «lista»;
  - P-11: difirió este formulario en la entrega 2;
  - P-20: escribir exige autoría, asignación activa y persona activa;
  - P-22: página propia, **solo para la captura rápida**;
  - P-23: zona horaria de «hoy»;
  - P-34 y P-38 (GL-13): lenguaje visual y aviso de la ficha.
- **Implementación existente (T1.6, GL-06):**
  - `app/controllers/feedback_entries_controller.rb`: captura (`new` y
    `create`), edición, detalle y «Marcar como lista»;
  - `app/models/feedback_entry.rb`: validaciones, `DIMENSIONS`, `SIGNALS`
    y `READY_FIELDS`;
  - `app/policies/feedback_entry_policy.rb`: `create?` exige autoría y
    persona en el alcance;
  - `app/views/feedback_entries/edit.html.erb`: los campos completos;
  - `app/views/people/show.html.erb`: la ficha con «Captura rápida».

## 2. Lo que ya existe y se reutiliza

- **Modelo y base:** todos los campos, las restricciones y la validación
  de una entrada lista ya existen. No hacen falta migraciones.
- **Autorización:** el alcance de personas (`policy_scope(Person)`) y
  `FeedbackEntryPolicy#create?`, como la captura. Una persona fuera del
  alcance responde 404.
- **Campos del formulario:** los mismos que la edición, con sus etiquetas,
  la opción «Sin indicar» y los mensajes de error en español.
- **Textos de privacidad:** los estados «solo vos» y los avisos sin
  «Publicar» de `feedback-capture`.

## 3. Diseño técnico

Turbo es una decisión de implementación, no un requisito de producto: los
deltas piden que el formulario se abra en la ficha y que funcione sin
JavaScript, sin nombrar la técnica.

- **Herramientas:** Hotwire/Turbo tal como ya está en el proyecto
  (`turbo-rails` 2.0.23 por importmap, con Rails 8.1.4.1). No se
  actualiza Rails, no se agregan dependencias, JavaScript propio,
  controladores de Stimulus ni una SPA.
- **Turbo Frames, sin Turbo Streams:** el flujo es abrir un formulario en
  un lugar de la ficha y, al enviarlo, mostrar la ficha completa: con el
  aviso si se guardó, o con el formulario y sus errores si no. Eso lo
  cubren un frame y la navegación normal de Turbo Drive. No hay que
  actualizar varias partes de la página por separado, que es lo que
  justificaría Turbo Streams.
- **Rutas:** siguen la convención de `config/routes.rb` (sección 4.2,
  punto 1). La implementada es `GET` y `POST
  /personas/:person_id/entradas/completa`, acciones `new_complete` y
  `create_complete`, helper `person_complete_feedback_entry_path`. La URL
  no es un requisito: las pruebas usan los helpers de ruta.
- **Acceso:** un enlace «+ Feedback» en la cabecera de la ficha, junto a
  «Captura rápida», que conserva su jerarquía de acción principal (GL-13);
  «+ Feedback» usa el botón común, con áreas táctiles de 44 px
  (`visual-language`).
- **Misma página, con mejora progresiva:** la ficha tiene un Turbo frame
  vacío (`feedback_form`) y el enlace apunta a él. El servidor responde
  con HTML renderizado por Rails: una página con el mismo frame y el
  formulario adentro. Con Turbo, el frame se inserta en la ficha sin
  cambiar de URL. Sin JavaScript, el mismo enlace navega a esa página.
  En los dos casos el formulario se envía fuera del frame
  (`data-turbo-frame="_top"`): con Turbo, como una navegación de Turbo
  Drive; sin JavaScript, como un formulario común.
- **Formulario:** fecha del hecho precargada con `Time.zone.today`, que
  usa la zona configurada en `config.time_zone` (hoy
  `America/Argentina/Buenos_Aires`, P-23), en un campo editable; al
  guardar se usa el valor enviado (`occurred_on` ya está entre los
  parámetros permitidos de la edición), no la fecha de hoy;
  contexto; señal y dimensión con «Sin indicar»; evidencia; impacto y
  confianza.
- **Guardado:** dos botones de envío, «Guardar borrador» y «Guardar como
  lista», con el mismo nombre de parámetro de estado y los valores
  `draft` y `ready`. El controlador acepta ese estado y los campos de la
  entrada, nunca `author_id` ni `person_id`: la persona sale del alcance
  (`policy_scope(Person)`) y la autoría, de la sesión, como en la captura.
- **Estado ausente o desconocido:** el modelo vigente ya define los dos
  casos y no hace falta código nuevo para ninguno.
  - Sin estado, la entrada queda en borrador: `enum :status` con
    `default: "draft"` y el valor por defecto de la columna.
  - Un valor que no es `draft` ni `ready` es un error de validación:
    `enum … validate: true` y la restricción `feedback_entries_status_allowed`.
    El controlador no lo traduce a borrador.
- **Validación y errores:** la del modelo. En un borrador, señal y
  dimensión son opcionales; como lista, `ready_entries_complete` informa
  qué falta (P-3); sin contexto o sin fecha, el error de cada campo. Con
  cualquier error, el servidor vuelve a renderizar la ficha completa
  (`people/show`) con el formulario dentro de su frame, lo cargado y los
  errores, con estado 422. El resumen y la cronología salen del concern
  `PersonPage`, compartido con `PeopleController#show`. Con Turbo, Turbo
  Drive muestra esa respuesta y la URL sigue siendo la de la ficha; sin
  JavaScript, es una página común. La ficha declara su sección de
  navegación, así que «Personas» queda activo también en esa respuesta.
- **Después de guardar:** redirección a la ficha con el aviso de éxito,
  para que el resumen y la cronología muestren la entrada nueva. El
  formulario se envía fuera del frame (`data-turbo-frame="_top"`), así que
  Turbo Drive sigue la redirección como una navegación normal y muestra la
  ficha completa con el aviso. No se usa `turbo-visit-control`: ver el
  desvío en la sección 8.
- **Disposición de las acciones:** desde 30 rem, «Guardar borrador»,
  «Guardar como lista» y «Cancelar» van en una fila; más angosto, cada una
  ocupa su fila con el mismo ancho y 44 px de alto (sección 8, «Ajustes
  visuales»).
- **Avisos:** al guardar un borrador, el de la captura («Guardamos tu
  borrador. Solo vos podés verlo.»); al guardar como lista, «Feedback
  guardado como lista.» (sección 4.3). Ningún aviso incluye el texto del
  feedback ni datos que revelen su contenido o a quién se refiere.
- **«Cancelar»:** un enlace común a la ficha de la persona, no un botón
  de envío, así que no guarda nada. Con Turbo, al estar dentro del frame,
  carga la ficha y toma de ella el frame vacío: el formulario se cierra y
  el resto de la ficha queda como estaba. Sin JavaScript, navega a la
  ficha. Lo cargado y no guardado se descarta.

## 4. Criterios de diseño

### 4.1 Acordados por Pablo (18/11/2026)

Concretan cómo se expresan 2.1 y 2.7; no amplían el alcance.

1. **«La misma página».** El formulario se presenta en la ficha, con
   Turbo Frames y HTML renderizado por Rails como mejora progresiva. Sin
   JavaScript, el enlace y el formulario funcionan como navegación y
   página comunes. No cambia P-22, que rige solo la captura.
2. **Después de guardar.** Si se guarda bien, se vuelve a la ficha con un
   aviso de éxito. Si hay errores de validación, se vuelve a mostrar el
   formulario con los errores.
3. **Nombres de las acciones.** «Guardar borrador» y «Guardar como
   lista».
4. **Señal y dimensión.** Opcionales en un borrador; obligatorias las dos
   para guardar como lista (P-3).
5. **Estado.** Un estado ausente sigue el comportamiento de borrador que
   ya define el modelo. Un valor desconocido produce un error de
   validación y no se convierte en borrador.
6. **Jerarquía.** «Captura rápida» conserva su jerarquía de acción
   principal; «+ Feedback» es una acción secundaria común.
7. **Orden y superposición con GL-14.** GL-15 va antes que GL-14. Al
   completar GL-15 se ajusta el delta de `people-browsing` de GL-14 para
   que los dos requisitos queden compatibles (sección 6).

Decisión técnica asociada: Hotwire/Turbo de la versión de Rails del
proyecto, sin actualizar Rails, sin SPA, sin JavaScript propio y sin
dependencias nuevas; Turbo Frames, sin Turbo Streams (sección 3).

### 4.2 Cerrados por Pablo (18/11/2026)

1. **Rutas: siguen las convenciones de la aplicación.** No se fija una
   URL como requisito de producto. Convención observada en
   `config/routes.rb`:
   - recursos REST de Rails (`resources`) con `only:` explícito, sin
     exponer acciones de más;
   - segmentos en español, como la interfaz (P-16): `path: "personas"`,
     `path: "entradas"` y `path_names: { new: "nueva" }`;
   - crear una entrada se anida bajo la persona (P-19), para que la
     persona salga de la URL y del alcance (`policy_scope(Person)`);
   - las acciones sobre una entrada existente no se anidan y usan rutas
     explícitas, por la lectura por autoría (PP-9).

   Aplicación a GL-15: el par para abrir y guardar el formulario se anida
   bajo la persona, dentro de `personas/:person_id/entradas`, con un
   segmento en español y solo los verbos GET y POST. Es una acción propia,
   separada de la captura (`nueva` y `create`), para no cambiar la captura
   ni P-22. El nombre del segmento se elige al implementar, dentro de esta
   convención, y se registra en este diseño.
2. **Aviso al guardar como lista:** «Feedback guardado como lista.»
   (sección 4.3).
3. **«Cancelar»:** vuelve a la ficha de la persona sin guardar los
   cambios (sección 3).

### 4.3 Aviso al guardar como lista (Pablo, 18/11/2026)

El requisito vigente «Textos que separan "lista" de "compartida"»
(`openspec/specs/feedback-capture/spec.md`) dice: «Los avisos de guardar
y marcar como lista SHALL decir que solo el autor ve la entrada». Pablo
decidió (tarea 0.6):

- **El aviso es exactamente «Feedback guardado como lista.».** Es un
  aviso genérico: solo confirma que la operación se completó.
- **No revela contenido ni identidad.** No incluye el texto del feedback
  ni datos que revelen su contenido o a quién se refiere.
- **Cambia el criterio del texto de los avisos, no la regla de
  privacidad.** El delta de `feedback-capture` modifica «Textos que
  separan "lista" de "compartida"» solo para admitir este aviso genérico
  sin la frase «solo el autor ve la entrada». La entrada sigue siendo
  privada de su autor, y los estados «Lista · solo vos» de la cronología y
  el detalle lo siguen indicando.

Opciones que se plantearon antes de esta decisión:

- **A.** Agregar al delta un MODIFIED de «Textos que separan "lista" de
  "compartida"» que exceptúe este aviso. Los estados «Lista · solo vos»
  de la cronología y el detalle siguen indicando la privacidad. Es la
  forma que tomó el delta en la corrección previa al commit
  (18/11/2026), limitada al criterio del texto de los avisos.
- **B.** Conservar el requisito y completar el aviso con la privacidad.
  Se eligió primero y después se precisó con la decisión de arriba: el
  aviso queda en «Feedback guardado como lista.», sin agregar texto.

## 5. Trazabilidad

| Criterio | Requisito (delta) | Escenarios | Tareas |
|---|---|---|---|
| 2.1 | `feedback-capture`: «Acceso visible a "+ Feedback"», «Formulario completo en la ficha»; `people-browsing`: «Solo lectura y sin funciones inexistentes» | «Ficha de una persona asignada», «Abrir el formulario en la ficha», «Abrir el formulario sin JavaScript», «Cancelar sin guardar», «Acciones disponibles en la ficha» | 1.1, 1.3, 1.4, 2.1, 2.2, 2.4 |
| 2.2 | «Fecha de hoy en el formulario» | «Fecha de hoy en la zona de la aplicación», «Guardar con otra fecha» | 1.1, 1.2, 1.3, 2.2, 2.3 |
| 2.7 | «Guardar como borrador o como lista» | «Guardar como borrador», «Guardar como lista», «Sin estado en el envío» | 1.2, 1.3, 1.4, 2.3 |
| 2.3 | «Validaciones del formulario completo» | «Sin contexto o sin fecha» | 1.2, 2.3 |
| 2.4, 2.5 | «Formulario completo en la ficha» | «Abrir el formulario en la ficha», «Guardar como lista» | 1.1, 1.2, 2.2 |
| 2.6 y P-3 | «Validaciones del formulario completo» | «Borrador sin señal ni dimensión», «Lista sin dimensión ni señal», «Lista con dimensión y sin señal» | 1.2, 2.3 |
| 2.8, 2.9 | «Guardar como borrador o como lista» | «Guardar como borrador», «Guardar como lista», «Otro líder de la misma persona» | 1.2, 2.3 |
| 2.10 y P-20 | «Formulario solo con asignación activa» | «Abrir sin asignación activa», «Guardar sin asignación» | 1.1, 1.2, 2.1 |
| — (seguridad) | «Guardar como borrador o como lista», «Validaciones del formulario completo» | «Parámetros no permitidos», «Estado desconocido» | 1.2, 2.3 |

## 6. Superposición con GL-14

GL-14 (borrador, sin autorización) también modifica «Solo lectura y sin
funciones inexistentes» de `people-browsing`. Su texto sigue prohibiendo
«+ Feedback» en la ficha, y su escenario «Acciones disponibles en la
ficha» dice que el único acceso para registrar feedback es «Captura
rápida». Los dos deltas parten de la spec vigente y reemplazan el
requisito completo.

Orden acordado (sección 4.1, punto 7): GL-15 va antes que GL-14. **Al
completar GL-15, se ajusta el delta de `people-browsing` de GL-14** sobre
la spec que deje GL-15, para que la ficha admita «+ Feedback» y el
listado conserve lo que agrega GL-14. Ese ajuste es un cambio a la
documentación de GL-14 y necesita el pedido de Pablo en su momento (tarea
4.4). Hoy no se modifica GL-14: su texto solo queda en contradicción con
la spec cuando GL-15 se archive.

GL-14 modifica además «Acceso visible a la captura rápida» de
`feedback-capture`. GL-15 no toca ese requisito: agrega requisitos
nuevos, y la jerarquía de «Captura rápida» como acción principal (sección
4.1, punto 6) es compatible con lo que pide GL-14.

## 7. Riesgos y verificación prevista

- **Segundo camino de escritura:** pruebas negativas por URL directa
  (sin asignación, persona inactiva, otro líder) sobre las dos rutas
  nuevas, y la cobertura de autorización existente
  (`spec/requests/authorization_coverage_spec.rb`) para las acciones
  nuevas.
- **«Lista» confundida con «compartida»:** pruebas de textos sin
  «Publicar» y con «solo vos».
- **Fecha de hoy:** la misma técnica de la prueba de P-23 de la captura,
  y una prueba que guarde una fecha distinta de hoy y compruebe que se
  guarda la elegida.
- **Misma página:** prueba de sistema con JavaScript (Chrome sin
  interfaz, ADR-6) que compruebe que la URL no cambia al abrir el
  formulario, que un error se muestra dentro de la ficha y que, al
  guardar, la ficha completa muestra el aviso y la entrada nueva; y una
  prueba sin JavaScript del enlace, el error y el guardado.
- **Salida del frame al guardar:** se resolvió enviando el formulario
  fuera del frame, sin `turbo-visit-control` (secciones 3 y 8); las
  pruebas de sistema con y sin JavaScript lo cubren.
- **Feedback fuera de los logs:** los parámetros nuevos pasan por el
  filtro existente (`feedback-entries`, «Texto del feedback fuera de los
  logs»).

## 8. Registro

### Implementación (18/11/2026)

Con la aprobación de Pablo para implementar (tarea 0.7). Las pruebas se
escribieron pero **no se ejecutaron**: el pedido excluyó correr pruebas y
CI en esta etapa, así que tampoco se comprobó que fallaran antes de
implementar.

- **Ruta elegida** (sección 4.2, punto 1): `GET` y `POST
  /personas/:person_id/entradas/completa`, acciones `new_complete` y
  `create_complete`, helper esperado `person_complete_feedback_entry_path`.
  El nombre del helper no se comprobó con `bin/rails routes`: lo
  comprueban las pruebas.
- **Desvío del mecanismo de salida del frame** (sección 3). No se usó
  `turbo-visit-control` en `reload`. Al leer `turbo.js` de `turbo-rails`
  2.0.23 apareció que Turbo Drive también rechaza mostrar una página con
  esa marca y la recarga, con lo que se perdería el aviso; además, la
  ficha pedida desde el frame llega con el layout mínimo de los frames. Se
  envía el formulario con `data-turbo-frame="_top"` y, con errores, se
  vuelve a mostrar la ficha completa con el formulario en su frame. Sigue
  siendo Turbo Frames con HTML renderizado por Rails, sin Turbo Streams,
  sin JavaScript propio ni dependencias nuevas.
- **Código:** las rutas; `FeedbackEntriesController#new_complete` y
  `#create_complete`; el concern `PersonPage`, que comparte el resumen y la
  cronología entre `PeopleController#show` y la ficha con errores; el
  mensaje del estado desconocido en el `enum` del modelo; las vistas
  `new_complete`, `_complete_form` y `_entry_fields` (esta última,
  compartida con la edición); la ficha con «+ Feedback» y el frame; los
  estilos de las acciones y del panel.
- **Pruebas escritas:** `spec/requests/feedback_complete_form_spec.rb` y
  `spec/system/feedback_complete_form_spec.rb` (con JavaScript y con
  `rack_test`); se actualizaron `navigation_spec`, `route_protection_spec`
  y `authorization_coverage_spec`.
- **Pendiente:** ejecutar las pruebas y `bin/ci` (tareas 1.x y 3.1), la
  comprobación manual (3.3) y la publicación (grupo 4). GL-14 y su delta
  no se tocaron (tarea 4.4).

### Ajustes visuales (18/11/2026)

A partir de las capturas a 375 × 812 y 1280 × 800, pedido sin número:

- **Acciones del formulario en pantalla angosta:** hasta 30 rem, «Guardar
  borrador», «Guardar como lista» y «Cancelar» ocupan cada una su fila,
  con el mismo ancho y 44 px de alto; desde ahí siguen en una fila. Solo
  CSS, limitado a `.entry-form-panel`.
- **Navegación en la ficha con errores:** la ficha declara su sección
  (`content_for :nav_section`) y el layout marca «Personas» también cuando
  la ficha la muestra `FeedbackEntriesController` con errores.
- **Pruebas primero:** se escribieron tres pruebas y las dos que cubren
  los defectos fallaron por la razón esperada antes del cambio. Después:
  specs de GL-15, navegación y lenguaje visual con 39 ejemplos y 0 fallos;
  `bin/ci` con código 0 y 428 ejemplos, sin actualizar la base de avisos
  de bundler-audit. Solo local; sin CI remoto.
- **Pendiente:** la conformidad visual de Pablo (tarea 3.3). Fuera de
  alcance: el resumen por dimensión que se desplaza en móvil (previo a
  GL-15).

### Conformidad visual (18/11/2026)

Pablo dio su conformidad visual a GL-15 (tarea 3.3) sobre las capturas
que revisó ese día, de la ficha, el formulario abierto y los errores al
guardar como lista, a 1280 × 800 y 375 × 812. Pedido sin número.

- **Botones en móvil:** «Guardar borrador», «Guardar como lista» y
  «Cancelar» quedan ordenados, uno por fila.
- **Navegación:** «Personas» conserva el estado activo también en la
  ficha con errores.
- **Observaciones fuera de GL-15:**
  - el resumen por dimensión se desplaza en horizontal en móvil; es
    previo a GL-15;
  - en la captura de página completa del formulario abierto a 375 × 812,
    la tabla del resumen sale en blanco; parece un efecto de la captura
    sobre una tabla con desplazamiento horizontal, porque en la captura
    con errores se ve bien.
- **Observación visual pendiente de GL-15:** con errores de validación,
  las opciones de Señal y Dimensión se apilan en vertical, mientras que
  con el formulario recién abierto van en línea. No se cambió este
  comportamiento.

### Verificación local (18/11/2026)

Solo local; sin CI remoto.

- **Specs de GL-15, `navigation_spec` y `visual_language_spec`:**
  `spec/requests/feedback_complete_form_spec.rb`,
  `spec/system/feedback_complete_form_spec.rb`,
  `spec/requests/navigation_spec.rb` y `spec/system/visual_language_spec.rb`:
  39 ejemplos, 0 fallos.
- **`bin/ci`:** código 0, con 428 ejemplos y 0 fallos; rubocop sin
  infracciones, bundler-audit sin vulnerabilidades, importmap audit sin
  paquetes vulnerables y Brakeman sin advertencias.
- **`openspec validate --all --strict`:** 23 de 23 en verde, según el
  reporte de implementación de GL-15.
- **Tareas cubiertas:** 1.1 a 1.4, 2.1 a 2.4, 3.2 y 3.4. La 3.3 ya tenía
  la conformidad visual (subsección anterior).
- **Desvíos:**
  - las pruebas de 1.1 a 1.4 se escribieron antes del código, pero no se
    vieron fallar antes de implementar (el pedido de implementación
    excluyó correr pruebas); solo las de los ajustes visuales se vieron
    fallar primero;
  - `bin/bundler-audit update` no se ejecutó, por indicación de Pablo:
    bundler-audit usó la base de avisos instalada. Por eso la tarea 3.1
    queda parcial.
- **Pendiente:** la tarea 3.1 (`bin/bundler-audit update`) y el grupo 4:
  commit y CI remoto, integración, archivo y el ajuste del delta de GL-14.

### Documentación

- 17/11/2026: borrador documental creado a pedido de Pablo. El pedido
  todavía no tiene número ni registro (ver `prompts.md`, «Mensajes sin
  registro»).
- 18/11/2026: Pablo acordó los criterios de diseño de la sección 4.1 y la
  decisión técnica sobre Turbo. Se ajustaron el ticket, la propuesta,
  este diseño, las tareas y el delta de `feedback-capture`. El pedido
  tampoco tiene número: la numeración posterior a M284 sigue pendiente.
- 18/11/2026: Pablo cerró los puntos de la sección 4.2: rutas según la
  convención existente, aviso «Feedback guardado como lista.» y
  «Cancelar» sin guardar. El aviso choca con un requisito vigente
  (sección 4.3), pendiente de decisión. Pedido sin número.
- 18/11/2026: a pedido de Pablo, el requisito «Fecha de hoy en el
  formulario» precisa la zona horaria configurada en la aplicación y que
  se guarda la fecha elegida (escenario «Guardar con otra fecha»). Pedido
  sin número.
- 18/11/2026: Pablo eligió la opción B para el aviso al guardar como
  lista (sección 4.3): se conserva el requisito de privacidad, el aviso
  solo confirma la operación y no incluye el texto del feedback ni a quién
  se refiere. Pedido sin número.
- 18/11/2026: Pablo precisó que el aviso es exactamente «Feedback guardado
  como lista.»: genérico, sin contenido ni identidad, y por eso no es una
  excepción al requisito general de privacidad. Se corrigieron el
  controlador, las pruebas, el delta, este diseño, las tareas y el
  ticket. Pedido sin número.
