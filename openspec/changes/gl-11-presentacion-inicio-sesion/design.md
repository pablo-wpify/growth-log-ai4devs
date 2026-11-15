# Design

> **Implementado en local (M240, 15/11/2026), sin commit.** P-32 y P-33
> aprobadas por Pablo en M240. El gate está bloqueado por avisos de gemas
> ajenos a GL-11 (ver el registro). Historia: borrador de M236, revisado en
> M238 y ajustado en M239. Fuente:
> `docs/tickets/GL-11-presentacion-inicio-sesion.md`.

## Context

- **Evidencia visual de Pablo (M236):** la ficha de una persona y la
  navegación con sesión se ven coherentes, pero en `/session/new` el
  formulario se ve casi sin formato.
- **Comprobado en el código (`6177aef`, 15/11/2026):**
  - `app/views/layouts/application.html.erb` incluye la hoja global en
    todas las páginas. El título, la tipografía y el botón de la página de
    login ya toman sus estilos, así que la carga del CSS no falló.
  - `app/views/sessions/new.html.erb` no tiene clases: el formulario, sus
    `div` y el aviso `role="alert"` no llevan ninguna.
  - `app/assets/stylesheets/application.css` da estilo a los campos solo
    dentro de `.entry-form` (`textarea`, `select` e `input[type="date"]`).
    Los `input` de correo y contraseña quedan con el aspecto del
    navegador, y la etiqueta y el campo quedan en línea.
  - El foco visible ya es global (`input:focus-visible` y
    `button:focus-visible`) y el botón ya tiene 44 px, en ambos casos por
    `application.css`.
- **Sin mock aprobado:** el Anexo E no tiene un mock del login. La
  referencia son las pantallas internas (P-32, aprobada en M240).
- **La spec `authentication`** fija el mensaje genérico, los estados y los
  límites; `people-browsing` fija que la página no muestre la cabecera.
  Ninguna cambia.

## Goals / Non-Goals

**Goals:**

- Que el login siga el lenguaje visual de las pantallas internas, con el
  resultado medible de la capability `sign-in-presentation`.
- Reutilizar los tokens y patrones existentes, sin duplicarlos de más.

**Non-Goals:**

- Cambiar autenticación, sesiones, límites, mensajes, rutas, CSRF o
  privacidad.
- Rediseñar otras pantallas, agregar un framework de CSS o JavaScript.
- Diseñar un mock del login.

## Decisions

### 1. Capability nueva y separada: `sign-in-presentation`

No hay una capability de interfaz general. `people-browsing` trata las
páginas con sesión y `authentication` el comportamiento. Agregar
requisitos visuales a `authentication` mezclaría presentación con
seguridad, y el pedido excluye cambiar sus requisitos. Una capability
pequeña deja el resultado visual comprobable sin tocar las otras.

### 2. Referencia: las pantallas internas (P-32, aprobada en M240)

Sin un mock aprobado, se toma como referencia `.entry-form` y
`.error-summary`: etiqueta en bloque y en negrita, campos con
`var(--border)`, radio de 0,375 rem, 44 px de alto y la tipografía
heredada. Pablo aprobó P-32 en M240, en forma explícita y separada de la
autorización para implementar.

### 3. Estructura de la vista

- Una clase propia del formulario (por ejemplo, `sign-in-form`) y una
  clase por grupo de etiqueta y campo (`field`), sin cambiar los helpers,
  los nombres, los atributos ni el orden de los campos.
- El aviso conserva `role="alert"`, su texto y su lugar antes del
  formulario, y toma la clase `error-summary` existente: borde rojo con
  barra izquierda de 4 px, que no depende solo del color.

**Alternativa:** reutilizar `.entry-form` en el login. Se descarta porque
esa clase pertenece a las entradas de GL-06 y su `select` y su fecha no
aplican. Se prefiere una regla que agrupe ambos selectores para los
campos, o una regla corta propia, con los mismos valores. Si se agrupan
selectores con `.entry-form`, se comprueba que los estilos calculados de
las pantallas internas no cambien (ver «Verificación»).

### 4. Estilos en `application.css`

- Etiquetas `display: block`, en negrita y con 0,25 rem de separación.
- `input[type="email"]` e `input[type="password"]` del formulario con
  `width: 100%`, `min-height: 44px`, 0,5 rem de relleno, `var(--border)`,
  radio de 0,375 rem y `font: inherit`. Con el `box-sizing: border-box`
  global no desbordan a 375 px.
