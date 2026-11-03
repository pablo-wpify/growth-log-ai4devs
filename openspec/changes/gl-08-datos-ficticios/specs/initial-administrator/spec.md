## MODIFIED Requirements

### Requirement: Solo para una instalación sin administradores
El procedimiento MUST negarse a crear una cuenta si ya existe un
administrador activo, sin modificar las cuentas existentes. Las cuentas del
conjunto ficticio de desarrollo no son administradoras y no impiden crear
el primer administrador.

#### Scenario: Administrador existente
- **WHEN** se ejecuta el procedimiento y ya hay un administrador activo
- **THEN** no crea ni modifica ninguna cuenta e informa que ya existe un administrador

#### Scenario: Solo cuentas ficticias
- **WHEN** se ejecuta el procedimiento en una base que solo tiene las cuentas del conjunto ficticio de desarrollo
- **THEN** crea el administrador y no modifica las cuentas ficticias

### Requirement: Sin credenciales en el código ni en la salida
El procedimiento MUST NOT leer la contraseña de argumentos, del código ni de
archivos versionados, y MUST NOT mostrarla en pantalla ni escribirla en los
logs. Cuando se ejecuta en una terminal, la contraseña SHALL pedirse sin
eco.

#### Scenario: Entrada sin eco
- **WHEN** el procedimiento pide la contraseña en una terminal
- **THEN** lo que se escribe no se muestra

#### Scenario: Salida sin la contraseña
- **WHEN** termina el procedimiento, con éxito o con error
- **THEN** ni la salida ni los logs contienen la contraseña

#### Scenario: Repositorio sin credenciales
- **WHEN** se buscan en los archivos versionados contraseñas, hashes de contraseñas o cuentas predefinidas, incluidos los seeds
- **THEN** no hay contraseñas ni hashes, y las únicas cuentas predefinidas son las del conjunto ficticio de desarrollo: correos del dominio `ficticio.example.test`, sin rol de administrador y sin contraseñas ni hashes versionados
