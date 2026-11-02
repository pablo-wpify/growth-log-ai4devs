# Spec Delta

## Purpose

Ofrece un chequeo de salud que indica si la aplicación arrancó
correctamente, para usarlo en el desarrollo, el CI y un futuro despliegue.

## ADDED Requirements

### Requirement: Chequeo de salud en GET /up
La aplicación SHALL responder `GET /up` con el estado HTTP 200 cuando
arrancó sin errores, sin exigir sesión ni exponer datos de la aplicación.

#### Scenario: Aplicación arrancada
- **WHEN** se hace `GET /up` a la aplicación en ejecución
- **THEN** la respuesta tiene estado 200 y no contiene datos de la aplicación

#### Scenario: Comprobación automatizada
- **WHEN** se ejecuta la suite automatizada
- **THEN** una prueba de petición hace `GET /up` y espera el estado 200

#### Scenario: Chequeo de salud alterado
- **WHEN** la ruta `/up` o su respuesta dejan de comportarse como se especifica
- **THEN** la prueba de petición falla, sin que se haya cambiado su expectativa
