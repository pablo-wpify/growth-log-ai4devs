# feedback-entries Specification

## Purpose
Define la entrada de feedback de un líder sobre una persona: sus estados
borrador y lista, las dimensiones y señales fijas, los campos opcionales,
la completitud que exige marcarla como lista y que su texto no aparezca en
los logs.

## Requirements

### Requirement: Entrada de feedback
Una entrada SHALL pertenecer a exactamente una cuenta autora y a una
persona, y SHALL tener una fecha del hecho y un contexto. La base MUST
rechazar una entrada sin autor, sin persona, sin fecha del hecho o con el
contexto vacío, y la aplicación MUST informar el error sin guardarla.

#### Scenario: Entrada sin autor o sin persona
- **WHEN** se intenta guardar una entrada sin cuenta autora o sin persona
- **THEN** la base la rechaza

#### Scenario: Entrada sin contexto
- **WHEN** se intenta guardar una entrada con el contexto vacío o solo con espacios
- **THEN** no se guarda y se informa que falta el contexto

#### Scenario: Entrada sin fecha del hecho
- **WHEN** se intenta guardar una entrada sin fecha del hecho
- **THEN** no se guarda y se informa que falta la fecha

### Requirement: Estados borrador y lista
El estado de una entrada SHALL ser borrador (`draft`) o lista (`ready`),
y la base MUST rechazar cualquier otro valor. El estado MUST NOT cambiar
quién puede leer la entrada: una entrada lista sigue siendo privada de su
autor.

#### Scenario: Estado inválido
- **WHEN** se intenta guardar una entrada con un estado distinto de `draft` o `ready`
- **THEN** la base la rechaza

#### Scenario: Entrada lista
- **WHEN** una entrada pasa a lista
- **THEN** las cuentas que pueden leerla son las mismas que cuando era borrador

### Requirement: Dimensiones fijas
La dimensión de una entrada SHALL ser opcional y, si existe, uno de estos
valores, con su etiqueta: `delivery` «Entrega», `technical_quality`
«Calidad técnica», `teamwork` «Trabajo en equipo», `communication`
«Comunicación» e `initiative` «Iniciativa» (P-1). La base MUST rechazar
cualquier otro valor. Cambiar la lista exige una migración y una decisión
registrada.

#### Scenario: Dimensión de la lista
- **WHEN** se guarda una entrada con la dimensión `teamwork`
- **THEN** se guarda y se muestra como «Trabajo en equipo»

#### Scenario: Dimensión fuera de la lista
- **WHEN** se intenta guardar una entrada con una dimensión que no está en la lista
- **THEN** la base la rechaza

### Requirement: Señales
La señal de una entrada SHALL ser opcional y, si existe, uno de estos
valores, con su etiqueta: `positive` «Positivo», `improvement` «A mejorar»
y `neutral` «Neutral» (P-2). La base MUST rechazar cualquier otro valor.

#### Scenario: Señal de la lista
- **WHEN** se guarda una entrada con la señal `improvement`
- **THEN** se guarda y se muestra como «A mejorar»

#### Scenario: Señal fuera de la lista
- **WHEN** se intenta guardar una entrada con una señal que no está en la lista
- **THEN** la base la rechaza

### Requirement: Campos opcionales
Una entrada SHALL admitir evidencia, impacto y una confianza de 1 a 5,
todos opcionales. La base MUST rechazar una confianza fuera de ese rango.

#### Scenario: Sin campos opcionales
- **WHEN** se guarda una entrada sin evidencia, impacto ni confianza
- **THEN** se guarda

#### Scenario: Confianza fuera de rango
- **WHEN** se intenta guardar una entrada con una confianza de 0 o de 6
- **THEN** la base la rechaza

### Requirement: Completitud para marcar como lista
Una entrada lista MUST tener dimensión y señal (P-3; amplía los criterios
2.6 y 3.5, que solo exigían la dimensión). Un borrador SHALL poder
guardarse sin dimensión ni señal. La base MUST rechazar una entrada lista
sin dimensión o sin señal.

#### Scenario: Borrador incompleto
- **WHEN** se guarda un borrador sin dimensión ni señal
- **THEN** se guarda como borrador

#### Scenario: Entrada lista sin señal
- **WHEN** se intenta guardar una entrada lista con dimensión y sin señal
- **THEN** la base la rechaza

#### Scenario: Entrada lista sin dimensión
- **WHEN** se intenta guardar una entrada lista con señal y sin dimensión
- **THEN** la base la rechaza

### Requirement: Texto del feedback fuera de los logs
El contexto, la evidencia y el impacto de una entrada MUST NOT aparecer en
los logs de la aplicación, ni en los parámetros de la petición ni en las
consultas a la base.

#### Scenario: Guardar una captura rápida
- **WHEN** se guarda una captura rápida con un texto
- **THEN** el log de la petición muestra el parámetro filtrado y no contiene el texto

#### Scenario: Completar una entrada
- **WHEN** se guardan la evidencia y el impacto de una entrada
- **THEN** el log no contiene ninguno de los dos textos
