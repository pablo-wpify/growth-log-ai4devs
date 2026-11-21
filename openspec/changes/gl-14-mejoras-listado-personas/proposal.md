# Proposal

> **Borrador documental (M257 a M259, 15 y 16/11/2026), revisado por
> Pablo el 21/11/2026.** Sin implementar. Las mejoras 1 a 9 del listado
> (P-41 a P-45) están **aprobadas por Pablo en M257**, y P-46 a P-53 en
> M258; M259 confirmó las interpretaciones de P-51 y P-53. El delta de
> `people-browsing` se ajustó el 19/11/2026 a la spec que dejó GL-15
> (tarea 4.4 de GL-15, M355), y los requisitos de los deltas se
> reestructuraron el 20/11/2026 en la revisión de Pablo (tarea 0.4), con
> `openspec validate --all --strict` en 22 de 22 (diseño, sección 7).
> Pablo dio su conformidad al borrador el 21/11/2026 (tarea 0.4). Sigue
> abierta la aprobación para implementar (0.6)
> (`docs/plan-entrega-final.md`).

## Why

El listado «Personas» es la página de inicio (P-15). Hoy muestra, para
cada persona, el nombre, «rol · equipo» y «N entradas listas», también con
0, todo dentro de un único enlace por fila
(`app/views/people/index.html.erb`). Eso deja cuatro problemas:

- «0 entradas listas» no distingue a una persona sin nada registrado de
  una con borradores sin terminar;
- el líder no ve cuándo fue el último hecho registrado sobre cada persona;
- con varias personas, no hay forma de buscar, filtrar ni ordenar por
  actividad;
- para registrar la primera entrada hay que entrar antes a la ficha.

Estas mejoras se propusieron dentro de GL-13 (M255 y M256). En M257 Pablo
las separó de la dirección visual y las aprobó como este ticket, con
ajustes de texto: «Último hecho» y «Hechos más recientes».

Fuente: `docs/tickets/GL-14-mejoras-listado-personas.md`.

## What Changes

Las nueve mejoras aprobadas en M257:

1. Filas con un único enlace de fila completa, foco de teclado visible y
   sin enlaces ni botones anidados.
2. Nombre arriba y «rol · equipo» debajo.
3. Conteos neutrales: «Sin entradas todavía», «Sin entradas listas · N
   borradores» y «N entradas listas · M borradores». Las listas, solo las
   visibles; los borradores, solo los propios.
4. «Último hecho: <fecha>», con la fecha del hecho más reciente entre las
   entradas listas visibles.
5. Búsqueda por nombre y filtro por equipo, limitados a las personas
   activas asignadas.
6. Orden «Nombre», el predeterminado (1.14), y «Hechos más recientes»,
   con desempate por nombre e identificador.
7. «Registrar la primera» para una persona sin entradas: un enlace
   independiente de la fila, hacia la captura existente, con la misma
   autorización y la vuelta a la ficha al guardar.
8. El estado vacío del listado se distingue de una persona sin entradas.
9. El estado sin resultados, «Limpiar filtros» y una presentación usable
   a 375 px.

Y sus precisiones, aprobadas en M258 (P-46 a P-53):

- «N entradas listas» cuando no hay borradores;
- en «Hechos más recientes», las personas sin entradas listas visibles al
  final;
- «Limpiar filtros» conserva el orden elegido;
- búsqueda parcial sin mayúsculas ni acentos;
- «Sin equipo indicado» en el filtro si hay personas sin equipo;
- búsqueda, filtro por equipo y orden en el navegador, sobre las
  personas autorizadas; la selección se pierde al recargar y no va a la
  URL;
- la captura abierta desde el listado vuelve a la ficha;
- el total de personas asignadas, que no cambia al filtrar, y un aviso
  breve de privacidad, una sola vez; sin personas asignadas, el mensaje
  vacío los reemplaza (confirmado en M259).

«Registrar la primera» se decide solo con las entradas visibles y los
borradores propios, y no revela entradas de otras cuentas.

**No incluye:**

