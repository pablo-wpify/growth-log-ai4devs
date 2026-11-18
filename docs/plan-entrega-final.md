# Plan de la entrega final de Growth Log

> **Fuente única y vigente de la secuencia de trabajo de la entrega final.**
> Cada ticket tiene su detalle en `docs/tickets/` y su cambio de OpenSpec.
> Este documento decide qué sigue, en qué orden y con qué alcance. Ningún
> otro documento mantiene una secuencia propia para esta entrega.
>
> **Base:**
> - la propuesta aprobada de la entrega 1 (`propuesta-mvp.md` y
>   `anexos/`), que no se modifica: el Anexo G sigue siendo la referencia
>   de todo el alcance del MVP;
> - el [plan de la entrega 2](plan-entrega-2.md), **cerrado y de solo
>   lectura**. Sus decisiones P-1 a P-33 siguen vigentes en los términos
>   en que quedaron, y su tabla de lo diferido sigue siendo requisito
>   pendiente.
>
> Creado: 15/11/2026 (M254). Actualizado el mismo día con las mejoras
> propuestas del listado «Personas» en GL-13 (M255 y M256) y con su
> separación a GL-14, cuyas decisiones aprobó Pablo (M257 y M258). El
> 16/11/2026 (M261) Pablo decidió las de GL-13, y en M264 autorizó su
> implementación. GL-14 todavía no tiene la aprobación para implementar.
> Actualizado el 17/11/2026 con el cierre de GL-13, su retiro de la
> entrega 2 y la integración del README de la demo (sección 1). El mismo
> día, la tarea T2.1 del Anexo G recibió el ID GL-15 como borrador
> documental, y el 18/11/2026 GL-15 se implementó en local, sin commit
> (sección 2).

## 1. Punto de partida

- **Rama:** `feature/entrega-final-pp`, creada desde el cierre de la
  entrega 2 (`eabac8e`).
- **Hito alcanzado:** «recorrido núcleo» (GL-09). **No** se alcanzó el
  «primer recorrido usable» del Anexo G (I1), que necesita GL-04.
- **Heredado de la entrega 2, sin cerrar:**
  - GL-11 implementado y desplegado, **sin archivar**. Su tarea 3.3, la
    comprobación manual de Pablo, quedó diferida al cierre de esta entrega
    (M245), cuando la interfaz sea definitiva.
  - GL-10 cerrado con la comprobación manual en Render parcial (CA8).
  - Lo diferido sigue pendiente: GL-04, I4, I5, I6, I7, I8 e I9 (plan de la
    entrega 2, sección 5, «Diferido»).

### 1.1. Estado al 17/11/2026

- **GL-13:** implementado, verificado y archivado. El archivo del cambio
  de OpenSpec tiene commit en `68f74cc`, en esta rama. Es el único ticket
  de esta entrega que está implementado.
- **GL-13 y la entrega 2:** el PR #8 se mergeó en `feature/entrega-2-pp`
  con `e6fce0b`. Después ese contenido se retiró de esa rama con el
  revert `3dc4e90`, para que la entrega 2 conserve su estado de cierre.
  GL-13 sigue solo en `feature/entrega-final-pp`.
- **PR #9** (archivo de GL-13, de `feature/entrega-final-pp` hacia
  `feature/entrega-2-pp`): cerrado sin merge. Su CI sobre `68f74cc` pasó
  ([43939186173](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43939186173)).
- **README de la demo:** el acceso a la demo y el recorrido sugerido se
  publicaron en la entrega 2 con `13d6c5a`. El README de esta rama los
  incorpora junto con la descripción de la entrega final.
- **P-29 y P-30:** P-29 sigue vigente: las contraseñas demo se configuran
  como variables secretas de Render. P-30 quedó resuelta al publicar en
  el README las credenciales de las dos cuentas demo ficticias.
- **GL-14:** borrador documental (ticket, registros de prompts y cambio
  de OpenSpec), sin implementación ni autorización para implementar. La
  aprobación de Pablo para implementar sigue pendiente (tarea 0.6 de su
  cambio).
- **GL-15:** la tarea T2.1 («+ Feedback», criterios 2.1, 2.2 y 2.7) está
  implementada en local, sin commit (18/11/2026). Las decisiones de diseño
  están cerradas; la verificación local (specs y `bin/ci` en código 0) y
  la conformidad visual de Pablo están registradas en su diseño. No está
  publicada, integrada ni archivada.
- **Demo:** sirve `cad6afe`, el código de la entrega 2, sin GL-13.
  **Pendiente:** decidir si se actualiza para la entrega final.
- **Forma de entrega:** según lo observado por Pablo, el Typeform permite
  elegir «Entrega final» y pide el enlace de la rama. **Pendiente de
  confirmar con Julio:** la fecha de la entrega y los criterios concretos
  de revisión de la demo.

