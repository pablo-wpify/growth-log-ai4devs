# GL-14. Mejoras del listado «Personas»

> Ticket de la entrega final de Growth Log. Lugar en la secuencia: [plan de
> la entrega final](../plan-entrega-final.md), única fuente de la secuencia
> de esta entrega. Cambio de OpenSpec, en borrador:
> [`gl-14-mejoras-listado-personas`](../../openspec/changes/gl-14-mejoras-listado-personas/proposal.md).
> **Estado: implementado en local el 21/11/2026, sin commit (tarea 0.6,
> M395).** Revisado por Pablo (tarea 0.4). Las decisiones 1 a 9 (P-41 a P-45)
> las aprobó Pablo en M257, y P-46 a P-53 en M258; M259 confirmó las
> interpretaciones de P-51 y P-53. El delta de `people-browsing` se
> ajustó el 19/11/2026 a la spec que dejó GL-15 (tarea 4.4 de GL-15), y
> los requisitos de los deltas se reestructuraron el 20/11/2026 por el
> largo que admite el modo estricto (diseño, sección 7). GL-13 y GL-15
> están cerrados. Queda abierta la publicación (grupo 4).

## Origen

Las mejoras se propusieron dentro de GL-13 (M255 y M256). En M257 Pablo
pidió separarlas de la dirección visual: GL-13 conserva la paleta, la
tipografía, la navegación, los componentes y el mapa de pantallas, y
GL-14 se queda con el comportamiento del listado. **ID:** GL-14 es el
siguiente libre. GL-13 es el último usado, y no hay otro GL-14 en el
repositorio, los cambios de OpenSpec ni las ramas.

## Problema

El listado «Personas» es la página de inicio (P-15). Hoy muestra el
nombre, «rol · equipo» y «N entradas listas», también con 0, dentro de un
solo enlace por fila. «0 entradas listas» no distingue a una persona sin
nada de una con borradores. No se ve cuándo fue el último hecho, no se
puede buscar, filtrar ni ordenar, y para registrar la primera entrada hay
que pasar antes por la ficha.

## Objetivo

Un listado más útil para el líder, que no amplíe lo que la cuenta puede
ver.

## Ya aprobado y sin cambios

- Solo las personas activas con una asignación activa de la cuenta,
  **ordenadas por nombre por defecto** (1.14).
- Los conteos incluyen solo lo que la cuenta puede ver (1.15), y hay un
  mensaje cuando no hay personas (1.16).
- La propuesta original no se edita: los cambios van como deltas de
  OpenSpec.

## Decisiones aprobadas por Pablo (M257)

1. Los nombres son enlaces de fila completa, con foco de teclado visible,
   sin enlaces ni botones anidados.
2. Nombre y, debajo, «rol · equipo».
3. **P-41.** Etiquetas neutrales:
   - sin entradas en ningún estado: «Sin entradas todavía»;
   - borradores propios, sin entradas listas visibles: «Sin entradas
     listas · N borradores»;
   - entradas listas visibles y borradores propios: «N entradas listas · M
     borradores».

   Las listas se limitan a lo que el líder puede ver; los borradores
   cuentan solo si son de ese líder.
4. **P-42.** «Último hecho»: la fecha del hecho más reciente entre las
   entradas listas visibles. Es la misma fecha que usa el orden «Hechos
   más recientes». Los borradores no cuentan para ninguno de los dos.
5. **P-43.** Búsqueda por nombre y filtro por equipo, limitados a las
   personas activas asignadas al líder.
6. **P-44.** El orden por nombre sigue como predeterminado (1.14).
   «Hechos más recientes» es una opción. En empates, por nombre y después
   por ID.
7. **P-45.** «Registrar la primera» para una persona sin entradas. Es una
   acción independiente de la fila, lleva a la captura existente,
   conserva la autorización y, al guardar, vuelve a la ficha.
8. La lista vacía, sin personas asignadas, se distingue de una persona
   sin entradas.
9. Estados sin resultados, limpieza de filtros y una presentación usable a
   375 px.

## Decisiones aprobadas por Pablo (M258)

- **P-46.** Con entradas listas y ningún borrador: «N entradas listas».
- **P-47.** En «Hechos más recientes», las personas sin entradas listas
  visibles para la cuenta van al final. Los borradores no participan.
- **P-48.** «Limpiar filtros» borra la búsqueda y el filtro por equipo y
  conserva el orden elegido.