- Grupos con `margin: 0 0 1rem`.
- **Ancho del formulario (P-33, aprobada en M240):**
  `max-width: 24rem` con `width: 100%`. Cuando el contenedor de 48 rem
  mide más de 24 rem, el formulario mide 24 rem y los campos no se estiran
  en escritorio. En pantallas menores el ancho es fluido y ocupa todo el
  contenedor. La alternativa es usar todo el contenedor, como
  `.entry-form`. El requisito «Ancho máximo del formulario» de la spec
  expresa lo aprobado.
- **Botón:** debajo de la contraseña, alineado con el borde izquierdo de
  los campos, con el estilo común de `button, input[type="submit"]`.
- Sin estilos en línea, por la CSP.

### 5. Errores sin señalar un campo

El mensaje es genérico por `authentication` («Fallo de inicio de sesión
sin revelar la causa»). La presentación no agrega `aria-invalid`,
`aria-describedby` hacia el aviso ni un estilo de error en un campo, para
no sugerir cuál falló. El anuncio accesible sigue a cargo de
`role="alert"`.

## Verificación (al implementar)

- **Pruebas primero:**
  - Prueba de peticiones: etiquetas con `for` igual al `id` del campo;
    aviso con `role="alert"` y `error-summary` antes del formulario, en el
    fallo y en el 429; sin `aria-invalid`; atributos de los campos sin
    cambios.
  - Prueba en navegador a 1280 px y a 375 px:
    - cada etiqueta queda encima de su campo, por posición;
    - los campos miden al menos 44 px de alto y tienen el mismo ancho, y
      su borde, radio y tipografía calculados coinciden con los del campo
      de la captura rápida;
    - el botón queda debajo de la contraseña, con el mismo borde izquierdo
      que los campos y al menos 44 px de alto;
    - a 1280 px el formulario mide 24 rem; a 375 px ocupa el ancho del
      contenedor (si P-33 se decide así);
    - `scrollWidth` del documento no supera el ancho de la ventana, también
      con un aviso;
    - **foco:** al cargar, el elemento activo es el campo de correo por
      `autofocus`, sin pulsar ninguna tecla. Su contorno calculado es
      `solid`, de 3 px, con el color de `--focus` y 2 px de
      `outline-offset`. Después de Tab y otra vez Tab, la contraseña y el
      botón muestran los mismos valores.
  - Verlas fallar por la razón esperada antes de cambiar la vista.
- **Sin modificar** las pruebas existentes de `authentication`,
  `navigation`, CSRF ni el E2E.
- **Pantallas internas sin cambios de estilo:**
  - antes de tocar la hoja, registrar los estilos calculados de los
    campos, etiquetas, botones y resumen de errores de la captura rápida y
    de la edición de una entrada, a 1280 px y a 375 px;
  - después del cambio, comprobar que son iguales;
  - además, compararlas a la vista en la comprobación manual.
- `bin/ci` con código 0 y el CI remoto con enlace y SHA.
- **Comprobación manual de Pablo** en local a 1280 px y a 375 px. En
  Render, solo tras un deploy manual autorizado aparte.

### Registro de la implementación (15/11/2026, local, sin commit)

Autorizada en M240, con P-32 y P-33 aprobadas en el mismo pedido.

**Referencia de las pantallas internas (tarea 1.3).** Antes de tocar la
hoja se registraron, con una herramienta no versionada en `tmp/gl11/`, los
estilos calculados de 19 selectores de la captura rápida y de la edición
de una entrada, con y sin errores, a 1280 y a 375 px. Se comprobó que el
viewport medía de verdad 375 px: la cabecera mide 375 px y el texto, 343 px.

**Pruebas primero:**

- `spec/requests/sign_in_presentation_spec.rb` (6 ejemplos) y
  `spec/system/sign_in_presentation_spec.rb` (9 ejemplos).
- Con la vista y la hoja originales fallaron 13 de 15, por la razón
  esperada: no estaban `sign-in-form`, `.field` ni `error-summary`, las
  etiquetas quedaban en línea y a 375 px había desplazamiento horizontal.
- Las 2 que pasaban son de conservación: atributos de los campos; sin
  estilos en línea ni cabecera.
- El contorno de foco del correo y la contraseña ya cumplía por la regla
  global; esa prueba falló en el botón, porque no había `.sign-in-form`.
- **Desvío:** una aserción de la prueba de peticiones usaba `:has`, que
  Nokogiri no admite, y otra volvía a parsear el documento en cada
  llamada. Se corrigieron después de implementar. Para confirmar la razón
  del fallo se repitió la corrida contra la vista y la hoja originales,
  restauradas desde una copia: 13 de 15 fallaron. Después se volvió a la
  versión nueva y se comprobó con `cmp`.

