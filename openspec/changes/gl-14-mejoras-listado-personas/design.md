# Design

> **Borrador documental (M257 a M259, 15 y 16/11/2026), revisado por
> Pablo el 21/11/2026.** Implementado en local el 21/11/2026, sin
> commit (sección 7). Las mejoras 1 a 9 (P-41 a
> P-45) las aprobó Pablo en M257, y P-46 a P-53 en M258 (sección 5). El
> delta de `people-browsing` se ajustó el 19/11/2026 a la spec que dejó
> GL-15, y los requisitos de los deltas se reestructuraron el 20/11/2026
> (sección 7). Pablo dio su conformidad al borrador el 21/11/2026
> (tarea 0.4) y autorizó implementar los grupos 1 a 3 (tarea 0.6, M395).
> Queda abierto el grupo 4.

## 1. Fuentes

| Fuente | Uso |
|---|---|
| Criterios 1.14, 1.15 y 1.16 (Anexo A); PP-2, PP-3 y PP-6 | alcance aprobado del listado y de lo que la cuenta puede ver |
| Specs vigentes `people-browsing`, `feedback-capture` y `authorization` | textos y reglas que este cambio modifica con deltas explícitos |
| P-15, P-17, P-20 y P-22 | «Personas» es el inicio; «rol · equipo» y sus faltantes; la escritura exige asignación y persona activas; la captura es una página propia que vuelve a la ficha |
| Código en `eade6a6`: `PeopleController#index`, `people/index.html.erb` y `PeopleHelper` | lo implementado. La vista y el helper no cambiaron desde `eabac8e`; el controlador solo sumó `include PersonPage` (GL-15, `bb5db27`), sin cambios en `index`. Los estilos de la fila son de GL-13 (`c7d4165`) |
| Referencia `~/Descargas/Lista de personas@1x.png` (M256, confirmada en M257) | **referencia visual**, no requisito |
| Pedidos M257 y M258 | las decisiones aprobadas y su reparto entre specs |
| Spec vigente `visual-language` (GL-13, archivado en `2026-11-16-gl-13-direccion-visual`): «Tokens visuales en un solo lugar», «Contraste y foco» y «Pantallas angostas» | tokens, componentes y foco que usa el listado. No define su comportamiento |
| Spec vigente `people-browsing`, con el ajuste de GL-15 (archivado en `2026-11-19-gl-15-formulario-feedback`) | la ficha admite «Captura rápida» y «+ Feedback» con su formulario |

## 2. Ya aprobado antes de este cambio

- El listado muestra solo las personas activas con una asignación activa
  de la cuenta, **ordenadas por nombre** (1.14).
- El conteo incluye solo lo que la cuenta puede ver (1.15) y, sin
  personas, hay un mensaje que lo explica (1.16).
- P-10 no se toca: la cronología de la ficha sigue de la más antigua a la
  más reciente. GL-14 no cambia la ficha.

## 3. Decisiones aprobadas por Pablo (M257)

