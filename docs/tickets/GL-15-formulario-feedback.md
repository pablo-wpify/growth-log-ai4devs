# GL-15. Formulario completo «+ Feedback» en la ficha

> Ticket de la entrega final de Growth Log. Lugar en la secuencia: [plan de
> la entrega final](../plan-entrega-final.md), única fuente de la secuencia
> de esta entrega. Cambio de OpenSpec:
> [`gl-15-formulario-feedback`](../../openspec/changes/gl-15-formulario-feedback/proposal.md).
> **Estado (18/11/2026): implementado en local, sin commit.** Decisiones
> de diseño cerradas; verificación local (specs y `bin/ci` en código 0) y
> conformidad visual de Pablo registradas (diseño, sección 8). Sin
> publicar, integrar ni archivar.

## Origen

Es la tarea T2.1 del [Anexo G](../../anexos/anexo-g-plan-incremental.md)
(incremento I2): «formulario completo "+ Feedback" en la ficha», que
depende de T1.6 y se acepta con «tests de validación y de sistema». En la
entrega 2 se difirió con P-11 (12/11/2026): el recorrido priorizado empezó
por la captura rápida, y los campos y validaciones de H2 se cubrieron al
completar un borrador (GL-06). Lo diferido sigue siendo requisito
pendiente. **ID:** GL-15 es el siguiente libre después de GL-14; no hay
otro GL-15 en el repositorio, los cambios de OpenSpec ni las ramas.

## Problema

Hoy el único acceso para registrar feedback desde la ficha es «Captura
rápida», que pide solo el texto y guarda un borrador (GL-06, P-22). No hay
forma de registrar una entrada completa de una sola vez ni de guardarla
directamente como lista. Los criterios 2.1, 2.2 y 2.7 de H2 siguen sin
cubrir, y la spec `people-browsing` hoy prohíbe mostrar «+ Feedback» en la
ficha porque la función no existía.

## Criterios de origen (Anexo A, H2)

Texto de `anexos/anexo-a-historias.md:108`, `:109` y `:114`, sin cambios:

- **2.1.** Cuando toco «+ Feedback» en la ficha de una persona, entonces el
  formulario se abre en la misma página.
- **2.2.** Cuando se abre el formulario, entonces la fecha viene con el día
  de hoy.
- **2.7.** Cuando creo una entrada, entonces puedo guardarla como borrador
  o como lista.

La tarea T2.1 incluye además 2.3, 2.4, 2.5 y 2.10 (`anexo-g:81`). Esos
criterios ya rigen la edición de una entrada (GL-06) y este cambio los
aplica al formulario nuevo, sin ampliarlos.

## Decisiones vigentes que se aplican

- **P-1 y P-2:** dimensiones y señales de lista fija.
- **P-3:** una entrada lista exige dimensión y señal (amplía 2.6).
- **P-20:** escribir exige autoría, asignación activa y persona activa.
- **P-22:** rige solo la **captura rápida** (página propia, sin Turbo
  frame). No se extiende a este formulario, cuyo criterio 2.1 pide la
  misma página.
- **P-23:** «hoy» es la fecha de `America/Argentina/Buenos_Aires`.
- **P-34 y P-38 (GL-13):** lenguaje visual y aviso de privacidad de la
  ficha.

## Objetivo

Que el líder asignado abra, desde la ficha y sin salir de ella, un
formulario con todos los campos de una entrada, con la fecha de hoy, y lo
guarde como borrador o como lista, con las mismas validaciones, la misma
autorización y la misma privacidad que ya tienen las entradas.

## Alcance

- **`feedback-capture`:** acceso «+ Feedback» en la ficha; formulario
  completo en la misma página, que también funciona sin JavaScript;
  guardar como borrador o como lista; volver a la ficha con un aviso o
  mostrar los errores en el formulario.
- **`people-browsing`:** la ficha deja de prohibir «+ Feedback» y lo
  suma a sus acciones permitidas.
- Sin cambios de modelo ni de base: la tabla de entradas ya tiene todos
  los campos y restricciones.

## Exclusiones

- La captura rápida y P-22: no cambian.
- Compartir, el feed, los filtros, la administración y las invitaciones.
- Volver a borrador o borrar una entrada (backlog de H3).
- GL-14 (listado «Personas»), sin autorización para implementar.
- Render y la demo.

## Criterios de aceptación

- **CA1 (2.1).** La ficha de una persona asignada y activa muestra
  «+ Feedback» como acción secundaria, y «Captura rápida» sigue como
  principal; al tocarlo, el formulario se abre en la misma página. Sin
  JavaScript, el enlace y el formulario funcionan como una página común.
- **CA2 (2.2).** El formulario abre con la fecha del hecho precargada con
  la fecha actual según la zona horaria configurada en la aplicación
  (P-23); se puede cambiar antes de guardar y se guarda la fecha elegida.
- **CA3 (2.3).** Sin contexto o sin fecha, no se guarda y el formulario
  se vuelve a mostrar con el error.
