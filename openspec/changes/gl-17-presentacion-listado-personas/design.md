# Design

> **Borrador documental (M408, 21/11/2026), corregido en M410 y revisado
> por Pablo en M415.** `openspec validate --all --strict`: 22 de 22
> (M410, tarea 0.2). P-54 y P-55 están aprobadas (tarea 0.3, M415;
> `docs/plan-entrega-final.md`, sección 5.4). **Implementado en local el
> 21/11/2026 (M417),** con la autorización de Pablo para los grupos 1 a 3
> (tarea 0.4): `bin/ci` en código 0 con 471 ejemplos; sin commit.
> **Conformidad visual de Pablo el 22/11/2026 (M420, tarea 3.2).** Falta
> publicar y archivar, con autorización para cada paso.

## Context

Ver proposal.md, «Why». Fuentes de este diseño:

| Fuente | Uso |
|---|---|
| Auditoría de M407 con Impeccable (registro en `docs/prompts/revision-ui-entrega-final/`) | hallazgos priorizados, contrastes y alcance de la revisión |
| Capturas de M395 a 1280 y 375 px, con datos ficticios, fuera del repositorio | estado visual de la pantalla en `ca2d5da`. El código de `app/` no cambió desde entonces; la captura sin resultados es anterior al ajuste que oculta la lista vacía |
| Proyecto privado de Stitch «Growth Log · Personas (exploración M404/M405)», ID `2213536355539089131` | **referencia de exploración**, no especificación. Se conserva por pedido de Pablo (M408) |
| Specs vigentes `people-browsing`, `feedback-capture` y `visual-language` | lo que el cambio respeta: textos, 44 px, foco, tokens, botón común y «Listado en pantalla angosta» |
| Cambio archivado `2026-11-21-gl-14-mejoras-listado-personas` | decisiones 1 y P-45 (fila de enlace completo y acción independiente) y el esquema de la sección 4.4, que ya ponía los detalles a la derecha |

**Estado actual en `63b86d0`:**

- `people/index.html.erb` muestra el total y el aviso en un solo párrafo
  (`.people-summary`), con un «·» oculto a lectores de pantalla.
- La fila es una grilla de una columna más el chevron: nombre, «rol ·
  equipo» y `.person-details` uno debajo del otro, en todos los anchos.
- «Registrar la primera» es un enlace de texto azul de 44 px
  (`.person-first-entry`), con `z-index` por encima del pseudoelemento
  que extiende el enlace de la fila.

**Restricciones:** sin tokens nuevos (`visual-language`, «Tokens
visuales en un solo lugar»); sin `style` en las vistas; contraste de
4,5:1 en el texto y de 3:1 en los bordes; 44 px; los selects siguen
apilados a 375 px.

## Goals / Non-Goals

**Goals:**

- Dos líneas para el total y el aviso, sin cambiar sus textos.
- Una acción «Registrar la primera» reconocible como propia, sin agrandar
  la fila más de lo necesario.
- Aprovechar el ancho desde 40 rem, como el esquema de GL-14.

**Non-Goals:**

- Selects en una fila a 375 px (requiere revisar «Listado en pantalla
  angosta»).
- Separar la acción del área de toque de la fila con otra estructura: la
  fila de enlace completo es la decisión 1 de GL-14.
- Contraste de la píldora y de los separadores (P3 decorativo).
- El listado que empieza bajo en móvil y el quiebre de la cabecera entre
  unos 600 y 767 px (M411): hallazgos separados, fuera de GL-17 (M415).
- Cualquier cambio en la cabecera, la ficha o el estado vacío.

## Decisions

### D1. Total y aviso en dos elementos de bloque (P-54)

El total y el aviso pasan a ser dos líneas del mismo bloque discreto, sin
el «·». Se conserva `data-people-total` para las pruebas y el aviso sigue
con su texto exacto.

- *Alternativa descartada:* mantener la línea única y dejar que el
  navegador la parta. Es el problema que se resuelve.
- *Alternativa descartada:* mover el aviso al pie de la lista. Lo aleja
  del total, y P-53 lo pide bajo el título.

### D2. «Registrar la primera» con el botón común en una variante compacta (P-55)

Se reutiliza el botón común de `visual-language` (`.button`: borde
`--field-border` de 4,27:1 contra la superficie, fondo `--surface`, texto
`--text`), con una variante compacta del listado: texto de 0,875 rem y
menos relleno horizontal. El alto mínimo de 44 px se conserva. El enlace
sigue siendo hermano del de la fila, con `z-index` por encima, el mismo
`aria-label` y el mismo destino.