| # | Decisión | Número | Cómo se especifica |
|---|---|---|---|
| 1 | Enlaces de fila completa, con foco de teclado visible y sin enlaces ni botones anidados | — (era R-10 de GL-13) | `people-browsing`, «Fila del listado navegable con teclado» |
| 2 | Nombre y, debajo, «rol · equipo» | — (era R-11 de GL-13) | `people-browsing`, «Listado de personas asignadas» |
| 3 | Etiquetas neutrales: «Sin entradas todavía», «Sin entradas listas · N borradores» y «N entradas listas · M borradores». Las listas, limitadas a lo visible; los borradores, solo los propios | **P-41** | `people-browsing`, «Conteos de entradas en el listado» y «Conteos limitados a lo visible para la cuenta»; registros, `authorization` |
| 4 | «Último hecho»: la fecha del hecho más reciente entre las entradas listas visibles. Es la misma fecha que usa «Hechos más recientes». Los borradores no cuentan | **P-42** | `people-browsing`, «Fecha del último hecho» |
| 5 | Búsqueda por nombre y filtro por equipo, limitados a las personas activas asignadas | **P-43** | `people-browsing`, «Búsqueda y filtro del listado» |
| 6 | Orden por nombre como predeterminado (1.14) y «Hechos más recientes» como opción, con desempate por nombre y después por ID | **P-44** | `people-browsing`, «Orden por hechos más recientes» |
| 7 | «Registrar la primera» para una persona sin entradas: acción independiente de la fila, hacia la captura existente, con la misma autorización y la vuelta a la ficha al guardar | **P-45** | `feedback-capture`, «Registrar la primera desde el listado» y «"Registrar la primera" decidido con el alcance de la cuenta» |
| 8 | El vacío del listado se distingue de una persona sin entradas | — (era L8 de GL-13) | `people-browsing`, «Estado vacío» |
| 9 | Sin resultados, limpieza de filtros y 375 px | — (era L9 de GL-13) | `people-browsing`, «Sin resultados…» y «Listado en pantalla angosta» |

**Cambios respecto de lo propuesto en GL-13 (M255):**

- la fecha se rotula «Último hecho», no «Última entrada lista»;
- el orden alternativo se llama «Hechos más recientes», no «Actividad
  reciente»;
- el conteo de borradores propios pasa de P-42 a P-41.

**Qué significa «sin entradas».** Según la decisión 3, una persona está
«sin entradas» cuando la cuenta no tiene entradas listas visibles ni
borradores propios sobre ella. Es la misma condición para «Sin entradas
todavía» y para «Registrar la primera». **Se decide solo con el alcance
de entradas de la cuenta (M258):** no hay consultas globales, y las
entradas de otros líderes no cambian nada de la fila. Así, «Registrar la
primera» no revela si otra cuenta registró algo sobre esa persona: «la
primera» es la primera de esta cuenta.

**Dónde vive cada cosa:**

- **`people-browsing`:** los textos y el comportamiento del listado.
- **`feedback-capture`:** el acceso directo a la captura.
- **`authorization`:** qué registros entran en cada lectura agregada, sin
  definir los textos de los conteos. Su delta no cambia permisos (ver la
  propuesta).

## 4. Diseño técnico propuesto

### 4.1. Lecturas

Una sola consulta agregada sobre el alcance, en lugar de la actual de
`@ready_counts`:

```ruby
policy_scope(FeedbackEntry).where(person: @people).group(:person_id)
  .pluck(:person_id,
         Arel.sql("COUNT(*) FILTER (WHERE status = 'ready')"),
         Arel.sql("COUNT(*) FILTER (WHERE status = 'draft')"),
         Arel.sql("MAX(occurred_on) FILTER (WHERE status = 'ready')"))
```

- Hoy el alcance de entradas solo contiene las de la cuenta, así que los
  borradores son siempre propios (PP-3). Con I4, las compartidas
  vigentes entrarán al alcance como listas. Los borradores seguirán
  siendo propios, porque un borrador no se comparte (3.9).
- Nunca se consulta `FeedbackEntry` sin alcance. Es la misma protección
  que en GL-07: se prueba con otro líder de la misma persona.
- Es una lectura más por página, sin consultas por fila.
- «Registrar la primera» se muestra cuando esa misma lectura no trae
  ninguna fila para la persona. No hay otra consulta para decidirlo.

### 4.2. Fila

```
<li class="person-row">
  <a href="/personas/:id" class="person-row__link">  ← nombre accesible: el nombre
    Ada Ejemplo
  </a>
  <span>Desarrolladora · Equipo Faro</span>
  <span>Último hecho: 20/05/2026</span>
  <span>2 entradas listas · 1 borrador</span>
  <a href="/personas/:id/entradas/nueva">Registrar la primera</a>  ← hermano, solo sin entradas
</li>
```

