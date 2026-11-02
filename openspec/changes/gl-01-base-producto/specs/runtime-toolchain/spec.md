# Spec Delta

## RENAMED Requirements

- FROM: `### Requirement: Fuente única de la versión de Ruby`
- TO: `### Requirement: Declaración coherente de la versión de Ruby`

## MODIFIED Requirements

### Requirement: Versiones de Ruby y Rails del proyecto
El proyecto SHALL ejecutarse con Ruby 4.0.9 y Rails 8.1.4, las versiones
aprobadas para el producto al adoptar la base del ensayo E1.

#### Scenario: Versiones informadas en el directorio del proyecto
- **WHEN** quien desarrolla consulta, en el directorio del proyecto y sin variables que fuercen otra versión, la versión de Ruby y la versión de Rails
- **THEN** se informan Ruby 4.0.9, declarada en `.tool-versions` y `.ruby-version`, y Rails 8.1.4

#### Scenario: Ruby distinto del declarado
- **WHEN** se instalan las dependencias o se arranca la aplicación con una versión de Ruby distinta de la declarada
- **THEN** la operación falla indicando la versión esperada

### Requirement: Declaración coherente de la versión de Ruby
`.ruby-version` y `.tool-versions` SHALL declarar la misma versión de Ruby.
El manifiesto de dependencias MUST leerla de `.ruby-version` sin escribir
el número, y el CI MUST obtenerla de `.ruby-version` o declarar esa misma
versión. Los archivos que generan las herramientas, como el lockfile, MAY
registrarla automáticamente.

#### Scenario: Archivos de versión coherentes
- **WHEN** se comparan la versión de Ruby de `.tool-versions` y la de `.ruby-version`
- **THEN** ambas indican `4.0.9`

#### Scenario: Consumidores de la versión
- **WHEN** se revisan el manifiesto de dependencias y cada preparación de Ruby del workflow de CI
- **THEN** el manifiesto toma la versión de `.ruby-version` sin escribir el número, y el CI la toma de `.ruby-version` o declara la misma versión

#### Scenario: Metadatos generados
- **WHEN** las herramientas regeneran el lockfile u otros metadatos
- **THEN** pueden registrar la versión de Ruby, y esos archivos no se editan a mano para quitarla

#### Scenario: Lockfile coherente
- **WHEN** se compara la versión de Ruby registrada en el lockfile con la de `.ruby-version`
- **THEN** ambas coinciden

#### Scenario: Ruby rechazado al cargar las dependencias
- **WHEN** se cargan las dependencias del proyecto con una versión de Ruby distinta de la declarada
- **THEN** la carga falla con un error que indica la discrepancia de versión, aunque el intérprete por sí solo haya arrancado
