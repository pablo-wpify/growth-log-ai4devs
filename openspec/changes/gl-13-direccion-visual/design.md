# Design

> **Estado (16/11/2026): publicado en el PR #8, sin merge ni archivo.**
>
> - **Origen:** propuesta de M254, ampliada en M255 y M256 y separada en
>   M257 (15/11/2026).
> - **Decisiones:** P-34 a P-40, resueltas por Pablo: P-36 y P-37 en
>   M257; P-34, P-35 y P-38 a P-40 en M261. Están en
>   el plan de la entrega final, `docs/plan-entrega-final.md`. Ese plan es
>   transversal: queda fuera del candidato de publicación de GL-13,
>   pendiente de una decisión de publicación aparte.
> - **Implementación:** Pablo la autorizó en M264, **solo para GL-13**. Lo
>   implementado, los desvíos y lo que no se implementó están en las
>   secciones 12 a 15. El resto del diseño, incluido el mapa de las
>   pantallas futuras, sigue siendo una propuesta.
> - **Conformidad visual:** Pablo la dio en M272 (sección 15).
> - **Publicación:** autorizada por Pablo en M278: commit `c7d4165`, PR #8 y CI remoto en verde
>   (sección 16).
> - **Pendiente:** el archivo, con su autorización.
>
> Las mejoras funcionales del listado «Personas» pasaron a GL-14, en el
> cambio de OpenSpec `gl-14-mejoras-listado-personas` (diseño en
> `openspec/changes/gl-14-mejoras-listado-personas/design.md`). Ese cambio
> no forma parte de GL-13 y no tiene autorización para implementar.
> No hay capturas ni mocks nuevos: no se dispuso de una herramienta para
> crearlos e inspeccionarlos. Los esquemas de la sección 7 son texto.

## 1. Fuentes y cómo se usan

| Fuente | Uso |
|---|---|
| `propuesta-mvp.md` (§1.3, navegación) y `anexos/anexo-a-historias.md` (H1 a H5, PP-1 a PP-9) | alcance aprobado: qué pantallas existen, qué hacen y quién ve qué |
| `anexos/anexo-e-mocks.md` y `anexos/mocks/` (mocks 1 a 4) | diseño propuesto del MVP; lo que no ilustran (AE:78-89) |
| `anexos/anexo-g-plan-incremental.md` | incrementos I1 a I9 y en cuál llega cada pantalla |
| Specs vigentes: `people-browsing`, `feedback-capture`, `feedback-entries`, `feedback-summary`, `authorization`; el cambio activo `gl-11-presentacion-inicio-sesion` | textos, acciones y órdenes exigidos, que este cambio no altera |
| Código en `eabac8e`: `application.css`, el layout y las vistas de `people`, `feedback_entries` y `sessions` | qué está implementado |
| `docs/plan-entrega-2.md` (cerrado, solo lectura) | decisiones P-1 a P-33 vigentes y alcance diferido |
| Referencia visual candidata (M254), «Ficha de persona · versión combinada» | paleta y tono. **No es especificación funcional** |

## 2. Decisiones aprobadas que condicionan el diseño

No se reabren en este cambio. Si la referencia las contradice, gana la
decisión.

| Decisión | Qué impone al diseño |
|---|---|
| PP-2 a PP-6, D2 (Anexo A y C) | privado por defecto; «lista» no es «compartida»; compartir es de a un destinatario, sobre una entrada lista, por su autor |
| D4 (abierta) | la persona acompañada **no tiene cuenta**: nunca es destinataria ni lectora |
| PP-8, C5 | el rol de administrador no da lectura; la administración no muestra entradas ni resúmenes |
| P-1 | cinco dimensiones fijas: Entrega, Calidad técnica, Trabajo en equipo, Comunicación, Iniciativa |
| P-2 | señales «Positivo», «A mejorar», «Neutral»; resumen con Positivos, A mejorar, Neutrales y Total |
| P-10 y spec `feedback-summary` («Cronología de entradas propias») | cronología de la ficha **de la más antigua a la más reciente**; borrador con «Borrador · solo vos · fuera del resumen» |
| 5.1 (Anexo A) | feed: **primero las más recientes**, solo listas por defecto |
| P-11 | sin «+ Feedback» hasta que se planifique |
| 1.14, 1.15 y 1.16 (Anexo A); spec `people-browsing` | «Personas» muestra solo las personas activas asignadas, **ordenadas por nombre**, con rol y equipo. El conteo incluye solo lo que la cuenta puede ver. Sin personas, un mensaje que lo explica. **El orden alfabético sigue siendo el predeterminado**, también en GL-14 |
| P-15, P-16, P-17 | «Personas» es el inicio; ficha con nombre, rol y equipo |
| P-22 | la captura es una página propia, no un modal |
| P-24 | detalle de una entrada propia sin acceso a la ficha: solo el nombre de la persona y sin enlace |
| P-32, P-33 (GL-11) | login con las reglas comunes de los formularios y un ancho máximo de 24 rem |
| `people-browsing`, «Solo lectura y sin funciones inexistentes» | nada de compartir, filtros, feed, administración ni nombres de otros líderes hasta su incremento |

**Sobre el orden de la cronología.** El pedido (M254) indica que la
especificación no establece qué extremo aparece primero. **En el
repositorio sí lo establece.** La spec vigente `feedback-summary` exige
«de la más antigua a la más reciente», y P-10 fue aprobada el 14/11/2026.
Por eso «Más recientes primero» en la ficha no se adoptó como
recomendación libre y quedó como **P-36**. **En M257 Pablo la resolvió:
se mantiene P-10**, de la más antigua a la más reciente, sin cambios en
su texto ni en `feedback-summary`. En el feed, «más recientes primero» ya
es el criterio aprobado 5.1.

## 3. La referencia frente a la propuesta

Comparación elemento por elemento: qué se adopta, qué se corrige y qué
queda abierto.