- **P-49.** Búsqueda por coincidencia parcial en el nombre, sin distinguir
  mayúsculas ni acentos.
- **P-50.** «Sin equipo indicado» en el filtro si hay personas sin equipo.
  El modelo permite ese estado: el equipo es opcional.
- **P-51.** Búsqueda, filtro por equipo y orden se procesan en el
  navegador, sobre las personas autorizadas. La selección se pierde al
  recargar y no se guarda en la URL (precisado en M259).
- **P-52.** La captura abierta desde el listado vuelve a la ficha, como
  hoy.
- **P-53.** El total «N personas que acompañás», que cuenta las personas
  asignadas y no cambia al filtrar, y un aviso breve de privacidad que
  aparece una sola vez. Sin personas asignadas, el mensaje vacío
  reemplaza el total y el aviso (confirmado en M259).

**Privacidad de «Registrar la primera» (M258).** Su disponibilidad y los
conteos se deciden solo con las entradas visibles para la cuenta y sus
borradores propios, sin consultas globales. Si otro líder tiene entradas
sobre la persona, la fila del líder sin entradas se ve igual que si
nadie las tuviera.

## Alcance

- **`people-browsing`:** los textos y el comportamiento del listado: la
  fila, los conteos, «Último hecho», la búsqueda, el filtro, el orden, el
  vacío, sin resultados y 375 px.
- **`feedback-capture`:** «Registrar la primera», en dos requisitos
  nuevos; «Acceso visible a la captura rápida» no cambia.
- **`authorization`:** qué registros entran en las lecturas agregadas
  nuevas, sin definir los textos de los conteos ni cambiar el modelo de
  permisos.

## Exclusiones

- La paleta, la tipografía, la navegación y los componentes: son de
  GL-13.
- La ficha y el orden de su cronología (P-10). El delta de
  `people-browsing` repite, sin cambiarlo, lo que la spec vigente permite
  en la ficha desde GL-15: «Captura rápida» y «+ Feedback» con su
  formulario (ajuste del 19/11/2026, tarea 4.4 de GL-15).
- Compartir, el feed, los filtros de entradas y la administración (I4, I6
  y GL-04).
- Render, configuración, datos y servicios.

## Criterios de aceptación

Son los escenarios de los deltas:

- **CA1.** Fila de enlace completo, con foco visible y sin anidar.
- **CA2.** Nombre arriba y «rol · equipo» debajo.
- **CA3.** Conteos neutrales, con listas visibles y borradores propios.
- **CA4.** «Último hecho» sin borradores ni entradas de otros líderes.
- **CA5.** Búsqueda y filtro sin ampliar el alcance ni mostrar equipos
  ajenos.
- **CA6.** Orden por nombre predeterminado y «Hechos más recientes» con su
  desempate.
- **CA7.** «Registrar la primera» solo sin entradas propias o visibles,
  independiente de la fila, sin revelar entradas de otras cuentas, con 404
  fuera del alcance y vuelta a la ficha.
- **CA8.** Vacío del listado distinto de una persona sin entradas.
- **CA9.** Sin resultados con «Limpiar filtros», que conserva el orden, y
  375 px sin desplazamiento horizontal y con 44 px.
- **CA10.** Búsqueda, filtro y orden en el navegador, sin URL ni estado
  guardado al recargar.
- **CA11.** Total de personas asignadas y aviso de privacidad, una sola
  vez y fuera del estado vacío.

## Dependencias

- GL-05, GL-06 y GL-07: el listado, la captura y las lecturas por
  alcance.
- **GL-13 (archivado):** el listado usa sus tokens y componentes,
  definidos en la spec vigente `visual-language`. GL-14 no depende de
  GL-13 en su comportamiento.
- **GL-15 (archivado):** la ficha admite «+ Feedback»; el delta de
  `people-browsing` de GL-14 ya está ajustado a esa spec. La secuencia
  pone GL-14 después de GL-13 y GL-15.
- La aprobación de Pablo para implementar.

## Riesgos

- **Una lectura agregada nueva que se filtre fuera del alcance** mostraría
  actividad de otros líderes. Se prueba con otro líder de la misma
  persona.
- **Un atajo a la captura que no pase por la autorización.** Va a la misma
  ruta, que busca la persona en el alcance. Se prueba por URL directa.
- **Pruebas existentes que fijan «0 entradas listas»**
  (`spec/requests/people_counts_spec.rb` y
  `spec/requests/feedback_summary_privacy_spec.rb`): cambian junto con
  sus escenarios y se registran.
