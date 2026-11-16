# Proposal

> **Estado (16/11/2026): implementado y verificado en local, sin
> publicar.**
>
> - **Origen:** borrador documental de M254 (15/11/2026). En M255 y M256
>   se le sumaron las mejoras del listado «Personas». En M257 se separaron
>   a GL-14, y GL-13 quedó como el cambio visual transversal.
> - **Decisiones:** P-34, P-35 y P-38 a P-40, decididas por Pablo en M261
>   (`docs/plan-entrega-final.md`).
> - **Implementación:** Pablo la autorizó en M264, y se completó con las
>   correcciones de M265 y la precisión de P-40 de M266. `bin/ci` pasó en
>   local después de M266 (M270).
> - **Conformidad visual:** Pablo la dio en M272.
> - **Pendiente:** commit, push, PR, CI remoto y archivo, cada uno con su
>   autorización. Detalle en el diseño, secciones 12 a 15.

## Why

La interfaz funciona, pero no tiene un lenguaje visual propio.

- **Paleta:** es neutra y genérica (`application.css:6-14`).
- **Acciones:** la principal se ve igual que las secundarias.
- **Estados:** un borrador solo se distingue de una entrada lista por su
  texto.
- **Pantallas pendientes:** compartir (I4), el feed (I6) y la
  administración (GL-04) no tienen todavía una forma prevista.

Para la entrega final, Pablo aportó una referencia visual candidata (M254).
Tiene navegación superior y una paleta crema, terracota, marrón y verde
salvia. Este cambio la contrasta con la propuesta aprobada (Anexos A, E y
G), con las specs vigentes y con el código. Así se define una dirección
visual que pueda aprobarse antes de implementarla.

Fuente: `docs/tickets/GL-13-direccion-visual.md`.

## What Changes

- **Capability nueva `visual-language`:**
  - tokens en un solo lugar;
  - contraste y foco;
  - estado, señal y origen siempre en texto;
  - borrador distinguible de una entrada lista;
  - resumen sin forma de puntaje;
  - cabecera superior sin destinos inexistentes;
  - pantallas angostas;
  - sin recursos de terceros;
  - la presentación no cambia el comportamiento, las acciones ni los
    textos existentes, salvo el aviso de privacidad de la ficha.
- **Decisiones de Pablo (M261):**
  - paleta cálida, con borde de campos `#857870` y «A mejorar» en ámbar;
  - azul solo para enlaces y etiquetas de contenido compartido;
  - fuente serif OFL alojada en la aplicación, con su licencia;
  - en la ficha, el mismo aviso breve de privacidad que el listado, sin
    panel «Quién ve qué»;
  - sin menú «⋯» ni menú desplegable de la cuenta;
  - etiquetas de origen para el ticket de compartir;
  - el login no cambia; en M264 se precisó que hereda el borde de campos,
    el foco y el botón común que exige GL-11.
- **Diseño:**
  - los tokens propuestos, con sus contrastes calculados;
  - los componentes;
  - la navegación;
  - un mapa de las siete pantallas pedidas, con su respaldo, lo
    implementado, lo pendiente y los estados;
  - la comparación con la referencia, con lo que se adopta, lo que se
    corrige y lo que queda abierto.
- **Implementado (M264 a M266):**
  - `app/assets/stylesheets/application.css`;
  - la fuente serif OFL y su licencia en `app/assets/fonts`;
  - clases en las vistas existentes, sin cambiar textos, rutas,
    formularios ni autorización, salvo el aviso de la ficha.
- **No incluye:**
  - funciones, destinos, roles ni datos nuevos;
  - **las mejoras funcionales del listado «Personas»:** la búsqueda, el
    filtro, el orden alternativo, los conteos ampliados y el acceso
    directo a la captura. Son de **GL-14**
    (`gl-14-mejoras-listado-personas`);
  - compartir, el feed, los filtros, la administración ni «+ Feedback»;
  - cambiar el orden de la cronología (P-10, que se mantiene) o el orden
    predeterminado del listado (1.14);
  - una pestaña «Compartir» en la ficha;
  - cambios en el inicio de sesión fuera del borde de campos, el foco y
    el botón común que exige GL-11 (P-40, M264);
  - mocks en imagen;
  - Render.

## Capabilities

### New Capabilities

- `visual-language`: el lenguaje visual común de la interfaz, comprobable
  sin cambiar el comportamiento.

### Modified Capabilities

- `people-browsing`: `ADDED` «Aviso de privacidad en la ficha» (P-38,
  M261). Es el único cambio de comportamiento de GL-13: suma un texto a
  la ficha.

Los deltas del listado que se habían sumado en M255 pasaron a GL-14.

- Sin cambios: `feedback-summary`, que fija los textos de estado, el orden
  de la cronología y la aclaración de que no es un puntaje.
- `sign-in-presentation` es del cambio GL-11, que no está archivado. Si
  P-40 decide un botón principal distinto, hará falta un delta
  `MODIFIED` después de archivar GL-11.

## Impact

- **Código, al implementar:**
  - `app/assets/stylesheets/application.css`;
  - clases en `app/views/layouts/application.html.erb`,
    `app/views/people/` y `app/views/feedback_entries/`. El inicio de
    sesión solo hereda el borde de campos, el foco y el botón común
    (P-40, M264).

  Rutas, controladores, políticas y modelos sin cambios.
- **Pruebas, al implementar:**
  - de sistema a 1280 y 375 px: contraste calculado, desplazamiento,
    alturas, tratamiento del borrador, cabecera y ausencia de recursos de
    terceros;
  - de peticiones: estilos en línea y textos exigidos.

  De las pruebas existentes, solo cambió el color de foco esperado en
  `spec/system/sign_in_presentation_spec.rb` (M264; diseño, sección 12).
- **GL-14:** usa los tokens y componentes de este cambio en el listado.
  Va después en la secuencia.
- **GL-11:** su comprobación manual (tarea 3.3) sigue pendiente para el
  cierre de la entrega final. Conviene hacerla después de GL-13 y GL-14,
  cuando la interfaz sea definitiva (M245).