| Elemento de la referencia | Respaldo | Tratamiento propuesto |
|---|---|---|
| Navegación superior con «Personas» y «Feedback» | PM §1.3; spec «cabecera» | **Se adopta** la cabecera superior. «Feedback» aparece **recién con I6** |
| Paleta crema, terracota, marrón y salvia | — (estética) | **Se adopta (P-34, M261)**, con el borde de campos `#857870` y «A mejorar» en ámbar |
| Títulos con serif | — | **Se adopta (P-35, M261):** fuente serif OFL alojada en la aplicación, sin servicios externos |
| Migas «Personas › Ada Ejemplo» | mock 3; cumple el «enlace de vuelta a Personas» | **Se adopta** en la ficha y el detalle, en lugar de «← Volver a …» |
| Avatar con iniciales | — | **Recomendación:** decorativo (`aria-hidden`), derivado del nombre, sin datos nuevos ni fotos (R-6) |
| «Captura rápida» como acción principal terracota | 3.1, mock 1 | **Se adopta** |
| Botón «⋯» junto a «Captura rápida» | — | **No se adopta** (P-38, M261): no hay acciones que lo respalden |
| «Líderes que la acompañan: Elena Boceto (vos), Franco Ensayo» | 1.18, mock 1 | **Diferido a I4**; hoy lo prohíbe `people-browsing` |
| Pestañas «Evidencia» / «Compartir» en la ficha | — | **No se adopta**: compartir ocurre sobre una entrada (H5, 5.6, mock 3). **P-37, resuelta en M257: sin pestaña «Compartir»** |
| «Evidencia · vista cronológica» con contador «4 entradas · 1 borrador» | 4.13 | Se adopta el bloque. El contador es un **dato nuevo** sin criterio; queda como recomendación opcional (R-7) |
| Selector «Orden: Más recientes primero» | — (5.1 es del feed) | **No se adopta** en la ficha: contradice P-10, que se mantiene (P-36, resuelta en M257) |
| Filtros Estado, Señal y Dimensión | 4.6, 4.7 | **Diferidos a I6**. Se define el componente |
| Borrador con borde discontinuo y fondo crema | 3.3; mock 1 | **Se adopta**. Texto exigido: «Borrador · solo vos · fuera del resumen», no «Borrador · solo vos» más «No cuenta en el resumen» |
| «Terminar borrador» | 3.4 | Hoy el detalle ofrece «Editar» y «Marcar como lista». Cambiar el texto es una **recomendación abierta** (R-8), no parte de este cambio |
| Etiqueta «Privada» | 4.3, mock 4 «Tuya · privada» | Hoy: «Lista · solo vos». Con I4: «Tuya · privada» (P-39) |
| «De Franco Ensayo» | 4.3, 4.8 | Con I4: «Compartida con vos · de Franco Ensayo» (P-39) |
| «Compartida con Ada» | — | **Error de la referencia:** Ada es la persona acompañada y no tiene cuenta (D4). Se corrige: el autor ve «Tuya · compartida» y, en el detalle, «Compartida con Franco Ensayo» (P-39) |
| Dimensión «Claridad» | — | **Contradice P-1.** Se usan las cinco dimensiones fijas |
| Resumen con columnas Positivo y A mejorar | 4.1 | **Contradice P-2.** Se conservan Positivos, A mejorar, Neutrales y Total |
| «1 tuya» / «1 de Franco Ensayo» bajo cada dimensión | 4.3 | Distinguir el origen corresponde a **I4**. Con I4, se recomienda un desglose en texto y no una columna con color (P-39) |
| Puntos verde y ámbar en los encabezados del resumen | — | **No se adoptan** en la tabla: acercan el resumen a un semáforo. El color de señal queda solo en las etiquetas de la cronología |
| Nota «No es un puntaje. Reúne evidencia para la próxima 1:1» | 4.5 | Se adopta la caja. El texto sigue siendo el exigido: «Solo entradas listas. No es un puntaje: reúne evidencia para la conversación» |
| «Solo entradas listas que podés ver» | 4.2 | Con I4, el aviso de alcance de los mocks 1 y 4. Hoy no aplica |
| Panel plegable «Quién ve qué» | — | **No se adopta** (P-38, M261). En su lugar, la ficha lleva el mismo aviso breve de privacidad que el listado (GL-14, P-53) |
| Menú desplegable de la cuenta (avatar, nombre y flecha) | — | **No se adopta** (P-38, M261): «Cerrar sesión» queda visible en la cabecera, como exige la spec (R-3) |
| Resumen en una columna lateral | — | **Recomendación** en pantallas anchas (R-4). Debajo de 72 rem, el resumen va antes que la cronología, como hoy |

## 4. Tokens (P-34, decidida en M261)

Los valores salen de la referencia y se muestrearon sobre la imagen. Los
contrastes se calcularon con la fórmula de WCAG 2.x. **Pablo adoptó esta
paleta en M261**, con el borde de campos `#857870` y «A mejorar» en ámbar.
Los valores exactos y sus contrastes **se verifican al implementar** con
estilos calculados, no se dan por buenos por esta tabla.

| Token | Valor | Uso | Contraste |
|---|---|---|---|
| `--bg` | `#faf7f2` crema | fondo de página | — |
| `--surface` | `#ffffff` | cabecera, tarjetas, campos | — |
| `--surface-muted` | `#f7f2ec` | borrador, notas, aviso del resumen | — |
| `--surface-active` | `#f3ece4` | destino actual de la cabecera, etiqueta neutra | — |
| `--text` | `#2b2320` marrón | texto y títulos | 14,4:1 sobre `--bg`; 13,8:1 sobre `--surface-muted` |
| `--muted` | `#6b5e57` | metadatos y textos secundarios | 5,8:1 sobre `--bg`; 5,6:1 sobre `--surface-muted` |
| `--line` | `#e8e0d6` | separadores y bordes de tarjeta (decorativos) | 1,3:1. **No se usa** como borde de campos |
| `--field-border` | `#857870` | borde de campos de formulario | 4,0:1 sobre `--bg`; 4,3:1 sobre blanco (≥ 3:1) |
| `--accent` | `#a6462a` terracota | acción principal, subrayado del destino actual, foco | blanco sobre terracota 5,9:1; terracota sobre `--bg` 5,6:1 |
| `--accent-strong` | `#8b3a22` | hover y activo de la acción principal | blanco sobre él 7,7:1 |
| `--accent-soft` / `--accent-ink` | `#f3e3d8` / `#6e3420` | avatar decorativo | 7,7:1 |
| `--sage` | `#5e7f4e` | marca (hoja) y detalles | 4,5:1 sobre blanco (solo gráfico) |
| `--positive-bg` / `--positive-ink` | `#e4f0e4` / `#2d5f34` | etiqueta «Positivo» | 6,4:1 |
| `--improve-bg` / `--improve-ink` | `#fbebd3` / `#8a4b0f` | etiqueta «A mejorar» (ámbar, **no rojo**: no es una falta) | 5,8:1 |
| `--neutral-bg` / `--neutral-ink` | `#f3ece4` / `#2b2320` | etiqueta «Neutral» y dimensión | 13,1:1 |
| `--shared-bg` / `--shared-ink` | `#e6ecf7` / `#2f4a86` | etiquetas de origen compartido (I4) | 7,2:1 |
| `--link` | `#2f4a86` | enlaces | 8,0:1 sobre `--bg` |
| `--danger` | `#a40e26` | errores (se conserva el actual) | 7,4:1 sobre `--bg` |