- El enlace de la persona se extiende a toda la fila con un
  pseudoelemento. «Registrar la primera» queda por encima, fuera del
  enlace.
- El foco se ve alrededor de la fila con `:focus-within`.
- El chevron es decorativo (`aria-hidden`).
- La fecha usa el formato de la cronología (dd/mm/aaaa).
- Nombre accesible del atajo, para que no se repita igual en varias
  filas: «Registrar la primera entrada sobre <nombre>».

### 4.3. Búsqueda, filtro y orden (P-49 a P-51)

- **En el navegador (P-51),** con un controlador Stimulus sobre las filas
  que el servidor ya mostró con el alcance. No hay consultas nuevas, ni
  dependencias nuevas, ni el nombre buscado en la URL o en los registros.
- **Sin estado guardado:** al recargar, el listado vuelve por nombre, con
  la búsqueda vacía y el filtro en «Todos».
- **Sin JavaScript:** los controles no se muestran y queda el listado
  completo por nombre.
- **El orden usa el mismo mecanismo (P-51, precisada en M259):** la
  búsqueda, el filtro por equipo y el orden se procesan en el navegador.
  La selección se pierde al recargar y no se guarda en la URL. Así
  «Limpiar filtros» conserva el orden (P-48) sin otro estado.
  Cada fila lleva como atributos de datos el nombre normalizado, el
  equipo y la fecha del último hecho.
- **Búsqueda (P-49):** coincidencia parcial, sin mayúsculas ni acentos.
  Se compara el nombre normalizado de la fila (NFD, sin marcas
  diacríticas, en minúsculas) con el texto buscado normalizado igual.
- **Filtro (P-50):** «Todos», los equipos de las personas listadas y,
  solo si alguna no tiene equipo, «Sin equipo indicado». El modelo lo
  permite: `people.team` admite nulo y la fila ya muestra ese texto (P-17).
- **«Limpiar filtros» (P-48):** vacía la búsqueda y vuelve el filtro a
  «Todos». No toca el orden.
- **Total y aviso (P-53):** se calculan en el servidor con el mismo
  alcance de personas. El total no cambia con la búsqueda ni el filtro.

### 4.4. Esquema (propuesta, no es una captura)

```
Personas
3 personas que acompañás · Ves solo a quienes tenés asignados y las entradas que podés ver
[Buscar por nombre        ] [Equipo: Todos ▾] [Orden: Nombre ▾]
┌──────────────────────────────────────────────────────────────────┐
│ Ada Ejemplo                       Último hecho: 20/05/2026     › │
│ Desarrolladora · Equipo Faro      2 entradas listas · 1 borrador │
├──────────────────────────────────────────────────────────────────┤
│ Bruno Muestra                     Último hecho: 02/04/2026     › │
│ Diseñador · Equipo Norte          1 entrada lista                │
├──────────────────────────────────────────────────────────────────┤
│ Carla Muestra                     Sin entradas todavía         › │
│ Analista · Equipo Faro            Registrar la primera  ← enlace independiente │
└──────────────────────────────────────────────────────────────────┘
```

La referencia muestra «Última entrada [FECHA]» incompleto en una fila.
Acá se usa el texto aprobado, completo.

### 4.5. Estados

| Estado | Qué se ve |
|---|---|
| Sin personas asignadas (1.16) | El mensaje actual, sin total, aviso, búsqueda, filtro ni orden |
| Persona sin entradas | «Sin entradas todavía» y «Registrar la primera», sin fecha |
| Solo borradores propios | «Sin entradas listas · N borradores», sin fecha ni atajo |
| Listas visibles y borradores propios | «N entradas listas · M borradores» y «Último hecho» |
| Listas visibles sin borradores | «N entradas listas» y «Último hecho» (P-46) |
| Otro líder con entradas sobre una persona sin entradas propias | Igual que sin entradas: «Sin entradas todavía» y «Registrar la primera» |
| Sin resultados | «Ninguna persona coincide con la búsqueda o el filtro» y «Limpiar filtros»; el total y el aviso no cambian |
| Recarga | Todas las personas por nombre, sin búsqueda ni filtro |
| Sin JavaScript | Todas las personas por nombre, sin controles |
| Administradora asignada sin entradas | Igual que un líder: «Sin entradas todavía» |
| 375 px | Una columna, controles apilados y 44 px |

