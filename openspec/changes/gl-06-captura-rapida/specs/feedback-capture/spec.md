## ADDED Requirements

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
la ficha ni ofrecer acciones de escritura (PP-9, AM-1, P-24). Sin listado
de esas entradas: 3.10 y 4.14 quedan parciales.

#### Scenario: Asignación terminada
- **WHEN** termina la asignación del autor con la persona y el autor abre por URL directa el detalle de su borrador o de su entrada lista
- **THEN** ve todos los campos de su entrada y, de la persona, solo el nombre, sin enlace a la ficha, sin «Editar» y sin «Marcar como lista»

#### Scenario: Persona inactiva
- **WHEN** la persona pasa a inactiva y el autor abre por URL directa el detalle de su entrada
- **THEN** ve todos los campos de su entrada y, de la persona, solo el nombre, sin enlace a la ficha ni acciones de escritura

### Requirement: Entradas propias en la ficha
La ficha SHALL listar las entradas de la cuenta sobre esa persona, en
borrador y listas, con la fecha del hecho, el estado y el comienzo del
contexto, cada una con un enlace a su detalle, ordenadas por fecha del
hecho descendente y, en empate, primero la creada después (P-21). MUST
NOT incluir entradas de otras cuentas. Sin entradas propias, SHALL
mostrar un mensaje que lo diga. Es provisoria: GL-07 la reemplaza por la
cronología con un cambio explícito de esta spec.

#### Scenario: Líder con entradas propias
- **WHEN** un líder con un borrador y una entrada lista sobre una persona abre su ficha
- **THEN** ve las dos, cada una con su estado, y no ve las entradas de otro líder de esa persona

#### Scenario: Orden de la sección
- **WHEN** un líder tiene tres entradas propias sobre una persona, dos con la misma fecha del hecho y una con una fecha anterior
- **THEN** la sección muestra primero las dos de la fecha más reciente, la creada después antes que la otra, y al final la de la fecha anterior

#### Scenario: Líder sin entradas propias
- **WHEN** un líder sin entradas sobre una persona abre su ficha
- **THEN** ve el mensaje de que todavía no registró entradas sobre esa persona

### Requirement: Textos que separan «lista» de «compartida»
Ningún texto de la interfaz de entradas MUST decir «Publicar». Los estados
SHALL mostrarse como «Borrador · solo vos» y «Lista · solo vos», y los
avisos de guardar y marcar como lista SHALL decir que solo el autor ve la
entrada.

#### Scenario: Páginas de entradas
- **WHEN** el autor recorre la ficha, la captura, el detalle y la edición
- **THEN** ninguna página contiene «Publicar» y los estados indican «solo vos»
