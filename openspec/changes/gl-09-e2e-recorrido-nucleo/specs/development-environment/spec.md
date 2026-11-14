## MODIFIED Requirements

### Requirement: Suite de pruebas única y efectiva
El proyecto SHALL tener una única suite de pruebas automática, ejecutable
con un solo comando, que reporte la cantidad de ejemplos ejecutados y
termine con código distinto de cero cuando algún ejemplo falla. Las
pruebas en navegador (P-4) MUST ser parte de esa suite, con Capybara y
`selenium-webdriver` sobre Chrome sin interfaz, sin Node ni un segundo
ejecutor.

#### Scenario: Suite en verde
- **WHEN** se ejecuta el comando de pruebas sin cambios en el código y con la base de test preparada
- **THEN** reporta más de cero ejemplos, cero fallos y termina con código 0

#### Scenario: Un fallo se detecta
- **WHEN** un ejemplo de la suite falla
- **THEN** el comando de pruebas termina con código distinto de 0

#### Scenario: Sin suite paralela
- **WHEN** se inspecciona el repositorio
- **THEN** no existe una segunda suite de pruebas generada por defecto que no se ejecute con el comando documentado

#### Scenario: Pruebas en navegador en la misma suite
- **WHEN** se ejecuta el comando de pruebas con Chrome instalado
- **THEN** las pruebas en navegador corren junto con las demás y cuentan en el total de ejemplos