## 2. Secuencia

| Orden | ID | Objetivo | Estado | Depende de | Decisiones que lo bloquean |
|---|---|---|---|---|---|
| 1 | [GL-13](tickets/GL-13-direccion-visual.md) | Dirección visual transversal: paleta, tipografía, navegación, componentes y mapa de pantallas | **implementado, verificado y archivado; archivo con commit en `68f74cc`** (cambio archivado en [`2026-11-16-gl-13-direccion-visual`](../openspec/changes/archive/2026-11-16-gl-13-direccion-visual/); borrador en M254; las mejoras funcionales del listado pasaron a GL-14 en M257); decisiones P-34 a P-40 **resueltas** (M257, M261 y M264); implementación autorizada en M264 e implementado en M264 a M266, con `bin/ci` en código 0 en M270; conformidad visual de Pablo (tarea 3.3, M272); publicado en el PR #8 (M278 y M281) y mergeado en `feature/entrega-2-pp` con `e6fce0b`, merge **revertido** en esa rama con `3dc4e90`; PR #9 cerrado sin merge, con CI en verde sobre `68f74cc` | GL-05, GL-06, GL-07, GL-11 | — |
| 2 | [GL-15](tickets/GL-15-formulario-feedback.md) | Formulario completo «+ Feedback» en la ficha (T2.1 del Anexo G; criterios 2.1, 2.2 y 2.7, más 2.3 a 2.5 y 2.10 aplicados al formulario) | **implementado en local, sin commit** (cambio [`gl-15-formulario-feedback`](../openspec/changes/gl-15-formulario-feedback/proposal.md); borrador del 17/11/2026, implementación autorizada e implementada el 18/11/2026); decisiones de diseño cerradas; verificación local (specs y `bin/ci` en código 0) y conformidad visual de Pablo registradas; sin publicar, integrar ni archivar | T1.6 (GL-06), cumplida; GL-13 para los tokens y componentes | — (falta `bin/bundler-audit update`, tarea 3.1; publicación y cierre, cada paso con autorización) |
| 3 | [GL-14](tickets/GL-14-mejoras-listado-personas.md) | Mejoras funcionales del listado «Personas» | **borrador documental** (cambio [`gl-14-mejoras-listado-personas`](../openspec/changes/gl-14-mejoras-listado-personas/proposal.md), M257); decisiones P-41 a P-53 **aprobadas** (M257 y M258); sin implementar ni autorización para implementar | GL-05, GL-06, GL-07; GL-13 para los tokens y componentes | la aprobación para implementar |
| — | GL-11, tarea 3.3 | Comprobación manual de Pablo y archivo | pendiente (M245) | GL-13, GL-15 y GL-14, si se implementan | — |

**El orden de lo diferido lo decide Pablo:** GL-04, compartir y revocar
(I4), el autor sin asignación (I5), el feed y los filtros (I6), y I7, I8 e
I9. Cada uno recibe su ID cuando se planifique, sin reutilizar números.
GL-13 no los adelanta. Solo prevé su presentación en el mapa de pantallas
de su diseño. El formulario «+ Feedback» (T2.1, diferido en la entrega 2
por P-11) recibió el ID GL-15 el 17/11/2026.

**Por qué este orden.** GL-13 define los tokens y los componentes que usa
el listado de GL-14. Así el listado se construye una sola vez con su forma
final. GL-14 no depende de GL-13 en su comportamiento: si P-34 o P-35 se
demoran, Pablo puede invertir el orden, y el listado se adapta después al
lenguaje visual. GL-15 va antes que GL-14 porque completa criterios ya
definidos de H2, depende solo de T1.6, ya cumplida, y GL-14 sigue sin
autorización para implementar. El orden entre los dos no cambia el
alcance de ninguno. La comprobación manual de GL-11 va al final, cuando la
interfaz sea definitiva (M245).

**ID elegidos:** GL-13 era el siguiente libre, después de GL-12 del plan
de la entrega 2. GL-14 es el siguiente después de GL-13 (M257): no hay
otro GL-14 en el repositorio, los cambios de OpenSpec ni las ramas.

## 3. GL-13. Dirección visual (implementado y archivado)

Implementado, verificado y archivado; el archivo tiene commit en
`68f74cc` (sección 1.1). Lo que sigue describe su alcance.

- **Problema:** la paleta es genérica y cada pantalla se resolvió por
  separado. Un borrador solo se distingue de una entrada lista por su
  texto, y no hay una forma prevista para compartir, el feed ni la
  administración.
- **Referencia:** imagen candidata aportada por Pablo (M254), con
  navegación superior y tonos crema, terracota, marrón y verde salvia. Es
  una referencia para explorar, no una especificación ni una decisión. El
  listado tiene su propia referencia, `~/Descargas/Lista de
  personas@1x.png` (M256, confirmada en M257).
