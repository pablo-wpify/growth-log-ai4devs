## ADDED Requirements

### Requirement: Resumen por dimensión
La ficha de una persona SHALL mostrar un resumen por dimensión de las
entradas propias listas de la cuenta sobre esa persona: una fila por cada
dimensión con al menos una entrada lista, en el orden de la lista de
dimensiones, con las columnas Positivos, A mejorar, Neutrales y Total
(4.1, P-2). Total SHALL ser la suma de las otras tres columnas. Las
dimensiones sin entradas listas MUST NOT mostrarse. Un borrador MUST NOT
contar (3.3).

#### Scenario: Entradas listas en dos dimensiones
- **WHEN** un líder tiene sobre una persona dos entradas listas positivas y una neutral en «Trabajo en equipo» y una lista «A mejorar» en «Entrega», y abre su ficha
- **THEN** el resumen tiene dos filas, primero «Entrega» con 0, 1, 0 y 1, y después «Trabajo en equipo» con 2, 0, 1 y 3, y ninguna fila para las otras dimensiones

#### Scenario: Un borrador no cuenta
- **WHEN** un líder tiene sobre una persona una entrada lista y un borrador con señal y dimensión, y abre su ficha
- **THEN** el resumen cuenta solo la entrada lista

### Requirement: Aclaración de que no es un puntaje
Cuando se muestra el resumen, la ficha SHALL mostrar junto a él el texto
«Solo entradas listas. No es un puntaje: reúne evidencia para la
conversación» (4.5).

#### Scenario: Resumen con datos
- **WHEN** un líder con una entrada lista sobre una persona abre su ficha
- **THEN** ve el resumen y el texto «Solo entradas listas. No es un puntaje: reúne evidencia para la conversación»

### Requirement: Resumen sin entradas listas
Si la cuenta no tiene entradas propias listas sobre la persona, la ficha
SHALL mostrar «Todavía no hay entradas listas para el resumen» en lugar
del resumen (4.4), aunque tenga borradores.

#### Scenario: Solo borradores
- **WHEN** un líder con un único borrador sobre una persona abre su ficha
- **THEN** ve «Todavía no hay entradas listas para el resumen» en lugar del resumen, y el borrador en la cronología

#### Scenario: Sin entradas
- **WHEN** un líder sin entradas sobre una persona abre su ficha
- **THEN** ve «Todavía no hay entradas listas para el resumen» en lugar del resumen

### Requirement: Cronología de entradas propias
La ficha SHALL mostrar una cronología con todas las entradas propias sobre
la persona, en borrador y listas, por fecha del hecho de la más antigua a
la más reciente; en empate, por fecha de creación y por identificador,
ascendentes (4.13 parcial, P-10). El estado de cada entrada SHALL ser
«Lista · solo vos» o, para un borrador, «Borrador · solo vos · fuera del
resumen».

#### Scenario: Orden y desempate
- **WHEN** un líder tiene tres entradas propias sobre una persona, dos con la misma fecha del hecho y una con una fecha anterior
- **THEN** la cronología muestra primero la de la fecha anterior y después las dos de la misma fecha, la creada antes primero

#### Scenario: Borrador en la cronología
- **WHEN** un líder con una entrada lista y un borrador sobre una persona abre su ficha
- **THEN** la cronología muestra las dos, la lista con «Lista · solo vos» y el borrador con «Borrador · solo vos · fuera del resumen», cada una con un enlace a su detalle

### Requirement: Contenido de cada entrada de la cronología
Cada entrada de la cronología SHALL mostrar su fecha del hecho, su estado,
su señal y su dimensión cuando las tiene, como el mock 1, y el comienzo de
su contexto, con un enlace a su detalle.

#### Scenario: Entrada lista completa
- **WHEN** un líder tiene sobre una persona una entrada lista positiva en «Trabajo en equipo» y abre su ficha
- **THEN** la cronología la muestra con su fecha, «Lista · solo vos», «Positivo», «Trabajo en equipo», el comienzo del contexto y un enlace a su detalle

#### Scenario: Borrador sin señal ni dimensión
- **WHEN** un líder tiene sobre una persona un borrador sin señal ni dimensión y abre su ficha
- **THEN** la cronología lo muestra con su fecha, «Borrador · solo vos · fuera del resumen», el comienzo del contexto y un enlace a su detalle, sin señal ni dimensión

### Requirement: Cronología sin entradas
Sin entradas propias sobre la persona, la cronología SHALL mostrar
«Todavía no registraste entradas sobre <nombre>», con el nombre de la
persona.

#### Scenario: Cronología vacía
- **WHEN** un líder sin entradas sobre una persona abre su ficha
- **THEN** la cronología muestra «Todavía no registraste entradas sobre» y el nombre de la persona

### Requirement: Solo entradas propias
El resumen y la cronología MUST incluir solo entradas de la cuenta: una
entrada de otro líder de la misma persona, lista o en borrador, MUST NOT
contar ni aparecer, y la respuesta MUST NOT contener su texto (4.2, 4.3,
4.11 y 4.12 parciales). Todo lo que se muestra es propio y SHALL llevar el
estado «… · solo vos»; no hay columna de origen (4.3 parcial; las
compartidas quedan para I4).

#### Scenario: Dos líderes de la misma persona
- **WHEN** dos líderes acompañan a la misma persona, el primero tiene una entrada lista y un borrador sobre ella y el segundo abre su ficha
- **THEN** el resumen del segundo no cuenta la entrada del primero, su cronología no muestra ninguna de las dos y la respuesta no contiene su texto

#### Scenario: Resúmenes distintos
- **WHEN** cada uno de dos líderes de la misma persona tiene una entrada lista en una dimensión distinta
- **THEN** cada uno ve en su resumen solo la fila de su propia entrada
