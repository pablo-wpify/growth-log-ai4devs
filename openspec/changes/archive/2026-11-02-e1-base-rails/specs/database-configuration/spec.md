# Spec Delta

## Purpose

Define cómo la aplicación se conecta a PostgreSQL, cómo se preparan las
bases de desarrollo y de test, qué comprueba que la conexión es real y cómo
se limitan los seeds a desarrollo.

## ADDED Requirements

### Requirement: Conexión configurada por variables de entorno
La aplicación SHALL obtener el host, el puerto, el usuario y la contraseña
de PostgreSQL de `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USERNAME` y
`DATABASE_PASSWORD`, con los mismos nombres en local y en el CI, y MUST NOT
leer credenciales locales o reales de archivos del repositorio.

#### Scenario: Variables de entorno presentes
- **WHEN** las cuatro variables apuntan al PostgreSQL del ensayo
- **THEN** la aplicación se conecta a ese servidor con autenticación por contraseña

#### Scenario: Contraseña ausente
- **WHEN** falta `DATABASE_PASSWORD`
- **THEN** la conexión falla con un error de autenticación y no se usa ninguna credencial guardada en el repositorio

### Requirement: Preparación explícita de las bases de desarrollo y de test
En local, la preparación SHALL crear o actualizar `growth_log_ensayo_development`
y `growth_log_ensayo_test` en PostgreSQL 18.6; en el CI, solo la base de
test. La preparación MUST poder repetirse sin errores ni pérdida de
estructura.

#### Scenario: Primera preparación
- **WHEN** se prepara la base de desarrollo y luego la de test sobre un servidor sin esas bases
- **THEN** ambas bases existen en el servidor del ensayo

#### Scenario: Preparación repetida
- **WHEN** se vuelve a preparar cualquiera de las dos bases
- **THEN** la operación termina sin errores y la base conserva su estructura

#### Scenario: Preparación en el CI
- **WHEN** el job de tests del CI prepara la base
- **THEN** prepara solo la base de test sobre el servicio de PostgreSQL del job

### Requirement: Consulta real a PostgreSQL en el entorno de test
La suite automatizada SHALL incluir una comprobación que ejecute una
consulta real contra la base de test y verifique que el servidor es
PostgreSQL de versión mayor 18, sin modelos del dominio.

#### Scenario: Base de test disponible
- **WHEN** la suite se ejecuta con la base de test preparada
- **THEN** la comprobación obtiene una respuesta del servidor e informa PostgreSQL con versión mayor 18

#### Scenario: Servidor inaccesible
- **WHEN** la suite se ejecuta sin acceso al servidor de PostgreSQL
- **THEN** la comprobación falla; no se omite ni se da por aprobada

### Requirement: Creación de datos de seeds limitada a desarrollo
La carga de seeds SHALL invocar la parte que crea datos solo en el entorno
de desarrollo; en cualquier otro entorno MUST terminar sin invocarla.

#### Scenario: Seeds fuera de desarrollo
- **WHEN** se cargan los seeds en el entorno de test
- **THEN** la parte que crea datos no se invoca

#### Scenario: Seeds en desarrollo
- **WHEN** se cargan los seeds con el entorno de desarrollo
- **THEN** la parte que crea datos se invoca exactamente una vez