- **Resultado propuesto:**
  - capability nueva `visual-language`;
  - tokens y componentes;
  - navegación;
  - un mapa de las siete pantallas pedidas, con su respaldo y sus estados.

  La implementación queda limitada a las pantallas con sesión que ya
  existen y no cambia su comportamiento, salvo el aviso de privacidad de
  la ficha (P-38, delta `ADDED` de `people-browsing`). El inicio de sesión
  solo hereda el borde de campos, el foco y el botón común (P-40,
  precisada en M264 y M266).
- **Decidido por Pablo en M261:** P-34, P-35 y P-38 a P-40 (sección 5.1).
- **La referencia contradice decisiones vigentes:**
  - la dimensión «Claridad» frente a P-1;
  - el resumen sin Neutrales ni Total frente a P-2;
  - el orden «Más recientes primero» en la ficha frente a P-10;
  - «Compartida con Ada» frente a D4;
  - la pestaña «Compartir» frente a H5.

  El diseño las corrige. **En M257 Pablo confirmó** que P-10 se mantiene
  y que no se agrega la pestaña «Compartir» (P-36 y P-37).
- **Fuera:** funciones, destinos, roles o puntajes nuevos; las mejoras
  funcionales del listado (GL-14); compartir, el feed, los filtros y la
  administración; mocks en imagen; Render.

## 4. GL-14. Mejoras del listado «Personas» (borrador documental)

- **Origen:** propuestas en GL-13 (M255 y M256) y separadas en M257 a
  pedido de Pablo.
- **Ya aprobado y sin cambios:** solo las personas activas asignadas,
  **por nombre como orden predeterminado** (1.14), con conteos que solo
  incluyen lo visible (1.15) y un mensaje si no hay personas (1.16).
- **Aprobado por Pablo en M257:**
  - fila de enlace completo, con foco visible y sin anidar;
  - nombre arriba y «rol · equipo» debajo;
  - conteos neutrales (P-41);
  - «Último hecho» (P-42);
  - búsqueda y filtro (P-43);
  - «Hechos más recientes» como opción (P-44);
  - «Registrar la primera» (P-45);
  - vacío frente a persona sin entradas;
  - sin resultados, «Limpiar filtros» y 375 px.
- **Aprobado por Pablo en M258:** P-46 a P-53 (sección 5.3). Además,
  «Registrar la primera» y los conteos se deciden solo con las entradas
  visibles para la cuenta y sus borradores propios, sin consultas
  globales.
- **Specs:**
  - `people-browsing`: textos y comportamiento del listado;
  - `feedback-capture`: el acceso directo a la captura;
  - `authorization`: el alcance de las lecturas agregadas, sin textos de
    pantalla ni cambios en el modelo de permisos.

  Todo como deltas, sin editar la propuesta original.
- **Abierto:** solo la aprobación para implementar.
- **Fuera:** la presentación (GL-13), la ficha, I4, I6, GL-04 y Render.

## 5. Decisiones de la entrega final

La numeración continúa la del plan de la entrega 2, que terminó en P-33,
para que ningún número se repita. La columna «Estado» indica qué resolvió
Pablo y en qué mensaje.

### 5.1. GL-13

Todas resueltas por Pablo. Resolverlas no autorizaba implementar: la
implementación se autorizó aparte, en M264.

| # | Decisión | Resuelta en |
|---|---|---|
| P-34 | Paleta cálida, con borde de campos `#857870` y «A mejorar» en ámbar; el contraste se verifica al implementar. Azul para enlaces y etiquetas de contenido compartido, como en la referencia; nunca para las señales de feedback | M261 |
| P-35 | Fuente serif con licencia OFL, alojada en la aplicación, para un aspecto igual en todos los equipos; licencia registrada y sin carga desde servicios externos | M261 |
| P-36 | Se mantiene P-10: la cronología de la ficha va de la más antigua a la más reciente. El texto de P-10 y la spec `feedback-summary` no cambian | M257 |
| P-37 | Sin pestaña «Compartir» en la ficha: compartir ocurre sobre una entrada lista, en su detalle (H5, 5.6, mock 3) | M257 |
| P-38 | La ficha lleva el mismo aviso breve de privacidad que el listado, sin el panel «Quién ve qué». No van el menú «⋯» ni el menú desplegable de la cuenta; «Cerrar sesión» sigue visible, como exige la spec | M261 |
| P-39 | Las etiquetas de origen quedan para un futuro ticket de compartir; se conservan las vigentes | M261 |
| P-40 | Se mantiene el estilo del botón «Iniciar sesión»: no pasa a botón principal (M261). Precisada en M264: el inicio de sesión hereda solo lo que la spec de GL-11 le exige compartir con la captura rápida (borde de campos, foco y botón común). No suma tarjeta, marca, fondo ni tipografía nuevos. «Guardar borrador» queda como botón común. Precisada en M266: «Iniciar sesión» es un botón común, con su fondo, su borde y su color de texto `#2b2320`; no es un botón principal ni se vuelve terracota. Los campos del login conservan el texto negro y comparten con la captura rápida solo el borde y el foco acordados en M264 | M261, M264 y M266 |