- *Alternativa descartada:* el botón a todo el ancho, debajo de una línea
  punteada, que propuso Stitch. Separa bien el toque, pero agranda la
  fila y compite como acción principal.
- *Alternativa descartada:* botón principal terracota. El acento se
  reserva para el foco y las acciones principales, y destacaría a las
  personas sin entradas sobre las demás.
- *Alternativa descartada:* dejar el enlace de texto. Es el hallazgo de
  M407.

### D3. Detalles a la derecha desde 40 rem (P-55)

Desde 40 rem, la grilla de la fila pasa a tres columnas: nombre y «rol ·
equipo» a la izquierda, `.person-details` en el centro y el chevron a la
derecha. El orden del DOM no cambia, así que el orden de foco tampoco.
Los detalles se alinean al final de la columna y se permite que partan en
dos renglones. Más angosto queda la grilla actual. El punto de corte es
el mismo que el de los controles (40 rem), y se aplica al ancho de la
ventana. En una media query, rem toma el tamaño de letra inicial del
navegador, 16 px por defecto, así que el corte cae en 640 px: a 640 px
los detalles van a la derecha y a 639 px, debajo. Las pruebas comprueban
los dos lados del corte, además de 1280 y 375 px. Los selects siguen
apilados por debajo de 40 rem, como hoy.

- *Alternativa descartada:* 48 rem o más. A 1280 px el contenedor mide
  unos 46 rem, así que el escritorio quedaría como hoy.

### D4. Esquema (propuesta, no es una captura)

```
Personas
4 personas que acompañás
Ves solo a quienes tenés asignados y las entradas que podés ver
[Buscar por nombre       ] [Equipo: Todos ▾] [Orden: Nombre ▾]
┌───────────────────────────────────────────────────────────────────┐
│ Ada Ejemplo                    Último hecho: 20/05/2026         › │
│ Desarrolladora · Equipo Faro   2 entradas listas · 1 borrador     │
├───────────────────────────────────────────────────────────────────┤
│ Carla Muestra                  Sin entradas todavía               │
│ Analista · Equipo Faro         ┌─────────────────────┐          › │
│                                │ Registrar la primera │            │
│                                └─────────────────────┘            │
└───────────────────────────────────────────────────────────────────┘

A 375 px: igual que hoy (una columna, controles apilados), con el total
y el aviso en dos líneas y la acción con borde debajo del conteo.
```

## Risks / Trade-offs

- [Toques imprecisos que siguen abriendo la ficha] → El borde marca el
  objetivo; el resto de la fila sigue siendo el enlace por la decisión 1
  de GL-14. Se revisa en la conformidad visual a 375 px. **Límite
  aceptado por Pablo (M415):** P-55 mejora la señal visual, pero no
  elimina que un toque fuera del botón pueda abrir la ficha.
- [Columna central apretada entre 40 y 48 rem] → `minmax` y `flex-wrap`
  en los detalles; pruebas de sistema a 640 px, con los detalles a la
  derecha, y a 639 px, con los detalles debajo, sin desplazamiento
  horizontal en ninguno de los dos.
- [Una variante compacta que se aleje del botón común] → Solo cambian el
  tamaño del texto y el relleno; el borde, el fondo, el radio y el foco
  son los del componente.
- [Pruebas existentes] → `spec/requests/people_listing_spec.rb` fija el
  texto de `data-people-total` y la existencia de `a[data-first-entry]`;
  siguen valiendo. `spec/system/people_listing_spec.rb` mide los 44 px a
  375 px; se suman las comprobaciones de las dos líneas, el borde y la
  posición a 1280, 640 y 639 px.

## Migration Plan

Sin datos ni configuración. Se publica con el procedimiento habitual
(`bin/ci` en código 0 y CI remoto) y se revierte con el commit.

## Registro

- **M408 (21/11/2026):** borrador creado a partir de la auditoría de M407
  y de la exploración en Stitch. No se ejecutaron validaciones, pruebas
  ni `bin/ci`; no se cambió código; no se subió nada nuevo a Stitch.
- **M410 (21/11/2026):** correcciones de la revisión recibida.
  - «Total de personas y aviso de privacidad» acortado a 482 caracteres
    (líneas recortadas, sin líneas vacías y unidas con saltos de línea),
    con el mismo alcance; sus escenarios no cambiaron. Los requisitos
    agregados miden 304 y 322.
  - Escenario «Corte en 40 rem» (640 y 639 px), alineado en el ticket,
    este diseño (D3 y riesgos) y las tareas 1.1 y 2.3.
  - Ticket, propuesta, diseño, tareas y delta revisados entre sí.
  - `openspec validate --all --strict`: 22 de 22, código de salida 0
    (tarea 0.2). Sin pruebas ni `bin/ci`; sin cambios de código.
  - Numeración por posición (opción A), confirmada por Pablo en M412 y
    M413, en coherencia con M407 a M410 (registro de M407).
