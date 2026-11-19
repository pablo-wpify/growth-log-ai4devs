# feedback-capture Specification

## Purpose
Define cómo el líder registra feedback desde la ficha: la captura rápida
en una página propia, completar un borrador, marcarlo como lista, el
detalle de una entrada propia, también sin acceso a la ficha, con textos
que no confunden «lista» con «compartida». Las entradas propias se listan
en la vista cronológica (spec `feedback-summary`).

## Requirements

### Requirement: Acceso visible a la captura rápida
La ficha de una persona del alcance de la cuenta SHALL ofrecer un acceso
visible a «Captura rápida» (criterio 3.1).

#### Scenario: Ficha de una persona asignada
- **WHEN** un líder abre la ficha de una persona que tiene asignada
- **THEN** ve el acceso «Captura rápida»

#### Scenario: Abrir la captura rápida
- **WHEN** un líder elige «Captura rápida» en la ficha de una persona que tiene asignada
- **THEN** se abre la página de captura de esa persona, con el campo de texto, la fecha de hoy y un enlace de vuelta a la ficha (P-22)

### Requirement: Guardar una captura rápida
La captura rápida SHALL abrirse en una página propia y pedir solo el
texto (P-22). Al guardarla, la entrada SHALL quedar como borrador de la
cuenta que la escribió, sobre esa persona, con la fecha de hoy en la zona
horaria de la aplicación (`America/Argentina/Buenos_Aires`, P-23) como
fecha del hecho, y la cuenta SHALL volver a la ficha con un aviso de que
el borrador solo lo ve ella (criterios 3.2, 2.8, 2.9 y 2.10). Sin texto,
la entrada MUST NOT guardarse y se MUST informar el error.

#### Scenario: Captura válida
- **WHEN** un líder asignado a una persona activa guarda una captura rápida con un texto
- **THEN** se guarda un borrador de su autoría sobre esa persona, con la fecha de hoy, y vuelve a la ficha con el aviso de que solo su autor lo ve

#### Scenario: Fecha de hoy en la zona de la aplicación
- **WHEN** un líder guarda una captura rápida a las 22:00 de Buenos Aires, cuando en UTC ya es el día siguiente
- **THEN** la fecha del hecho es la de ese día en Buenos Aires

#### Scenario: Captura sin texto
- **WHEN** un líder guarda una captura rápida sin texto
- **THEN** la respuesta tiene estado 422, muestra el error y no se guarda ninguna entrada

### Requirement: Completar un borrador
El autor SHALL poder editar su borrador para completar la fecha del hecho,
el contexto, la señal, la dimensión, la evidencia, el impacto y la
confianza (criterios 3.4, 2.3, 2.4 y 2.5). Guardar la edición MUST NOT
cambiar el estado de la entrada. La edición MUST NOT permitir cambiar el
autor, la persona ni el estado.

#### Scenario: Completar los datos
- **WHEN** el autor guarda su borrador con señal, dimensión, evidencia, impacto y confianza
- **THEN** la entrada conserva esos datos y sigue como borrador

#### Scenario: Quitar la fecha o el contexto
- **WHEN** el autor guarda su borrador sin fecha del hecho o sin contexto
- **THEN** la respuesta tiene estado 422, muestra el error y la entrada no cambia

#### Scenario: Parámetros no permitidos
- **WHEN** la edición envía otro autor, otra persona o el estado lista
- **THEN** esos valores se ignoran y la entrada conserva su autor, su persona y su estado

### Requirement: Marcar como lista
El autor SHALL poder marcar su borrador como lista con una acción propia.
Si el borrador tiene dimensión y señal, SHALL pasar a lista y seguir
privado, con un aviso que lo diga. Si le falta alguna, la acción MUST
indicar cuáles faltan y la entrada MUST quedar como estaba (criterios 2.6,
3.5 y 3.6, ampliados por P-3). Si la entrada ya está lista, la acción MUST
NOT cambiarla y SHALL volver al detalle sin error (P-25).

#### Scenario: Borrador completo
- **WHEN** el autor marca como lista un borrador con dimensión y señal
- **THEN** la entrada pasa a lista y el aviso dice que sigue siendo privada

#### Scenario: Borrador sin dimensión ni señal
- **WHEN** el autor marca como lista un borrador sin dimensión ni señal
- **THEN** la respuesta tiene estado 422, indica que faltan la dimensión y la señal, y la entrada sigue como borrador sin cambios