Además:

- **Radios:** 0,375 rem en campos y botones, 0,75 rem en tarjetas y 999 px
  en etiquetas.
- **Espaciado:** escala de 0,25 rem.
- **Sombras:** ninguna, o una sola y mínima en las tarjetas.

**El azul (P-34, M261):** se usa, como en la referencia, **solo** para los
enlaces (`--link`) y las etiquetas de contenido compartido (`--shared-*`).
**No se usa para las señales de feedback:** «Positivo», «A mejorar» y
«Neutral» siguen con `--positive-*`, `--improve-*` y `--neutral-*`.

## 5. Tipografía (P-35, decidida en M261)

- **Decisión:** los títulos (`h1`, `h2`, la marca y el nombre de la
  persona en el listado y en la ficha) usan una **fuente serif con
  licencia OFL, alojada en la aplicación** (`app/assets/fonts`), para que
  se vean iguales en todos los equipos. El texto conserva la pila actual
  (`system-ui, …`).
- **Licencia:** el archivo de la licencia OFL se versiona junto a la
  fuente, y la fuente y su versión se registran en este diseño al
  implementar.
- **Sin servicios externos:** la fuente se sirve desde la propia
  aplicación (requisito «Sin recursos de terceros»).
- **La fuente concreta** se elige al implementar, entre fuentes serif
  OFL, y se registra con su licencia. Pablo no eligió una en particular.
- **Respaldo:** la pila serif del sistema
  (`ui-serif, Georgia, Cambria, "Times New Roman", serif`) queda solo
  como reserva de `font-family` si el archivo no carga.
- **Tamaños:** `h1` 2 rem en escritorio y 1,75 rem a 375 px; `h2` 1,375 rem;
  texto de 1 rem con interlineado 1,5; fechas con `tabular-nums`.

## 6. Componentes y navegación

### 6.1. Componentes

- **Botón principal:** fondo `--accent` y texto blanco, 44 px. Solo uno
  por pantalla: «Captura rápida» en la ficha y «Marcar como lista» en el
  detalle de un borrador. «Guardar borrador» queda como botón común,
  porque la spec de GL-11 exige que «Iniciar sesión» tenga su mismo
  aspecto (P-40, M264).
- **Botón secundario:** fondo `--surface` y borde `--field-border`. Lo usan
  «Editar», «Cerrar sesión» y los demás.
- **Etiqueta:** píldora con texto siempre visible. Hay cuatro familias:
  - estado, en `--neutral`, con un ícono de lápiz para el borrador;
  - señal, en `--positive`, `--improve` o `--neutral`;
  - dimensión, en contorno con `--line`;
  - origen (I4), en `--shared`, o en `--neutral` con candado para «Tuya ·
    privada».
- **Tarjeta:** fondo `--surface`, borde `--line` y radio de 0,75 rem.
  Contiene el resumen, la cronología, los formularios y el detalle.
- **Fila de cronología:**
  - fecha en negrita, etiquetas y el comienzo del contexto debajo;
  - un punto marrón como marca temporal decorativa (`aria-hidden`).
- **Borrador:** contenedor con borde discontinuo `--field-border`, fondo
  `--surface-muted` y etiqueta de estado con lápiz. Así se distingue de
  una entrada lista **en forma, color y texto** (requisito «Borrador
  distinguible»).
- **Entrada lista sin compartir:** fila normal sobre `--surface`, con la
  etiqueta «Lista · solo vos» (con I4, «Tuya · privada» y candado). No
  lleva ningún tratamiento de borrador ni de compartida.
- **Entrada compartida (I4):** fila normal con una etiqueta `--shared`:
  - «Tuya · compartida» si la escribió quien mira;
  - «Compartida con vos · de <autor>» si la recibió.
- **Tabla del resumen:** números alineados a la derecha, sin color por
  fila ni barras. Debajo, la caja con la aclaración de 4.5.
- **Avisos:**
  - éxito (`flash-notice`) con borde izquierdo salvia;
  - error (`error-summary`) con borde `--danger` y `role="alert"`, como
    hoy.
- **Campo de formulario:** borde `--field-border`, 44 px y etiqueta
  encima, como en GL-11.
- **Filtros (I6):** selects con su etiqueta visible y un botón «Limpiar».
  A 375 px se apilan a todo el ancho.

### 6.2. Navegación y estructura

| Elemento | Propuesta |
|---|---|
| Cabecera | Superior y blanca, con borde inferior `--line`. A la izquierda, la hoja salvia (decorativa) y «Growth Log» en serif. Luego los destinos. A la derecha, «Sesión iniciada como <nombre>» y «Cerrar sesión», ambos visibles |
| Destinos | Hoy solo «Personas». **«Feedback» llega con I6** (PM §1.3, H5). **«Administración», solo para cuentas administradoras, con GL-04** (PP-8, PM §1.3) |
| Destino actual | Fondo `--surface-active` y peso 600, además de `aria-current` (no solo color) |
| Barra lateral | **No.** Los mocks del Anexo E la muestran, pero ningún criterio la pide y la propuesta tiene dos o tres destinos. La referencia nueva ya usa la cabecera superior |
| Pie de página | **No**: ningún mock, criterio ni recorrido lo usa |
| Migas | «Personas › <persona>» en la ficha y «Personas › <persona> › Entrada» en el detalle. En el detalle sin acceso a la ficha (P-24), sin migas ni enlace a la persona |
| Ancho | Contenido de 48 rem para formularios y detalle. Ficha y feed de hasta 72 rem, con dos columnas iguales en la ficha desde 72 rem (R-4) |
| Pantalla angosta | Por debajo de 30 rem, la cabecera pasa a dos líneas (como hoy). Las tablas se desplazan en su caja y los filtros se apilan. Sin menú hamburguesa: con tres destinos no hace falta |

