## MODIFIED Requirements

### Requirement: Versiones de Ruby y Rails del proyecto
El proyecto SHALL ejecutarse con Ruby 4.0.9 y Rails 8.1.4.1: Ruby, la
versión aprobada al adoptar la base del ensayo E1; Rails, la serie 8.1.4
con la corrección de seguridad del 04/11/2026 (GL-01b). El `Gemfile`
admite la serie con `~> 8.1.4` (P-18) y el lockfile MUST fijar 8.1.4.1.

#### Scenario: Versiones informadas en el directorio del proyecto
- **WHEN** quien desarrolla consulta, en el directorio del proyecto y sin variables que fuercen otra versión, la versión de Ruby y la versión de Rails
- **THEN** se informan Ruby 4.0.9, declarada en `.tool-versions` y `.ruby-version`, y Rails 8.1.4.1

#### Scenario: Ruby distinto del declarado
- **WHEN** se instalan las dependencias o se arranca la aplicación con una versión de Ruby distinta de la declarada
- **THEN** la operación falla indicando la versión esperada
