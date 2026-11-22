# GL-17. Presentación del listado «Personas»

> Ticket de la entrega final de Growth Log. Lugar en la secuencia: [plan de
> la entrega final](../plan-entrega-final.md), única fuente de la secuencia
> de esta entrega. Cambio de OpenSpec:
> [`gl-17-presentacion-listado-personas`](../../openspec/changes/gl-17-presentacion-listado-personas/proposal.md).
> **Estado: borrador documental (M408, 21/11/2026), corregido en M410 y
> revisado por Pablo en M415.** `openspec validate --all --strict`: 22 de
> 22 (M410, tarea 0.2). Pablo dio su conformidad con el borrador y aprobó
> P-54 y P-55 (tarea 0.3, 21/11/2026, M415). **Implementado en local el
> 21/11/2026 (M417)**, con la autorización de Pablo para los grupos 1 a 3
> (tarea 0.4): `bin/ci` en código 0 con 471 ejemplos; sin commit.
> **Conformidad visual de Pablo el 22/11/2026 (M420, tarea 3.2).** Falta
> publicar y archivar, con autorización para cada paso.

## Origen

La revisión de UI de «Personas» (M404 a M407) auditó la pantalla que dejó
GL-14 con Impeccable y exploró una alternativa con Stitch, sobre las
capturas de M395 a 1280 y 375 px, con datos ficticios. En M408 Pablo pidió
un cambio documental con dos de las mejoras recomendadas. **ID:** GL-17
es el siguiente libre. GL-16 es el último usado, GL-04 sigue reservado
para lo diferido, y no hay otro GL-17 en el repositorio, los cambios de
OpenSpec ni las ramas. GL-14 está archivado y no se reabre.

## Problema

Hallazgos de la auditoría de M407 que este ticket atiende:

- **El total y el aviso van en una sola línea, unidos con «·».** A 375 px
  se cortan en tres renglones, y el aviso de privacidad se lee como parte
  del conteo.
- **«Registrar la primera» es un enlace de texto, junto a la píldora del
  conteo.** El espacio de la fila que lo rodea abre la ficha, así que un
  toque impreciso lleva a otro destino. Además, por su alto mínimo de
  44 px, esa fila es más alta que las demás (unos 132 px contra 109 a
  1280 px).

## Objetivo

Que el total y el aviso se lean por separado, y que «Registrar la
primera» se reconozca como una acción propia, distinta de la fila y del
conteo, sin cambiar el comportamiento del listado ni lo que la cuenta
puede ver.

## Aprobado por Pablo (M415)

- **P-54.** El total y el aviso de privacidad, en líneas apiladas: el
  total arriba y el aviso debajo, sin el separador «·». Los textos no
  cambian.
- **P-55.** Alternativa B de M405 para «Registrar la primera»: una acción
  secundaria pequeña, con el borde del botón común de GL-13, distinta del
  enlace de la fila y de la píldora del conteo. Desde 40 rem de ancho, la
  fecha, el conteo y la acción van a la derecha del nombre y de «rol ·
  equipo». Más angosto, siguen debajo, como hoy.

**Límite aceptado (M415):** P-55 mejora la señal visual de «Registrar la
primera», pero no elimina que un toque fuera del botón pueda abrir la
ficha. La fila sigue siendo un enlace completo (decisión 1 de GL-14).

## Alcance

- **`people-browsing`:** el requisito «Total de personas y aviso de
  privacidad» se modifica para pedir las dos líneas. Se agregan dos
  requisitos: «Registrar la primera» como acción secundaria, y la
  ubicación de los detalles de la fila desde 40 rem.
- Presentación del listado: vista y estilos de «Personas», con los tokens
  y componentes vigentes de `visual-language`.

## Exclusiones

- **Los selects en una sola fila en móvil.** Queda fuera: requiere
  revisar el requisito «Listado en pantalla angosta», que pide apilar la
  búsqueda, el filtro y el orden. A 375 px siguen apilados.
- El comportamiento de «Registrar la primera»: disponibilidad, destino,
  autorización y vuelta a la ficha. Las specs de `feedback-capture` no
  cambian.
- Textos, conteos, «Último hecho», búsqueda, filtro, orden y estados del
  listado de GL-14.
- Paleta, tipografía, tokens nuevos y la cabecera (GL-13).
- La ficha, Render y la demo.
- El hallazgo P3 de contraste de la píldora y los separadores: es
  decorativo y no incumple WCAG.
- **El listado que empieza bajo en móvil** (a 375 px, la primera fila en
  y=503 de 760 px; M411). Queda como hallazgo separado (M415).
- **El quiebre de la cabecera entre unos 600 y 767 px** (M411). Queda
  como hallazgo separado (M415).

## Criterios de aceptación

Son los escenarios del delta:

- **CA1.** El total y el aviso, una sola vez, en dos líneas y sin «·»; el
  total no cambia al buscar ni al filtrar y no aparece en el estado
  vacío.
- **CA2.** «Registrar la primera» con borde visible, al menos 44 px de
  alto, fuera del enlace de la fila y con un aspecto distinto del de la
  píldora del conteo y del de un botón principal.
- **CA3.** Desde 40 rem, la fecha, el conteo y «Registrar la primera» a
  la derecha del nombre y de «rol · equipo»; a 375 px, debajo y sin
  desplazamiento horizontal. El corte se comprueba a 640 px (40 rem),
  con los detalles a la derecha, y a 639 px, con los detalles debajo.
  Las pruebas a 1280 y 375 px se mantienen.

## Dependencias

- **GL-14 (archivado):** el listado, sus textos y el requisito «Listado
  en pantalla angosta», que no cambia.
- **GL-13 (archivado):** tokens, botón común y foco de `visual-language`.
- La revisión de Pablo del borrador y su aprobación para implementar.

## Riesgos

- **Toques imprecisos que siguen abriendo la ficha.** El enlace de la
  fila completa (decisión 1 de GL-14) se conserva. El borde reduce el
  error, pero no lo elimina. Se verifica en la revisión visual a 375 px.
  Pablo aceptó este límite al aprobar P-55 (M415).
- **Una columna derecha apretada entre 40 y 48 rem.** Con un conteo largo
  y la acción, la columna puede partirse en dos renglones. Se prueba a
  640 px, justo en el corte, y a 639 px, justo por debajo.
- **Pruebas que fijan la línea única del total** o la posición de la
  acción: cambian junto con sus escenarios y se registran.
