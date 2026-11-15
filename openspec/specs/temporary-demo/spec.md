# temporary-demo Specification

## Purpose
Define la instancia demo temporal y editable de Growth Log, con datos
exclusivamente ficticios, y la tarea explícita e idempotente que prepara
su conjunto en una base dedicada, separada de los datos de desarrollo.

## Requirements

### Requirement: Instancia demo temporal con datos ficticios
La instancia demo SHALL contener solo datos ficticios: cuentas del dominio
reservado `ficticio.example.test`, personas y entradas inventadas, y lo
que quienes revisan capturan sobre ellas. MUST NOT usarse para cargar datos
reales. La demo es editable, con las mismas reglas de autorización y
privacidad que cualquier instancia: no tiene un modo de solo lectura ni
relaja ninguna regla.

#### Scenario: Recorrido en la demo
- **WHEN** una cuenta demo inicia sesión en la instancia demo
- **THEN** ve solo las personas que tiene asignadas y puede capturar, completar y marcar como lista sus entradas, como en cualquier instancia

#### Scenario: Privacidad entre las cuentas demo
- **WHEN** la segunda cuenta demo abre la ficha de la persona compartida o pide por URL directa el detalle de una entrada de la primera
- **THEN** no ve las entradas de la primera y el detalle responde la página de no encontrado

### Requirement: Tarea demo explícita y separada de los datos de desarrollo
La preparación del conjunto demo SHALL ejecutarse solo mediante una tarea
explícita propia, distinta de la tarea de datos ficticios de desarrollo, que
sigue limitada a `development`. Ni la carga de seeds, ni las migraciones, ni
el arranque del servidor web MUST ejecutarla ni crear datos demo.

#### Scenario: Seeds, migraciones y arranque
- **WHEN** se cargan los seeds, se ejecutan las migraciones o arranca el servidor web, en cualquier entorno
- **THEN** no se crea ningún dato demo

#### Scenario: Datos de desarrollo sin cambios
- **WHEN** se ejecuta la tarea de datos ficticios de desarrollo fuera de `development`
- **THEN** se sigue negando como antes de este cambio

### Requirement: Solo en la instancia demo
La tarea demo SHALL ejecutarse solo en el entorno de producción y con el
indicador explícito de instancia demo configurado con su valor exacto. En
`development`, en `test`, o sin ese indicador, MUST terminar con error antes
de escribir en la base.

#### Scenario: Entorno de desarrollo o de test
- **WHEN** se ejecuta la tarea demo en un proceso propio con el entorno de desarrollo o de test, aunque el indicador esté configurado
- **THEN** el proceso termina con error, lo informa y la base no cambia

#### Scenario: Producción sin indicador
- **WHEN** se ejecuta la tarea demo en producción sin el indicador de instancia demo o con otro valor
- **THEN** el proceso termina con error y la base no cambia

### Requirement: Base dedicada sin registros ajenos
La tarea demo SHALL ejecutarse solo sobre una base dedicada a la demo. Si la
base contiene una cuenta, una persona o una asignación sin la marca del
conjunto demo, o una entrada que no está marcada ni fue escrita por una
cuenta demo, la tarea MUST terminar con error sin crear, modificar, marcar
ni borrar ningún registro.

#### Scenario: Cuenta ajena en la base
- **WHEN** la base tiene una cuenta que la tarea demo no creó
- **THEN** la tarea termina con error, no modifica esa cuenta ni crea ningún registro

#### Scenario: Correo del conjunto ya usado
- **WHEN** existe una cuenta con un correo del conjunto demo sin la marca demo
- **THEN** la tarea no la adopta, termina con error y no escribe ningún registro

### Requirement: Conjunto demo definido
En una base dedicada sin el conjunto, la tarea SHALL crear exactamente:

- dos cuentas líderes activas, no administradoras;
- una persona activa asignada a ambas;
- las dos asignaciones activas;
- un borrador y una entrada lista de la primera cuenta sobre esa persona;
- una entrada lista de la segunda.