## 7. Mapa de pantallas y estados (propuesta)

> **Propuesta.** Los esquemas son texto y no reproducen ninguna pantalla
> existente. Cada pantalla futura se implementa con su ticket, no con
> GL-13.

### 7.1. Inicio de sesión (`/session/new`)

- **Respaldo:** sin mock (P-32). Spec `sign-in-presentation`, del cambio
  GL-11 activo. `authentication`.
- **Implementado:** formulario de 24 rem, etiquetas encima, aviso genérico
  con `role="alert"` y sin cabecera (GL-11, desplegado). La **tarea 3.3 de
  GL-11 sigue pendiente** para el cierre de la entrega final.
- **P-40 (M261, precisada en M264 y M266).** El botón «Iniciar sesión» no pasa
  a botón principal, y GL-13 no le agrega tarjeta, marca, fondo ni
  tipografía nuevos. No hay delta de `sign-in-presentation`.
- **Lo que hereda (M264):** esa spec de GL-11 exige que los campos, el
  botón y el foco del login sean los de la captura rápida y los demás
  botones. Por eso el login hereda el borde de campos `#857870`, el foco
  de la paleta y el botón común. Pablo lo decidió en la consulta de M264,
  al ver que P-34, P-40 y esa spec no podían cumplirse a la vez.
- **Botón y campos (M266):** el botón «Iniciar sesión» es un botón
  común, con el fondo, el borde y el color de texto `#2b2320` de ese
  botón. No es principal ni terracota. Los campos del login conservan el
  texto negro y comparten solo el borde y el foco.
- **Cómo se implementa:** las reglas nuevas de las páginas con sesión
  quedan dentro de `body.app`. Las compartidas (campos, foco y botón
  común) son globales.

### 7.2. «Personas»

- **Respaldo:**
  - 1.14 (solo personas activas asignadas, **ordenadas por nombre**, con
    rol y equipo);
  - 1.15 (conteo solo con entradas visibles) y 1.16 (mensaje si no hay
    personas);
  - PM §1.3;
  - spec `people-browsing`.

  No tiene mock en el Anexo E. Referencia candidata: `~/Descargas/Lista
  de personas@1x.png` (M256, confirmada en M257), que **no es un
  requisito**.
- **Implementado** (`app/views/people/index.html.erb`,
  `people_controller.rb:11-16`):
  - el listado por nombre y después por id;
  - nombre, «rol · equipo» y «N entradas listas», también con 0, todo
    dentro de **un solo enlace por fila**;
  - el estado vacío.
- **Comportamiento nuevo: GL-14.** La fila navegable, los conteos
  neutrales, «Último hecho», la búsqueda, el filtro, el orden «Hechos más
  recientes», «Registrar la primera», sin resultados y 375 px se
  especifican en `gl-14-mejoras-listado-personas`. **GL-13 no los
  define.**
- **Pendiente en otros tickets:** contar las entradas compartidas (I4).
- **Propuesta visual de GL-13**, aplicable a lo que muestre el listado:
  - cada fila como una tarjeta continua sobre `--surface`, con separadores
    `--line`;
  - el nombre en la serif de P-35, igual que en la ficha, y «rol · equipo» en
    `--muted`;
  - los conteos como etiquetas neutras (`--neutral`), y los borradores con
    el borde discontinuo de la ficha;
  - el foco del teclado con el contorno de 3 px `--accent` (requisito
    «Contraste y foco»);
  - el avatar de iniciales decorativo, en un único tono
    (`--accent-soft`), para que el color no parezca una categoría;
  - los controles de búsqueda, filtro y orden, cuando GL-14 los agregue,
    con el componente de campo y de filtros de la sección 6.1.
- **Otros elementos de la referencia del listado:**
  - **«Feedback» en la cabecera:** llega con I6; hoy no se muestra;
  - **menú desplegable de la cuenta:** no se adopta (P-38);
  - **«3 personas que acompañás» y «Ves solo a quienes tenés asignados…»:**
    agregan un dato y un texto. No son presentación, así que no quedan en
    GL-13. Pablo los aprobó para GL-14 (P-53, M258).
- **Estados de presentación:** sin personas (1.16), dentro de una tarjeta;
  listado con personas; 375 px en una columna. Los demás estados son de
  GL-14.

### 7.3. Ficha de persona

- **Respaldo:** mock 1, 1.17, 3.1, 4.1 a 4.5 y 4.13; specs
  `people-browsing` y `feedback-summary`.
- **Implementado:**
  - nombre, rol y equipo;
  - «Captura rápida»;
  - resumen con Positivos, A mejorar, Neutrales y Total, más la
    aclaración;
  - cronología ascendente con los estados «… · solo vos».
- **Pendiente (otros tickets):**
  - nombres de los otros líderes, origen y entradas compartidas (I4);
  - filtros (I6).
- **Aviso de privacidad (P-38, M261):** la ficha muestra, una sola vez y
  de forma discreta, el mismo aviso breve que el listado: «Ves solo a
  quienes tenés asignados y las entradas que podés ver». No lleva el
  panel «Quién ve qué». Las etiquetas de cada entrada («Lista · solo vos»,
  «Borrador · solo vos · fuera del resumen») se conservan. Requisito en
  el delta de `people-browsing` de este cambio; es la única excepción al
  requisito «La presentación no cambia el comportamiento».
- **Propuesta:**

```
Personas › Ada Ejemplo
(AE)  Ada Ejemplo                               [✎ Captura rápida]
      Desarrolladora · Equipo Faro
      Ves solo a quienes tenés asignados y las entradas que podés ver
      ── con I4: «Líderes que la acompañan: Elena Boceto (vos) · Franco Ensayo»
┌─ Vista cronológica ───────────────────┐ ┌─ Resumen por dimensión ────┐
│ ── con I6: filtros Estado/Señal/Dim.  │ │ Dim.   Pos. A mej. Neu. Tot│
│ 12/03 [Lista · solo vos] [Positivo]   │ │ Entrega  0    1    0    1  │
│       [Trabajo en equipo]  texto…     │ │ Trabajo  2    0    1    3  │
│ ┆08/06 [✎ Borrador · solo vos ·     ┆ │ │ ┌ Solo entradas listas. No ┐│
│ ┆      fuera del resumen]  texto…   ┆ │ │ │ es un puntaje: reúne …   ││
│ ┆ (borde discontinuo, fondo crema)  ┆ │ │ └──────────────────────────┘│
└───────────────────────────────────────┘ └────────────────────────────┘
(orden: el de P-10, de la más antigua a la más reciente)
```

