# Spec Delta

## Purpose

Identifica quién hace cada petición: inicio y cierre de sesión, sesiones
con vencimiento, limitación de intentos y rutas del producto cerradas por
defecto. No decide qué puede hacer cada cuenta: eso son las políticas sobre
recursos.

## ADDED Requirements

### Requirement: Inicio de sesión con correo y contraseña
Una cuenta activa SHALL poder iniciar sesión con su correo y su contraseña.
Al hacerlo, la aplicación MUST crear una sesión nueva en el servidor y
llevar a la persona a la página que pidió o, si no pidió ninguna, a la
página de inicio.

#### Scenario: Credenciales válidas
- **WHEN** una cuenta activa envía su correo y su contraseña correctos
- **THEN** se crea una sesión en el servidor asociada a esa cuenta y la persona llega a la página de inicio

#### Scenario: Vuelta a la página pedida
- **WHEN** una persona sin sesión pide una página del producto y después inicia sesión correctamente
- **THEN** llega a la página que había pedido

### Requirement: Fallo de inicio de sesión sin revelar la causa
Un intento con contraseña incorrecta, con un correo que no existe o con una
cuenta desactivada MUST NOT crear una sesión y SHALL responder con el mismo
estado y el mismo mensaje genérico, sin indicar cuál de los datos falló.
Este requisito trata del contenido de la respuesta, no de su tiempo.

#### Scenario: Contraseña incorrecta
- **WHEN** se envía un correo existente con una contraseña incorrecta
- **THEN** no se crea ninguna sesión y se muestra el mensaje genérico

#### Scenario: Correo desconocido
- **WHEN** se envía un correo que no corresponde a ninguna cuenta
- **THEN** no se crea ninguna sesión y se muestra el mismo mensaje genérico

#### Scenario: Cuenta desactivada
- **WHEN** una cuenta desactivada envía su correo y su contraseña correctos
- **THEN** no se crea ninguna sesión y se muestra el mismo mensaje genérico

### Requirement: Limitación de intentos por dirección IP
La aplicación SHALL aceptar como máximo 10 intentos de inicio de sesión,
exitosos o fallidos, desde una misma dirección IP en una ventana fija de 3
minutos que empieza con el primer intento contado. Superado el límite MUST
responder con el estado 429 y un mensaje genérico, sin evaluar las
credenciales, hasta que la ventana termine.

#### Scenario: Undécimo intento en la ventana
- **WHEN** una misma dirección IP envía el undécimo intento dentro de la ventana de 3 minutos
- **THEN** la respuesta tiene estado 429 y no se crea ninguna sesión, aunque las credenciales sean válidas

#### Scenario: Ventana vencida
- **WHEN** terminan los 3 minutos de la ventana
- **THEN** el conteo vuelve a empezar y un intento con credenciales válidas inicia sesión

### Requirement: Limitación de intentos fallidos por correo
La aplicación SHALL aceptar como máximo 5 intentos fallidos para un mismo
correo, normalizado igual que en las cuentas, en una ventana fija de 15
minutos que empieza con el primer fallo. Al llegar al límite MUST responder
con el estado 429 y un mensaje genérico, sin evaluar las credenciales,
hasta que la ventana termine.

#### Scenario: Sexto intento tras cinco fallos
- **WHEN** hubo 5 intentos fallidos para un correo dentro de 15 minutos, desde direcciones IP distintas, y llega un sexto intento
- **THEN** la respuesta tiene estado 429 y no se crea ninguna sesión, aunque las credenciales sean válidas

#### Scenario: Intentos simultáneos
- **WHEN** llegan a la vez más de 5 intentos para un mismo correo sin fallos previos en la ventana
- **THEN** como máximo 5 evalúan las credenciales y el resto recibe 429 sin evaluarlas

#### Scenario: Variantes del mismo correo
- **WHEN** los intentos fallidos usan el mismo correo con distintas mayúsculas o espacios alrededor
- **THEN** cuentan para el mismo límite

#### Scenario: Ventana vencida
- **WHEN** terminan los 15 minutos de la ventana
- **THEN** el correo puede volver a intentar sin intervención de un administrador

### Requirement: Reinicio del conteo por correo tras un éxito
Un inicio de sesión exitoso SHALL reiniciar el conteo de intentos fallidos
de su correo.

#### Scenario: Éxito antes del límite
- **WHEN** después de menos de 5 fallos se inicia sesión correctamente con ese correo
- **THEN** el conteo de fallos de ese correo vuelve a cero

### Requirement: Almacén de los límites compartido entre procesos
Los contadores de los límites SHALL guardarse en un almacén compartido por
todos los procesos de la aplicación, con incrementos atómicos, y MUST NOT
guardar el correo ni la dirección IP en claro en las claves.

#### Scenario: Dos procesos
- **WHEN** dos procesos de la misma instancia cuentan intentos para la misma clave
- **THEN** ambos ven el mismo contador

#### Scenario: Claves sin datos personales en claro
- **WHEN** se inspeccionan las claves guardadas por los límites
- **THEN** no contienen el correo ni la dirección IP en claro

