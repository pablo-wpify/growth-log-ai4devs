# Design

> **Borrador documental (M257, completado en M258, 15/11/2026), para
> revisión de Pablo.** Sin implementar. Las mejoras 1 a 9 (P-41 a P-45)
> las aprobó Pablo en M257, y P-46 a P-53 en M258 (sección 5). Solo falta
> la aprobación del cambio para implementarlo.

## 1. Fuentes

| Fuente | Uso |
|---|---|
| Criterios 1.14, 1.15 y 1.16 (Anexo A); PP-2, PP-3 y PP-6 | alcance aprobado del listado y de lo que la cuenta puede ver |
| Specs vigentes `people-browsing`, `feedback-capture` y `authorization` | textos y reglas que este cambio modifica con deltas explícitos |
| P-15, P-17, P-20 y P-22 | «Personas» es el inicio; «rol · equipo» y sus faltantes; la escritura exige asignación y persona activas; la captura es una página propia que vuelve a la ficha |
| Código en `eabac8e`: `PeopleController#index`, `people/index.html.erb` y `PeopleHelper` | lo implementado |
| Referencia `~/Descargas/Lista de personas@1x.png` (M256, confirmada en M257) | **referencia visual**, no requisito |
| Pedidos M257 y M258 | las decisiones aprobadas y su reparto entre specs |
| Cambio `gl-13-direccion-visual` | tokens, componentes y foco que usa el listado. No define su comportamiento |

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
| 3 | Etiquetas neutrales: «Sin entradas todavía», «Sin entradas listas · N borradores» y «N entradas listas · M borradores». Las listas, limitadas a lo visible; los borradores, solo los propios | **P-41** | `people-browsing`, «Listado de personas asignadas»; registros, `authorization` |
| 4 | «Último hecho»: la fecha del hecho más reciente entre las entradas listas visibles. Es la misma fecha que usa «Hechos más recientes». Los borradores no cuentan | **P-42** | `people-browsing`, «Fecha del último hecho» |
| 5 | Búsqueda por nombre y filtro por equipo, limitados a las personas activas asignadas | **P-43** | `people-browsing`, «Búsqueda y filtro del listado» |
| 6 | Orden por nombre como predeterminado (1.14) y «Hechos más recientes» como opción, con desempate por nombre y después por ID | **P-44** | `people-browsing`, «Orden por hechos más recientes» |
| 7 | «Registrar la primera» para una persona sin entradas: acción independiente de la fila, hacia la captura existente, con la misma autorización y la vuelta a la ficha al guardar | **P-45** | `feedback-capture`, «Acceso visible a la captura rápida» |
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
  textos de pantalla. Su delta no cambia permisos (ver la propuesta).

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
| P-46 | Con entradas listas y ningún borrador: «N entradas listas» | `people-browsing`, «Listado de personas asignadas» |
| P-47 | En «Hechos más recientes», las personas sin entradas listas visibles para la cuenta van al final. Los borradores no participan. Entre ellas rige el desempate de P-44 | `people-browsing`, «Orden por hechos más recientes» |
| P-48 | «Limpiar filtros» borra la búsqueda y el filtro por equipo y conserva el orden elegido | `people-browsing`, «Sin resultados de búsqueda o filtro» |
| P-49 | Coincidencias parciales en el nombre, sin distinguir mayúsculas ni acentos | `people-browsing`, «Búsqueda y filtro del listado» |
| P-50 | «Sin equipo indicado» en el filtro solo si hay personas sin equipo. El modelo permite ese estado | `people-browsing`, «Búsqueda y filtro del listado» |
| P-51 | Búsqueda, filtro por equipo y orden se procesan en el navegador, sobre las personas autorizadas. La selección se pierde al recargar y no se guarda en la URL (precisado en M259) | `people-browsing`, «Búsqueda, filtro y orden en el navegador» |
| P-52 | La captura abierta desde el listado vuelve a la ficha, como hoy | `feedback-capture`, «Acceso visible a la captura rápida» |
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
  (`spec/requests/people_counts_spec.rb`) cambian junto con su escenario.
  Se registra cuáles.
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
