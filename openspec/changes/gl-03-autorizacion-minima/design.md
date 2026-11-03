# Design

## Context

Después de GL-02, toda ruta del producto exige una sesión válida de una
cuenta activa (spec `authentication`), pero ninguna decide qué puede hacer
esa cuenta. Hoy la única ruta del producto con sesión es la página de
inicio provisoria (`GET /`), que GL-05 reemplazará por «Personas». No
existen personas, asignaciones ni entradas.

Decisiones aprobadas por Pablo el 02/11/2026
([plan, sección 6.1](../../../docs/plan-entrega-2.md#61-detalle-de-las-decisiones-que-abren-gl-03)):

| # | Decisión |
|---|---|
| P-5 (ADR-3) | Pundit, con denegación por defecto, carga por alcance y 404. Sus verificaciones detectan omisiones; las pruebas de comportamiento comprueban las reglas |
| P-7 | Se conservan PP-9 y AM-1: la lectura de las entradas propias no depende de una asignación activa; la escritura sí. El acceso desde la interfaz sin asignación queda explícitamente pendiente |
| P-8 | Una asignación activa por par líder y persona, con un índice único parcial |
| P-9 | Estados independientes de persona, asignación y cuenta; la ficha de una persona inactiva responde 404, y se conserva la lectura de las entradas propias |

## Goals / Non-Goals

**Goals:**
- Que ninguna acción del producto pueda terminar sin una decisión de
  autorización, y que una omisión se detecte en las pruebas.
- Que las acciones que leen registros solo encuentren registros del alcance.
- Personas y asignaciones mínimas, con sus restricciones en la base.
- Política y alcance de personas comprobados con todos los actores.
- Dejar definida, para GL-06, la regla de entradas.

**Non-Goals:**
- Rutas, vistas ni interfaz de personas (GL-05).
- Tabla, acciones y autorización de entradas (GL-06); resumen (GL-07).
- Compartición, destinatarios y nombres de otros líderes (I4).
- Interfaz del autor sin asignación y sus datos mínimos (pendiente, P-7).
- Invitaciones, vista de administración y acciones administrativas (GL-04).
- Roles o permisos configurables, o una plataforma general de permisos.
- Row Level Security (ADR-5) y datos ficticios de desarrollo (GL-08).

## Decisions

### 1. Pundit 2.5.2

`gem "pundit", "~> 2.5.2"`. Es la última versión publicada (24/09/2025). Se
verifica con `git diff Gemfile.lock` que solo se agrega `pundit` y con
`bin/bundler-audit` que no hay avisos. Alternativas descartadas en P-5:
objetos de política propios (habría que escribir y mantener las
verificaciones), Action Policy (más amplia de lo necesario).

### 2. Verificaciones en `ApplicationController`

```ruby
include Pundit::Authorization
after_action :verify_authorized
after_action :verify_policy_scoped
rescue_from Pundit::NotAuthorizedError, ActiveRecord::RecordNotFound, with: :render_not_found
```

`Current.user` se expone a Pundit con `pundit_user`. Las dos verificaciones
se aplican a **todas** las acciones: una acción que no lee registros lo
declara con `skip_policy_scope` dentro de la acción.

Qué detectan y qué no (P-5):

| Pieza | Detecta | No detecta |
|---|---|---|
| `ApplicationPolicy` que deniega todo y `Scope#resolve` → `scope.none` | una regla que falta | una regla mal escrita |
| `verify_authorized` | que no se llamó a `authorize` | el objeto o la consulta autorizados; una regla incorrecta |
| `verify_policy_scoped` | que no se llamó a `policy_scope` | otra consulta sin alcance en la misma acción |

Las dos corren **después** de la acción y solo si no lanzó una excepción:
detectan omisiones en las pruebas, no impiden efectos en producción. Las
reglas las comprueban las pruebas de comportamiento (estrategia de
pruebas).

### 3. Excepciones por acción concreta

Autenticación y autorización son pasos distintos: `new` y `create` de
`SessionsController` se ejecutan sin cuenta identificada, así que no hay a
quién autorizar. Son las únicas acciones exceptuadas, con
`skip_after_action :verify_authorized, :verify_policy_scoped, only: %i[new
create]`. Una acción nueva de ese controlador queda sujeta a las
verificaciones. `destroy` (cerrar sesión) se autoriza con `SessionPolicy`,
que permite cerrar la propia sesión, y declara `skip_policy_scope` porque no
lee registros. El chequeo de salud no hereda de `ApplicationController`.

Una prueba busca en `app/` las llamadas a `skip_after_action`,
`skip_authorization` y `skip_policy_scope` y las compara, por controlador y
acción, con la lista declarada en la propia prueba. Hoy la lista tiene:
`SessionsController#new` y `#create` (las dos verificaciones),
`SessionsController#destroy` (alcance) y `HomeController#show` (alcance).

### 4. Respuesta 404

`render_not_found` responde con `public/404.html` y estado 404. Atiende
también `ActiveRecord::RecordNotFound`, para que un acceso denegado, un
registro fuera del alcance y uno inexistente den exactamente la misma
respuesta en todos los entornos (en test, `consider_all_requests_local`
mostraría una página de depuración distinta). No se usa 403: no revela si
el recurso existe.

### 5. Carga por alcance

Toda acción que lee un registro por id lo hace con
`policy_scope(Modelo).find(params[:id])` y después `authorize` sobre ese
registro. Lo que está fuera del alcance no se encuentra (404); `authorize`
decide la acción concreta. La primera acción así llega con GL-05.

### 6. Página de inicio

`HomeController#show` llama a `authorize :home, :show?` y a
`skip_policy_scope`. `HomePolicy#show?` permite a cualquier cuenta
identificada: que la cuenta esté activa lo garantiza la autenticación
(GL-02), que actúa antes. Permitir la página de inicio no da acceso a
ningún recurso.

### 7. Tablas

- `people`: `name` (obligatorio), `role`, `team`, `active` (booleano,
  obligatorio, verdadero por defecto), marcas de tiempo.
- `assignments`: `leader_id` (referencia a `users`, obligatoria),
  `person_id` (obligatoria), `started_at` (obligatoria), `ended_at`,
  marcas de tiempo. Índice único parcial `(leader_id, person_id) WHERE
  ended_at IS NULL`; índice por `person_id`; restricción de comprobación
  `ended_at IS NULL OR ended_at >= started_at`. Sin índice único por
  persona (P-8).
- Modelos: `Person` (`scope :active`), `Assignment` (`belongs_to :leader,
  class_name: "User"`, `belongs_to :person`, `scope :active`), `User`
  (`has_many :assignments, foreign_key: :leader_id`). Las asociaciones usan
  `restrict_with_exception`: borrar una cuenta o una persona con
  asignaciones falla en lugar de borrar en cascada.

### 8. Política de personas

- `PersonPolicy::Scope#resolve`: personas activas cuyo id está entre las
  asignaciones activas de la cuenta.
- `PersonPolicy#show?`: el registro está en ese alcance. La regla vive en un
  solo lugar, el alcance, para que política y consulta no diverjan.
- El rol de administrador no aparece en ninguna condición.

### 9. Regla de entradas para GL-06 (definida, no especificada)

GL-06 la especifica, la implementa y la prueba con entradas reales. No se
agrega a las specs de este cambio porque no hay entradas que la sostengan.

| Acción sobre una entrada | Condición |
|---|---|
| Leer | ser su autor con cuenta activa; **no** depende de la asignación (PP-9, AM-1) |
| Crear, editar, marcar como lista | ser su autor y tener asignación activa con la persona, y persona activa |
| Leer entradas ajenas | nunca en el núcleo (compartir está diferido, D2) |

Queda **pendiente**, sin adelantarlo a GL-06 ni a GL-07: dónde encuentra el
autor sin asignación sus entradas y qué datos mínimos de la persona ve
(detalle de AM-1). Si una persona está inactiva, si su autor puede seguir
editando entradas existentes no está definido: se decide en GL-06.

### 10. Prueba de cobertura de rutas con sesión

Complementa `route_protection_spec` (sin sesión). Para cada ruta del
producto, una tabla en la prueba declara cómo prepararla: datos, un actor
autorizado y un actor sin permisos.

- Actor autorizado: la petición termina sin errores de verificación. Así
  se ejecutan las dos verificaciones de Pundit.
- Actor sin permisos: la respuesta es 404 o la misma página para todos
  (página de inicio), nunca datos de un registro ajeno.
- Una ruta sin entrada en la tabla hace fallar la prueba.

Hoy la tabla solo tiene la página de inicio. GL-05 y GL-06 agregan sus
rutas; sin eso la prueba falla.

## Qué se verifica ahora y qué no

| Comprobación | En GL-03 | Requiere |
|---|---|---|
| Denegación por defecto de `ApplicationPolicy` y su alcance | sí | — |
| `verify_authorized` y `verify_policy_scoped` detectan omisiones | sí, con un controlador **solo de prueba** y rutas temporales | — |
| 404 ante `NotAuthorizedError` y registro fuera del alcance | sí, con el controlador de prueba | — |
| Excepciones por acción concreta; cierre de sesión autorizado | sí | — |
| Página de inicio autorizada; mutación sin `authorize` falla | sí | — |
| Política y alcance de personas con L1, L2, L3, A, persona inactiva y asignación terminada | sí, a nivel de política y alcance | — |
| Restricciones de `people` y `assignments`, incluida la concurrencia | sí | — |
| Persona ajena por URL directa: 404; mutación `Person.find` en lugar del alcance | **no** | rutas de GL-05 |
| 1.19 y 1.14 por la interfaz | **no** | GL-05 |
| Borrador y entrada lista privados; lectura propia sin asignación; escritura con asignación | **no**: **la autorización del feedback no se da por comprobada** | entradas reales de GL-06 |
| Resumen, cronología y conteos con alcance | **no** | GL-07 |
| CI remoto | pendiente hasta un push autorizado | push |

El controlador de prueba comprueba el **mecanismo**; no comprueba ninguna
regla del producto sobre personas ni sobre feedback.

## Estrategia de pruebas

| Archivo | Qué prueba | Spec |
|---|---|---|
| `spec/policies/application_policy_spec.rb` | todas las consultas deniegan; el alcance está vacío | Denegación por defecto |
| `spec/requests/authorization_mechanism_spec.rb` | controlador solo de prueba con rutas temporales (`with_routing`), a través del middleware real: sin `authorize` falla; lee sin `policy_scope` y falla; una acción denegada y un registro fuera del alcance dan un 404 idéntico al de un inexistente | Autorización obligatoria; Alcance obligatorio; Respuesta |
| `spec/requests/authorization_coverage_spec.rb` | tabla de rutas del producto con sesión; ruta sin preparar falla; página de inicio | Autorización obligatoria |
| `spec/authorization/exceptions_spec.rb` | omisiones en `app/`, por controlador y acción, iguales a la lista declarada | Excepciones declaradas por acción |
| `spec/policies/person_policy_spec.rb` | L1 y L2 asignados a P; L3 sin asignación; A sin asignación; A asignada a Q; P inactiva; asignación terminada | Acceso de un líder a una persona |
| `spec/models/person_spec.rb`, `spec/models/assignment_spec.rb` | nombre obligatorio; activa por defecto; restricciones de la base; varios líderes; reasignación; estados independientes | `people`, `assignments` |
| `spec/models/assignment_concurrency_spec.rb` | dos inserciones simultáneas del mismo par con conexiones distintas: queda una | Una asignación activa por par |

Mutaciones registradas, con copia de seguridad y restauración comprobada
como en GL-02:

1. sin `authorize` en `HomeController#show`: falla la prueba de cobertura;
2. sin la condición de asignación activa en `PersonPolicy::Scope`: falla
   `person_policy_spec`;
3. sin la condición `active` de la persona: falla `person_policy_spec`;
4. ampliar la excepción de `SessionsController` a todas sus acciones: falla
   la prueba de excepciones;
5. sin el índice único parcial (en una migración descartable): falla la
   prueba de unicidad.

Datos ficticios (`@example.test`) y contraseñas generadas en cada prueba.

## Registro de evidencia

Ejecutado en local el 03/11/2026 sobre la base `93b42ec`. Evidencias en
el directorio local de evidencias de GL-03, fuera del repositorio.
**Remoto: pendiente** hasta un push autorizado.

| Criterio | Estado | Evidencia |
|---|---|---|
| B1 | Comprobado (local) | `application_policy_spec` (9): las siete consultas deniegan, también a una administradora; alcance base vacío |
| B2 | Comprobado (local), **solo el mecanismo** | `authorization_mechanism_spec` (4), con un controlador solo de prueba: sin `authorize`, `Pundit::AuthorizationNotPerformedError`; leer sin alcance, `Pundit::PolicyScopingNotPerformedError`; acción denegada y registro fuera del alcance, 404 con el mismo cuerpo que un inexistente y sin el nombre de la persona. No comprueba rutas reales del producto |
| B3 | Comprobado (local) | `authorization_coverage_spec` (5): rutas del producto con sesión, `GET /` y `DELETE /session`, igual a la tabla. Mutación 1 (sin `authorize` en la página de inicio): 2 fallos con `AuthorizationNotPerformedError` |
| B4 | Comprobado (local) | `exceptions_spec` (3): omisiones en `app/` iguales a la lista por acción; verificaciones instaladas; una acción nueva de un subcontrolador de sesiones queda sujeta. Mutación 4 (excepción sin `only:`): 2 fallos |
| B5 | Comprobado (local), **política y alcance** | `person_policy_spec` (8): L1 y L2 asignados a P; L3 sin asignación; asignación terminada; persona inactiva con asignación activa; sin cuenta. Mutación 2 (sin la condición de asignación): 6 fallos; mutación 3 (sin persona activa): 1 fallo. La URL directa queda para GL-05 |
| B6 | Comprobado (local) | `person_policy_spec`: administradora sin asignaciones con alcance vacío; asignada a Q, solo Q |
| B7 | Comprobado (local) | `person_spec` (5), `assignment_spec` (11), `assignment_concurrency_spec` (1, 5 de 5 corridas): restricciones de la base, varios líderes por persona y varias personas por líder, reasignación, estados independientes y segunda inserción simultánea rechazada mientras espera la fila de la primera. Mutación 5 (sin el índice único, solo en la base de test): 2 fallos; índice restaurado idéntico y `db/schema.rb` sin cambios. Migraciones revertidas y reaplicadas en test |
| B8 | Hecho | decisión 9 de este diseño; no es una prueba |
| B9 | Comprobado (local); **pendiente (remota)** | `bin/ci` código 0: 73 archivos sin infracciones, sin avisos (base `a58f1d0`), importmap limpio, Brakeman 0 advertencias, RSpec 120 ejemplos y 0 fallos (74 de GL-02 + 46 de GL-03). `openspec validate --all --strict`. Base de test vacía al terminar |

Dependencia: `pundit` 2.5.2; el diff de `Gemfile.lock` solo agrega
`pundit` (que depende de `activesupport`, ya presente) y `bundler-audit`
no informa avisos.

Mutaciones de código (1 a 4) con copia de seguridad, restauración por
`trap` y `sha256sum -c` correcto para cada archivo.

**Límites de lo comprobado:**

- El controlador de prueba verifica el **mecanismo**, no la autorización de
  futuras rutas reales. Cada ruta nueva tiene que entrar en la tabla de
  cobertura con sus actores (GL-05 en adelante).
- La autorización del feedback **no está comprobada**: no hay entradas
  hasta GL-06.
- La URL directa de una persona ajena, 1.14 y 1.19 por la interfaz, y la
  mutación de `Person.find` en lugar de la carga por alcance quedan para
  GL-05.
- La prueba de excepciones analiza el código línea por línea: una omisión
  escrita de forma inusual (por ejemplo, en varias líneas) podría escapar.
  La prueba dinámica de la acción nueva y la de cobertura la complementan.

**Desvíos e incidencias registrados:**

- El diseño preveía un controlador anónimo en una prueba de controlador.
  Se usó un controlador de prueba con rutas temporales en una prueba de
  peticiones, para pasar por el middleware real y comparar el 404 completo.
- `authorization_coverage_spec` no podía fallar antes de existir el
  mecanismo (sin verificaciones no hay nada que omitir); su eficacia la
  demuestra la mutación 1. Las demás pruebas fallaron primero por la razón
  esperada (constantes inexistentes, verificaciones no instaladas, acción
  nueva no sujeta).
- La primera versión de `exceptions_spec` usaba `stub_const` fuera del
  ciclo de la prueba; se corrigió antes de registrar el fallo esperado.
- La primera ejecución de la mutación 5 dejó colgada la prueba de
  concurrencia: sin el índice, la espera fallaba y la primera transacción
  no se liberaba. Se detuvo el proceso, se restauró la base de test con
  `db:test:prepare` (quedaba sin el índice y con una cuenta de prueba) y
  la prueba se reescribió para liberar siempre la transacción y fallar con
  un mensaje claro. Con la prueba corregida, la mutación 5 falla sin
  colgarse.

## Risks / Trade-offs

- **Verificaciones después de la acción** → una acción que modifica antes
  de autorizar dejaría efectos aunque falle la verificación. Mitigación:
  autorizar primero, la tabla de cobertura y la revisión del diff.
- **`verify_policy_scoped` no ve una segunda consulta sin alcance** →
  mitigación: carga por alcance como única forma de leer por id y la matriz
  de actores por URL directa de GL-05 a GL-07.
- **Tabla de cobertura mantenida a mano** → si se olvida una ruta, la
  prueba falla; el costo es mantener la tabla.
- **Regla de entradas fuera de las specs hasta GL-06** → queda en el
  diseño y en el plan; GL-06 no puede cerrarse sin especificarla.
- **Dependencia nueva** → una gema pequeña y madura, auditada en `bin/ci`.

## Migration Plan

Dos migraciones reversibles, sin datos: se aplican en desarrollo y test y
se comprueba la reversión en la base de test.

## Open Questions

- Edición de entradas existentes de una persona inactiva: se decide en
  GL-06.
- Interfaz y datos mínimos del autor sin asignación (AM-1): pendiente.