- **Estados:**
  - sin entradas: «Todavía no hay entradas listas para el resumen» y
    «Todavía no registraste entradas sobre <nombre>»;
  - solo borradores: resumen vacío y cronología con borradores;
  - borrador y lista juntos;
  - lista sin compartir;
  - con I4, compartida por mí y compartida conmigo;
  - con I6, filtros sin resultados («Ninguna entrada coincide con los
    filtros» y «Limpiar»);
  - 375 px: una columna, primero el resumen y después la cronología.

### 7.4. Captura rápida

- **Respaldo:** mock 2 (modal, reemplazado por una página propia por
  P-22), 3.1 a 3.3; spec `feedback-capture`.
- **Implementado:** página propia con «¿Qué pasó?», la fecha de hoy y
  «Guardar borrador». Al guardar, vuelve a la ficha con un aviso.
- **Propuesta:**
  - tarjeta de 48 rem;
  - migas «Personas › Ada Ejemplo › Captura rápida»;
  - texto de ayuda en `--muted`: «Se guarda como borrador: solo vos podés
    verlo» (R-9, recomendación; repite la regla PP-3);
  - «Guardar borrador» como acción principal.
- **Estados:**
  - texto vacío: el resumen de errores y el error junto al campo, como
    hoy;
  - aviso de éxito en la ficha;
  - 375 px, con el área de texto a todo el ancho.

### 7.5. Detalle de entrada y acción para compartir

- **Respaldo:** mock 3, 2.9, 3.4 a 3.10, 4.8 a 4.10 y H5 (5.6, 5.7, 5.9,
  5.12); spec `feedback-capture`.
- **Implementado:**
  - detalle de una entrada propia con todos los campos, «Editar» y
    «Marcar como lista» si es borrador;
  - variante sin acceso a la ficha (P-24).

  La edición tiene radios de señal y dimensión.
- **Pendiente (I4):**
  - la sección «Compartir» en una entrada lista;
  - «Compartida con» y «Dejar de compartir»;
  - la lectura de una entrada recibida.
- **Propuesta:**
  - encabezado con la persona y la fecha del hecho;
  - etiquetas de estado, señal y dimensión;
  - campos en una lista de definiciones dentro de una tarjeta;
  - acciones al pie.

  Con I4, la sección «Compartir» va **en el detalle, no en la ficha**
  (H5, mock 3):
  - **un destinatario por vez**, con un grupo de radios o un select con
    los líderes activos de esa persona, y no con casillas como el mock 3
    (5.6): las casillas sugieren que se pueden elegir varios;
  - «Compartida con: Franco Ensayo» y «Dejar de compartir» por
    destinatario;
  - la persona acompañada **nunca** aparece como destinataria (D4).
- **Estados:**
  - **borrador:** sin la sección «Compartir» (3.9), con «Marcar como
    lista»;
  - **lista sin compartir:** «Compartida con: nadie todavía»;
  - **compartida:** la lista de destinatarios;
  - **recibida:** «Compartida con vos · de <autor>», solo lectura, sin
    «Editar» ni «Compartir» (4.10, 5.9);
  - **autor sin asignación (P-24):** aviso de solo lectura, sin migas ni
    enlace a la persona, con «Dejar de compartir» disponible con I4
    (5.12);
  - **errores:** el resumen de errores, como hoy;
  - **375 px:** acciones apiladas.

### 7.6. Feed «Feedback» (I6, no implementado)

- **Respaldo:** mock 4, H5 (5.1 a 5.5 y 5.8), 4.6, 4.7 y PM §1.3.
- **Implementado:** nada. No hay ruta ni enlace, y la spec prohíbe
  anunciarlo.
- **Propuesta:**
  - destino «Feedback» en la cabecera;
  - primero las más recientes y solo las listas por defecto (5.1);
  - filtros Estado, Señal y Dimensión con «Limpiar»;
  - lista de filas: persona, fecha, etiquetas de señal, dimensión y
    origen, y el comienzo del texto;
  - en escritorio, una tabla dentro de su caja; a 375 px, filas apiladas
    en lugar de la tabla de seis columnas del mock 4;
  - paginación;
  - leyenda de origen: «Tuya · privada», «Tuya · compartida», «Compartida
    con vos».

  Los filtros por origen y persona siguen **sin decidir** (AE:72).
- **Estados:**
  - vacío sin entradas;
  - filtros sin resultados;
  - con borradores propios cuando el filtro de estado los incluye (5.5);
  - recibida;
  - última página;
  - 375 px.

### 7.7. Administración e invitaciones (GL-04, I7 e I8, no implementado)

- **Respaldo:** H1 (1.1 a 1.13), PP-1, PP-8, D1, AM-3 a AM-5 y PM §1.3.
  **Sin mock** (AE:80-89).
- **Implementado:** nada. Las cuentas, las personas y las asignaciones se
  preparan con datos ficticios (GL-08, GL-10).
- **Propuesta:**
  - destino «Administración» solo para cuentas administradoras;
  - una pantalla con tres secciones en pestañas internas o
    encabezados: **Cuentas**, **Personas** y **Asignaciones**;
  - nunca entradas, resúmenes ni conteos de entradas (PP-8);
  - en Cuentas, invitar por correo y el estado de cada invitación
    (pendiente, vencida o usada), con «Volver a invitar» cuando venció o se
    usó (1.3), y desactivar;
  - en Personas, crear y editar (nombre obligatorio, 1.4) y dar de baja;
  - en Asignaciones, asignar y terminar;
  - la revocación administrativa de una compartición (1.13, I8) muestra
    solo metadatos sin contenido (AM-3). Qué metadatos, está sin decidir
    (Anexo C, C.3);
  - **establecer la contraseña desde la invitación (1.2):** página sin
    sesión, con el mismo esqueleto que el inicio de sesión.
- **Estados:**
  - vacío por sección;
  - error de validación;
  - invitación vencida o usada;
  - último administrador, bloqueado por I7 y AM-4: el mensaje queda sin
    definir (Anexo C, C.3);
  - confirmación antes de desactivar o terminar;
  - 375 px.