## 5. Decisiones aprobadas por Pablo (M258)

En M257 quedaron abiertas como consecuencias funcionales sin definir. En
M258 Pablo las decidió así, y los deltas las reflejan:

| # | Decisión | En el delta |
|---|---|---|
| P-46 | Con entradas listas y ningún borrador: «N entradas listas» | `people-browsing`, «Conteos de entradas en el listado» |
| P-47 | En «Hechos más recientes», las personas sin entradas listas visibles para la cuenta van al final. Los borradores no participan. Entre ellas rige el desempate de P-44 | `people-browsing`, «Orden por hechos más recientes» |
| P-48 | «Limpiar filtros» borra la búsqueda y el filtro por equipo y conserva el orden elegido | `people-browsing`, «Sin resultados de búsqueda o filtro» |
| P-49 | Coincidencias parciales en el nombre, sin distinguir mayúsculas ni acentos | `people-browsing`, «Búsqueda y filtro del listado» |
| P-50 | «Sin equipo indicado» en el filtro solo si hay personas sin equipo. El modelo permite ese estado | `people-browsing`, «Búsqueda y filtro del listado» |
| P-51 | Búsqueda, filtro por equipo y orden se procesan en el navegador, sobre las personas autorizadas. La selección se pierde al recargar y no se guarda en la URL (precisado en M259) | `people-browsing`, «Búsqueda, filtro y orden en el navegador» |
| P-52 | La captura abierta desde el listado vuelve a la ficha, como hoy | `feedback-capture`, «Registrar la primera desde el listado» |
| P-53 | Total «N personas que acompañás», que cuenta las personas asignadas y no cambia al filtrar, y aviso breve de privacidad, una sola vez. Sin personas asignadas, el mensaje vacío reemplaza el total y el aviso (confirmado en M259) | `people-browsing`, «Total de personas y aviso de privacidad» |

**Cómo se aplica «discretos y sin duplicar» (P-53, confirmado en
M259):** los dos van una sola vez, bajo el título, en texto secundario,
con los textos de la referencia. El total cuenta las personas asignadas y
no se repite como «X de N» al filtrar. Sin personas asignadas, el mensaje
vacío de 1.16 reemplaza el total y el aviso.

## 6. Riesgos y verificación prevista

- **Privacidad de las lecturas nuevas:** los conteos, la fecha y el orden
  se prueban con el actor que **no** debe influir: otro líder de la misma
  persona, con una entrada lista posterior y un borrador.
- **Autorización del atajo:** «Registrar la primera» se prueba por URL
  directa, en `new` y en `create`, con una persona fuera del alcance
  (404, sin entrada creada).
- **El atajo no revela entradas ajenas:** se prueba con otro líder de la
  misma persona que tiene una entrada lista y un borrador. La fila del
  líder sin entradas muestra igual «Sin entradas todavía» y «Registrar la
  primera».
- **Equipos ajenos:** el filtro se prueba con una persona activa no
  asignada de otro equipo.
- **Sin JavaScript y recarga:** se prueba que el listado queda completo
  por nombre y que la URL no cambia al buscar o filtrar.
- **Pruebas que cambian:** las de «0 entradas listas»
  (`spec/requests/people_counts_spec.rb` y
  `spec/requests/feedback_summary_privacy_spec.rb`, que comprueba el
  escenario de la administradora de `authorization`) cambian junto con
  sus escenarios. Se registra cuáles.
