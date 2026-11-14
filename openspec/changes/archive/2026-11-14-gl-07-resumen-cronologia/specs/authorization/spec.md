## ADDED Requirements

### Requirement: Lecturas agregadas con el alcance de entradas
El resumen, la cronología y el conteo de entradas MUST leer solo del
alcance de entradas de la cuenta y recibirlo ya resuelto, nunca consultar
el modelo directamente. Una entrada de otro líder, lista o en borrador,
MUST NOT contar ni aparecer en ninguno de los tres, aunque los dos
acompañen a la misma persona (4.11, 4.12 parcial, 1.15 parcial). Ser
administrador MUST NOT agregar entradas.

#### Scenario: Otro líder de la misma persona
- **WHEN** un primer líder tiene una entrada lista y un borrador sobre una persona que también acompaña un segundo líder, y el segundo abre la ficha y «Personas»
- **THEN** su resumen, su cronología y su conteo no incluyen ninguna de las dos entradas

#### Scenario: Autor
- **WHEN** el primer líder abre la ficha y «Personas»
- **THEN** su resumen y su conteo incluyen su entrada lista y no su borrador, y su cronología muestra las dos

#### Scenario: Administradora asignada a la persona
- **WHEN** una cuenta administradora asignada a la misma persona, sin entradas propias, abre la ficha y «Personas»
- **THEN** ve el mensaje del resumen vacío, la cronología vacía y «0 entradas listas»
