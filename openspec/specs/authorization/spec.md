# authorization Specification

## Purpose
Decide qué puede hacer una cuenta identificada: denegación por defecto,
autorización y alcance obligatorios en cada acción del producto,
excepciones declaradas por acción y acceso de un líder a una persona por
asignación activa. La autenticación (spec `authentication`) actúa antes y
no da acceso a ningún recurso.

## Requirements

### Requirement: Denegación por defecto
Toda decisión de autorización del producto SHALL denegar salvo que una
política la permita de forma explícita. Una política sin reglas propias
MUST denegar todas sus acciones, y un alcance sin regla propia MUST
devolver un conjunto vacío.

#### Scenario: Política sin reglas propias
- **WHEN** se consulta cualquier acción de una política que no define reglas propias
- **THEN** la respuesta es denegar

#### Scenario: Alcance sin regla propia
- **WHEN** se resuelve el alcance de una política que no define una regla propia
- **THEN** el resultado está vacío

### Requirement: Autorización obligatoria en cada acción del producto
Toda acción de un controlador del producto, salvo las excepciones
declaradas, MUST tomar una decisión de autorización explícita. Si una acción
termina sin tomarla, la petición MUST fallar en las pruebas. Llamar a la
autorización no demuestra que la regla sea correcta: eso lo comprueban las
pruebas de cada política.

#### Scenario: Acción sin decisión de autorización
- **WHEN** una acción del producto termina sin tomar una decisión de autorización
- **THEN** la petición falla con un error que identifica la omisión, y la prueba que recorre las rutas del producto falla

#### Scenario: Ruta nueva sin preparar en la prueba de cobertura
- **WHEN** se agrega una ruta del producto y la prueba de cobertura no tiene preparados sus datos ni los actores que la ejercitan
- **THEN** la prueba de cobertura falla

#### Scenario: Página de inicio
- **WHEN** una cuenta activa con sesión pide la página de inicio
- **THEN** la acción toma una decisión de autorización que la permite

### Requirement: Alcance obligatorio en las acciones que leen registros
Toda acción del producto que lee registros MUST obtenerlos a través del
alcance de su política, de modo que un registro fuera del alcance no se
encuentre. Si una acción de ese tipo termina sin usar el alcance, la
petición MUST fallar en las pruebas. Las acciones que no leen registros
MUST declararlo de forma explícita.

#### Scenario: Acción que lee sin usar el alcance
- **WHEN** una acción que lee registros termina sin haber usado el alcance de su política
- **THEN** la petición falla con un error que identifica la omisión

#### Scenario: Registro fuera del alcance
- **WHEN** una acción carga por su identificador un registro que está fuera del alcance de la cuenta
- **THEN** el registro no se encuentra y la respuesta es la misma que ante un registro inexistente

### Requirement: Excepciones declaradas por acción
Solo las acciones sin cuenta identificada, el formulario y el envío del
inicio de sesión, y el chequeo de salud SHALL quedar fuera de las
verificaciones de autorización. Cada omisión MUST declararse por acción
concreta en una lista, nunca para un controlador completo, y una prueba
MUST fallar si aparece una omisión que no está en la lista.

#### Scenario: Omisión no declarada
- **WHEN** una acción del producto omite la verificación de autorización o de alcance sin figurar en la lista declarada
- **THEN** la prueba de excepciones falla

#### Scenario: Acción nueva en un controlador con excepciones
- **WHEN** se agrega una acción a un controlador que tiene acciones exceptuadas
- **THEN** la acción nueva queda sujeta a las verificaciones

#### Scenario: Cierre de sesión
- **WHEN** una cuenta con sesión cierra su sesión
- **THEN** la acción toma una decisión de autorización que la permite

### Requirement: Respuesta ante un acceso denegado
Ante una acción denegada o un registro fuera del alcance, la aplicación
SHALL responder con el estado 404 y la misma página que ante un recurso
inexistente, sin incluir datos del recurso pedido.

#### Scenario: Acción denegada
- **WHEN** una política deniega la acción pedida
- **THEN** la respuesta tiene estado 404 y es igual a la de un recurso inexistente

### Requirement: Acceso de un líder a una persona
La aplicación SHALL dar acceso a una persona solo a una cuenta que tenga
una asignación activa con ella, y solo si la persona está activa. El rol de
administrador MUST NOT dar acceso a ninguna persona. El alcance de personas
de una cuenta MUST contener exactamente las personas a las que tiene
acceso.

#### Scenario: Líder con asignación activa
- **WHEN** una cuenta con una asignación activa con una persona activa consulta esa persona
- **THEN** la política la permite y la persona está en su alcance

#### Scenario: Líder sin asignación
- **WHEN** una cuenta sin asignación con una persona la consulta
- **THEN** la política la deniega y la persona no está en su alcance

#### Scenario: Asignación terminada
- **WHEN** termina la asignación de una cuenta con una persona y la cuenta vuelve a consultarla
- **THEN** la política la deniega y la persona ya no está en su alcance

#### Scenario: Persona inactiva
- **WHEN** una cuenta con asignación activa consulta una persona inactiva
- **THEN** la política la deniega y la persona no está en su alcance

#### Scenario: Administradora sin asignación
- **WHEN** una cuenta administradora sin asignaciones consulta cualquier persona
- **THEN** la política la deniega y su alcance está vacío

#### Scenario: Administradora con asignación
- **WHEN** una cuenta administradora tiene una asignación activa con una sola persona
- **THEN** su alcance contiene solo esa persona, igual que el de cualquier líder

#### Scenario: Varios líderes de una persona
- **WHEN** dos cuentas tienen asignaciones activas con la misma persona
- **THEN** la persona está en el alcance de las dos

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
