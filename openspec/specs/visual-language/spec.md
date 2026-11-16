# visual-language Specification

## Purpose
Define el lenguaje visual común de la interfaz de Growth Log: tokens,
contraste y foco, textos de estado, señal y origen, cabecera, pantallas
angostas y recursos propios. Es comprobable sin cambiar el
comportamiento, las acciones ni los textos existentes (GL-13).

## Requirements

### Requirement: Tokens visuales en un solo lugar
Los colores, las tipografías, los radios y los espaciados de la interfaz
SHALL definirse como propiedades personalizadas en `:root` de
`app/assets/stylesheets/application.css` y las reglas SHALL usarlas por
nombre. Las vistas MUST NOT llevar estilos en línea ni colores literales.

#### Scenario: Cambiar un color de la paleta
- **WHEN** se cambia el valor de un token de color en `:root`
- **THEN** cambian todos los elementos que lo usan, sin editar vistas ni otras reglas

#### Scenario: Vistas sin estilos propios
- **WHEN** se revisan las vistas de la aplicación
- **THEN** ninguna tiene atributos `style` ni colores escritos en la vista

### Requirement: Contraste y foco
Todo texto SHALL tener un contraste de al menos 4,5:1 con su fondo. Los
bordes de los campos de formulario y el indicador de foco SHALL tener al
menos 3:1 con el fondo adyacente. Todo elemento interactivo SHALL mostrar
un foco visible al recibirlo con el teclado.

#### Scenario: Texto sobre los fondos de la paleta
- **WHEN** se calcula el contraste de cada combinación de texto y fondo que usa la hoja
- **THEN** cada una tiene al menos 4,5:1

#### Scenario: Campo de formulario
- **WHEN** se abre la captura rápida o la edición de una entrada
- **THEN** el borde de cada campo tiene al menos 3:1 con el fondo del formulario, y al recibir el foco por teclado muestra un contorno de al menos 3:1

### Requirement: Estado, señal y origen siempre en texto
El estado de una entrada, su señal, su dimensión y, cuando exista, su
origen SHALL leerse en texto. El color, el borde o el ícono MAY
reforzarlos, pero MUST NOT ser la única forma de distinguirlos.

#### Scenario: Entrada lista en la cronología
- **WHEN** un líder abre la ficha de una persona con una entrada lista positiva en «Trabajo en equipo»
- **THEN** la cronología muestra en texto «Lista · solo vos», «Positivo» y «Trabajo en equipo», aunque se quiten los colores de la hoja

### Requirement: Borrador distinguible de una entrada lista
En la cronología, un borrador SHALL distinguirse a simple vista de una
entrada lista, con un tratamiento visual propio además de su texto de
estado. Una entrada lista que no se compartió MUST NOT presentarse como
borrador ni como compartida.

#### Scenario: Borrador y entrada lista juntos
- **WHEN** un líder con un borrador y una entrada lista sobre una persona abre su ficha
- **THEN** el borrador tiene un contenedor con un tratamiento distinto del de la entrada lista y muestra «Borrador · solo vos · fuera del resumen», y la entrada lista muestra «Lista · solo vos»

### Requirement: El resumen no se presenta como puntaje
El resumen por dimensión SHALL mostrarse como una tabla de conteos, junto
con la aclaración de que no es un puntaje. MUST NOT agregar barras,
porcentajes, promedios, semáforos por fila, rankings ni cualquier otra
forma visual de calificación.

#### Scenario: Resumen con entradas listas
- **WHEN** un líder con entradas listas sobre una persona abre su ficha
- **THEN** el resumen muestra solo los conteos por dimensión y la aclaración, sin barras, porcentajes ni colores que califiquen una fila

### Requirement: Cabecera superior
La navegación con sesión SHALL ser una cabecera en la parte superior de
la página, con el nombre de la aplicación a la izquierda y los destinos
principales que existan. El destino actual SHALL marcarse con
`aria-current="page"` y con un tratamiento visual que no dependa solo del
color. La cabecera MUST NOT mostrar destinos de funciones que todavía no
existen.

#### Scenario: Cabecera en «Personas»
- **WHEN** un líder abre el listado «Personas»
- **THEN** la cabecera está arriba, muestra «Growth Log», «Personas» marcado como destino actual, su nombre y «Cerrar sesión», y no muestra «Feedback» ni «Administración»

### Requirement: Pantallas angostas
A 375 px de ancho, toda página con sesión SHALL verse sin desplazamiento
horizontal de la página. Las tablas SHALL desplazarse dentro de su propia
caja. Los enlaces y los botones de la navegación y de las acciones SHALL
medir al menos 44 px de alto.

#### Scenario: Ficha a 375 px
- **WHEN** un líder abre una ficha con resumen y cronología en una ventana de 375 px de ancho
- **THEN** la página no se desplaza en horizontal, la cabecera ocupa dos líneas como máximo y «Captura rápida» mide al menos 44 px de alto

### Requirement: Sin recursos de terceros
Las hojas de estilo, las tipografías y los íconos SHALL servirse desde la
propia aplicación. La interfaz MUST NOT cargar recursos de dominios de
terceros.

#### Scenario: Carga de una página con sesión
- **WHEN** se abre la ficha de una persona
- **THEN** todos los recursos de estilo, tipografía e íconos que pide la página son del mismo origen

### Requirement: La presentación no cambia el comportamiento
Aplicar el lenguaje visual MUST NOT, por sí solo, cambiar rutas,
formularios, acciones, textos existentes, reglas de autorización ni el
orden de la cronología. Un cambio de comportamiento SHALL venir de un
requisito explícito de la capability afectada. La única excepción de
este cambio es el aviso breve de privacidad de la ficha, que exige el
requisito «Aviso de privacidad en la ficha» de `people-browsing`. Tampoco
MUST agregar acciones ni textos que anuncien funciones que todavía no
existen.

#### Scenario: Ficha antes y después
- **WHEN** se compara la ficha antes y después de aplicar el lenguaje visual
- **THEN** tiene las mismas acciones, los mismos textos existentes, incluidos los exigidos por `people-browsing`, `feedback-capture` y `feedback-summary`, y el mismo orden de la cronología, y el único texto nuevo es el aviso breve de privacidad
