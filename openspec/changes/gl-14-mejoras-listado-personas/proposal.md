# Proposal

> **Borrador documental (M257, completado en M258, 15/11/2026), para
> revisión de Pablo.** Sin implementar. Las mejoras 1 a 9 del listado
> (P-41 a P-45) están **aprobadas por Pablo en M257**, y P-46 a P-53 en
> M258. Falta la aprobación del cambio para implementarlo
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
  - `MODIFIED` «Listado de personas asignadas»: dos líneas y conteos
    neutrales. El orden por nombre sigue como predeterminado (1.14);
  - `MODIFIED` «Estado vacío»: se distingue de una persona sin entradas;
  - `MODIFIED` «Solo lectura y sin funciones inexistentes»: admite la
    búsqueda, el filtro, el orden, «Limpiar filtros» y «Registrar la
    primera»;
  - `ADDED`: «Fila del listado navegable con teclado», «Fecha del último
    hecho», «Búsqueda y filtro del listado», «Orden por hechos más
    recientes», «Sin resultados de búsqueda o filtro», «Búsqueda, filtro y
    orden en el navegador», «Total de personas y aviso de privacidad» y
    «Listado en pantalla angosta».
- `feedback-capture`: `MODIFIED` «Acceso visible a la captura rápida»,
  que agrega «Registrar la primera», decidido solo con el alcance de la
  cuenta.
- `authorization`: `MODIFIED` «Lecturas agregadas con el alcance de
  entradas». **No cambia el modelo de permisos.** Hace falta por dos
  motivos:
  - el requisito vigente enumera tres lecturas: el resumen, la cronología
    y el conteo. Los conteos de borradores, la fecha, el orden y la
    decisión de mostrar «Registrar la primera» son lecturas agregadas
    nuevas y tienen que quedar cubiertas explícitamente;
  - su escenario de la administradora fija el texto de pantalla «0
    entradas listas», que GL-14 reemplaza en `people-browsing`.

  El delta generaliza la regla a toda lectura agregada y describe qué
  registros entran, sin textos de pantalla. El alcance, las políticas y
  las reglas de lectura y escritura no cambian.

## Impact

- **Código, al implementar:**
  - `PeopleController#index`: una consulta agregada sobre
    `policy_scope(FeedbackEntry)` para los conteos y la fecha;
  - `app/views/people/index.html.erb` y `people_helper.rb`;
  - un controlador Stimulus para la búsqueda, el filtro y el orden en el
    navegador (P-51), sin dependencias nuevas;
  - estilos del listado con los tokens de GL-13, si ya están aprobados.

  Rutas de captura, políticas y modelos sin cambios.
- **Pruebas, al implementar:** de peticiones y de sistema, incluidas las
  del actor que no debe influir y la URL directa. Cambian las pruebas
  existentes que comprueban «0 entradas listas»
  (`spec/requests/people_counts_spec.rb`), junto con su escenario.
- **Secuencia:** después de GL-13, cuyos tokens y componentes usa el
  listado. Ver el plan de la entrega final.
