## MODIFIED Requirements

### Requirement: Textos que separan «lista» de «compartida»
Ningún texto de la interfaz de entradas MUST decir «Publicar». Los estados
SHALL mostrarse como «Borrador · solo vos» y «Lista · solo vos»; en la
cronología de la ficha, el estado de un borrador SHALL ser «Borrador ·
solo vos · fuera del resumen» (P-10). Los avisos de guardar y marcar como
lista SHALL decir que solo el autor ve la entrada.

#### Scenario: Páginas de entradas
- **WHEN** el autor recorre la ficha, la captura, el detalle y la edición
- **THEN** ninguna página contiene «Publicar» y los estados indican «solo vos»

#### Scenario: Borrador en la cronología
- **WHEN** el autor abre la ficha con un borrador propio sobre la persona
- **THEN** la cronología lo muestra como «Borrador · solo vos · fuera del resumen»

## REMOVED Requirements

### Requirement: Entradas propias en la ficha
**Reason**: Era provisoria (P-21): GL-07 la reemplaza por la cronología
de la ficha (P-10), que muestra las mismas entradas propias, en borrador y
listas, en orden ascendente y con el borrador marcado «fuera del resumen».
**Migration**: Ver el requisito «Cronología de entradas propias» de la
spec `feedback-summary`. El acceso al detalle de cada entrada propia desde
la ficha se conserva.