- **Verificación prevista:** pruebas de peticiones y de sistema a 1280 y
  375 px, `bin/ci` y comprobación manual de Pablo.

## 7. Registro

- **M257 (15/11/2026):**
  - se separaron de GL-13 los requisitos funcionales del listado y se
    creó este cambio;
  - Pablo aprobó las decisiones 1 a 9 (P-41 a P-45);
  - se abrieron P-46 a P-53 como consecuencias sin definir;
  - solo se ejecutó `openspec validate --all --strict` (resultado en el
    registro del pedido);
  - sin pruebas, CI, auditorías, código ni commits.
- **M258 (15/11/2026):**
  - Pablo decidió P-46 a P-53 y los deltas se ajustaron;
  - se agregaron a `people-browsing` los requisitos «Búsqueda, filtro y
    orden en el navegador» y «Total de personas y aviso de privacidad»;
  - «Registrar la primera» se decide solo con el alcance de la cuenta,
    con un escenario de otro líder en `feedback-capture` y en
    `authorization`;
  - solo se ejecutó `openspec validate --all --strict`.
- **M259 (16/11/2026):** Pablo confirmó las tres interpretaciones de M258.
  P-51 cubre explícitamente el orden, y P-53 quedó precisada: el total
  cuenta las personas asignadas y no cambia al filtrar, el aviso aparece
  una vez y el mensaje vacío los reemplaza. Solo se ejecutó `openspec
  validate --all --strict`.
- **19/11/2026 (tarea 4.4 de GL-15, M355):** al archivar GL-15, la spec
  vigente de `people-browsing` pasó a admitir «+ Feedback» en la ficha.
  Se ajustó «Solo lectura y sin funciones inexistentes» de este delta
  para que no la contradiga: la ficha conserva «Captura rápida» y permite
  «+ Feedback» con su formulario, y el escenario «Acciones disponibles en
  la ficha» coincide con la spec vigente. El cambio quedó registrado en el
  diseño de GL-15 (sección 8) y publicado en `0472210`. GL-14 siguió sin
  archivar ni implementar.
- **20/11/2026 (revisión de la tarea 0.4, pedido sin numerar todavía):**
  tres requisitos de los deltas superaban los 500 caracteres que admite
  el modo estricto al aplicarse sobre las specs vigentes, como pasó al
  archivar GL-15. Se dividieron sin cambiar el alcance ni el
  comportamiento aprobados:
  - `people-browsing`: «Listado de personas asignadas» conserva el
    alcance, el orden y las dos líneas; las reglas de los conteos pasan a
    «Conteos de entradas en el listado» y «Conteos limitados a lo visible
    para la cuenta»;
  - `feedback-capture`: «Acceso visible a la captura rápida» vuelve a su
    texto vigente y sale del delta; «Registrar la primera» pasa a
    «Registrar la primera desde el listado» y a «"Registrar la primera"
    decidido con el alcance de la cuenta»;
  - `authorization`: «Lecturas agregadas con el alcance de entradas»
    conserva la regla; la enumeración de lecturas pasa a «Lecturas
    agregadas de la ficha y del listado».

  Se alinearon la propuesta, el ticket, las tareas y el plan, y se
  sumó `spec/requests/feedback_summary_privacy_spec.rb` a las pruebas
  existentes que cambian.

  **Validación.** La primera ejecución de `openspec validate --all
  --strict` después de la división dio 21 de 22: los requisitos
  `MODIFIED` habían perdido escenarios que la spec vigente todavía tiene
  («Conteo de entradas listas» y «Conteo con otro líder de la misma
  persona» en «Listado de personas asignadas», y «Autor» en «Lecturas
  agregadas con el alcance de entradas»), y un `MODIFIED` no puede
  quitarlos. Se corrigió así:
  - esos tres escenarios volvieron a sus requisitos `MODIFIED`, con su
    nombre y el texto de GL-14;
  - cada requisito `ADDED` tiene un escenario propio que prueba su regla
    sin repetirlos: «Conteos en singular y en plural», «Entradas de otro
    líder sobre una persona con entradas propias» y «Orden y acceso del
    listado desde el alcance». Este último compara dos personas: con una
    entrada lista propia sobre B y solo un borrador propio sobre A, una
    entrada lista posterior de otro líder sobre A no la pone antes que B
    en «Hechos más recientes» ni le da «Último hecho», y el borrador
    propio impide mostrar «Registrar la primera» en A;
  - el texto de los requisitos no cambió. Medidos con el criterio del
    validador, el más largo de los tres deltas es «Solo lectura y sin
    funciones inexistentes», con 498 caracteres.

  Con eso, `openspec validate --all --strict` dio 22 de 22. Sin ejecutar
  pruebas.
