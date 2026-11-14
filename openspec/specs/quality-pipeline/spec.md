# quality-pipeline Specification

## Purpose
Define las verificaciones automáticas de estilo, seguridad y tests que
protegen cada cambio, tanto en la máquina de quien desarrolla como en el CI
de GitHub.

## Requirements

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

### Requirement: Recorrido núcleo en navegador
La suite SHALL incluir una prueba en un navegador real (Chrome sin
interfaz) en la que un líder inicia sesión, elige una persona asignada,
guarda una captura rápida, la completa con señal y dimensión, la marca
como lista y la ve en el resumen y en la cronología de la ficha. MUST
correr con el comando de pruebas, en la verificación local y en el CI.

#### Scenario: Recorrido completo
- **WHEN** un líder asignado a una persona hace el recorrido en el navegador
- **THEN** después de guardar, la cronología muestra el borrador «fuera del resumen» y el resumen no lo cuenta; después de marcarla como lista, el resumen la cuenta en su dimensión y su señal y la cronología la muestra «Lista · solo vos»

#### Scenario: Una pieza del recorrido se rompe
- **WHEN** marcar como lista deja de cambiar el estado de la entrada
- **THEN** la prueba del recorrido falla

### Requirement: Rama negativa de privacidad en navegador
La suite SHALL incluir una prueba en navegador en la que otro líder
asignado a la misma persona inicia sesión y abre la ficha y, por URL
directa, el detalle de las entradas de un primer líder. Ni el resumen ni
la cronología MUST mostrar esas entradas, y el detalle MUST responder la
página de no encontrado, sin su texto (4.11, PP-3, PP-4).

#### Scenario: Ficha del otro líder
- **WHEN** un primer líder tiene una entrada lista y un borrador sobre una persona que también acompaña un segundo líder, y el segundo abre su ficha en el navegador
- **THEN** el resumen y la cronología no muestran ninguna de las dos y la página no contiene su texto

#### Scenario: URL directa
- **WHEN** el segundo líder abre en el navegador la URL del detalle de cada entrada del primero
- **THEN** ve la página de no encontrado, sin el texto de la entrada

#### Scenario: Una consulta pierde el alcance
- **WHEN** la cronología, el resumen o el detalle leen entradas sin el alcance de la cuenta
- **THEN** la prueba de la rama negativa falla