## 8. Recomendaciones

Entran en el alcance de GL-13 si Pablo aprueba el cambio.

- **R-1.** Un solo botón principal por pantalla (6.1).
- **R-2.** Borrador con borde discontinuo, fondo crema y lápiz, además de
  su texto.
- **R-3.** «Sesión iniciada como <nombre>» y «Cerrar sesión» visibles en la
  cabecera, sin menú desplegable.
- **R-4.** Ficha a dos columnas iguales desde 72 rem, con la cronología a
  la izquierda y el resumen a la derecha. Debajo de 72 rem, una columna con el
  orden actual.
- **R-5.** Migas en lugar de «← Volver a …» en la ficha, la captura y el
  detalle con acceso a la ficha. Mantienen el enlace a «Personas» que pide
  la spec.
- **R-6.** Avatar de iniciales decorativo, sin datos nuevos.
- **R-7, opcional.** Contador «N entradas · M borradores» en la cronología.
  Es un dato derivado sin criterio. Si Pablo no lo quiere, se omite.
- **R-8, fuera de GL-13.** Revisar si «Editar» de un borrador debería
  decir «Completar», como en 3.4. Cambia textos y queda para una decisión
  aparte.
- **R-9.** Ayuda de privacidad en la captura, con el mensaje de PP-3 que
  ya usan los avisos.
- **R-10 a R-13:** se retiraron en M257. R-10 (fila con un enlace
  extendido) y R-11 (nombre y «rol · equipo» en dos líneas) son ahora
  las decisiones 1 y 2 de GL-14, aprobadas por Pablo. R-12 (contador de
  personas) y R-13 (aviso de alcance) pasaron a GL-14, donde Pablo las
  aprobó (P-53, M258).

## 9. Decisiones

Todas resueltas por Pablo. Detalle en el plan de la entrega final.
**Ninguna autoriza implementar.**

| # | Pregunta | Decisión |
|---|---|---|
| P-34 | ¿Se adopta la dirección visual y el azul? | **M261:** paleta cálida, con borde de campos `#857870` y «A mejorar» en ámbar; contraste verificado al implementar. Azul para enlaces y etiquetas de contenido compartido, nunca para las señales de feedback |
| P-35 | Tipografía de títulos | **M261:** fuente serif OFL alojada en la aplicación, con la licencia registrada y sin servicios externos |
| P-36 | ¿«Más recientes primero» en la ficha? | **M257:** se mantiene P-10, de la más antigua a la más reciente |
| P-37 | ¿Pestaña «Compartir» en la ficha? | **M257:** sin pestaña «Compartir» |
| P-38 | Elementos de la referencia sin respaldo | **M261:** la ficha lleva el mismo aviso breve de privacidad que el listado, sin el panel «Quién ve qué»; no van el menú «⋯» ni el menú desplegable de la cuenta; «Cerrar sesión» sigue visible. El selector de orden ya quedó descartado por P-36 |
| P-39 | Etiquetas de origen y compartición | **M261:** se dejan para un futuro ticket de compartir. Se conservan las etiquetas vigentes |
| P-40 | Estilo del botón «Iniciar sesión» | **M261:** se mantiene el estilo actual; GL-13 no modifica el login. **M264:** el login hereda solo el borde de campos, el foco y el botón común que exige la spec de GL-11, y «Guardar borrador» queda como botón común. **M266:** el botón «Iniciar sesión» toma el fondo, el borde y el color de texto `#2b2320` del botón común, sin volverse principal ni terracota; los campos del login conservan el texto negro |

P-41 a P-45 pasaron a GL-14 en M257, donde Pablo las aprobó. Ver el plan
de la entrega final y el diseño de `gl-14-mejoras-listado-personas`.

## 10. Riesgos y verificación prevista

- **Cambio visual amplio sobre pantallas probadas:** las pruebas de sistema
  de GL-09 y GL-11 buscan textos y estructura, no colores. Igual se corren
  completas. Al implementar se registran los estilos calculados antes y
  después, como en GL-11.
- **GL-11, tarea 3.3:** la comprobación manual sigue pendiente para el
  cierre de la entrega final. Este cambio **no la marca**. Conviene hacerla
  después de GL-13, cuando la interfaz sea definitiva (M245).
- **Listado «Personas»:** los riesgos de las lecturas nuevas, el atajo a
  la captura y el filtrado son de GL-14.
- **Contraste:** se comprueba con estilos calculados en las pruebas de
  sistema, no a ojo (P-34).
- **Fuente alojada:** se comprueba que se sirve del mismo origen y que su
  licencia está versionada (P-35).
- **Login:** se comprueba que conserva su fondo, su tipografía y su
  estructura, y que solo hereda el borde de campos, el foco y el botón
  común (P-40, M264).
- **Verificación prevista:**
  - pruebas de sistema a 1280 y 375 px con contraste calculado,
    desplazamiento, alturas, tratamiento del borrador, cabecera y
    recursos del mismo origen;
  - prueba de peticiones de que no hay estilos en línea y de que siguen
    los textos exigidos;
  - `bin/ci`;
  - comprobación manual de Pablo.

## 11. Registro

- **M250 (15/11/2026):** primer pedido, reemplazado por M254. Antes de
  reemplazarlo quedaron escritos el delta de la spec, el ticket y la
  propuesta.
- **M254 (15/11/2026):**
  - ubicó el trabajo en la entrega final, con plan propio y sin tocar la
    entrega 2;
  - se corrigieron el ticket y la propuesta y se prepararon este diseño,
    las tareas, el plan de la entrega final y el registro del pedido;
  - ejecutado solo `openspec validate --all --strict` (resultado en el
    registro del pedido);
  - sin pruebas, CI, auditorías, código funcional ni commits.
- **M255 y M256 (15/11/2026):**
  - mejoras del listado «Personas» (7.2.1) con la referencia `Lista de
    personas@1x.png`, que M256 confirmó;
  - deltas `MODIFIED` y `ADDED` de `people-browsing` y `MODIFIED` de
    `feedback-capture` y `authorization`, y ajuste del requisito de
    `visual-language` sobre el comportamiento;
  - decisiones P-41 a P-45;
  - solo se ejecutó `openspec validate --all --strict`.