- **21/11/2026 (cierre de la revisión, tarea 0.4):** antes de la
  conformidad se hicieron estos ajustes, sin cambiar el comportamiento
  aprobado:
  - Pablo decidió conservar en los escenarios restaurados los textos de
    GL-14 y no los `THEN` de la spec vigente, que describen el
    comportamiento anterior: al archivar, la spec principal tiene que
    reflejar el estado final de GL-14;
  - «Búsqueda y filtro del listado» dice que, con una búsqueda o un
    filtro activos, se ofrece «Limpiar filtros», haya o no resultados.
    Para no pasar los 500 caracteres, «SHALL encontrar coincidencias
    parciales en el nombre» pasó a «SHALL admitir coincidencias
    parciales»; la búsqueda sigue siendo por nombre. El requisito quedó
    en 495 caracteres;
  - el escenario «Acciones disponibles» nombra «Limpiar filtros» cuando
    hay una búsqueda o un filtro activos. Siguen los escenarios «Sin
    resultados» y «Limpiar filtros conserva el orden»;
  - en la propuesta y en el ticket, el delta de `authorization` describe
    los registros «sin definir los textos de los conteos».

  Después de esos ajustes, `openspec validate --all --strict` dio 22 de
  22. Pablo revisó el diff v4 respecto de `eade6a6` y dio su conformidad:
  los escenarios originales se conservan y describen el comportamiento
  previsto, los requisitos nuevos tienen escenarios propios, y la
  redacción de «Limpiar filtros» y la propuesta son coherentes. La
  conformidad no autoriza la implementación (tarea 0.6). Sin ejecutar
  pruebas.
