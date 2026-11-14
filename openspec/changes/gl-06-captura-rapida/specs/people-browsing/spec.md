## MODIFIED Requirements

### Requirement: Ficha con datos mínimos
La ficha de una persona del alcance SHALL mostrar su nombre, su rol y su
equipo, o la indicación de que falta uno, y un enlace de vuelta a
«Personas». Además SHALL ofrecer «Captura rápida» y las entradas propias de
la cuenta sobre esa persona, según la spec `feedback-capture`. MUST NOT
mostrar los nombres de otros líderes asignados, entradas de otras cuentas
ni datos que ningún criterio vigente pida.

#### Scenario: Ficha de una persona asignada
- **WHEN** un líder abre la ficha de una persona que tiene asignada
- **THEN** ve su nombre, su rol, su equipo, el enlace a «Personas», «Captura rápida» y sus propias entradas sobre ella, y no ve los nombres de los otros líderes de esa persona ni sus entradas

### Requirement: Solo lectura y sin funciones inexistentes
El listado «Personas» MUST NOT ofrecer formularios ni acciones salvo
«Cerrar sesión». La ficha MUST NOT ofrecer más acciones que «Cerrar
sesión», «Captura rápida» y los enlaces a las entradas propias. Ninguna de
las dos MUST mostrar enlaces o textos que anuncien funciones que todavía
no existen: administración, «+ Feedback», resumen, cronología, compartir o
feed.

#### Scenario: Acciones disponibles
- **WHEN** un líder abre el listado «Personas»
- **THEN** el único formulario es «Cerrar sesión» y no hay enlaces para crear, editar o asignar personas ni para registrar feedback

#### Scenario: Acciones disponibles en la ficha
- **WHEN** un líder abre una ficha
- **THEN** el único formulario es «Cerrar sesión», el único acceso para registrar feedback es «Captura rápida», y no hay «+ Feedback», resumen, compartir ni enlaces de administración