- **M257 (15/11/2026):**
  - se separaron a GL-14 los requisitos funcionales del listado: la
    búsqueda, el filtro, el orden alternativo, los conteos ampliados y el
    acceso directo a la captura;
  - se retiraron de este cambio los deltas de `people-browsing`,
    `feedback-capture` y `authorization`, la sección 7.2.1, R-10 a R-13 y
    P-41 a P-45;
  - Pablo resolvió P-36 (se mantiene P-10) y P-37 (sin pestaña
    «Compartir»). P-34, P-35 y P-38 a P-40 siguen abiertas;
  - solo se ejecutó `openspec validate --all --strict`.
- **M260 (16/11/2026):** revisión de solo lectura de P-34, P-35 y P-38 a
  P-40, sin editar archivos.
- **M261 (16/11/2026):**
  - Pablo decidió P-34, P-35 y P-38 a P-40 (sección 9);
  - el login queda fuera de GL-13 (7.1), y la ficha suma el aviso breve
    de privacidad, con un delta `ADDED` de `people-browsing`;
  - no se autoriza implementar GL-13 ni GL-14;
  - solo se ejecutó `openspec validate --all --strict`.
- **M263 (16/11/2026):** correcciones de redacción, sin cambiar P-34 a
  P-40. El delta de `people-browsing` ya no prohíbe otros textos de
  privacidad: conserva las etiquetas por entrada. `visual-language`
  declara el aviso de la ficha como única excepción a «La presentación no
  cambia el comportamiento». Solo se ejecutó `openspec validate --all
  --strict`.
- **M264 (16/11/2026):** Pablo autorizó implementar GL-13 (no GL-14).
  Antes de empezar se detectó la contradicción entre P-34, P-40 y la spec
  de GL-11, y Pablo la resolvió en la consulta de ese pedido (sección
  7.1). Implementado en local; resultados en la sección 12.

## 12. Implementación (M264, 16/11/2026)

**Estado:** implementado y verificado en local, **sin commit**. Falta la
comprobación manual de Pablo (tarea 3.3).

**Archivos:**

- `app/assets/stylesheets/application.css`: tokens en `:root`; las reglas
  de las páginas con sesión, dentro de `body.app`; campos, foco y botón
  común, compartidos con el inicio de sesión;
- `app/assets/fonts/noto-serif-display/NotoSerifDisplay-Regular.ttf` y
  `OFL.txt`: Noto Serif Display Regular, OFL 1.1, copiada sin modificar
  del paquete `fonts-noto-core` 20201225-1build1 del sistema; SHA-256
  `bcdc596729c24044e28c54815ecbe6004f83b10169a49a51160b22f59116249f`.
  No se descargó nada;
- `app/views/layouts/application.html.erb`: clase `app` en las páginas
  con sesión y clase opcional del contenedor;
- `app/views/people/show.html.erb`: aviso de privacidad, «Captura rápida»
  como acción principal, dos columnas y clases de las etiquetas;
- `app/views/feedback_entries/show.html.erb`: tarjeta y «Marcar como
  lista» como acción principal;
- pruebas nuevas: `spec/requests/visual_language_spec.rb` (8 ejemplos) y
  `spec/system/visual_language_spec.rb` (9 ejemplos);
- prueba existente modificada: `spec/system/sign_in_presentation_spec.rb`,
  solo el color de foco esperado, de `rgb(10, 88, 202)` a
  `rgb(166, 70, 42)`. La spec de GL-11 pide «el color de foco de la
  aplicación», que desde M264 es el de la paleta. Su texto no cambia.

**Pruebas primero:** antes de tocar la hoja y las vistas fallaron 11 de
17 ejemplos nuevos, por las razones esperadas: faltaban los tokens, la
fuente y su licencia, el aviso, la clase `app`, el borde `#857870`, el
fondo del destino actual, la serif y el foco de la paleta. Los otros 6
(contraste AA, sin desplazamiento, recursos propios y sin estilos en
línea) ya se cumplían y quedan como protección.

**Estado de antes:** estilos calculados y capturas de 8 pantallas a 1280
y 375 px (32 archivos), tomados antes del cambio y repetidos después,
fuera del repositorio. Comparando el inicio de sesión, solo cambiaron el
borde de los campos (`#d0d7de` → `#857870`), el foco (azul → terracota) y
el color del texto de los campos y del botón (`#000000` y `#1f2328` →
`#2b2320`). No cambiaron el fondo, el título, las etiquetas, el aviso ni
las medidas.

**Verificación (local):**

- `bundle exec rspec`: 400 ejemplos, 0 fallos;
- `bin/bundler-audit update` con código 0 y `bin/ci` con código 0: estilo,
  auditoría de gemas y de importmap, Brakeman (0 avisos) y RSpec;
- `openspec validate --all --strict`: 22 de 22.

Nada se comprobó en el CI remoto ni en Render.

**Desvíos y lo que no se implementó:**

- **Migas (R-5), avatar de iniciales (R-6), contador de la cronología
  (R-7), ayuda de la captura (R-9) y hoja de la marca:** no se
  implementaron. Cambiarían o sumarían textos visibles, y el requisito
  «La presentación no cambia el comportamiento» (M263) solo admite el
  aviso de la ficha.
- **R-4:** dos columnas iguales desde 72 rem, y no desde 64 rem. Con
  64 rem, la tabla del resumen no entraba en su columna y se desplazaba
  dentro de la caja. Ahora entra entera a 1280 y 1440 px.
- **Fuente:** TTF completa, sin recortar a latín (548 KB). No había
  herramientas locales para convertirla a WOFF2 ni para recortarla, y no
  se descargó ninguna. Se carga con `font-display: swap` y solo en las
  páginas con sesión.
- **«Guardar borrador»** queda como botón común (P-40, M264).

**Pendiente:**

- la comprobación manual de Pablo a 1280 y 375 px (tarea 3.3);
- commit, push, PR y CI remoto (4.1) y el archivo (4.2), cada uno con su
  autorización;
- la tarea 3.3 de GL-11, que se registra en su propio cambio.

## 13. Correcciones de la revisión visual (M265, 16/11/2026)

La sección 12 queda como registro de M264. Pablo revisó las capturas y
pidió tres correcciones dentro de la misma autorización.

