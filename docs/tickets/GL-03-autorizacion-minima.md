# GL-03. Autorización mínima del recorrido: denegar por defecto y alcance por asignación

> Cuarto ticket de la entrega 2 de Growth Log. Lugar en la secuencia y
> decisiones pendientes: [plan de la entrega 2](../plan-entrega-2.md).
> Cambio de OpenSpec:
> [`gl-03-autorizacion-minima`](../../openspec/changes/gl-03-autorizacion-minima/proposal.md).
> **Estado (03/11/2026): implementado y verificado en local; pendiente el CI
> remoto (B9).** Resultados y límites en el registro de evidencia del
> diseño. La autorización del feedback no está comprobada: llega con GL-06.

## Problema

GL-02 identifica quién hace cada petición, pero no decide qué puede hacer.
El recorrido núcleo (elegir una persona asignada, capturar, completar,
marcar como lista y consultar el resumen) expone feedback privado. Si una
acción nueva olvida verificar permisos, un líder vería lo de otro (RN-1).

## Resultado esperado

Antes de que exista la primera entrada de feedback:

1. Ninguna acción del producto responde sin una decisión de autorización
   explícita, y una prueba lo detecta sobre todas las rutas del producto.
2. Un líder accede a una persona solo con una asignación activa con ella y
   si la persona está activa.
3. La regla de las entradas queda definida en el diseño para que GL-06 y
   GL-07 la apliquen con el mismo mecanismo: el autor con cuenta activa lee
   sus entradas, **con o sin asignación** (PP-9, AM-1); crear, editar y
   marcar como lista exigen además asignación activa; nadie más lee una
   entrada en el núcleo.
4. Ser administrador no da ningún acceso en las vistas del líder.

## Origen

| Fuente | Qué exige |
|---|---|
| Anexo G, E3 | autorización que deniega por defecto; fixtures con dos líderes y una administradora; «un test falla si una ruta queda sin política» |
| README 2.5 | autorización en el servidor, denegar por defecto, consultas con alcance, también por URL directa |
| PP-2, D1, 1.19 | acceso a la persona solo con asignación activa |
| PP-3, PP-4, 4.9, 4.11 | borradores y entradas listas privados del autor |
| PP-8, 1.10 | administrar no da lectura de entradas ni resúmenes |
| ADR-3 (Anexo D) | biblioteca o política propia; 404 o 403 |
| Feedback de LIDR | denegar por defecto y consultas con alcance |

## Alcance

1. Mecanismo de autorización según ADR-3 (P-5): políticas que deniegan por
   defecto, verificaciones de autorización y de alcance, carga por alcance
   y lista fija de excepciones.
2. Respuesta ante un recurso fuera del alcance o una acción denegada: 404,
   sin revelar si existe.
3. Tablas mínimas `people` (nombre, rol, equipo, `active`, P-9) y
   `assignments` (líder, persona, inicio, fin; una sola activa **por par
   líder y persona**, P-8), **sin interfaz de administración**.
4. Política y alcance de personas: un líder accede solo a personas activas
   con las que tiene una asignación activa (P-9). Al terminar la
   asignación pierde la ficha; la lectura de sus propias entradas no
   depende de la asignación (P-7).
5. Ayudas de prueba con L1 y L2 asignados a la misma persona, L3 sin
   asignación y una administradora sin asignación.
6. Prueba de cobertura: una tabla prepara cada ruta del producto con un
   actor autorizado y uno sin permisos; una ruta sin preparar la hace
   fallar.
7. Página de inicio provisoria y cierre de sesión autorizados con el mismo
   mecanismo; solo el formulario y el envío del inicio de sesión quedan
   exceptuados, por acción.

## Exclusiones

- Compartir, revocar, destinatarios y nombres de otros líderes (I4).
- Interfaz para que el autor sin asignación encuentre sus entradas y
  decisión de sus datos mínimos (AM-1): pendientes, sin adelantarlas a
  GL-06 ni a GL-07 (P-7). La regla de lectura sí se conserva.
