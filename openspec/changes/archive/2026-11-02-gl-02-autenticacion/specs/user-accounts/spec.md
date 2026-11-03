# Spec Delta

## Purpose

Define las cuentas individuales de Growth Log: qué datos tienen, cómo se
guarda su contraseña, qué contraseñas se aceptan y cuándo una cuenta está
activa. Las cuentas solo las crean procedimientos internos, nunca un
registro público.

## ADDED Requirements

### Requirement: Cuenta individual identificada por correo
Cada cuenta SHALL tener un correo y un nombre obligatorios. El correo MUST
guardarse normalizado (sin espacios al principio ni al final y en
minúsculas) y MUST ser único entre todas las cuentas.

#### Scenario: Correo normalizado
- **WHEN** se crea una cuenta con el correo ` Ana.Admin@Example.TEST `
- **THEN** la cuenta queda con el correo `ana.admin@example.test`

#### Scenario: Correo duplicado
- **WHEN** se intenta crear una cuenta con un correo que ya existe, aunque difiera en mayúsculas
- **THEN** la cuenta no se guarda y se informa el error

#### Scenario: Datos obligatorios
- **WHEN** se intenta crear una cuenta sin correo o sin nombre
- **THEN** la cuenta no se guarda y se informa el error

### Requirement: Contraseña guardada solo como hash adaptativo
La contraseña de una cuenta SHALL guardarse únicamente como hash bcrypt. La
contraseña en texto plano MUST NOT guardarse en la base ni aparecer en los
logs de la aplicación.

#### Scenario: Hash en la base
- **WHEN** se crea una cuenta con una contraseña válida
- **THEN** la base guarda un hash bcrypt distinto de la contraseña y ninguna columna contiene la contraseña

#### Scenario: Contraseña fuera de los logs
- **WHEN** se envía una contraseña en un intento de inicio de sesión
- **THEN** el log de la petición muestra el parámetro filtrado y no su valor

### Requirement: Política de contraseñas
Una contraseña SHALL tener al menos 15 caracteres y como máximo 72 bytes,
sin reglas de composición obligatorias.

#### Scenario: Contraseña corta
- **WHEN** se intenta guardar una contraseña de 14 caracteres
- **THEN** no se guarda y se informa la longitud mínima

#### Scenario: Contraseña demasiado larga
- **WHEN** se intenta guardar una contraseña de más de 72 bytes
- **THEN** no se guarda y se informa el límite

#### Scenario: Contraseña válida sin composición especial
- **WHEN** se guarda una frase de 15 caracteres o más, solo con letras minúsculas y espacios
- **THEN** se acepta

### Requirement: Estado activo de la cuenta
Una cuenta SHALL estar activa mientras no tenga fecha de desactivación. Una
cuenta desactivada MUST conservarse con todos sus datos.

#### Scenario: Cuenta nueva
- **WHEN** se crea una cuenta
- **THEN** está activa

#### Scenario: Cuenta desactivada
- **WHEN** una cuenta tiene fecha de desactivación
- **THEN** no está activa y sigue existiendo en la base

### Requirement: Sin registro público
La aplicación MUST NOT ofrecer ninguna ruta para que una persona cree su
propia cuenta ni para recuperar una contraseña.

#### Scenario: Rutas declaradas
- **WHEN** se listan las rutas de la aplicación
- **THEN** ninguna permite crear cuentas sin sesión ni restablecer contraseñas