1. **Cabecera a 375 px.** Ocupaba tres filas: el nombre y «Personas»;
   la cuenta; «Cerrar sesión». La prueba aceptaba hasta 3 × 56 px, aunque
   la spec permite dos líneas como máximo. Por debajo de 30 rem, la
   cabecera pasa a ser una grilla de dos columnas: arriba el nombre y
   «Personas»; abajo la cuenta y «Cerrar sesión». La cuenta baja a
   0,875 rem y, si es larga, se ajusta dentro de su celda, sin agregar
   filas. La prueba ahora cuenta las filas por solapamiento vertical y
   exige como máximo dos, con los cuatro elementos visibles, en
   «Personas» y en la ficha, a 1280 y a 375 px.
2. **Radios de los formularios internos.** Tomaban el azul del
   navegador. Ahora usan `accent-color: var(--accent)` dentro de
   `body.app`, y el foco común sigue igual (3 px terracota). Pruebas:
   el `accentColor` calculado de todos los radios de la edición es
   `rgb(166, 70, 42)`; al llegar con Tab, el radio muestra el contorno
   sólido terracota con 3:1 o más; y la hoja declara `accent-color` solo
   en reglas de `body.app`.
3. **Color del texto de los campos del login.** La spec de GL-11 exige
   «el mismo borde, radio y tipografía» en los campos y «el borde, el
   radio y el fondo» en el botón. Su prueba compara `border*`,
   `borderTopLeftRadius`, `fontFamily` y `fontSize` (y `backgroundColor`
   en el botón), pero no `color`. **El color del texto no es parte del
   estilo compartido.** Por eso el login recupera el suyo, `rgb(0, 0, 0)`
   del navegador. `color: var(--text)` pasa a aplicarse solo a los campos
   de `body.app`. La prueba de sistema del login lo comprueba en el correo
   y en la contraseña. P-40 no se amplía.

**Pruebas primero:** antes de cambiar la hoja fallaron 6 ejemplos, por
las razones esperadas:

- la cabecera a 375 px ocupaba 3 filas;
- el `accentColor` de los radios era `auto`, a 1280 y a 375 px;
- el texto del campo del login era `rgb(43, 35, 32)`;
- no había ninguna regla con `accent-color`.

El primer intento de contar filas comparaba el borde superior de cada
elemento, y a 1280 px daba un falso positivo, porque los elementos de una
misma fila están centrados. Se corrigió antes de implementar.

**Capturas:** se repitieron las 8 pantallas a 1280 y 375 px, fuera del
repositorio. Cambiaron solo:

- la cabecera a 375 px, de 137 a 109 px de alto, en dos filas;
- el color del texto de los campos del login, que vuelve a
  `rgb(0, 0, 0)`;
- los radios de la edición, ahora terracota.

En la serie de M264, los estilos calculados en JSON de la ficha no
coincidían con su captura: la tabla y las filas figuraban como ausentes.
La imagen sí era la correcta. La serie nueva es coherente en los dos.

**Fuera de alcance, sin cambios:** el texto del botón común del login
también pasó en M264 de `#1f2328` a `#2b2320`. La spec de GL-11 tampoco
exige ese color, pero M265 pidió corregir solo los campos. Queda como
observación para que Pablo decida.

**Verificación (local):** ver el registro de M265.

## 14. Precisión de P-40 (M266, 16/11/2026)

Resuelve la observación de la sección 13 sobre el color del texto del
botón del login. Pablo decidió:

- **Botón «Iniciar sesión»:** es un botón común. Conserva el fondo y el
  borde de ese botón y hereda también su color de texto, `#2b2320`. No es
  un botón principal y no se vuelve terracota.
- **Campos del login:** conservan el texto negro, `rgb(0, 0, 0)` (M265).
  Con la captura rápida comparten solo el borde y el foco acordados en
  M264.

El CSS ya cumplía esto desde M265, y no cambió. Se agregaron dos
comprobaciones a la prueba de sistema del login,
`spec/system/visual_language_spec.rb`:

- el color del texto del botón es `rgb(43, 35, 32)`;
- su borde es el del botón común, `rgb(133, 120, 112)`.

Ya existía la comprobación de que su fondo no es el terracota principal.
Por eso pasaron sin necesidad de un cambio previo. Fijan un comportamiento
vigente y no implementan uno nuevo.

## 15. Conformidad visual de Pablo (M272, 16/11/2026)

Pablo dio su conformidad visual con GL-13 en M272. La frase que pidió
registrar es «Doy mi conformidad». Con eso se cierra la tarea 3.3.

- **Qué revisó:** las 16 capturas de M265, a 1280 y 375 px:
  - inicio de sesión, con y sin aviso;
  - «Personas», con y sin personas;
  - ficha;
  - captura con error;
  - detalle de un borrador;
  - edición.
- **Dónde están:** en `~/Descargas/gl-13-capturas/m265/`, fuera del
  repositorio. Sus nombres y SHA-256 están en el registro de M266.
- **Si siguen vigentes:** M266 y M267 no cambiaron la interfaz, y
  `bin/ci` pasó con código 0 después de M266 (M270).

**Pendiente:**

- commit, push, PR y CI remoto (4.1) y el archivo (4.2), cada uno con su
  autorización;
- la tarea 3.3 de GL-11, en su propio cambio.

## 16. Publicación (M278, 16/11/2026)

Pablo autorizó publicar GL-13 con el candidato de M277, sin el plan
transversal, que queda para una publicación documental posterior.

- **Commit:** `c7d41654dc6549602d6f99ade854ad16efd42bc9`, sobre `eabac8e`.
  Contiene el candidato de M277 (29 archivos completos y la parte de GL-13
  de `prompts.md`) y la fuente `NotoSerifDisplay-Regular.ttf`, sumada
  aparte. No incluye GL-14, `CLAUDE.md`, el plan ni la Entrega 2.
- **PR:** [#8](https://github.com/pablo-wpify/growth-log-ai4devs/pull/8),
  de `feature/entrega-final-pp` a `feature/entrega-2-pp`, la rama que
  apunta a `eabac8e`.
- **CI remoto:**
  [run 43903787327](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43903787327),
  en verde: 403 ejemplos y 0 fallos, con los cuatro jobs aprobados
  (`test`, `lint`, `scan_ruby` y `scan_js`).
- **No se corrió `bin/ci` local:** pasó en M270 y después solo cambiaron
  documentos.

**Pendiente:** el archivo del cambio (4.2), con su autorización. Sin
merge ni deploy.
