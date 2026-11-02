# Spec Delta

## Purpose

Garantiza que otra persona pueda preparar el entorno local de Growth Log
desde cero, con PostgreSQL, comandos documentados que funcionan tal como
están escritos y una única suite de pruebas.

## ADDED Requirements

### Requirement: Guía de desarrollo reproducible
La guía de desarrollo SHALL documentar los prerrequisitos, las variables de
entorno necesarias (por nombre, sin valores) y los comandos para preparar
las bases, ejecutar la suite, ejecutar la verificación completa y comprobar
la ruta de salud. Cada comando documentado MUST funcionar tal como está
escrito desde el entorno preparado.

#### Scenario: Recorrido desde un clon limpio
- **WHEN** una persona con Ruby 4.0.9 y un PostgreSQL 18.6 accesible sigue la guía desde un clon limpio
- **THEN** cada comando documentado termina con éxito y la ruta de salud responde con estado HTTP 200

#### Scenario: Sin valores secretos
- **WHEN** se revisa la guía de desarrollo
- **THEN** nombra las variables de entorno necesarias sin incluir ninguna contraseña ni credencial

### Requirement: Configuración local de la base sin secretos versionados
Las variables de conexión locales SHALL vivir en un archivo local que Git
ignora, y el repositorio MUST ofrecer una plantilla versionada con los
nombres de esas variables y sin ninguna contraseña real.

#### Scenario: Archivo local ignorado
- **WHEN** se consulta a Git si el archivo local de variables está ignorado
- **THEN** lo está y no figura entre los archivos versionados

#### Scenario: Plantilla sin secretos
- **WHEN** se revisa la plantilla versionada
- **THEN** contiene los nombres de las variables `DATABASE_*` y un marcador en lugar de la contraseña

### Requirement: Suite de pruebas única y efectiva
El proyecto SHALL tener una única suite de pruebas automática, ejecutable
con un solo comando, que reporte la cantidad de ejemplos ejecutados y
termine con código distinto de cero cuando algún ejemplo falla.

#### Scenario: Suite en verde
- **WHEN** se ejecuta el comando de pruebas sin cambios en el código y con la base de test preparada
- **THEN** reporta más de cero ejemplos, cero fallos y termina con código 0

#### Scenario: Un fallo se detecta
- **WHEN** un ejemplo de la suite falla
- **THEN** el comando de pruebas termina con código distinto de 0

#### Scenario: Sin suite paralela
- **WHEN** se inspecciona el repositorio
- **THEN** no existe una segunda suite de pruebas generada por defecto que no se ejecute con el comando documentado
