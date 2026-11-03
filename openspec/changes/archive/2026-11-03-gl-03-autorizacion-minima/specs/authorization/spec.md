## ADDED Requirements

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