- **CA4 (2.4 y 2.5).** El formulario ofrece señal y dimensión de la lista
  fija, y evidencia, impacto y confianza de 1 a 5, opcionales.
- **CA5 (2.7).** Se puede guardar con «Guardar borrador» o «Guardar como
  lista». En un borrador, señal y dimensión son opcionales; como lista,
  se exigen las dos (2.6 y P-3), y si faltan no se guarda y el formulario
  muestra qué falta. Sin estado, la entrada queda en borrador, como ya
  define el modelo; un estado desconocido es un error de validación y no
  se guarda. Al guardar, vuelve a la ficha con un aviso de éxito.
  «Cancelar» vuelve a la ficha sin guardar.
- **CA6 (2.8 y 2.9).** La entrada guardada queda con la cuenta como
  autora y privada, en cualquiera de los dos estados; ningún texto dice
  «Publicar».
- **CA7 (2.10 y P-20).** Sin asignación activa o con la persona inactiva,
  no se abre el formulario ni se crea la entrada, también por URL
  directa (404).

## Criterios de diseño

Detalle en la [sección 4 del diseño](../../openspec/changes/gl-15-formulario-feedback/design.md#4-criterios-de-diseño).

**Acordados por Pablo (18/11/2026):**

1. El formulario se presenta en la ficha, con mejora progresiva: con
   JavaScript, dentro de la ficha; sin JavaScript, como enlace y página
   comunes.
2. Al guardar bien, vuelve a la ficha con un aviso de éxito; con errores
   de validación, el formulario se vuelve a mostrar con los errores.
3. Las acciones se llaman «Guardar borrador» y «Guardar como lista».
4. Señal y dimensión: opcionales en un borrador, obligatorias para
   guardar como lista (P-3).
5. Sin estado, borrador, como ya define el modelo; un estado desconocido
   es un error de validación, no un borrador.
6. «Captura rápida» conserva su jerarquía de acción principal;
   «+ Feedback» es una acción secundaria común.
7. GL-15 va antes que GL-14; al completar GL-15 se ajusta el delta de
   GL-14 (ver «Riesgos»).

**Decisión técnica:** Turbo Frames con HTML renderizado por Rails, con el
Hotwire que ya trae el proyecto. Sin actualizar Rails, sin SPA, sin
JavaScript propio, sin dependencias nuevas y sin Turbo Streams. Es una
decisión de implementación, no un requisito de producto.

**Cerrados por Pablo (18/11/2026):**

- Las rutas siguen las convenciones de la aplicación (recursos REST con
  `only:`, segmentos en español, creación anidada bajo la persona); la URL
  no es un requisito de producto.
- Al guardar como lista, el aviso es «Feedback guardado como lista.».
- «Cancelar» vuelve a la ficha de la persona sin guardar los cambios.

**Aviso y privacidad:** «Feedback guardado como lista.» es un aviso
genérico que solo confirma que la operación se completó. No incluye el
texto del feedback ni datos que revelen su contenido o a quién se
refiere. El delta modifica el criterio del texto de los avisos en
«Textos que separan "lista" de "compartida"», no la regla de privacidad:
la entrada sigue siendo privada de su autor. Detalle en la sección 4.3
del diseño.

## Dependencias

- **T1.6 (GL-06):** cumplida. Reutiliza el modelo, las validaciones, la
  autorización y los textos de privacidad de las entradas.
- **GL-13:** tokens y componentes de la ficha.
- **GL-14:** no depende de GL-14, pero los dos modifican el requisito
  «Solo lectura y sin funciones inexistentes» de `people-browsing` (ver
  «Riesgos»).

## Riesgos

- **Un segundo camino de escritura sin autorización.** Se mitiga
  reutilizando la política y el alcance de la captura, con pruebas
  negativas por URL directa.
- **Confundir «lista» con «compartida».** Se mantienen los textos
  «solo vos» y no se usa «Publicar».
- **Deltas superpuestos con GL-14.** GL-14 también modifica «Solo lectura
  y sin funciones inexistentes» y, en su texto, sigue prohibiendo
  «+ Feedback» en la ficha. GL-15 va primero: al completarlo, se ajusta
  el delta de GL-14 sobre la spec que deje GL-15 para que los dos
  requisitos queden compatibles, con el pedido de Pablo en ese momento.
  Este ticket no modifica GL-14.
- **Aviso que revele el feedback.** El aviso al guardar como lista no
  incluye el texto ni a quién se refiere; las pruebas de la tarea 1.2 lo
  comprueban.
- **Salir del frame al guardar.** Resuelto: el formulario se envía fuera
  del frame y, con errores, se vuelve a mostrar la ficha completa con el
  formulario; las pruebas de sistema lo cubren (diseño, secciones 3 y 8).

## Registro

El pedido que creó este borrador (17/11/2026) y el que acordó los
criterios de diseño (18/11/2026) todavía no tienen número ni registro:
la numeración de los pedidos posteriores a M284 está pendiente de la
decisión de Pablo (ver `prompts.md`).