**Implementación:**

- `app/views/sessions/new.html.erb`:
  - clase `sign-in-form` en el formulario y `field` en cada grupo;
  - clase `error-summary` en el aviso, que conserva `role="alert"`, su
    texto y su lugar;
  - sin cambios en los helpers, los nombres, los atributos ni el orden.
- `app/assets/stylesheets/application.css`: una sección nueva, toda dentro
  de `.sign-in-form`, con `max-width: 24rem` y `width: 100%`, etiquetas en
  bloque y campos de correo y contraseña con los valores de `.entry-form`.
- **Desvío respecto de la preferencia del diseño:** no se agruparon
  selectores con `.entry-form`. Se usó una regla corta propia, como
  permitía la decisión 3, para no tocar ninguna regla existente (M240:
  evitar selectores que alteren otros formularios).

**Mutaciones**, restauradas y comprobadas con `cmp`. Todas fueron
detectadas:

| # | Mutación | Resultado |
|---|---|---|
| M1 | sin `max-width` | 1 fallo (escritorio, P-33) |
| M2 | aviso sin `error-summary` | 4 fallos |
| M3 | `aria-invalid` en la contraseña tras un fallo | 2 fallos |

**Verificación:**

- Pruebas nuevas: 15 de 15.
- Estilos de las pantallas internas: los JSON de antes y después son
  idénticos byte a byte (tarea 3.1b).
- Capturas a 1280 y 375 px, sin y con el aviso, revisadas por el agente:
  etiquetas encima de los campos, campos de 24 rem en escritorio y del
  ancho del contenedor a 375 px, botón debajo y alineado, foco visible en
  el correo y aviso con barra roja. Quedan como evidencia local, no
  versionada.
- **Gate:**
  - `bin/bundler-audit update` terminó con código 0.
  - `bin/ci` terminó con **código 1**, solo por la auditoría de gemas.
    Hay avisos nuevos en `msgpack` 1.8.6 (CVE-2026-126366, alta) y en
    `puma` 8.0.2 (siete GHSA). `Gemfile.lock` no cambió y el CI del merge
    `6177aef` había pasado, así que los avisos se publicaron después y no
    los introduce GL-11.
  - En el mismo `bin/ci` pasaron RuboCop (120 archivos, sin ofensas),
    Importmap, Brakeman (0 avisos) y RSpec (383 ejemplos, 0 fallos).
  - Actualizar gemas queda fuera de este cambio.

**Pendiente:**

- el gate en código 0, que requiere una decisión de Pablo sobre los avisos
  de `msgpack` y `puma`; afectan también a la demo de GL-10, que usa Puma;
- la comprobación manual de Pablo (3.3);
- el commit, el CI remoto, el merge, el deploy y el archivo, cada uno con
  su autorización.

**Gate desbloqueado (M242, 15/11/2026):** con GL-12 (`msgpack` 1.8.7 y
`puma` 8.0.3) en el árbol, `bin/bundler-audit update` y `bin/ci`
terminaron con código 0: auditoría sin vulnerabilidades, Brakeman con 0
avisos y RSpec con 383 ejemplos y 0 fallos (tarea 3.2).

**Observación para Pablo, sin cambio:** a 1280 px el aviso ocupa el ancho
del contenedor (48 rem) y el formulario, 24 rem. La spec no lo fija. Si se
prefiere el aviso del mismo ancho que el formulario, es un ajuste aparte.

## Risks / Trade-offs

- **Sin mock:** el juicio estético depende de Pablo; las pruebas comprueban
  propiedades medibles, no la estética.
- **Fragilidad de la prueba en navegador:** medir posiciones depende del
  tamaño de la ventana. Se fijan los tamaños y se comparan relaciones
  (encima, dentro), no píxeles exactos.
- **Duplicar estilos:** si se copian las reglas de `.entry-form`, divergen
  con el tiempo. Se prefiere agrupar selectores.

## Migration Plan

Sin migraciones ni datos. El cambio se revierte con el commit.

## Open Questions

- ~~P-32~~ Aprobada en M240: las pantallas internas existentes, sin mock
  nuevo.
- ~~P-33~~ Aprobada en M240: `max-width: 24rem` en escritorio y ancho
  fluido en pantallas más estrechas.

Las dos se decidieron en forma explícita, por separado de la autorización
para implementar (también en M240).
