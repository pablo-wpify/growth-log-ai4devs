# Spec Delta

## Purpose

Fija el lenguaje y el framework sobre los que corre Growth Log, y garantiza
que su versión se declare en un único lugar del repositorio.

## ADDED Requirements

### Requirement: Versiones de Ruby y Rails del proyecto
El proyecto SHALL ejecutarse con Ruby 4.0.9 y Rails 8.1.4, las versiones
aceptadas para el ensayo.

#### Scenario: Versiones informadas en el directorio del proyecto
- **WHEN** quien desarrolla consulta, con el entorno del ensayo cargado, la versión de Ruby y la versión de Rails del proyecto
- **THEN** se informan la versión de Ruby declarada en `.ruby-version` y Rails 8.1.4

#### Scenario: Ruby distinto del declarado
- **WHEN** se instalan las dependencias o se arranca la aplicación con una versión de Ruby distinta de la declarada
- **THEN** la operación falla indicando la versión esperada

### Requirement: Fuente única de la versión de Ruby
`.ruby-version` SHALL ser la única fuente de configuración de la versión de
Ruby: el manifiesto de dependencias, el CI y el entorno local MUST leerla de
ese archivo sin escribir el número. Los archivos que generan las
herramientas, como el lockfile, MAY registrarla automáticamente.

#### Scenario: Consumidores de la versión
- **WHEN** se revisan el manifiesto de dependencias, el workflow de CI y el archivo de entorno del ensayo
- **THEN** los tres obtienen la versión de `.ruby-version` y ninguno escribe el número

#### Scenario: Metadatos generados
- **WHEN** las herramientas regeneran el lockfile u otros metadatos
- **THEN** pueden registrar la versión de Ruby, y esos archivos no se editan a mano para quitarla
