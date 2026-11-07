## ADDED Requirements

### Requirement: Navegación con sesión
Toda página con sesión SHALL mostrar una cabecera con el nombre de la
aplicación, el enlace «Personas», el nombre de la cuenta y la acción
«Cerrar sesión». Las páginas sin sesión MUST NOT mostrarla. Tras iniciar
sesión, la página de inicio SHALL ser el listado «Personas».

#### Scenario: Después de iniciar sesión
- **WHEN** una cuenta activa inicia sesión
- **THEN** llega al listado «Personas» y la cabecera muestra «Personas», su nombre y «Cerrar sesión»

#### Scenario: Página de inicio de sesión
- **WHEN** se pide el formulario de inicio de sesión sin sesión
- **THEN** la página no muestra la cabecera de navegación

### Requirement: Listado de personas asignadas
El listado «Personas» SHALL mostrar exactamente las personas del alcance de
la cuenta definido por la spec `authorization`: activas y con una
asignación activa de esa cuenta. MUST ordenarlas por nombre y mostrar su
rol y su equipo. Ser administrador MUST NOT agregar personas al listado.

#### Scenario: Líder con varias personas
- **WHEN** un líder con asignaciones activas con dos personas activas, una asignación terminada con otra y una asignación activa con una persona inactiva abre «Personas»
- **THEN** ve solo las dos personas activas asignadas, ordenadas por nombre, con su rol y su equipo

#### Scenario: Administradora asignada
- **WHEN** una cuenta administradora con una sola asignación activa abre «Personas»
- **THEN** ve solo esa persona

### Requirement: Estado vacío
Si la cuenta no tiene personas en su alcance, el listado SHALL mostrar un
mensaje que explica que no tiene personas asignadas, sin otras acciones.

#### Scenario: Líder sin asignaciones
- **WHEN** un líder sin asignaciones activas abre «Personas»
- **THEN** ve el mensaje de que no tiene personas asignadas y ninguna persona

#### Scenario: Administradora sin asignaciones
- **WHEN** una cuenta administradora sin asignaciones abre «Personas»
- **THEN** ve el mismo mensaje y ninguna persona

### Requirement: Ficha con datos mínimos
La ficha de una persona del alcance SHALL mostrar su nombre, su rol y su
equipo, o la indicación de que falta uno, y un enlace de vuelta a
«Personas». MUST NOT mostrar los nombres de otros líderes asignados ni
datos que ningún criterio vigente pida.

#### Scenario: Ficha de una persona asignada
- **WHEN** un líder abre la ficha de una persona que tiene asignada
- **THEN** ve su nombre, su rol, su equipo y el enlace a «Personas», y no ve los nombres de los otros líderes de esa persona

### Requirement: Persona fuera del alcance
La ficha de una persona fuera del alcance de la cuenta SHALL responder con
el estado 404 y la misma página que ante una persona inexistente, sin datos
de la persona, también cuando se pide por URL directa.

#### Scenario: Persona sin asignación
- **WHEN** un líder pide por URL directa la ficha de una persona con la que no tiene asignación
- **THEN** la respuesta es 404, igual que para una persona inexistente, y no contiene su nombre

#### Scenario: Persona inactiva
- **WHEN** un líder con asignación activa pide la ficha de una persona inactiva
- **THEN** la respuesta es 404, igual que para una persona inexistente

#### Scenario: Asignación terminada
- **WHEN** un líder cuya asignación con una persona terminó pide su ficha
- **THEN** la respuesta es 404, igual que para una persona inexistente

#### Scenario: Administradora sin asignación
- **WHEN** una cuenta administradora sin asignación con una persona pide su ficha
- **THEN** la respuesta es 404, igual que para una persona inexistente

### Requirement: Solo lectura y sin funciones inexistentes
El listado y la ficha MUST NOT ofrecer formularios ni acciones salvo
«Cerrar sesión», ni enlaces o textos que anuncien funciones administrativas
o de feedback que todavía no existen.

#### Scenario: Acciones disponibles
- **WHEN** un líder abre el listado o una ficha
- **THEN** el único formulario es «Cerrar sesión» y no hay enlaces para crear, editar o asignar personas ni para registrar feedback
