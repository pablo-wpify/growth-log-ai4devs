## ADDED Requirements

### Requirement: Acceso visible a «+ Feedback»
La ficha de una persona del alcance de la cuenta SHALL ofrecer un acceso
visible a «+ Feedback», además de «Captura rápida» (criterio 2.1).
«Captura rápida» SHALL conservar su lugar de acción principal y
«+ Feedback» SHALL presentarse como acción secundaria.

#### Scenario: Ficha de una persona asignada
- **WHEN** un líder abre la ficha de una persona activa que tiene asignada
- **THEN** ve «Captura rápida» como acción principal y «+ Feedback» como acción secundaria

### Requirement: Formulario completo en la ficha
Al elegir «+ Feedback», el formulario SHALL abrirse en la misma página de
la ficha (criterio 2.1). Sin JavaScript, el acceso y el formulario SHALL
funcionar como un enlace y una página comunes. SHALL ofrecer la fecha del
hecho, el contexto, la señal y la dimensión de sus listas fijas (P-1 y
P-2), y la evidencia, el impacto y una confianza de 1 a 5, estos tres
opcionales (criterios 2.4 y 2.5).

#### Scenario: Abrir el formulario en la ficha
- **WHEN** un líder asignado elige «+ Feedback» en la ficha de una persona, en un navegador con JavaScript
- **THEN** el formulario aparece dentro de la ficha, sin cambiar de página, con todos los campos de la entrada

#### Scenario: Abrir el formulario sin JavaScript
- **WHEN** un líder asignado elige «+ Feedback» en un navegador sin JavaScript
- **THEN** el enlace lleva a una página con el mismo formulario, que se puede completar y guardar

#### Scenario: Cancelar sin guardar
- **WHEN** un líder completa parte del formulario y elige «Cancelar»
- **THEN** vuelve a la ficha de la persona y no se guarda ninguna entrada

### Requirement: Fecha de hoy en el formulario
Al abrirse, el formulario SHALL precargar la fecha del hecho con la fecha
actual según la zona horaria configurada en la aplicación (hoy
`America/Argentina/Buenos_Aires`, P-23) (criterio 2.2). La cuenta SHALL
poder cambiarla antes de guardar, y la entrada SHALL guardarse con la
fecha elegida.

#### Scenario: Fecha de hoy en la zona de la aplicación
- **WHEN** un líder abre el formulario a las 22:00 de Buenos Aires, cuando en UTC ya es el día siguiente
- **THEN** la fecha del hecho precargada es la de ese día en Buenos Aires

#### Scenario: Guardar con otra fecha
- **WHEN** un líder cambia la fecha precargada por otra y guarda, como borrador o como lista
- **THEN** la entrada se guarda con la fecha que eligió, no con la de hoy

### Requirement: Formulario solo con asignación activa
Abrir el formulario y guardarlo SHALL estar permitido solo a una cuenta
con una asignación activa con una persona activa (criterio 2.10, P-20).
En otro caso la respuesta MUST ser 404, igual que ante un recurso
inexistente, también por URL directa, y MUST NOT crearse ninguna entrada.

#### Scenario: Abrir sin asignación activa
- **WHEN** una cuenta sin asignación activa con la persona, o con la persona inactiva, pide el formulario por URL directa
- **THEN** la respuesta es 404

#### Scenario: Guardar sin asignación
- **WHEN** una cuenta sin asignación activa con la persona envía el formulario por URL directa
- **THEN** la respuesta es 404 y no se crea ninguna entrada

### Requirement: Guardar como borrador o como lista
El formulario SHALL ofrecer «Guardar borrador» y «Guardar como lista»
(2.7). La entrada SHALL quedar sobre esa persona, de la cuenta, con el
estado elegido y privada en los dos estados (2.8, 2.9); autor y persona
MUST NOT fijarse con parámetros. Al guardar SHALL volver a la ficha con un
aviso: el del borrador dice que solo su autor lo ve; el de lista es
«Feedback guardado como lista.». Ningún aviso MUST incluir el texto ni a
quién se refiere, ni decir «Publicar».

#### Scenario: Guardar como borrador
- **WHEN** un líder asignado completa la fecha y el contexto y elige «Guardar borrador»
- **THEN** se guarda un borrador de su autoría sobre esa persona, con esos datos, vuelve a la ficha y el aviso dice que solo su autor lo ve

