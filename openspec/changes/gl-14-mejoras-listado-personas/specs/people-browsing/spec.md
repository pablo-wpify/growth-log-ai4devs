## MODIFIED Requirements

### Requirement: Listado de personas asignadas
El listado «Personas» SHALL mostrar exactamente las personas del alcance de
la cuenta definido por la spec `authorization`: activas y con una
asignación activa de esa cuenta (1.14). Por defecto MUST ordenarlas por
nombre y, en empate, por identificador (1.14). Cada fila SHALL mostrar el
nombre como texto principal y, en una segunda línea, «rol · equipo».
Después SHALL mostrar las entradas de la cuenta sobre esa persona:
- sin entradas listas visibles ni borradores propios: «Sin entradas
  todavía»;
- con borradores propios y sin entradas listas visibles: «Sin entradas
  listas · 1 borrador» o «Sin entradas listas · N borradores»;
- con entradas listas visibles: «1 entrada lista» o «N entradas listas»
  y, si además hay borradores propios, «· 1 borrador» o «· N borradores».

Las entradas listas MUST contarse solo dentro del alcance de entradas de
la cuenta (1.15 parcial), y los borradores solo si son de esa cuenta. Ser
administrador MUST NOT agregar personas ni entradas.

#### Scenario: Líder con varias personas
- **WHEN** un líder con asignaciones activas con dos personas activas, una asignación terminada con otra y una asignación activa con una persona inactiva abre «Personas»
- **THEN** ve solo las dos personas activas asignadas, ordenadas por nombre, con el nombre en la primera línea y «rol · equipo» en la segunda

#### Scenario: Administradora asignada
- **WHEN** una cuenta administradora con una sola asignación activa abre «Personas»
- **THEN** ve solo esa persona

#### Scenario: Conteo de entradas listas
- **WHEN** un líder tiene dos entradas listas y un borrador sobre una persona, una entrada lista sobre otra, solo un borrador sobre una tercera y ninguna entrada sobre una cuarta, y abre «Personas»
- **THEN** la primera muestra «2 entradas listas · 1 borrador», la segunda «1 entrada lista», la tercera «Sin entradas listas · 1 borrador» y la cuarta «Sin entradas todavía»

#### Scenario: Conteo con otro líder de la misma persona
- **WHEN** otro líder asignado a la misma persona tiene sobre ella una entrada lista y un borrador, y el líder, sin entradas sobre ella, abre «Personas»
- **THEN** esa persona muestra «Sin entradas todavía»

### Requirement: Estado vacío
Si la cuenta no tiene personas en su alcance, el listado SHALL mostrar un
mensaje que explica que no tiene personas asignadas, sin búsqueda, filtro,
orden ni otras acciones (1.16). Este estado MUST distinguirse del de una
persona sin entradas, que aparece en el listado con «Sin entradas
todavía».

#### Scenario: Líder sin asignaciones
- **WHEN** un líder sin asignaciones activas abre «Personas»
- **THEN** ve el mensaje de que no tiene personas asignadas, ninguna persona y ningún control de búsqueda, filtro u orden

#### Scenario: Administradora sin asignaciones
- **WHEN** una cuenta administradora sin asignaciones abre «Personas»
- **THEN** ve el mismo mensaje y ninguna persona

#### Scenario: Persona sin entradas
- **WHEN** un líder con una sola persona asignada, sin entradas sobre ella, abre «Personas»
- **THEN** ve esa persona con «Sin entradas todavía» y no ve el mensaje de que no tiene personas asignadas

### Requirement: Solo lectura y sin funciones inexistentes
El listado «Personas» MUST NOT ofrecer formularios ni acciones salvo
«Cerrar sesión», la búsqueda, el filtro, el orden, «Limpiar filtros» y
«Registrar la primera». La ficha MUST NOT ofrecer más acciones que
«Cerrar sesión», «Captura rápida», «+ Feedback» con su formulario y los
enlaces de la cronología a las entradas propias. Los accesos de registro
siguen la spec `feedback-capture`. Ninguna de las dos MUST anunciar
funciones inexistentes: administración, compartir, filtros de entradas o
feed.

#### Scenario: Acciones disponibles
- **WHEN** un líder abre el listado «Personas»
- **THEN** solo tiene «Cerrar sesión», la búsqueda, el filtro por equipo, el orden y, en las personas sin entradas, «Registrar la primera», y no hay enlaces para crear, editar o asignar personas

#### Scenario: Acciones disponibles en la ficha
- **WHEN** un líder abre una ficha
- **THEN** el único formulario es «Cerrar sesión», los accesos para registrar feedback son «Captura rápida» y «+ Feedback», y no hay compartir, filtros ni enlaces de administración

## ADDED Requirements

