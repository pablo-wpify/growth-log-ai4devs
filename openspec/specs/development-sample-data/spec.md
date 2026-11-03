# development-sample-data Specification

## Purpose
Prepara, solo en desarrollo y mediante una tarea explícita, un conjunto
fijo de cuentas, personas y asignaciones ficticias para recorrer la
aplicación con varios líderes, sin credenciales versionadas, sin adoptar ni
modificar registros existentes, y permite establecer la contraseña de esas
cuentas sin eco.

## Requirements

### Requirement: Tarea explícita solo en desarrollo
La preparación de datos ficticios SHALL ejecutarse solo mediante una tarea
explícita y solo en el entorno de desarrollo. En cualquier otro entorno la
tarea MUST terminar con error antes de consultar o escribir la base. Ni la
carga de seeds, ni las migraciones, ni el arranque de la aplicación MUST
crear datos ficticios.

#### Scenario: Proceso real fuera de desarrollo
- **WHEN** se ejecuta la tarea en un proceso propio con el entorno de test o de producción, conectado a una base de pruebas aislada
- **THEN** el proceso termina con error, lo informa y la base no cambia

#### Scenario: Seeds, migraciones y arranque
- **WHEN** se cargan los seeds, se ejecutan las migraciones o arranca la aplicación
- **THEN** no se crea ningún dato ficticio

### Requirement: Conjunto ficticio definido
La tarea SHALL crear un conjunto fijo y documentado de cuentas líderes,
personas y asignaciones ficticias que representa: varios líderes de una
misma persona, un líder con varias personas, un líder sin asignaciones, una
asignación terminada, una persona inactiva con asignación activa, una
persona sin líderes y una cuenta desactivada con asignación activa. Las
cuentas MUST usar el dominio reservado `ficticio.example.test` y MUST NOT
ser administradoras.

#### Scenario: Primera ejecución
- **WHEN** se ejecuta la tarea en desarrollo sobre una base sin el conjunto ficticio
- **THEN** existen exactamente las cuentas, personas y asignaciones definidas, ninguna cuenta es administradora y cada registro creado queda marcado como parte del conjunto

### Requirement: Marcas inequívocas
Cada marca SHALL tener una clave única y referenciar exactamente un
registro, del tipo que indica su clave: cuenta, persona o asignación. Un
registro MUST tener como máximo una marca, y mientras esté marcado la base
MUST impedir borrarlo.

#### Scenario: Clave duplicada o referencia ambigua
- **WHEN** se intenta guardar una marca con una clave existente, sin registro, con más de un registro, con un tipo distinto del de su clave, o para un registro ya marcado
- **THEN** la base la rechaza

#### Scenario: Borrar un registro marcado
- **WHEN** se intenta borrar un registro que tiene una marca
- **THEN** la base lo impide

### Requirement: Repetición sin duplicar, sobrescribir ni reactivar
Una nueva ejecución SHALL crear solo los elementos del conjunto que no
tienen marca y MUST NOT modificar ni borrar registros existentes:
contraseñas, roles, estados, nombres y fechas se conservan, aunque se hayan
cambiado después de crearlos. MUST NOT reactivar cuentas desactivadas ni
asignaciones terminadas, ni crear otra asignación para un par cuya
asignación marcada terminó. Repetir la tarea MUST NOT requerir borrar
datos.

#### Scenario: Segunda ejecución
- **WHEN** se ejecuta la tarea por segunda vez
- **THEN** no se crea, modifica ni borra ningún registro y la salida indica que el conjunto ya existía

#### Scenario: Cambios manuales entre ejecuciones
- **WHEN** entre dos ejecuciones se desactiva una cuenta ficticia, se termina una de sus asignaciones, o se cambian su contraseña, su nombre o el estado de una persona
- **THEN** la segunda ejecución conserva esos cambios: la cuenta sigue desactivada, la asignación sigue terminada y no se crea otra para ese par

### Requirement: Sin adopción de registros ajenos
La tarea SHALL reconocer como propios solo los registros que ella misma
marcó. Si existe una cuenta con un correo del conjunto sin esa marca, o una
asignación activa de un par del conjunto sin marca, la tarea MUST terminar
con error sin crear, modificar ni marcar ningún registro.

