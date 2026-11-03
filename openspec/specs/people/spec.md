# people Specification

## Purpose
Define las personas acompañadas: sus datos y su estado activo,
independiente de sus asignaciones y de las cuentas de sus líderes.

## Requirements

### Requirement: Persona acompañada
La aplicación SHALL registrar cada persona acompañada con un nombre
obligatorio y, de forma opcional, su rol y su equipo. En este cambio las
personas solo se crean por procedimientos internos; no hay interfaz para
crearlas ni editarlas.

#### Scenario: Persona sin nombre
- **WHEN** se intenta guardar una persona sin nombre
- **THEN** no se guarda

#### Scenario: Persona con rol y equipo
- **WHEN** se guarda una persona con nombre, rol y equipo
- **THEN** se conservan los tres datos

### Requirement: Estado activo de la persona
Una persona SHALL estar activa al crearse. Su estado activo MUST ser
independiente de sus asignaciones y de las cuentas de sus líderes:
desactivarla no termina ni borra sus asignaciones y no borra a la persona.

#### Scenario: Persona nueva
- **WHEN** se crea una persona sin indicar su estado
- **THEN** queda activa

#### Scenario: Desactivar una persona
- **WHEN** se desactiva una persona que tiene asignaciones activas
- **THEN** la persona se conserva y sus asignaciones siguen sin terminar