- **M415 (21/11/2026):** conformidad de Pablo con el borrador y
  aprobación de P-54 y P-55 (tarea 0.3). Quedó explícito que P-55 no
  elimina el toque fuera del botón que abre la ficha, y que el listado que
  empieza bajo en móvil y el quiebre de la cabecera quedan fuera. La
  implementación sigue sin autorizar (tarea 0.4); sin validaciones,
  pruebas ni cambios de código.
- **M417 (21/11/2026): implementación local, grupos 1 a 3.** Autorizada
  por Pablo (tarea 0.4).
  - **Pruebas primero (1.1 y 1.2):** bloque «presentación (GL-17)» en
    `spec/system/people_listing_spec.rb`, con `aggregate_failures`: dos
    ejemplos por ancho, a 1280, 640, 639 y 375 px. Comprueban el ancho
    exacto de la ventana, que no haya desplazamiento horizontal, el total
    y el aviso en líneas separadas y sin «·», la ubicación de los detalles
    respecto de «rol · equipo», y «Registrar la primera» con borde, 44 px,
    más angosta que su columna y sin el fondo de la píldora ni el del
    botón principal. Contra el código de `63b86d0` fallaron los 8 por las
    razones esperadas: el «·», el aviso en la misma línea, los detalles
    debajo a 1280 y 640 px, y el enlace sin borde. Las aserciones de
    alto, ancho y fondo ya se cumplían y quedan como resguardo. El orden
    de foco a 1280 y 375 px lo cubre la prueba de GL-14 «cada fila recibe
    el foco una vez…». Las pruebas de peticiones no cambiaron.
  - **Implementación (2.1 a 2.3):** en la vista, el total y el aviso son
    dos párrafos dentro de `.people-summary` y «Registrar la primera»
    suma la clase `button`. En la hoja, `.person-first-entry` queda como
    variante compacta (0,875 rem y relleno de 0,25 × 0,75 rem) y la fila
    pasa a tres columnas desde 40 rem. Sin tokens nuevos ni cambios de
    DOM, controlador, helpers ni rutas.
  - **Verificación (3.1):** `bin/bundler-audit update` y `bin/ci` en
    código 0: RuboCop, bundler-audit, importmap y Brakeman sin
    advertencias, y RSpec con 471 ejemplos y 0 fallas.
  - **Desvíos:**
    - la prueba del ancho de «Registrar la primera» pedía al principio
      menos de la mitad de la fila, más que el escenario («más angosta
      que la fila»). A 375 px el botón mide 186 px y la fila 326, así que
      se ajustó a ser más angosto que su columna de detalles, que es el
      criterio de la spec;
    - el helper de la prueba devolvía claves de texto y se corrigió antes
      de dar por buena la fase roja;
    - en una corrida combinada falló una vez el ejemplo de GL-14 «sin
      JavaScript». No se repitió solo ni en tres corridas completas
      posteriores, ni en `bin/ci`. Queda registrado como intermitente,
      sin causa identificada.
  - **Límites observados en la app local (cuenta ficticia, sin datos
    nuevos):**
    - desde 40 rem, la fila sin entradas mide 98 px contra 81 de las
      demás (antes, 132 contra 108);
    - a 639 y 375 px los altos no cambian (132 y 157 px), porque a 375 px
      el botón sigue bajando a su propio renglón;
    - un toque 6 px a la derecha o 4 px arriba del botón sigue abriendo
      la ficha, como aceptó Pablo en M415;
    - el texto del botón es seminegrita, la del botón común;
    - el resumen ocupa 2 renglones desde 40 rem y 3 a 375 px (el total
      y el aviso partido en dos).
  - **Pendiente:** la comprobación manual y la conformidad visual de
    Pablo (3.2). Las capturas, con datos ficticios, están en el
    scratchpad de la sesión, fuera del repositorio. La publicación y el
    archivo (seguimiento del flujo) necesitan autorización.
- **M420 (22/11/2026):** conformidad visual de Pablo sobre las 14
  capturas de M417 (tarea 3.2), copiadas en
  `~/Descargas/gl-17-implementacion/capturas/`, fuera del repositorio.
  Todas las tareas de los grupos 0 a 3 están completas. Falta publicar y
  archivar, con autorización para cada paso.

