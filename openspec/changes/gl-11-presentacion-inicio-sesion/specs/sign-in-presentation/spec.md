## ADDED Requirements

### Requirement: Etiquetas sobre los campos
La página de inicio de sesión SHALL mostrar cada etiqueta encima de su
campo y asociada a él, con un espaciado uniforme entre los grupos de
etiqueta y campo.

#### Scenario: Etiquetas sobre los campos
- **WHEN** se abre la página de inicio de sesión sin sesión, en una ventana de 1280 px de ancho
- **THEN** la etiqueta «Correo» queda encima de su campo y «Contraseña» encima del suyo, cada una asociada a su campo

### Requirement: Campos con el aspecto de la aplicación
Los campos de correo y de contraseña SHALL ocupar el ancho del
formulario, con una altura mínima de 44 px y el mismo borde, radio y
tipografía que los campos de las pantallas internas. La presentación MUST
usar la hoja de estilos de la aplicación, sin estilos en línea.

#### Scenario: Campos utilizables
- **WHEN** se abre la página de inicio de sesión
- **THEN** los dos campos tienen el mismo ancho, al menos 44 px de alto y el mismo borde, radio y tipografía que los campos de la captura rápida

### Requirement: Botón «Iniciar sesión»
El botón «Iniciar sesión» SHALL quedar debajo del campo de contraseña,
alineado a la izquierda con el borde izquierdo de los campos, con al menos
44 px de alto y el estilo común de los botones de la aplicación.

#### Scenario: Posición y aspecto del botón
- **WHEN** se abre la página de inicio de sesión
- **THEN** el botón «Iniciar sesión» queda debajo del campo de contraseña, su borde izquierdo coincide con el de los campos y tiene al menos 44 px de alto y el borde, el radio y el fondo de los demás botones

### Requirement: Ancho máximo del formulario
El formulario SHALL tener un ancho máximo de 24 rem y un ancho fluido por
debajo de ese máximo: en una ventana donde el contenedor mide más de
24 rem, el formulario mide 24 rem; en una más angosta, ocupa todo el ancho
disponible del contenedor. Es lo que decidió Pablo en P-33.

#### Scenario: Escritorio
- **WHEN** se abre la página de inicio de sesión en una ventana de 1280 px de ancho
- **THEN** el formulario y sus campos miden 24 rem de ancho, sin estirarse al ancho del contenedor

#### Scenario: Pantalla angosta
- **WHEN** se abre la página de inicio de sesión en una ventana de 375 px de ancho
- **THEN** el formulario ocupa todo el ancho disponible del contenedor

### Requirement: Foco visible
El campo de correo, el de contraseña y el botón SHALL mostrar, mientras
tienen el foco, el indicador de foco común de la aplicación: el contorno
sólido de 3 px con el color de foco y 2 px de separación. El campo de
correo recibe el foco al cargar la página (`autofocus`) y SHALL mostrar
ese indicador sin que se pulse ninguna tecla.

#### Scenario: Foco inicial
- **WHEN** se abre la página de inicio de sesión
- **THEN** el campo de correo tiene el foco y muestra el contorno sólido de 3 px con el color de foco de la aplicación y 2 px de separación

#### Scenario: Recorrido con el teclado
- **WHEN** desde el campo de correo se pulsa Tab y después otra vez Tab
- **THEN** el foco pasa a la contraseña y después al botón, y cada uno muestra el mismo contorno mientras tiene el foco

### Requirement: Avisos de error accesibles y genéricos
Los avisos de fallo de inicio de sesión y de demasiados intentos SHALL
aparecer antes del formulario. Cada aviso conserva `role="alert"` y su
texto, y SHALL distinguirse con el estilo del resumen de errores de las
pantallas internas, sin depender solo del color. La presentación MUST NOT
marcar como erróneo un campo concreto ni agregar texto que indique qué
dato falló.

#### Scenario: Credenciales incorrectas
- **WHEN** un intento de inicio de sesión falla
- **THEN** el aviso genérico aparece antes del formulario con `role="alert"` y el estilo del resumen de errores, y ningún campo queda marcado como erróneo

#### Scenario: Demasiados intentos
- **WHEN** un intento recibe la respuesta de demasiados intentos
- **THEN** su aviso aparece en el mismo lugar y con la misma presentación

### Requirement: Adaptación a pantallas angostas
A 375 px de ancho, la página de inicio de sesión MUST NOT tener
desplazamiento horizontal, y los campos y el botón SHALL verse completos
dentro de la página.

#### Scenario: Ventana de 375 px
- **WHEN** se abre la página de inicio de sesión en una ventana de 375 px de ancho, también con un aviso de error
- **THEN** el ancho del documento no supera el de la ventana y los campos y el botón entran completos

### Requirement: Presentación sin cambios de comportamiento
La presentación MUST NOT cambiar el comportamiento de la página de
inicio de sesión definido por la spec `authentication`: los nombres de los
campos, sus atributos (`autocomplete`, `required`, `autofocus` y
`maxlength`), el correo repetido tras un fallo, el título, los mensajes,
los estados de respuesta y la ruta. La presentación MUST NOT cambiar
tampoco la ausencia de la cabecera de navegación sin sesión, que define la
spec `people-browsing`.

#### Scenario: Envío del formulario
- **WHEN** se envía el formulario de inicio de sesión con la presentación nueva
- **THEN** la petición, la respuesta, los mensajes y la sesión resultante son los mismos que antes del cambio