#### Scenario: Correo ya usado por una cuenta ajena
- **WHEN** existe una cuenta con un correo del conjunto que la tarea no creó
- **THEN** la tarea termina con error, no modifica esa cuenta ni crea ningún registro

### Requirement: Operación atómica
Toda la preparación SHALL ejecutarse como una sola operación: ante un
conflicto o cualquier error durante la ejecución, MUST revertirse completa,
sin dejar registros ni marcas de esa ejecución.

#### Scenario: Error a mitad de la creación
- **WHEN** la creación falla después de haber creado parte del conjunto
- **THEN** no queda ningún registro ni marca de esa ejecución

### Requirement: Ejecuciones simultáneas
Dos ejecuciones simultáneas de la tarea SHALL dejar un solo conjunto
ficticio.

#### Scenario: Dos ejecuciones a la vez
- **WHEN** se ejecuta la tarea dos veces al mismo tiempo, con conexiones distintas
- **THEN** cada elemento del conjunto existe una sola vez

### Requirement: Contraseña inicial aleatoria y descartada
La tarea SHALL crear cada cuenta ficticia con una contraseña aleatoria de
48 caracteres que no se guarda, no se muestra y se descarta. La cuenta
queda con el estado que define el conjunto: activa, salvo la que el
conjunto define como desactivada. Una cuenta activa solo admite iniciar
sesión con esa contraseña, que nadie conoce, hasta que se establezca otra.
El repositorio MUST NOT contener contraseñas ni hashes de esas cuentas, y la
salida MUST NOT contener contraseñas.

#### Scenario: Cuenta recién creada
- **WHEN** se crea una cuenta ficticia
- **THEN** su hash es distinto en cada ejecución que la crea, su contraseña no aparece en el repositorio, la salida ni los logs, y un intento con cualquier contraseña de prueba falla

### Requirement: Contraseña de una cuenta ficticia
Una tarea explícita SHALL establecer la contraseña de una cuenta del
conjunto ficticio, pedida dos veces sin eco cuando hay una terminal y leída
de la entrada estándar cuando no la hay, con la política de contraseñas, y
MUST eliminar todas las sesiones existentes de esa cuenta. MUST NOT leer la
contraseña de argumentos ni de variables de entorno, ni mostrarla en la
salida o los logs.

#### Scenario: Cuenta activa del conjunto
- **WHEN** se establece en desarrollo la contraseña de una cuenta ficticia activa con la misma contraseña válida dos veces
- **THEN** la cuenta puede iniciar sesión con ella, sus sesiones anteriores se eliminan y la salida no contiene la contraseña

#### Scenario: Contraseñas distintas o fuera de la política
- **WHEN** las dos contraseñas no coinciden o no cumplen la política
- **THEN** la contraseña y las sesiones no cambian y se informa el error sin mostrarla

#### Scenario: Contraseña en variables de entorno
- **WHEN** la contraseña se pasa en una variable de entorno y no por la entrada
- **THEN** la tarea no la usa y la contraseña no cambia

### Requirement: Estado de la cuenta al cambiar la contraseña
Establecer la contraseña de una cuenta ficticia MUST NOT cambiar su estado,
su rol ni su nombre: una cuenta desactivada sigue desactivada y su inicio
de sesión se rechaza como en cualquier cuenta desactivada.

#### Scenario: Cuenta desactivada del conjunto
- **WHEN** se establece la contraseña de la cuenta ficticia desactivada
- **THEN** la contraseña cambia, sus sesiones se eliminan, la cuenta sigue desactivada y el inicio de sesión con la contraseña nueva se rechaza

### Requirement: Contraseña solo para cuentas ficticias en desarrollo
La tarea de contraseña MUST negarse, sin modificar ninguna cuenta, fuera
de desarrollo, para correos desconocidos y para cuentas que no forman parte
del conjunto ficticio, incluidas las administradoras.

#### Scenario: Cuenta fuera del conjunto
- **WHEN** se pide establecer la contraseña de una cuenta que la tarea de datos ficticios no creó, también una administradora
- **THEN** la tarea se niega y no modifica la cuenta

#### Scenario: Proceso real fuera de desarrollo
- **WHEN** se ejecuta la tarea de contraseña en un proceso propio con el entorno de test, sobre una cuenta marcada de una base de pruebas aislada
- **THEN** el proceso termina con error y la cuenta no cambia