### Requirement: Fila del listado navegable con teclado
Cada fila SHALL abrir la ficha de su persona con un único enlace de fila
completa, cuyo nombre accesible es el nombre de la persona. Al recibir el
foco con el teclado, la fila SHALL mostrar un foco visible. La fila MUST
NOT anidar enlaces ni botones dentro de ese enlace: «Registrar la
primera», cuando existe, SHALL ser un enlace independiente, alcanzable con
el teclado después del de la persona.

#### Scenario: Recorrido con el teclado
- **WHEN** un líder recorre el listado con Tab
- **THEN** cada fila recibe el foco una vez en el enlace de la persona, con un foco visible alrededor de la fila; en una persona sin entradas, el Tab siguiente va a «Registrar la primera», y Enter abre la ficha o la captura, según el enlace

#### Scenario: Sin enlaces anidados
- **WHEN** se inspecciona una fila con «Registrar la primera»
- **THEN** ese enlace no está dentro del enlace a la ficha y la fila no tiene otros controles anidados

### Requirement: Fecha del último hecho
Con al menos una entrada lista visible sobre la persona, la fila SHALL
mostrar «Último hecho: <fecha>», con la fecha del hecho más reciente entre
las entradas listas del alcance de entradas de la cuenta. Sin entradas
listas visibles, MUST NOT mostrar ninguna fecha. Los borradores y las
entradas fuera del alcance MUST NOT influir en esa fecha.

#### Scenario: Fecha con entradas listas y un borrador
- **WHEN** un líder tiene sobre una persona dos entradas listas, con fecha del hecho 12/03/2026 y 20/05/2026, y un borrador con fecha del hecho 08/06/2026
- **THEN** la fila muestra «Último hecho: 20/05/2026»

#### Scenario: Sin fecha con solo borradores
- **WHEN** un líder tiene sobre una persona solo un borrador
- **THEN** la fila no muestra «Último hecho»

#### Scenario: Fecha con otro líder de la misma persona
- **WHEN** otro líder asignado a la misma persona tiene sobre ella una entrada lista con una fecha del hecho posterior a la última del líder
- **THEN** la fila del líder muestra la fecha de su propia entrada lista más reciente

### Requirement: Búsqueda y filtro del listado
Con al menos una persona en el alcance, el listado SHALL ofrecer una
búsqueda por nombre y un filtro por equipo. Los dos MUST actuar solo sobre
las personas activas asignadas que ya muestra el listado. La búsqueda
SHALL encontrar coincidencias parciales en el nombre, sin distinguir
mayúsculas ni acentos. El filtro MUST ofrecer solo «Todos», los equipos de
esas personas y, si alguna no tiene equipo, «Sin equipo indicado».

#### Scenario: Búsqueda por nombre
- **WHEN** un líder con «Ada Ejemplo» y «Carla Muestra» asignadas busca «Ada»
- **THEN** el listado muestra solo «Ada Ejemplo»

#### Scenario: Búsqueda parcial sin mayúsculas ni acentos
- **WHEN** un líder con «Inés Prueba» y «Carla Muestra» asignadas busca «ines» o «PRU»
- **THEN** el listado muestra solo «Inés Prueba»

#### Scenario: Persona sin equipo
- **WHEN** un líder tiene asignadas una persona de «Equipo Faro» y otra sin equipo
- **THEN** el filtro ofrece «Todos», «Equipo Faro» y «Sin equipo indicado», y al elegir «Sin equipo indicado» muestra solo la persona sin equipo

#### Scenario: Sin «Sin equipo indicado» cuando todas tienen equipo
- **WHEN** todas las personas asignadas al líder tienen equipo
- **THEN** el filtro no ofrece «Sin equipo indicado»

#### Scenario: Equipos del filtro
- **WHEN** un líder tiene asignadas personas de «Equipo Faro» y «Equipo Norte», y existe otra persona activa de «Equipo Brújula» que no tiene asignada
- **THEN** el filtro ofrece «Todos», «Equipo Faro» y «Equipo Norte», y no ofrece «Equipo Brújula»

#### Scenario: Búsqueda sin ampliar el alcance
- **WHEN** un líder busca el nombre de una persona activa que no tiene asignada
- **THEN** esa persona no aparece

### Requirement: Orden por hechos más recientes
El listado SHALL ofrecer un orden con «Nombre», el predeterminado, y
«Hechos más recientes». Este último SHALL ordenar de la fecha del último
hecho más reciente a la más antigua, según el requisito «Fecha del último
hecho». Las personas sin entradas listas visibles SHALL ir al final. Los
empates, también entre las personas sin entradas listas visibles,
SHALL resolverse por nombre y después por identificador. Los borradores
MUST NOT intervenir.

