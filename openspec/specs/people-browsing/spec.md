# people-browsing Specification

## Purpose
Define la navegación con sesión, el listado de personas asignadas, el
estado vacío, la ficha con datos mínimos y la respuesta ante una persona
fuera del alcance, de solo lectura y sin funciones que todavía no existen.

## Requirements

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
rol, su equipo y, después, cuántas entradas propias listas tiene la
cuenta sobre cada una: «1 entrada lista» o «N entradas listas», también
con 0 (1.15 parcial). Borradores y entradas ajenas MUST NOT contar. Ser
administrador MUST NOT agregar personas ni entradas.

#### Scenario: Líder con varias personas
- **WHEN** un líder con asignaciones activas con dos personas activas, una asignación terminada con otra y una asignación activa con una persona inactiva abre «Personas»
- **THEN** ve solo las dos personas activas asignadas, ordenadas por nombre, con su rol y su equipo

#### Scenario: Administradora asignada
- **WHEN** una cuenta administradora con una sola asignación activa abre «Personas»
- **THEN** ve solo esa persona

#### Scenario: Conteo de entradas listas
- **WHEN** un líder tiene dos entradas listas y un borrador sobre una persona, una entrada lista sobre otra y ninguna sobre una tercera, y abre «Personas»
- **THEN** después de «rol · equipo», la primera muestra «2 entradas listas», la segunda «1 entrada lista» y la tercera «0 entradas listas»

#### Scenario: Conteo con otro líder de la misma persona
- **WHEN** otro líder asignado a la misma persona tiene una entrada lista sobre ella y el líder abre «Personas»
- **THEN** el conteo de esa persona no incluye la entrada del otro líder

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
«Personas». Además SHALL ofrecer «Captura rápida», según la spec
`feedback-capture`, y el resumen por dimensión y la cronología de las
entradas propias de la cuenta, según la spec `feedback-summary`. MUST NOT
mostrar los nombres de otros líderes asignados, entradas de otras cuentas
ni datos que ningún criterio vigente pida.

#### Scenario: Ficha de una persona asignada
- **WHEN** un líder abre la ficha de una persona que tiene asignada
- **THEN** ve su nombre, su rol, su equipo, el enlace a «Personas», «Captura rápida», el resumen y la cronología de sus propias entradas, y no ve los nombres de los otros líderes de esa persona ni sus entradas

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
El listado «Personas» MUST NOT ofrecer formularios ni acciones salvo
«Cerrar sesión». La ficha MUST NOT ofrecer más acciones que «Cerrar
sesión», «Captura rápida», «+ Feedback» con su formulario, según la spec
`feedback-capture`, y los enlaces de la cronología a las entradas
propias. Ninguna de las dos MUST mostrar enlaces o textos que anuncien
funciones que todavía no existen: administración, compartir, filtros o
feed.

#### Scenario: Acciones disponibles
- **WHEN** un líder abre el listado «Personas»
- **THEN** el único formulario es «Cerrar sesión» y no hay enlaces para crear, editar o asignar personas ni para registrar feedback

#### Scenario: Acciones disponibles en la ficha
- **WHEN** un líder abre una ficha
- **THEN** el único formulario es «Cerrar sesión», los accesos para registrar feedback son «Captura rápida» y «+ Feedback», y no hay compartir, filtros ni enlaces de administración

### Requirement: Aviso de privacidad en la ficha
La ficha de una persona del alcance SHALL mostrar una sola vez, con un
tratamiento discreto y debajo de los datos de la persona, el aviso breve
«Ves solo a quienes tenés asignados y las entradas que podés ver», el
mismo que el listado «Personas». MUST NOT mostrar un panel expandible
«Quién ve qué». Las etiquetas de privacidad de cada entrada que exigen
otras specs, como «Lista · solo vos» y «Borrador · solo vos · fuera del
resumen», SHALL conservarse.

#### Scenario: Aviso en la ficha
- **WHEN** un líder abre la ficha de una persona que tiene asignada
- **THEN** ve una sola vez «Ves solo a quienes tenés asignados y las entradas que podés ver», y no hay un panel «Quién ve qué»

#### Scenario: Aviso y etiquetas por entrada
- **WHEN** un líder con un borrador y una entrada lista sobre una persona abre su ficha
- **THEN** ve el aviso una sola vez y, en la cronología, «Borrador · solo vos · fuera del resumen» y «Lista · solo vos»