#### Scenario: Guardar como lista
- **WHEN** un líder asignado completa la fecha, el contexto, la señal y la dimensión y elige «Guardar como lista»
- **THEN** se guarda una entrada lista de su autoría sobre esa persona, vuelve a la ficha y el aviso es «Feedback guardado como lista.», sin el texto del feedback ni a quién se refiere

#### Scenario: Parámetros no permitidos
- **WHEN** el envío incluye otro autor u otra persona
- **THEN** esos valores se ignoran: la entrada queda de la cuenta y sobre la persona de la ficha

#### Scenario: Sin estado en el envío
- **WHEN** el envío no incluye el estado
- **THEN** la entrada se guarda como borrador, el valor por defecto del modelo vigente

#### Scenario: Otro líder de la misma persona
- **WHEN** un líder guarda una entrada, borrador o lista, y otro líder asignado a la misma persona abre la ficha y el detalle por URL directa
- **THEN** el otro líder no ve la entrada en la ficha y recibe 404 en el detalle

### Requirement: Validaciones del formulario completo
Sin contexto o sin fecha del hecho, la entrada MUST NOT guardarse
(criterio 2.3). En un borrador, señal y dimensión son opcionales; al
guardar como lista sin alguna, MUST NOT guardarse (criterio 2.6, P-3). Un
valor de estado desconocido MUST NOT guardarse ni convertirse en
borrador. Con cualquier error, el formulario SHALL volver a mostrarse
con lo cargado y los errores, indicando qué falta.

#### Scenario: Sin contexto o sin fecha
- **WHEN** un líder guarda, como borrador o como lista, sin contexto o sin fecha del hecho
- **THEN** la respuesta tiene estado 422, el formulario se vuelve a mostrar con el error y no se guarda ninguna entrada

#### Scenario: Borrador sin señal ni dimensión
- **WHEN** un líder elige «Guardar borrador» con fecha y contexto, sin señal ni dimensión
- **THEN** se guarda el borrador

#### Scenario: Lista sin dimensión ni señal
- **WHEN** un líder elige «Guardar como lista» sin dimensión ni señal
- **THEN** la respuesta tiene estado 422, el formulario se vuelve a mostrar indicando que faltan la dimensión y la señal, y no se guarda ninguna entrada

#### Scenario: Lista con dimensión y sin señal
- **WHEN** un líder elige «Guardar como lista» con dimensión y sin señal
- **THEN** la respuesta tiene estado 422, el formulario se vuelve a mostrar indicando que falta la señal, y no se guarda ninguna entrada

#### Scenario: Estado desconocido
- **WHEN** el envío incluye un valor de estado que no es borrador ni lista
- **THEN** la respuesta tiene estado 422, el formulario se vuelve a mostrar con un error de validación y no se guarda ninguna entrada

## MODIFIED Requirements

### Requirement: Textos que separan «lista» de «compartida»
Ningún texto de la interfaz de entradas MUST decir «Publicar». Los estados
SHALL mostrarse como «Borrador · solo vos» y «Lista · solo vos»; en la
cronología de la ficha, el estado de un borrador SHALL ser «Borrador ·
solo vos · fuera del resumen» (P-10). Los avisos de guardar y marcar como
lista SHALL decir que solo el autor ve la entrada, salvo el aviso genérico
«Feedback guardado como lista.» del formulario completo, que solo
confirma la operación. Ningún aviso cambia la privacidad de la entrada.

#### Scenario: Páginas de entradas
- **WHEN** el autor recorre la ficha, la captura, el detalle y la edición
- **THEN** ninguna página contiene «Publicar» y los estados indican «solo vos»

#### Scenario: Borrador en la cronología
- **WHEN** el autor abre la ficha con un borrador propio sobre la persona
- **THEN** la cronología lo muestra como «Borrador · solo vos · fuera del resumen»

#### Scenario: Aviso genérico al guardar como lista
- **WHEN** el autor guarda como lista desde el formulario completo
- **THEN** el aviso es exactamente «Feedback guardado como lista.», sin el texto del feedback ni a quién se refiere, la cronología muestra la entrada como «Lista · solo vos» y otro líder de la misma persona no la ve
