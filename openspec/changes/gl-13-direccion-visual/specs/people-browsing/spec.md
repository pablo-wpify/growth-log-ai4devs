## ADDED Requirements

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
