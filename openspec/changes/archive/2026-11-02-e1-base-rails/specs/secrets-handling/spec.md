# Spec Delta

## Purpose

Evita que claves y credenciales locales o reales queden versionadas, para
que el repositorio pueda publicarse sin exponer secretos.

## ADDED Requirements

### Requirement: Repositorio sin secretos ni credenciales locales o reales
Los archivos versionados SHALL NOT incluir la clave maestra de la
aplicación ni credenciales locales o reales. La única contraseña versionada
MUST ser la del servicio de PostgreSQL del CI, exclusivamente de prueba.

#### Scenario: Clave maestra
- **WHEN** se listan los archivos versionados y las reglas de exclusión
- **THEN** `config/master.key` no está versionada y está excluida

#### Scenario: Credenciales locales
- **WHEN** se busca en los archivos versionados la contraseña de la base local del ensayo
- **THEN** no aparece

#### Scenario: Contraseñas versionadas
- **WHEN** se buscan asignaciones de contraseñas en los archivos versionados
- **THEN** la única es la contraseña de prueba del servicio de CI, que no coincide con ninguna credencial local ni real