- **21/11/2026 (implementación local, M395):** Pablo aprobó la tarea 0.6
  para los grupos 1 a 3, en local y sin commit. El grupo 4 necesita una
  autorización para cada paso.

  **Pruebas primero (1.1 a 1.3).**
  - Nuevas: `spec/requests/people_listing_spec.rb` (conteos, «Último
    hecho», otro líder de la misma persona, administradora asignada,
    «Registrar la primera», captura por URL directa en `new` y `create`,
    total y aviso, y controles servidos ocultos) y
    `spec/system/people_listing_spec.rb` (a 1280 y 375 px: Tab y foco,
    búsqueda, filtro, orden y desempate, «Limpiar filtros», vacío frente
    a sin resultados, URL sin cambios y sin peticiones, recarga, 44 px y
    sin JavaScript).
  - Ajustadas junto con sus escenarios: `spec/requests/people_counts_spec.rb`
    y `spec/requests/feedback_summary_privacy_spec.rb` («0 entradas
    listas» pasa a los textos de GL-14, y el conteo del autor pasa a «1
    entrada lista · 1 borrador»).
  - Primera ejecución, antes de implementar: 62 ejemplos y 41 fallos, por
    la razón esperada (faltaban las filas, los conteos, la fecha, los
    controles, el total y «Registrar la primera»). Pasaban las pruebas de
    comportamiento que ya existía: la captura por URL directa, la vuelta
    a la ficha y el estado vacío. Un fallo era de la prueba: buscaba
    `input` en toda la página y encontraba el campo oculto de «Cerrar
    sesión»; se limitó a `main`.

  **Implementación (2.1 a 2.5).**
  - `PeopleController#index`: una consulta agregada sobre
    `policy_scope(FeedbackEntry)` con los conteos de listas y borradores
    y la fecha del último hecho; la prueba de una sola consulta sigue en
    verde.
  - `PeopleHelper`: textos de los conteos, «Último hecho», el total, el
    nombre normalizado y las opciones del filtro.
  - `app/views/people/index.html.erb`: total y aviso, controles ocultos
    sin JavaScript y sin formulario, fila con un enlace extendido y
    «Registrar la primera» aparte, con el nombre accesible del diseño.
  - `app/javascript/controllers/people_list_controller.js`: búsqueda,
    filtro, orden y «Limpiar filtros» en el navegador, sin dependencias
    nuevas.
  - `app/assets/stylesheets/application.css`: estilos del listado con los
    tokens existentes de `visual-language`.

  **Decisiones de implementación.**
  - El listado desactiva la precarga de Turbo al pasar el puntero
    (`data-turbo-prefetch="false"`). Con la fila completa como enlace, la
    prueba de sistema a 1280 px detectó una petición a `/personas/:id`
    mientras se buscaba, y el escenario «Búsqueda sin cambiar la URL»
    pide que no haya peticiones. Abrir la ficha no cambia.
  - Sin resultados, la lista vacía también se oculta, para que no quede su
    borde sobre el mensaje (visto en las capturas de comprobación).

  **Desvío.** `spec/requests/people_spec.rb` también cambió, aunque la
  tarea 3.1 solo preveía las dos pruebas de «0 entradas listas». Sus
  ayudas tomaban todos los enlaces de cada fila como enlaces a la ficha, y
  con «Registrar la primera» la fila tiene dos. Ahora toman solo el enlace
  de la persona (`a[data-person-link]`). Las expectativas no cambiaron.
  Queda para que Pablo lo acepte; por eso la 3.1 sigue abierta.

  **Verificación (3.1 y 3.2).**
  - Las pruebas de GL-14 pasaron tres veces seguidas: 19 ejemplos de
    sistema.
  - `bin/bundler-audit update`: código 0.
  - `bin/ci`, sobre el estado final: código 1. Pasaron el estilo
    (127 archivos, sin ofensas), la auditoría de gemas, la de importmap y
    RSpec (463 ejemplos, 0 fallos). Falló solo Brakeman, porque
    `bin/brakeman` usa `--ensure-latest` y la 8.1.0 instalada ya no es la
    última (8.1.1). Brakeman sin esa comprobación: 0 errores y 0
    advertencias. El árbol no cambió con el CI. Actualizar Brakeman es
    actualizar una dependencia y no está autorizado, así que la 3.2 sigue
    abierta.
  - No se ejecutó `openspec validate --all --strict`: los deltas no
    cambiaron.

  **Pendiente.** La aceptación del desvío (3.1), Brakeman o una decisión
  sobre su versión (3.2), la comprobación manual de Pablo a 1280 y 375 px
  (3.3) y el grupo 4. Sin commit.
