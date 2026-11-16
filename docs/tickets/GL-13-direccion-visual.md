# GL-13. Dirección visual de la aplicación y de sus pantallas principales

> Ticket propuesto para la entrega final de Growth Log. Lugar en la
> secuencia: el plan de la entrega final, `docs/plan-entrega-final.md`,
> única fuente de la secuencia de esta entrega. Ese plan es transversal:
> queda fuera del candidato de publicación de GL-13, pendiente de una
> decisión de publicación aparte. La entrega 2 está cerrada y su plan no
> se modifica. Cambio de OpenSpec, implementado en local y sin
> publicar:
> [`gl-13-direccion-visual`](../../openspec/changes/gl-13-direccion-visual/proposal.md).
> **Estado (16/11/2026, M264): implementado y verificado en local, sin
> commit.** Pablo autorizó implementar en M264. Dio su conformidad
> visual en M272 (tarea 3.3, sobre las capturas de M265). Falta la
> autorización para publicar. En M265 se corrigieron los hallazgos de su revisión
> visual: la cabecera a 375 px, los radios internos y el color del texto
> de los campos del login (diseño, sección 13). Pablo decidió P-34, P-35 y P-38 a P-40 en M261
> (P-40 se precisó en M264 y M266), y P-36 (se mantiene P-10) y P-37 (sin pestaña
> «Compartir») en M257. En M257, las mejoras funcionales del listado «Personas»
> pasaron a GL-14, cuyo ticket es `docs/tickets/GL-14-mejoras-listado-personas.md`.
> No forma parte de este cambio.

## Problema

La interfaz usa una paleta neutra genérica: grises, azul de enlace y
fondo blanco (`app/assets/stylesheets/application.css:6-14`). Cada
pantalla se resolvió por separado, en GL-05, GL-06, GL-07 y GL-11. Faltan
cuatro cosas:

- un lenguaje visual común;
- una jerarquía clara entre la acción principal y las secundarias;
- una diferencia visible entre un borrador y una entrada lista (hoy solo
  la da el texto);
- una forma prevista para lo que llega con compartir (I4), el feed (I6) y
  la administración (GL-04).

Pablo aportó una referencia visual candidata (M254): `~/Descargas/Ficha de
persona · versión combinada@2x.png`. Tiene navegación superior y tonos
crema, terracota, marrón y verde salvia. **Es una referencia para
explorar.** No es una especificación funcional ni una decisión de Pablo.

## Objetivo

Definir una dirección visual coherente que se pueda revisar y aprobar
antes de implementarla. Incluye:

- los tokens de color y de tipografía;
- los componentes comunes;
- la navegación;
- un mapa de pantallas y estados.

La dirección tiene que respetar las historias, los criterios y las reglas
de privacidad vigentes.

## Alcance

- **Documental (este borrador):**
  - propuesta, diseño con el mapa de pantallas y estados, tareas y la
    capability nueva `visual-language`;
  - decisiones P-34 a P-40 en el plan, todas resueltas.
- **Implementación, cuando Pablo la apruebe:**
  - aplicar los tokens y los componentes a las pantallas con sesión que
    ya existen: «Personas», ficha, captura, detalle y edición;
  - el inicio de sesión solo hereda el borde de campos, el foco y el botón
    común, como exige la spec de GL-11 (P-40, precisada en M264);
  - no cambiar el comportamiento, salvo el aviso de privacidad de la
    ficha (P-38).

## Decisiones de Pablo (M261)

- **P-34.** Paleta cálida, con el borde de campos `#857870` y «A mejorar»
  en ámbar. El contraste se verifica al implementar. Azul para enlaces y
  etiquetas de contenido compartido, como en la referencia; nunca para
  las señales de feedback.
- **P-35.** Fuente serif con licencia OFL, alojada en la aplicación, para
  que se vea igual en todos los equipos. Se registra la licencia y no se
  carga desde un servicio externo.
- **P-38.** La ficha lleva el mismo aviso breve de privacidad que el
  listado, sin el panel «Quién ve qué». No van el menú «⋯» ni el menú
  desplegable de la cuenta; «Cerrar sesión» sigue visible.
- **P-39.** Las etiquetas de origen quedan para un futuro ticket de
  compartir. Se conservan las vigentes.
- **P-40.** Se mantiene el estilo actual del botón «Iniciar sesión».
  GL-13 no modifica el login.
  - **Precisión de M264**, decidida por Pablo en la consulta de ese
    pedido: la spec `sign-in-presentation` de GL-11 exige que los campos,
    el botón y el foco del login sean los de la captura rápida y los demás
    botones. Por eso el login hereda solo el borde de campos `#857870`, el
    foco de la paleta y el botón común. No suma tarjeta, marca, fondo ni
    tipografía nuevos, y «Iniciar sesión» no pasa a botón principal. Para
    que eso se cumpla, «Guardar borrador» también queda como botón común.
  - **Precisión de M266:** hay que distinguir el botón de los campos.
    - **Botón «Iniciar sesión»:** es un botón común. Tiene el fondo, el
      borde y el color de texto `#2b2320` del botón común. No es un botón
      principal y no se vuelve terracota.
    - **Campos del login:** conservan el texto negro. Con la captura
      rápida comparten solo el borde y el foco acordados en M264.

