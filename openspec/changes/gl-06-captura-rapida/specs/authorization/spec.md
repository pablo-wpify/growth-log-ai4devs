## ADDED Requirements

### Requirement: Lectura de entradas por autoría
El alcance de entradas de una cuenta SHALL contener exactamente las
entradas de su autoría. La lectura MUST NOT depender de que la cuenta
tenga una asignación activa con la persona ni de que la persona esté
activa (PP-3, PP-4, PP-9, AM-1, P-7). Ninguna otra cuenta MUST leer una
entrada ajena, tampoco si acompaña a la misma persona o es
administradora: compartir no existe en este cambio. Una entrada fuera del
alcance MUST responder como un recurso inexistente.

#### Scenario: Autor con asignación activa
- **WHEN** el autor abre el detalle de su borrador o de su entrada lista
- **THEN** la política lo permite y la entrada está en su alcance

#### Scenario: Autor con la asignación terminada
- **WHEN** termina la asignación del autor con la persona y el autor pide el detalle de su borrador o de su entrada lista
- **THEN** la política permite la lectura de los dos y ambos siguen en su alcance (3.10, 4.14 y la lectura de entradas propias de la rama de lectura de PT-11)

#### Scenario: Autor de una entrada sobre una persona inactiva
- **WHEN** la persona de una entrada pasa a inactiva y el autor abre el detalle
- **THEN** la política permite la lectura

#### Scenario: Administradora sin asignación
- **WHEN** una cuenta administradora sin asignación pide por URL directa el detalle de una entrada ajena
- **THEN** la respuesta es 404, igual que para una entrada inexistente, y no contiene su texto

### Requirement: Escritura de entradas con asignación activa
Crear una entrada, editarla y marcarla como lista SHALL estar permitido
solo a su autor mientras tenga una asignación activa con la persona y la
persona esté activa (PP-2, PP-3, 2.10, 3.10, P-9, P-20). Una petición
denegada MUST responder 404, igual que ante un recurso inexistente, y MUST
NOT cambiar la base.

#### Scenario: Crear sin asignación
- **WHEN** un líder sin asignación activa con una persona envía una captura rápida sobre ella por URL directa
- **THEN** la respuesta es 404 y no se crea ninguna entrada

#### Scenario: Crear sobre una persona inactiva
- **WHEN** un líder con asignación activa envía una captura rápida sobre una persona inactiva
- **THEN** la respuesta es 404 y no se crea ninguna entrada

#### Scenario: Editar con la asignación terminada
- **WHEN** termina la asignación del autor y el autor envía una edición o marca su borrador como lista
- **THEN** la respuesta es 404 y la entrada no cambia (3.10, PT-11)

#### Scenario: Marcar como lista una entrada lista con la asignación terminada
- **WHEN** termina la asignación del autor y el autor envía «Marcar como lista» sobre su entrada que ya está lista
- **THEN** la respuesta es 404, como cualquier escritura sin permiso, y la entrada no cambia

#### Scenario: Editar una entrada de una persona inactiva
- **WHEN** la persona pasa a inactiva y el autor envía una edición de su entrada
- **THEN** la respuesta es 404 y la entrada no cambia

### Requirement: Aislamiento de las entradas entre líderes
Acompañar a la misma persona MUST NOT dar acceso a las entradas de otro
líder (4.11). Para el borrador y la entrada lista de un autor, otro líder
asignado a la misma persona, un líder sin asignación y una cuenta
administradora, asignada o no a la persona, MUST recibir 404 en el
detalle, el formulario de edición, la edición y marcar como lista, también
por URL directa, sin el texto de la entrada en la respuesta y sin cambios
en la base.

#### Scenario: Otro líder de la misma persona
- **WHEN** un segundo líder asignado a la misma persona pide por URL directa el detalle, la edición o marcar como lista del borrador o de la entrada lista del autor
- **THEN** cada respuesta es 404, igual que para una entrada inexistente, no contiene el texto y la entrada no cambia

#### Scenario: Administradora asignada a la persona
- **WHEN** una cuenta administradora asignada a la misma persona pide el detalle de una entrada del autor
- **THEN** la respuesta es 404, igual que para una entrada inexistente
