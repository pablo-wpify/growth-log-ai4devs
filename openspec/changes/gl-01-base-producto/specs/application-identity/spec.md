# Spec Delta

## Purpose

Fija con qué nombre se identifica la aplicación ante quien la usa y en su
propio código, para que el producto no conserve el nombre del ensayo del
que proviene.

## ADDED Requirements

### Requirement: Nombre visible de la aplicación
La aplicación SHALL presentarse como «Growth Log» en el título por defecto
de sus páginas, en su nombre de aplicación y en su manifiesto, y MUST NOT
mostrar el nombre del ensayo del que proviene.

#### Scenario: Título por defecto
- **WHEN** se carga una página que no define un título propio
- **THEN** el título es «Growth Log»

#### Scenario: Manifiesto
- **WHEN** se revisa el manifiesto de la aplicación
- **THEN** su nombre es «Growth Log» y ninguna propiedad menciona el ensayo

### Requirement: Identificador interno de la aplicación
El espacio de nombres de la aplicación SHALL ser `GrowthLog`, y los archivos
versionados MUST NOT contener el identificador del ensayo fuera de los
artefactos que documentan su procedencia.

#### Scenario: Espacio de nombres
- **WHEN** se consulta el nombre del módulo de la aplicación con el entorno cargado
- **THEN** es `GrowthLog`

#### Scenario: Sin rastros del ensayo
- **WHEN** se buscan «ensayo» y `EnsayoOpenspec` en los archivos de código, configuración y pruebas, excluyendo la documentación de la entrega 1 y los artefactos de procedencia y planificación
- **THEN** no hay resultados
