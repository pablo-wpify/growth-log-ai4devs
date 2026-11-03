## ADDED Requirements

### Requirement: Asignación entre un líder y una persona
Una asignación SHALL vincular una cuenta líder con una persona, con una
fecha de inicio obligatoria. Está activa mientras no tenga fecha de fin.
La fecha de fin, si existe, MUST ser igual o posterior a la de inicio. En
este cambio las asignaciones solo se crean y terminan por procedimientos
internos; no hay interfaz para administrarlas.

#### Scenario: Asignación sin líder o sin persona
- **WHEN** se intenta guardar una asignación sin cuenta líder o sin persona
- **THEN** la base la rechaza

#### Scenario: Fin anterior al inicio
- **WHEN** se intenta guardar una asignación cuya fecha de fin es anterior a la de inicio
- **THEN** la base la rechaza

### Requirement: Una asignación activa por par líder y persona
La base SHALL rechazar una segunda asignación activa para el mismo par de
cuenta líder y persona, también cuando dos inserciones llegan a la vez. La
restricción MUST NOT limitar cuántos líderes tiene una persona ni cuántas
personas tiene un líder. Reasignar MUST crear una asignación nueva.

#### Scenario: Varios líderes de una persona
- **WHEN** dos cuentas distintas tienen cada una una asignación activa con la misma persona
- **THEN** la base acepta las dos

#### Scenario: Un líder con varias personas
- **WHEN** una cuenta tiene asignaciones activas con dos personas distintas
- **THEN** la base acepta las dos

#### Scenario: Segunda asignación activa del mismo par
- **WHEN** se intenta crear una asignación activa para un par que ya tiene una, también de forma simultánea
- **THEN** la base rechaza la segunda y queda una sola activa

#### Scenario: Reasignación
- **WHEN** se termina la asignación de un par y después se crea otra para el mismo par
- **THEN** la base acepta la nueva y la terminada se conserva

### Requirement: Estados independientes de asignación, persona y cuenta
Terminar una asignación SHALL NOT cambiar el estado de la persona ni el de
la cuenta. Desactivar una cuenta o una persona SHALL NOT terminar ni borrar
sus asignaciones.

#### Scenario: Terminar una asignación
- **WHEN** se termina una asignación
- **THEN** la persona y la cuenta líder conservan su estado

#### Scenario: Desactivar una cuenta líder
- **WHEN** se desactiva una cuenta con asignaciones activas
- **THEN** sus asignaciones se conservan sin terminar