Estas decisiones no autorizaban implementar. La implementación de GL-13
se autorizó aparte en M264; GL-14 sigue sin autorización.
- **Listado «Personas»:** GL-13 define solo su presentación con el
  lenguaje común. La referencia visual es `~/Descargas/Lista de
  personas@1x.png` (M256, confirmada en M257). El comportamiento nuevo
  del listado es de GL-14 (`docs/tickets/GL-14-mejoras-listado-personas.md`): la fila
  navegable, los conteos, «Último hecho», la búsqueda, el filtro, el orden
  alternativo, «Registrar la primera» y sus estados.
- **Pantallas futuras:** compartir, el feed y la administración quedan
  descritas en el mapa. Cada una se implementa con su propio ticket (I4,
  I6 y GL-04), usando este lenguaje visual.

## Exclusiones

- Funciones nuevas, destinos de navegación, roles, puntajes o
  recomendaciones automáticas que la propuesta aprobada no respalde.
- Compartir, el feed, los filtros, la administración, las invitaciones y
  el formulario «+ Feedback» (siguen diferidos).
- Cambiar el orden de la cronología: P-10 se mantiene (P-36, resuelta en
  M257).
- Una pestaña «Compartir» en la ficha (P-37, resuelta en M257).
- Los requisitos funcionales del listado «Personas»: la búsqueda, el
  filtro, el orden alternativo, los conteos ampliados y el acceso directo
  a la captura. Son de GL-14.
- Capturas o mocks nuevos en imagen: no hay una herramienta de diseño
  disponible para crearlos e inspeccionarlos. El diseño tiene un mapa en
  texto, marcado como propuesta.
- La comprobación manual de GL-11 (tarea 3.3), que sigue pendiente para
  el cierre de la entrega final.
- Render, configuración, datos y servicios.

## Criterios de aceptación

Son los de la capability `visual-language`:

- **CA1.** Tokens en `:root`, sin estilos en línea.
- **CA2.** Contraste AA en el texto y 3:1 en los bordes de los campos y
  en el foco.
- **CA3.** Estado, señal y origen siempre en texto.
- **CA4.** Un borrador se distingue a simple vista de una entrada lista.
- **CA5.** El resumen no se presenta como puntaje.
- **CA6.** Cabecera superior sin destinos inexistentes.
- **CA7.** A 375 px, sin desplazamiento horizontal y con áreas táctiles de
  44 px.
- **CA8.** Sin recursos de terceros.
- **CA9.** La presentación no cambia por sí sola el comportamiento, las
  acciones, los textos existentes ni el orden de la cronología. La única
  excepción es el aviso de privacidad de la ficha (CA10).
- **CA10.** La ficha muestra una vez el aviso breve de privacidad del
  listado, sin panel «Quién ve qué», y conserva las etiquetas de
  privacidad de cada entrada.
- **CA11.** El inicio de sesión conserva su fondo, su tipografía y su
  estructura. Solo cambian el borde de campos, el foco y el botón común,
  compartidos con la captura rápida (P-40, M264).

## Dependencias

- GL-05, GL-06, GL-07 y GL-11: las pantallas que se presentan.
- **Decisiones P-34 a P-40:** resueltas. Implementación autorizada en
  M264.
- **GL-14** va después y usa este lenguaje en el listado.
- **GL-11 sin archivar.** GL-13 no cambia `sign-in-presentation`: el
  login hereda lo que esa spec le exige compartir (P-40, M264).

## Riesgos

- **Adoptar la referencia tal como está** la haría contradecir decisiones
  aprobadas:
  - la dimensión «Claridad» frente a P-1;
  - el resumen sin Neutrales ni Total frente a P-2;
  - la cronología «Más recientes primero» frente a P-10;
  - «Compartida con Ada» frente a D4.

  El diseño las registra y las corrige.
- **Mostrar elementos de I4 o I6 antes de tiempo,** como los nombres de
  otros líderes, los filtros o el origen, viola `people-browsing`
  («Solo lectura y sin funciones inexistentes»).
- **Una paleta cálida con bordes suaves puede no llegar a 3:1** en los
  campos. Por eso el borde de campos es `#857870` (P-34), y el contraste
  se verifica al implementar.
- **El login comparte la hoja de estilos:** fuera del borde, el foco y el
  botón común, los tokens nuevos no deben cambiar su aspecto (P-40). Se
  comprueba con los estilos calculados registrados antes del cambio.
