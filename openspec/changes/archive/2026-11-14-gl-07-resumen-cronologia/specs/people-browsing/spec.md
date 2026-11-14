## MODIFIED Requirements

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

### Requirement: Solo lectura y sin funciones inexistentes
El listado «Personas» MUST NOT ofrecer formularios ni acciones salvo
«Cerrar sesión». La ficha MUST NOT ofrecer más acciones que «Cerrar
sesión», «Captura rápida» y los enlaces de la cronología a las entradas
propias. Ninguna de las dos MUST mostrar enlaces o textos que anuncien
funciones que todavía no existen: administración, «+ Feedback»,
compartir, filtros o feed.

#### Scenario: Acciones disponibles
- **WHEN** un líder abre el listado «Personas»
- **THEN** el único formulario es «Cerrar sesión» y no hay enlaces para crear, editar o asignar personas ni para registrar feedback

#### Scenario: Acciones disponibles en la ficha
- **WHEN** un líder abre una ficha
- **THEN** el único formulario es «Cerrar sesión», el único acceso para registrar feedback es «Captura rápida», y no hay «+ Feedback», compartir, filtros ni enlaces de administración
