## ADDED Requirements

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