Cada registro creado MUST quedar marcado como parte del conjunto demo, con
marcas separadas de las del conjunto de desarrollo.

#### Scenario: Primera ejecución
- **WHEN** se ejecuta la tarea en la instancia demo sobre una base dedicada vacía, después de las migraciones
- **THEN** existen exactamente las cuentas, la persona, las asignaciones y las entradas del conjunto, cada una con su marca demo, y ninguna cuenta es administradora

### Requirement: Repetición sin sobrescribir, adoptar ni borrar
Una nueva ejecución SHALL crear solo los elementos del conjunto que no
tienen marca. MUST NOT modificar ni borrar registros existentes:

- se conservan los cambios hechos en la demo, incluidos los de las entradas
  de ejemplo;
- se conservan las entradas que quienes revisan crearon con las cuentas
  demo.

#### Scenario: Ejecución en cada despliegue
- **WHEN** la tarea se ejecuta de nuevo después de que una cuenta demo editó la entrada de ejemplo, marcó el borrador como listo y capturó entradas nuevas
- **THEN** no se crea, modifica ni borra ningún registro y la salida indica que el conjunto ya existía

### Requirement: Operación atómica y ejecuciones simultáneas
La preparación SHALL ser una sola operación: ante un conflicto o cualquier
error, MUST revertirse completa. Dos ejecuciones simultáneas MUST dejar un
solo conjunto.

#### Scenario: Error a mitad de la creación
- **WHEN** la creación falla después de crear parte del conjunto
- **THEN** no queda ningún registro ni marca de esa ejecución

### Requirement: Contraseñas iniciales desde secretos del entorno
Al crear una cuenta demo, la tarea SHALL tomar su contraseña inicial de la
variable de entorno secreta asignada a esa cuenta, y MUST validarla con la
política de contraseñas antes de escribir. Si falta la variable de una
cuenta que hay que crear, o su valor no cumple la política, la tarea MUST
terminar con error sin crear, modificar ni marcar ningún registro. MUST NOT
leer esa variable ni cambiar la contraseña de una cuenta demo que ya existe.

#### Scenario: Creación con secretos válidos
- **WHEN** la tarea crea las cuentas demo con sus variables de contraseña presentes y válidas
- **THEN** cada cuenta puede iniciar sesión con la contraseña de su variable

#### Scenario: Secreto ausente o inválido
- **WHEN** falta la variable de contraseña de una cuenta que hay que crear, o su valor no cumple la política
- **THEN** la tarea termina con error y no queda ningún registro ni marca de esa ejecución

#### Scenario: Cuenta existente
- **WHEN** la tarea se ejecuta de nuevo con el valor de una variable de contraseña cambiado o sin la variable
- **THEN** la contraseña de la cuenta existente no cambia y la tarea no falla por esa variable

### Requirement: Contraseñas nunca visibles ni versionadas
La tarea demo MUST NOT mostrar contraseñas ni hashes en la salida, en los
mensajes de error ni en los logs. El repositorio y los prompts registrados
MUST NOT contener contraseñas ni hashes de las cuentas demo.

#### Scenario: Salida de la tarea
- **WHEN** la tarea termina, con éxito o con error, incluido un error por una contraseña inválida
- **THEN** ni la salida ni los logs contienen contraseñas ni hashes

### Requirement: Ejecución en el build habilitada por el indicador
El script de build de la instancia demo SHALL ejecutar las migraciones y,
después de ellas, invocar la tarea demo solo si el indicador de instancia
demo está configurado. Sin el indicador, MUST completar el build sin
invocar la tarea. Si la tarea o las migraciones fallan, el build MUST
fallar.

#### Scenario: Deploy solo de migraciones
- **WHEN** el build corre sin el indicador de instancia demo
- **THEN** ejecuta las migraciones, no invoca la tarea demo y no crea datos demo

#### Scenario: Deploy con la tarea habilitada
- **WHEN** el build corre con el indicador configurado
- **THEN** ejecuta las migraciones y después la tarea demo, y si la tarea falla el build falla