- cambios en la propuesta original ni en el modelo de permisos;
- funciones de I4 o I6: compartir, el feed ni filtros de entradas;
- la paleta, la tipografía ni los componentes, que son de GL-13;
- Render, datos ni servicios.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `people-browsing`, fuente de los textos y del comportamiento del
  listado:
  - `MODIFIED` «Listado de personas asignadas»: nombre arriba y «rol ·
    equipo» debajo. El orden por nombre sigue como predeterminado (1.14).
    Conserva sus escenarios, incluidos «Conteo de entradas listas» y
    «Conteo con otro líder de la misma persona», con los textos de GL-14;
  - `MODIFIED` «Estado vacío»: se distingue de una persona sin entradas;
  - `MODIFIED` «Solo lectura y sin funciones inexistentes»: admite en el
    listado la búsqueda, el filtro, el orden, «Limpiar filtros» y
    «Registrar la primera». En la ficha conserva lo que dejó GL-15:
    «Captura rápida» y «+ Feedback» con su formulario (ajuste del
    19/11/2026, tarea 4.4 de GL-15);
  - `ADDED`: «Conteos de entradas en el listado» y «Conteos limitados a lo
    visible para la cuenta», con escenarios propios («Conteos en singular
    y en plural» y «Entradas de otro líder sobre una persona con entradas
    propias»), y «Fila del listado navegable con teclado»,
    «Fecha del último hecho», «Búsqueda y filtro del listado», «Orden por
    hechos más recientes», «Sin resultados de búsqueda o filtro»,
    «Búsqueda, filtro y orden en el navegador», «Total de personas y aviso
    de privacidad» y «Listado en pantalla angosta».
- `feedback-capture`: `ADDED` «Registrar la primera desde el listado» y
  «"Registrar la primera" decidido con el alcance de la cuenta».
  «Acceso visible a la captura rápida» no cambia.
- `authorization`: `MODIFIED` «Lecturas agregadas con el alcance de
  entradas», que conserva sus tres escenarios, incluido «Autor», y
  `ADDED` «Lecturas agregadas de la ficha y del listado», con el
  escenario propio «Orden y acceso del listado desde el alcance»: con una
  entrada lista propia sobre B y solo un borrador propio sobre A, una
  entrada lista posterior de otro líder sobre A no la adelanta en
  «Hechos más recientes» (B queda antes que A) ni le da «Último hecho», y
  el borrador propio impide mostrar «Registrar la primera» en A.
  **No cambia el modelo de permisos.** Hace falta por dos motivos:
  - el requisito vigente enumera tres lecturas: el resumen, la cronología
    y el conteo. Los conteos de borradores, la fecha, el orden y la
    decisión de mostrar «Registrar la primera» son lecturas agregadas
    nuevas y tienen que quedar cubiertas explícitamente;
  - su escenario de la administradora fija el texto de pantalla «0
    entradas listas», que GL-14 reemplaza en `people-browsing`.

  El delta generaliza la regla a toda lectura agregada, enumera en el
  requisito nuevo las lecturas de la ficha y del listado y describe qué
  registros entran, sin definir los textos de los conteos. El alcance,
  las políticas y las reglas de lectura y escritura no cambian.

## Impact

- **Código, al implementar:**
  - `PeopleController#index`: una consulta agregada sobre
    `policy_scope(FeedbackEntry)` para los conteos y la fecha;
  - `app/views/people/index.html.erb` y `people_helper.rb`;
  - un controlador Stimulus para la búsqueda, el filtro y el orden en el
    navegador (P-51), sin dependencias nuevas;
  - estilos del listado con los tokens y componentes de la spec vigente
    `visual-language` (GL-13, archivado).

  Rutas de captura, políticas y modelos sin cambios.
- **Pruebas, al implementar:** de peticiones y de sistema, incluidas las
  del actor que no debe influir y la URL directa. Cambian las pruebas
  existentes que comprueban «0 entradas listas»
  (`spec/requests/people_counts_spec.rb` y
  `spec/requests/feedback_summary_privacy_spec.rb`), junto con sus
  escenarios.
- **Secuencia:** después de GL-13, cuyos tokens y componentes usa el
  listado, y de GL-15; los dos están cerrados. Ver el plan de la entrega
  final.