#### Scenario: Borrador con dimensión y sin señal
- **WHEN** el autor marca como lista un borrador con dimensión y sin señal
- **THEN** la respuesta tiene estado 422, indica que falta la señal, y la entrada sigue como borrador sin cambios

#### Scenario: Entrada que ya está lista
- **WHEN** el autor, con permiso para escribir, envía «Marcar como lista» sobre su entrada que ya está lista
- **THEN** la entrada no cambia y la respuesta lo lleva al detalle sin error (P-25)

### Requirement: Editar una entrada lista
El autor SHALL poder editar una entrada lista, que MUST seguir lista
(criterio 3.7). Una edición que deja la entrada sin dimensión o sin señal
MUST rechazarse sin cambiar la entrada. Volver a borrador no existe.

#### Scenario: Editar sin tocar el estado
- **WHEN** el autor cambia la evidencia de una entrada lista
- **THEN** la entrada guarda el cambio y sigue lista

#### Scenario: Quitar la señal de una entrada lista
- **WHEN** el autor guarda una entrada lista sin señal
- **THEN** la respuesta tiene estado 422, indica que falta la señal y la entrada no cambia

### Requirement: Detalle de una entrada propia
El detalle de una entrada SHALL mostrar al autor, la fecha del hecho, el
estado y todos sus campos con sus etiquetas (criterios 2.8 y 4.8, parcial
sin entradas compartidas). Si el autor puede escribir en la entrada, SHALL
ofrecer «Editar», «Marcar como lista» si es un borrador, y un enlace a la
ficha de la persona.

#### Scenario: Detalle de un borrador propio con asignación activa
- **WHEN** el autor abre el detalle de su borrador
- **THEN** ve su nombre como autor, la fecha, «Borrador», todos los campos, «Editar», «Marcar como lista» y el enlace a la ficha

#### Scenario: Detalle de una entrada lista propia con asignación activa
- **WHEN** el autor abre el detalle de su entrada lista
- **THEN** ve su nombre como autor, la fecha, «Lista · solo vos», todos los campos, «Editar» y el enlace a la ficha, y no ve «Marcar como lista»

### Requirement: Detalle sin acceso a la ficha
Si el autor ya no puede abrir la ficha de la persona (asignación
terminada o persona inactiva), el detalle de su borrador o de su entrada
lista SHALL seguir disponible por URL directa con todos los campos de la
entrada. De la persona MUST mostrar solo el nombre, y MUST NOT enlazar a
la ficha ni ofrecer acciones de escritura (PP-9, AM-1, P-24; rama de
lectura de PT-11). Sin listado: 3.10 y 4.14 quedan parciales.

#### Scenario: Asignación terminada
- **WHEN** termina la asignación del autor con la persona y el autor abre por URL directa el detalle de su borrador o de su entrada lista
- **THEN** ve todos los campos de su entrada y, de la persona, solo el nombre, sin enlace a la ficha, sin «Editar» y sin «Marcar como lista»

#### Scenario: Persona inactiva
- **WHEN** la persona pasa a inactiva y el autor abre por URL directa el detalle de su entrada
- **THEN** ve todos los campos de su entrada y, de la persona, solo el nombre, sin enlace a la ficha ni acciones de escritura

### Requirement: Textos que separan «lista» de «compartida»
Ningún texto de la interfaz de entradas MUST decir «Publicar». Los estados
SHALL mostrarse como «Borrador · solo vos» y «Lista · solo vos»; en la
cronología de la ficha, un borrador SHALL mostrarse como «Borrador · solo
vos · fuera del resumen» (P-10). Los avisos de guardar y marcar como lista
SHALL decir que solo el autor ve la entrada, salvo el aviso genérico
«Feedback guardado como lista.» del formulario completo, que solo
confirma la operación. Ningún aviso cambia la privacidad.

#### Scenario: Páginas de entradas
- **WHEN** el autor recorre la ficha, la captura, el detalle y la edición
- **THEN** ninguna página contiene «Publicar» y los estados indican «solo vos»

#### Scenario: Borrador en la cronología
- **WHEN** el autor abre la ficha con un borrador propio sobre la persona
- **THEN** la cronología lo muestra como «Borrador · solo vos · fuera del resumen»

#### Scenario: Aviso genérico al guardar como lista
- **WHEN** el autor guarda como lista desde el formulario completo
- **THEN** el aviso es exactamente «Feedback guardado como lista.», sin el texto del feedback ni a quién se refiere, la cronología muestra la entrada como «Lista · solo vos» y otro líder de la misma persona no la ve

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
