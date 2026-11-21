## MODIFIED Requirements

### Requirement: Guía de desarrollo reproducible
La guía de desarrollo SHALL documentar los prerrequisitos, las variables de
entorno necesarias (por nombre, sin valores) y los comandos para preparar
las bases, ejecutar la suite, ejecutar la verificación completa y comprobar
la ruta de salud. Cada comando documentado MUST funcionar tal como está
escrito desde el entorno preparado.

#### Scenario: Recorrido desde un clon limpio
- **WHEN** una persona con Ruby 4.0.10 y un PostgreSQL 18.6 accesible sigue la guía desde un clon limpio
- **THEN** cada comando documentado termina con éxito y la ruta de salud responde con estado HTTP 200

#### Scenario: Sin valores secretos
- **WHEN** se revisa la guía de desarrollo
- **THEN** nombra las variables de entorno necesarias sin incluir ninguna contraseña ni credencial