- **21/11/2026 (M396):**
  - **Desvío de la 3.1 aceptado:** Pablo aceptó el cambio en
    `spec/requests/people_spec.rb`: el selector `a[data-person-link]` es
    el ajuste necesario para que sus ayudas identifiquen solo el enlace de
    la ficha, con las mismas expectativas. Con eso y la suite de M395
    (463 ejemplos, 0 fallos), la 3.1 queda completa.
  - **Comprobación manual (3.3):** Pablo revisó las capturas del listado a
    1280 y 375 px (listado, foco en la fila y sin resultados) y su
    revisión es conforme. La 3.3 queda completa.
  - **Brakeman (3.2):** Pablo autorizó actualizar solo Brakeman, de 8.1.0
    a 8.1.1. `bundle update brakeman --conservative` cambió dos líneas de
    `Gemfile.lock`: la versión y su checksum, sin otras gemas ni cambios
    en el `Gemfile`. Después, `bin/ci` terminó con código 1: pasaron el
    estilo, las auditorías y RSpec (463 ejemplos, 0 fallos), y Brakeman
    8.1.1 informó una advertencia nueva de confianza alta en
    `.ruby-version`: según su salida, Ruby 4.0.9 tiene una vulnerabilidad
    crítica de ejecución remota de código (CVE-2026-132825) y hay que
    pasar a 4.0.10 o posterior. No se verificó fuera de Brakeman.
    Resolverla exige actualizar Ruby, que es más amplio que lo
    autorizado, así que el trabajo se detuvo ahí: no se tocó Ruby ni se
    agregó una excepción a Brakeman. La 3.2 sigue abierta. La
    actualización de Brakeman queda en el árbol, sin commit.
- **21/11/2026 (M397 y M398, cambio de runtime):** Brakeman 8.1.1 marcaba
  Ruby 4.0.9. En M397 Pablo autorizó pasar a 4.0.10 solo con
  `.ruby-version` y el lockfile. El trabajo se detuvo antes de aplicarlo,
  porque hacía falta más alcance: `.tool-versions`, la spec vigente
  `runtime-toolchain` (que fijaba 4.0.9) y el plugin de asdf, que no
  ofrecía 4.0.10. En M398 Pablo autorizó ese alcance y pidió tratar la
  spec y la guía como un cambio de OpenSpec independiente de GL-14.
  - **Entorno local:** el plugin `ruby` de asdf actualizado; Ruby 4.0.10
    instalado (`ruby 4.0.10 (2026-11-19 revision a704b7cd95)`).
  - **Repositorio:**
    - `.ruby-version` y `.tool-versions` pasan a 4.0.10;
    - `bundle install` solo cambió `RUBY VERSION` en `Gemfile.lock`; las
      dos líneas de Brakeman 8.1.1 vienen de M396;
    - Bundler sigue en 4.0.20, y ninguna otra gema ni el `Gemfile`
      cambiaron.
  - **Cambio de OpenSpec independiente, `openspec/changes/gl-16-ruby-4-0-10`:**
    `MODIFIED` «Versiones de Ruby y Rails del proyecto» y «Declaración
    coherente de la versión de Ruby» de `runtime-toolchain`, y «Guía de
    desarrollo reproducible» de `development-environment`, con todos sus
    escenarios. La guía de desarrollo y el paso de instalación del
    `README.md` piden Ruby 4.0.10. No tiene ID de ticket ni lugar en el
    plan todavía.
  - **Resultado:**
    - `openspec validate --all --strict`: 23 de 23;
    - `bin/bundler-audit update`: código 0;
    - `bin/ci`: código 0, con el estilo sin ofensas, sin gemas ni paquetes
      vulnerables, Brakeman 8.1.1 sin advertencias y RSpec con 463
      ejemplos y 0 fallos. Se corrió dos veces, antes y después de
      actualizar la base de avisos, con el mismo resultado;
    - el árbol no cambió con el CI.

    La 3.2 queda completa.
  - **Desvío respecto de M397:** el alcance pasó de `.ruby-version` y el
    lockfile a lo que se detalla arriba, con la autorización de M398.
  - **Pendiente fuera de este cambio:** siguen nombrando 4.0.9 como
    versión vigente `CLAUDE.md`, el estado del `README.md` (líneas 178 y
    272) y `openspec/config.yaml`, que no se edita sin autorización. Que
    el CI remoto ofrezca Ruby 4.0.10 solo se comprueba al publicar.
