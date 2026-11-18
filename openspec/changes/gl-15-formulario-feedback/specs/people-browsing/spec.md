## MODIFIED Requirements

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