- Invitaciones y vista de administración (GL-04).
- Roles, permisos configurables o una plataforma genérica de permisos:
  solo las dos reglas del recorrido.
- La tabla de entradas y sus acciones: llegan con GL-06, que aplica la
  regla de entradas con este mecanismo.
- Datos ficticios para desarrollo (GL-08).
- Row Level Security en PostgreSQL (ADR-5, opcional).

## Criterios de aceptación

| # | Criterio | Cómo se verifica en GL-03 | Origen |
|---|---|---|---|
| B1 | Las políticas deniegan por defecto: una política sin reglas deniega y su alcance está vacío | prueba de `ApplicationPolicy` | E3, RN-1, ADR-3 |
| B2 | Una acción del producto sin `authorize`, o una que lee registros sin `policy_scope`, falla en las pruebas; una acción denegada o un registro fuera del alcance responden 404, igual que un inexistente | controlador anónimo **solo de prueba**: comprueba el mecanismo, no reglas del producto | P-5, ADR-3 |
| B3 | La prueba de cobertura recorre las rutas del producto con sesión, con un actor autorizado y uno sin permisos, y falla ante una ruta sin preparar; hoy cubre la página de inicio. Mutación: sin `authorize` en la página de inicio, falla | prueba de peticiones y mutación registrada | E3, RN-1 |
| B4 | Las excepciones se declaran por acción concreta: solo `SessionsController#new` y `#create` omiten las verificaciones, y el cierre de sesión y la página de inicio omiten solo el alcance; una acción nueva no queda exceptuada y una omisión no declarada hace fallar una prueba | prueba de excepciones y mutación | P-5 |
| B5 | El alcance y la política de personas dan acceso solo con persona activa y asignación activa; lo niegan sin asignación, con la asignación terminada y con la persona inactiva; varios líderes de una persona la tienen en su alcance | prueba de política y alcance con L1, L2, L3; mutaciones de las condiciones | PP-2, 1.14, 1.19, P-7, P-9 |
| B6 | Una administradora sin asignación no tiene ninguna persona en su alcance; asignada a una sola, ve solo esa | prueba de política y alcance | PP-8, 1.10 y 1.21 parciales |
| B7 | Dos líderes pueden tener asignación activa con la misma persona y un líder con varias personas; la base rechaza una segunda asignación activa del mismo par, también en simultáneo; tras terminarla se puede crear otra; persona, asignación y cuenta cambian de estado de forma independiente | pruebas de modelo y de concurrencia | P-8, P-9, D1, 1.8, README 3.2 |
| B8 | El diseño define la regla de entradas para GL-06: lectura por autoría con cuenta activa, sin depender de la asignación; escritura con autoría y asignación activa | revisión del diseño; **no** es una prueba | PP-3, PP-4, PP-9, AM-1 |
| B9 | `bin/ci` local y el CI remoto pasan | local; remoto tras un push autorizado | GL-01 |

**No se comprueba en GL-03:**
- persona ajena por URL directa (404) y la mutación de `Person.find` en
  lugar de la carga por alcance: requieren las rutas de GL-05;
- la autorización del feedback (borrador y entrada lista privados, lectura
  propia sin asignación, escritura con asignación): requiere las entradas
  reales de GL-06. **No se da por comprobada** con las pruebas de este
  ticket;
- resumen, cronología y conteos con alcance: GL-07.

PT-1 queda parcial: no hay vista de administración ni feed.

## Dependencias

GL-02 cerrado (`94e40a1`). Decisiones P-5, P-7, P-8 y P-9, aprobadas el
02/11/2026 ([plan, sección 6.1](../plan-entrega-2.md#61-detalle-de-las-decisiones-que-abren-gl-03)).
Agrega la gema `pundit` 2.5.2, que se revisa como `bcrypt` en GL-02.

## Relación con la entrega

Tarea habilitadora E3 del Anexo G, con las tablas de personas y
asignaciones de T1.1 sin su interfaz. Protege los pasos «elegir una
persona asignada» en adelante.
