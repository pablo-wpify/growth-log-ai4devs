## ADDED Requirements

### Requirement: Registrar la primera desde el listado
En el listado «Personas», una persona del alcance sin entradas listas
visibles ni borradores propios SHALL ofrecer «Registrar la primera», como
un enlace independiente del de la fila. Lleva a la misma página de
captura que «Captura rápida», con la misma autorización y el mismo enlace
de vuelta a la ficha, y al guardar SHALL volver a la ficha de esa
persona. Pedir esa página para una persona fuera del alcance MUST
responder 404.

#### Scenario: Registrar la primera desde el listado
- **WHEN** un líder elige «Registrar la primera» en una persona asignada sin entradas y guarda un texto
- **THEN** se abre la misma página de captura de esa persona, con el enlace de vuelta a su ficha, y al guardar se crea un borrador de su autoría y vuelve a la ficha de esa persona

#### Scenario: Sin el acceso cuando ya hay entradas
- **WHEN** un líder tiene un borrador o una entrada lista sobre una persona y abre «Personas»
- **THEN** esa fila no muestra «Registrar la primera»

#### Scenario: Persona fuera del alcance
- **WHEN** un líder pide por URL directa la página de captura de una persona con la que no tiene asignación activa, o la envía
- **THEN** la respuesta es 404 y no se crea ninguna entrada

### Requirement: «Registrar la primera» decidido con el alcance de la cuenta
La disponibilidad de «Registrar la primera» MUST decidirse solo con las
entradas del alcance de entradas de la cuenta y sus borradores propios,
sin consultas fuera de ese alcance, y MUST NOT revelar si existen
entradas que la cuenta no puede ver.

#### Scenario: Entradas de otro líder sobre la misma persona
- **WHEN** otro líder asignado a la misma persona tiene sobre ella una entrada lista y un borrador, y el líder, sin entradas sobre ella, abre «Personas»
- **THEN** esa fila muestra «Sin entradas todavía» y «Registrar la primera», igual que si nadie tuviera entradas sobre esa persona
