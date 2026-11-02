# Spec Delta

## MODIFIED Requirements

### Requirement: Verificación local en un solo comando
El proyecto SHALL ofrecer un comando de verificación local que ejecute, en
este orden, la revisión de estilo, la auditoría de gemas vulnerables, la
auditoría de los paquetes JavaScript fijados por importmap, el análisis
estático de seguridad, la preparación de la base de test y la suite de
tests, y MUST terminar con error si alguno falla.

#### Scenario: Todo en orden
- **WHEN** se ejecuta el comando de verificación local con el PostgreSQL local del producto disponible y sin problemas en el código
- **THEN** todos los pasos se ejecutan y el comando termina sin error

#### Scenario: Un paso falla
- **WHEN** se ejecuta el comando con una infracción de estilo o un test que falla
- **THEN** el comando termina con error e indica qué paso falló

### Requirement: Workflow de CI en cada pull request
El repositorio SHALL definir un workflow de GitHub Actions que, en cada pull
request y en cada push a `main` o a la rama de entrega
`feature/entrega-2-pp`, ejecute las mismas verificaciones que el comando
local, con un servicio `postgres:18.6` autenticado por un usuario y una
contraseña exclusivamente de prueba y la base de test preparada.

#### Scenario: Revisión local de la definición
- **WHEN** se revisa el archivo del workflow en el repositorio
- **THEN** declara el disparo por pull request y por push a `main` y a `feature/entrega-2-pp`, los mismos pasos que la verificación local, el servicio `postgres:18.6` con autenticación por contraseña, las variables `DATABASE_*` del servicio y la preparación de la base de test

#### Scenario: Ejecución en GitHub Actions
- **WHEN** se hace push a `feature/entrega-2-pp` en el repositorio del producto, `pablo-wpify/growth-log-ai4devs`, o se abre allí un pull request
- **THEN** GitHub Actions ejecuta todas las verificaciones y el resultado queda visible en la ejecución
