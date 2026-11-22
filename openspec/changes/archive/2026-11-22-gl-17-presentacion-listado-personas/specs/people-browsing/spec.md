## MODIFIED Requirements

### Requirement: Total de personas y aviso de privacidad
Con personas asignadas, «Personas» SHALL mostrar una vez, bajo el
título y discretamente, el total («1 persona que acompañás» o «N
personas que acompañás») y el aviso «Ves solo a quienes tenés asignados
y las entradas que podés ver». El total y el aviso SHALL ir en líneas
separadas, con el total arriba y sin separador. El total MUST contar
las personas asignadas del alcance, sin variar con la búsqueda ni el
filtro. Sin asignaciones, el mensaje vacío de 1.16 SHALL reemplazarlos.

#### Scenario: Total y aviso
- **WHEN** un líder con tres personas asignadas abre «Personas» y filtra por un equipo con una sola
- **THEN** ve una vez «3 personas que acompañás» y el aviso, antes y después de filtrar

#### Scenario: Total y aviso en líneas separadas
- **WHEN** un líder con personas asignadas abre «Personas» a 1280 px y a 375 px
- **THEN** el total ocupa su propia línea, el aviso empieza en la línea siguiente y entre los dos no hay «·»

#### Scenario: Sin total en el estado vacío
- **WHEN** un líder sin asignaciones activas abre «Personas»
- **THEN** ve solo el mensaje de que no tiene personas asignadas, sin total ni aviso

## ADDED Requirements

### Requirement: «Registrar la primera» como acción secundaria
«Registrar la primera» SHALL verse como una acción secundaria pequeña,
con un borde visible, distinta del enlace de la fila y de la píldora del
conteo. MUST NOT presentarse como acción principal ni ocupar el ancho de
la fila. SHALL medir al menos 44 px de alto y conservar su texto y su
nombre accesible.

#### Scenario: Acción distinta de la fila y del conteo
- **WHEN** un líder abre «Personas» con una persona sin entradas
- **THEN** «Registrar la primera» tiene un borde visible, mide al menos 44 px de alto, no tiene el fondo de la píldora «Sin entradas todavía» ni el de un botón principal, y es más angosta que la fila

#### Scenario: Comportamiento sin cambios
- **WHEN** un líder elige «Registrar la primera» en una persona sin entradas
- **THEN** llega a la misma captura que antes de este cambio, con la misma autorización y la vuelta a la ficha que pide `feedback-capture`

### Requirement: Detalles de la fila en pantalla ancha
Desde 40 rem de ancho, la fecha del último hecho, el conteo y, cuando
exista, «Registrar la primera» SHALL ubicarse a la derecha del nombre y
de «rol · equipo», antes del chevron. Más angosto, SHALL quedar debajo,
según «Listado en pantalla angosta». La ubicación MUST NOT cambiar el
orden de foco ni el enlace de la fila.

#### Scenario: Fila a 1280 px
- **WHEN** un líder con una persona sin entradas abre «Personas» a 1280 px
- **THEN** en esa fila, «Sin entradas todavía» y «Registrar la primera» están a la derecha del nombre y de «rol · equipo»

#### Scenario: Fila a 375 px
- **WHEN** un líder con una persona sin entradas abre «Personas» a 375 px
- **THEN** «Sin entradas todavía» y «Registrar la primera» están debajo de «rol · equipo» y la página no se desplaza en horizontal

#### Scenario: Corte en 40 rem
- **WHEN** un líder con una persona sin entradas abre «Personas» en una ventana de 640 px (40 rem) y en otra de 639 px de ancho
- **THEN** a 640 px «Sin entradas todavía» y «Registrar la primera» están a la derecha del nombre y de «rol · equipo»; a 639 px están debajo de «rol · equipo», y en los dos anchos la página no se desplaza en horizontal

#### Scenario: Orden de foco
- **WHEN** un líder recorre con Tab una fila con «Registrar la primera» a 1280 px
- **THEN** el foco pasa primero por el enlace de la persona y después por «Registrar la primera», como a 375 px