### 5.2. GL-14, aprobadas por Pablo (M257)

Se propusieron en GL-13 (M255) y Pablo las aprobó en M257 para GL-14, con
los textos que figuran acá. Las decisiones 1, 2, 8 y 9 del pedido no
tienen número propio. Eran recomendaciones o estados de GL-13 (R-10, R-11,
L8 y L9) y están en el [ticket de GL-14](tickets/GL-14-mejoras-listado-personas.md).

| # | Decisión aprobada | Cambio respecto de lo propuesto en M255 |
|---|---|---|
| P-41 | Conteos neutrales: «Sin entradas todavía» si no hay entradas en ningún estado; «Sin entradas listas · N borradores» si hay borradores propios y ninguna lista visible; «N entradas listas · M borradores» si hay de las dos. Las listas, limitadas a lo que el líder puede ver; los borradores, solo los propios | absorbe el conteo de borradores, que estaba en P-42 |
| P-42 | «Último hecho»: la fecha del hecho más reciente entre las entradas listas visibles; los borradores no cuentan | rótulo «Último hecho» en lugar de «Última entrada lista» |
| P-43 | Búsqueda por nombre y filtro por equipo, limitados a las personas activas asignadas al líder | el mecanismo lo fija P-51 |
| P-44 | Orden por nombre como predeterminado (1.14) y «Hechos más recientes» como opción, con la misma fecha que P-42; en empates, por nombre y después por ID | nombre «Hechos más recientes» en lugar de «Actividad reciente» |
| P-45 | «Registrar la primera» para una persona sin entradas: acción independiente de la fila, hacia la captura existente, con la misma autorización y vuelta a la ficha al guardar | sin cambios |

### 5.3. GL-14, aprobadas por Pablo (M258)

En M257 quedaron abiertas como consecuencias funcionales que las
decisiones anteriores no definían. Pablo las decidió en M258. Detalle en el
[diseño de GL-14, sección 5](../openspec/changes/gl-14-mejoras-listado-personas/design.md).

| # | Decisión aprobada |
|---|---|
| P-46 | Con entradas listas y ningún borrador: «N entradas listas» |
| P-47 | En «Hechos más recientes», las personas sin entradas listas visibles para la cuenta van al final; los borradores no participan del orden |
| P-48 | «Limpiar filtros» borra la búsqueda y el filtro por equipo y conserva el orden elegido |
| P-49 | Búsqueda por coincidencia parcial en el nombre, sin distinguir mayúsculas ni acentos |
| P-50 | «Sin equipo indicado» en el filtro si hay personas sin equipo; el modelo permite ese estado |
| P-51 | Búsqueda, filtro por equipo y orden se procesan en el navegador, sobre las personas autorizadas. La selección se pierde al recargar y no se guarda en la URL (precisado en M259) |
| P-52 | La captura abierta desde el listado vuelve a la ficha, como hoy |
| P-53 | Total «N personas que acompañás», que cuenta las personas asignadas y no cambia al filtrar, y aviso breve de privacidad, una sola vez. Sin personas asignadas, el mensaje vacío reemplaza el total y el aviso (confirmado en M259) |

## 6. Próximo paso

1. GL-13: cerrado. Implementado, verificado y archivado, con el archivo
   en `68f74cc`. Su merge en `feature/entrega-2-pp` (`e6fce0b`) se revirtió
   con `3dc4e90`, y el PR #9 se cerró sin merge. La comprobación manual
   (tarea 3.3) quedó cerrada con la conformidad de Pablo en M272.
2. GL-15: `bin/bundler-audit update` (tarea 3.1); después, commit, push y
   CI remoto, integración y archivo, cada paso con autorización de Pablo.
   Al completarlo, ajustar el delta de GL-14 (tarea 4.4 de GL-15).
3. GL-14: revisión de Pablo y aprobación explícita para implementar.
4. Demo: decidir si se actualiza para la entrega final. Hoy sirve
   `cad6afe`, sin GL-13.
5. Con Julio: confirmar la fecha de la entrega final y los criterios
   concretos de revisión de la demo.
6. GL-11, tarea 3.3: al cierre de esta entrega (M245).

GL-13 (M264) y GL-15 (18/11/2026, pedido sin número) tienen autorización
para implementar. GL-14 sigue sin ella.
