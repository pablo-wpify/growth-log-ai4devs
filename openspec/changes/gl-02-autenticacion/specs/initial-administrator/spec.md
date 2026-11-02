# Spec Delta

## Purpose

Permite crear la primera cuenta administradora de una instalación con un
procedimiento documentado y reproducible, sin credenciales en el código ni
secretos versionados.

## ADDED Requirements

### Requirement: Creación del primer administrador
Un procedimiento de línea de comandos SHALL crear una cuenta administradora
activa a partir de un correo y un nombre, y de una contraseña ingresada dos
veces en el momento. La contraseña MUST cumplir la política de contraseñas.

#### Scenario: Creación correcta
- **WHEN** se ejecuta el procedimiento con `ana.admin@example.test`, un nombre y la misma contraseña válida dos veces, y no hay ningún administrador activo
- **THEN** existe una cuenta administradora activa con ese correo, que puede iniciar sesión con esa contraseña

#### Scenario: Contraseñas distintas
- **WHEN** las dos contraseñas ingresadas no coinciden
- **THEN** no se crea ninguna cuenta y se informa el error

#### Scenario: Contraseña que no cumple la política
- **WHEN** la contraseña ingresada no cumple la política de contraseñas
- **THEN** no se crea ninguna cuenta y se informa qué falta

### Requirement: Solo para una instalación sin administradores
El procedimiento MUST negarse a crear una cuenta si ya existe un
administrador activo, sin modificar las cuentas existentes.

#### Scenario: Administrador existente
- **WHEN** se ejecuta el procedimiento y ya hay un administrador activo
- **THEN** no crea ni modifica ninguna cuenta e informa que ya existe un administrador

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
- **WHEN** se buscan en los archivos versionados contraseñas o cuentas predefinidas, incluidos los seeds
- **THEN** no hay ninguna