#### Scenario: Orden con borradores y otro líder
- **WHEN** un líder tiene una entrada lista del 20/05/2026 sobre una persona, una del 01/04/2026 sobre otra y solo un borrador del 08/06/2026 sobre una tercera, otro líder tiene una entrada lista del 10/06/2026 sobre la segunda, y el líder elige «Hechos más recientes»
- **THEN** el orden es la primera, la segunda y la tercera

#### Scenario: Empate en la fecha del último hecho
- **WHEN** dos personas tienen la misma fecha del último hecho y el líder elige «Hechos más recientes»
- **THEN** aparecen por nombre y, si el nombre coincide, por identificador

#### Scenario: Orden predeterminado
- **WHEN** un líder abre «Personas» sin elegir un orden
- **THEN** el listado está ordenado por nombre

### Requirement: Sin resultados de búsqueda o filtro
Si la búsqueda o el filtro no dejan ninguna persona, el listado SHALL
mostrar «Ninguna persona coincide con la búsqueda o el filtro» y la
acción «Limpiar filtros». «Limpiar filtros» SHALL borrar la búsqueda y el
filtro por equipo y MUST conservar el orden elegido. Este estado MUST
distinguirse del estado vacío.

#### Scenario: Sin resultados
- **WHEN** un líder busca un nombre que no coincide con ninguna persona asignada
- **THEN** ve «Ninguna persona coincide con la búsqueda o el filtro» y «Limpiar filtros», no ve el mensaje de que no tiene personas asignadas, y al usar «Limpiar filtros» vuelven todas sus personas

#### Scenario: Limpiar filtros conserva el orden
- **WHEN** un líder eligió «Hechos más recientes», filtró por un equipo y usa «Limpiar filtros»
- **THEN** la búsqueda queda vacía, el filtro vuelve a «Todos» y el listado sigue ordenado por «Hechos más recientes»

### Requirement: Búsqueda, filtro y orden en el navegador
La búsqueda, el filtro y el orden SHALL aplicarse en el navegador sobre
las filas que el servidor ya mostró con el alcance de la cuenta, sin
pedir otras personas ni entradas. MUST NOT agregarse a la URL ni
conservarse al recargar: al recargar, el listado vuelve a mostrar todas
las personas por nombre. Sin JavaScript, el listado SHALL mostrar todas
las personas por nombre y no los controles.

#### Scenario: Búsqueda sin cambiar la URL
- **WHEN** un líder busca un nombre y filtra por un equipo
- **THEN** la URL no cambia y no se hace ninguna petición nueva al servidor

#### Scenario: Recargar la página
- **WHEN** un líder con una búsqueda, un filtro y el orden «Hechos más recientes» recarga «Personas»
- **THEN** ve todas sus personas, ordenadas por nombre, con la búsqueda vacía y el filtro en «Todos»

#### Scenario: Sin JavaScript
- **WHEN** un líder abre «Personas» sin JavaScript
- **THEN** ve todas sus personas ordenadas por nombre y no ve la búsqueda, el filtro ni el orden

### Requirement: Total de personas y aviso de privacidad
Con al menos una persona en el alcance, el listado SHALL mostrar una sola
vez, bajo el título y con un tratamiento discreto, el total de personas
asignadas, «1 persona que acompañás» o «N personas que acompañás», y el
aviso «Ves solo a quienes tenés asignados y las entradas que podés ver».
El total MUST contar las personas asignadas del alcance y MUST NOT
cambiar con la búsqueda ni el filtro. En el estado sin personas
asignadas, el mensaje vacío de 1.16 SHALL reemplazar el total y el
aviso.

#### Scenario: Total y aviso
- **WHEN** un líder con tres personas asignadas abre «Personas» y filtra por un equipo con una sola
- **THEN** ve una vez «3 personas que acompañás» y el aviso, antes y después de filtrar

#### Scenario: Sin total en el estado vacío
- **WHEN** un líder sin asignaciones activas abre «Personas»
- **THEN** ve solo el mensaje de que no tiene personas asignadas, sin total ni aviso

### Requirement: Listado en pantalla angosta
A 375 px de ancho, el listado SHALL verse sin desplazamiento horizontal.
La búsqueda, el filtro y el orden SHALL apilarse a todo el ancho. En cada
fila, el nombre y «rol · equipo» SHALL quedar arriba, y los conteos, la
fecha y «Registrar la primera», debajo. Los controles y los enlaces SHALL
medir al menos 44 px de alto.

#### Scenario: Listado a 375 px
- **WHEN** un líder con tres personas, una sin entradas, abre «Personas» en una ventana de 375 px
- **THEN** la página no se desplaza en horizontal, los controles quedan uno debajo del otro y «Registrar la primera» mide al menos 44 px de alto