### Requirement: Sesión con vencimiento
Una sesión SHALL vencer tras 2 horas sin actividad y, en cualquier caso, 12
horas después de iniciarse. Ambos vencimientos MUST comprobarse en el
servidor en cada petición, con los datos guardados de la sesión y no solo
con el vencimiento de la cookie. Una sesión vencida MUST rechazarse; su
registro se elimina cuando se presenta o cuando su cuenta inicia una nueva
sesión.

#### Scenario: Actividad dentro del plazo
- **WHEN** una sesión hace una petición antes de cumplir 2 horas sin actividad y 12 horas desde su inicio
- **THEN** la petición se atiende y el plazo de inactividad se renueva

#### Scenario: Vencimiento por inactividad
- **WHEN** una sesión hace una petición después de 2 horas sin actividad
- **THEN** la petición redirige al inicio de sesión y la sesión ya no existe en el servidor

#### Scenario: Vencimiento absoluto
- **WHEN** una sesión con actividad constante hace una petición 12 horas o más después de iniciarse, aunque se reenvíe la cookie
- **THEN** la petición redirige al inicio de sesión

#### Scenario: Máximo absoluto comprobado con los datos del servidor
- **WHEN** la sesión guardada superó las 12 horas y la cookie todavía no venció
- **THEN** la petición redirige al inicio de sesión y la sesión ya no existe en el servidor

#### Scenario: Limpieza al iniciar sesión
- **WHEN** una cuenta inicia una sesión nueva
- **THEN** sus sesiones vencidas se eliminan del servidor

### Requirement: Cierre de sesión
Cerrar sesión SHALL eliminar la sesión del servidor y borrar la cookie. Una
cookie de una sesión cerrada MUST NOT servir aunque se vuelva a enviar.

#### Scenario: Cerrar sesión
- **WHEN** una persona con sesión cierra la sesión
- **THEN** la sesión deja de existir en el servidor y la persona vuelve al inicio de sesión

#### Scenario: Reenvío de la cookie
- **WHEN** después de cerrar sesión se reenvía la cookie anterior a una página del producto
- **THEN** la petición redirige al inicio de sesión

### Requirement: Sesión de una cuenta desactivada
Una sesión cuya cuenta esté desactivada MUST rechazarse en la siguiente
petición y eliminarse del servidor.

#### Scenario: Cuenta desactivada con sesión abierta
- **WHEN** una cuenta con una sesión abierta queda desactivada y la sesión hace una petición
- **THEN** la petición redirige al inicio de sesión y la sesión ya no existe en el servidor

### Requirement: Atributos de la cookie de sesión
La cookie que identifica la sesión SHALL estar firmada, no ser accesible
desde JavaScript, enviarse con `SameSite=Lax`, vencer a las 12 horas y
marcarse como `Secure` cuando la conexión es HTTPS.

#### Scenario: Atributos al iniciar sesión por HTTPS
- **WHEN** se inicia sesión por HTTPS
- **THEN** la cookie de sesión tiene `HttpOnly`, `SameSite=Lax`, `Secure` y un vencimiento de 12 horas

### Requirement: Identificador de sesión nuevo al iniciar sesión
Al iniciar sesión, la aplicación SHALL descartar la sesión anónima previa y
emitir un identificador nuevo, para que un identificador fijado antes del
inicio de sesión no sirva después.

#### Scenario: Rotación del identificador
- **WHEN** una persona con una cookie de sesión anónima inicia sesión
- **THEN** la cookie de sesión anónima cambia y la cookie de la sesión autenticada es nueva

### Requirement: Protección CSRF
Toda petición que modifica estado, incluidos el inicio y el cierre de
sesión, MUST incluir un token CSRF válido; sin él SHALL rechazarse.

#### Scenario: Inicio de sesión sin token
- **WHEN** con la protección CSRF activada se envía el inicio de sesión sin token válido
- **THEN** la petición se rechaza y no se crea ninguna sesión

#### Scenario: Cierre de sesión sin token
- **WHEN** con la protección CSRF activada se envía el cierre de sesión sin token válido
- **THEN** la petición se rechaza y la sesión sigue existiendo

### Requirement: Rutas del producto protegidas por defecto
Toda ruta del producto SHALL exigir una sesión válida de una cuenta activa,
también cuando se pide por URL directa. Las únicas excepciones MUST ser el
chequeo de salud, el formulario de inicio de sesión y su envío; cualquier
excepción nueva debe declararse.

#### Scenario: Ruta del producto sin sesión
- **WHEN** se pide sin sesión cualquier ruta del producto que no sea una excepción declarada
- **THEN** la respuesta redirige al inicio de sesión y no muestra contenido del producto

#### Scenario: Excepciones declaradas
- **WHEN** se piden sin sesión el chequeo de salud y el formulario de inicio de sesión
- **THEN** responden sin exigir sesión

#### Scenario: Rechazo antes de la acción
- **WHEN** se pide sin sesión una ruta del producto que modifica estado
- **THEN** la petición se redirige al inicio de sesión antes de ejecutar la acción y no hay ningún efecto en la base

#### Scenario: Ruta nueva sin declarar
- **WHEN** se agrega una ruta y la prueba recorre todas las rutas sin sesión
- **THEN** la prueba falla si la ruta responde sin sesión y no está entre las excepciones declaradas
