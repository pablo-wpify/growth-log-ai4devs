## MODIFIED Requirements

### Requirement: Lecturas agregadas con el alcance de entradas
Toda lectura agregada de entradas MUST leer solo del alcance de entradas
de la cuenta y recibirlo ya resuelto, sin consultar nunca el modelo
directamente. Una entrada de otro líder, lista o en borrador, MUST NOT
contar, aparecer ni influir en ninguna de esas lecturas, aunque los dos
acompañen a la misma persona (4.11, 4.12 parcial, 1.15 parcial). Ser
administrador MUST NOT agregar entradas. Los textos con que se muestran
los definen las specs de cada pantalla.

#### Scenario: Otro líder de la misma persona
- **WHEN** un primer líder tiene una entrada lista y un borrador sobre una persona que también acompaña un segundo líder, y el segundo abre la ficha y «Personas»
- **THEN** su resumen, su cronología, sus conteos, su fecha del último hecho, su orden por hechos más recientes y la presencia de «Registrar la primera» no incluyen ni reflejan ninguna de las dos entradas

#### Scenario: Autor
- **WHEN** el primer líder abre la ficha y «Personas»
- **THEN** su resumen, su conteo de entradas listas y su fecha del último hecho incluyen su entrada lista y no su borrador, su conteo de borradores incluye el borrador y su cronología muestra las dos

#### Scenario: Administradora asignada a la persona
- **WHEN** una cuenta administradora asignada a la misma persona, sin entradas propias, abre la ficha y «Personas»
- **THEN** su resumen y su cronología están vacíos, y en «Personas» esa persona no tiene entradas listas, borradores ni fecha del último hecho

## ADDED Requirements

### Requirement: Lecturas agregadas de la ficha y del listado
Las lecturas agregadas de entradas SHALL ser el resumen y la cronología
de la ficha y, en el listado «Personas», los conteos de entradas listas
y de borradores, la fecha del último hecho, el orden por hechos más
recientes y la decisión de mostrar «Registrar la primera». Todas MUST
cumplir el requisito «Lecturas agregadas con el alcance de entradas».

#### Scenario: Orden y acceso del listado desde el alcance
- **WHEN** un líder tiene una entrada lista propia sobre una persona B y solo un borrador propio sobre una persona A, otro líder asignado a A tiene sobre ella una entrada lista con una fecha del hecho posterior a la de la entrada propia sobre B, y el primero abre «Personas» y elige «Hechos más recientes»
- **THEN** B queda antes que A, y A no muestra «Último hecho» ni «Registrar la primera»: la entrada del otro líder no influye en el orden ni en la fecha, y el borrador propio impide mostrar «Registrar la primera»
