# Design

> **Estado (14/11/2026): publicado en el [PR #4](https://github.com/pablo-wpify/growth-log-ai4devs/pull/4), abierto y sin fusionar.**
> P-1, P-2, P-3 y P-11 están aprobadas (12/11/2026), Pablo decidió P-19 a
> P-26 (13/11/2026) y aprobó el cambio el mismo día («Vamos para
> adelante», según M120). CI remoto exitoso sobre `b5665aa` (ver «CI
> remoto del 14/11/2026»). F17 quedó **parcial** por decisión de Pablo,
> sin más comprobaciones manuales previstas. Lo ejecutado se registra en
> «Evidencia que se registra aquí al implementar»; las verificaciones y
> la aclaración de PT-11, en «Open Questions».

## Context

- **Autorización (GL-03):** Pundit con `verify_authorized` y
  `verify_policy_scoped`, 404 ante `NotAuthorizedError` y `RecordNotFound`,
  `PersonPolicy::Scope` (personas activas con asignación activa de la
  cuenta), excepciones por acción y una tabla de cobertura de rutas con
  sesión. La regla de entradas quedó **definida en el diseño de GL-03
  (sección 9), no especificada**: «GL-06 la especifica, la implementa y la
  prueba».
- **Personas (GL-05):** `PeopleController#show` carga con
  `policy_scope(Person).find` y la ficha es de solo lectura; la spec
  `people-browsing` y `navigation_spec` exigen que el único formulario sea
  «Cerrar sesión» y prohíben el texto «captura rápida».
- **Datos (GL-08):** Elena y Tomás comparten a Ada; Inés no tiene
  asignaciones; Darío está inactivo. No hay entradas, y el aislamiento del
  feedback entre dos líderes de la misma persona quedó para GL-06.
- **Logs:** `filter_parameters` cubre credenciales, no `context`,
  `evidence` ni `impact` (`config/initializers/filter_parameter_logging.rb`).
- **Fecha:** `config.time_zone` no está configurada: la aplicación usa UTC.
- **Presentación:** CSS propio de GL-05, Turbo incluido por importmap, sin
  framework visual.
- **Sesión vencida (GL-02):** sin una sesión válida, `require_authentication`
  redirige al inicio de sesión y solo recuerda la URL de una petición `GET`
  o `HEAD` (`app/controllers/concerns/authentication.rb:22-23` y `49-53`).

## Goals / Non-Goals

**Goals:**
- Capturar, completar y marcar como lista una entrada propia, privada.
- Especificar y probar la regla de entradas de GL-03 con entradas reales,
  con la matriz de actores por URL directa.
- Dejar a GL-07 un modelo y un alcance estables.

**Non-Goals:**
- Formulario completo «+ Feedback» (2.1, 2.2, 2.7; P-11).
- Resumen, cronología, conteos (GL-07); compartir y feed (I4, I6).
- Interfaz del autor sin asignación (listado y datos mínimos de AM-1),
  salvo el detalle por URL directa de P-24.
- Captura dentro de la ficha con Turbo frame (P-22 eligió la página propia).
- PT-11: compartir, revocar y la transición de reasignación (P-26).
- Volver a borrador, borrar entradas, entradas en los datos ficticios.
- Prueba automatizada en navegador (GL-09, P-4).

## Decisions

### 1. Decisiones aprobadas (12/11/2026)

| # | Decisión | Efecto en este cambio |
|---|---|---|
| P-1 | Cinco dimensiones fijas: `delivery` «Entrega», `technical_quality` «Calidad técnica», `teamwork` «Trabajo en equipo», `communication` «Comunicación», `initiative` «Iniciativa» | restricción `CHECK` en la base y etiquetas en el modelo |
| P-2 | Señales `positive` «Positivo», `improvement` «A mejorar», `neutral` «Neutral» | restricción `CHECK` y etiquetas. Las columnas del resumen (Positivos, A mejorar, Neutrales y Total) son de GL-07: ver la sección 9 |
| P-3 | Dimensión y señal obligatorias para «lista»; opcionales en borrador | `CHECK` en la base, validación en el modelo y mensaje de qué falta. **Amplía 2.6 y 3.5**: el delta está en `feedback-entries` y `feedback-capture`; el Anexo A no se modifica |
| P-11 | Se difiere el formulario completo «+ Feedback» | 2.1, 2.2 y 2.7 siguen pendientes en el plan; los campos de H2 se completan al editar |

### 1a. Decisiones de Pablo (13/11/2026)

Registro: `docs/decisiones/2026-11-13-gl-06-captura.md` y plan, sección 6.

| # | Decisión | Efecto en este cambio |
|---|---|---|
| P-19 | Captura bajo `/personas/:person_id/entradas`; detalle, edición, actualización y marcar como lista bajo `/entradas/:id` | sección 4 |
| P-20 | Escribir exige autoría, asignación activa y persona activa; la lectura propia se conserva | sección 3; escenarios de `authorization` |
| P-21 | Sección «Tus entradas sobre <nombre>», por fecha del hecho descendente y, en empate, primero la creada después; GL-07 la reemplaza con un cambio explícito | secciones 5, 6 y 9 |
| P-22 | Captura en página propia, sin Turbo frame | sección 6 |
| P-23 | `America/Argentina/Buenos_Aires` para toda la instancia | sección 7 |
| P-24 | Sin acceso a la ficha: de la persona solo el nombre, de la entrada todos los campos; solo por URL directa, sin listado. 3.10 y 4.14 quedan parciales | sección 6; matriz y trazabilidad |
| P-25 | «Marcar como lista» sobre una entrada ya lista no la cambia y vuelve al detalle sin error | sección 5; escenario de `feedback-capture` |
| P-26 | De PT-11, solo la rama de lectura, parcial mientras «con datos mínimos» siga pendiente de interpretación (aclarada el 14/11/2026: ver Open Questions); la reasignación queda fuera | Non-Goals; trazabilidad |

### 2. Tabla y modelo

Tabla `feedback_entries`:

| Columna | Tipo | Restricción |
|---|---|---|
| `author_id` | referencia a `users` | not null, clave foránea |
| `person_id` | referencia a `people` | not null, clave foránea |
| `status` | string | not null, por defecto `draft`; `CHECK (status IN ('draft','ready'))` |
| `occurred_on` | date | not null |
| `context` | text | not null; `CHECK (btrim(context) <> '')` |
| `signal` | string | null o `CHECK` con los tres valores de P-2 |
| `dimension` | string | null o `CHECK` con los cinco valores de P-1 |
| `evidence`, `impact` | text | null |
| `confidence` | integer | null o `CHECK (confidence BETWEEN 1 AND 5)` |
| `created_at`, `updated_at` | timestamps | not null |

- `CHECK (status <> 'ready' OR (signal IS NOT NULL AND dimension IS NOT NULL))` (P-3).
- Índices: `(person_id, author_id)` para la sección de la ficha y GL-07; `author_id` para el alcance.
- Claves foráneas sin `ON DELETE CASCADE`: una cuenta con entradas no se
  borra (D5), y las personas tampoco se borran (backlog).
- Migración reversible; la reversión se prueba en la base de test.

`FeedbackEntry`: `belongs_to :author, class_name: "User"` y `:person`;
`enum :status, { draft: "draft", ready: "ready" }` con valores de texto;
constantes `DIMENSIONS` y `SIGNALS` (valor → etiqueta); validaciones
equivalentes a las restricciones, para mostrar errores en español; y un
método `mark_ready` que valida la completitud y devuelve los campos que
faltan sin modificar el registro si falla. Las restricciones de la base
son la garantía; las validaciones son para el mensaje.

### 3. Política y alcance

```ruby
class FeedbackEntryPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve = scope.where(author: user)       # lectura por autoría
  end

  def show? = author?
  def new? = create?
  def create? = author? && writable_person?
  def edit? = update?
  def update? = author? && writable_person?
  def mark_ready? = update?

  private

  def author? = record.author_id == user.id
  def writable_person? = PersonPolicy::Scope.new(user, Person.all).resolve.exists?(record.person_id)
end
```

Asociaciones nuevas: `Person has_many :feedback_entries` y `User has_many
:authored_feedback_entries`, ambas con `dependent: :restrict_with_exception`,
como las asignaciones de GL-03.

- La lectura no depende de la asignación (P-7); la escritura usa el mismo
  alcance de personas de GL-03, que ya exige asignación activa y persona
  activa (P-9, P-20).
- El rol de administrador no aparece en ninguna condición.
- Una cuenta desactivada no llega a la política: GL-02 rechaza su sesión.

### 4. Rutas (P-19, decidida)

```ruby
resources :people, only: %i[ index show ], path: "personas" do
  resources :feedback_entries, only: %i[ new create ], path: "entradas",
            path_names: { new: "nueva" }
end
resources :feedback_entries, only: %i[ show edit update ], path: "entradas",
          path_names: { edit: "editar" } do
  patch :mark_ready, on: :member, path: "marcar-lista"
end
```

| Ruta | Acción |
|---|---|
| `GET /personas/:person_id/entradas/nueva` | formulario de captura rápida |
| `POST /personas/:person_id/entradas` | guardar la captura |
| `GET /entradas/:id` | detalle |
| `GET /entradas/:id/editar` | formulario para completar |
| `PATCH /entradas/:id` | guardar la edición |
| `PATCH /entradas/:id/marcar-lista` | marcar como lista |

Las acciones de miembro no se anidan bajo la persona: anidarlas obligaría a
cargar la persona por su alcance, que falla sin asignación y rompería la
lectura por autoría de PP-9.

### 5. Controlador

```ruby
class FeedbackEntriesController < ApplicationController
  def new
    @person = policy_scope(Person).find(params[:person_id])
    @entry = @person.feedback_entries.new(author: Current.user)
    authorize @entry
  end

  def create
    @person = policy_scope(Person).find(params[:person_id])
    @entry = @person.feedback_entries.new(author: Current.user, status: "draft",
                                          occurred_on: Time.zone.today,
                                          context: params.dig(:feedback_entry, :context))
    authorize @entry
    if @entry.save
      redirect_to person_path(@person), notice: "Guardamos tu borrador. Solo vos podés verlo."
    else
      render :new, status: :unprocessable_content
    end
  end

  def show   = load_entry
  def edit   = load_entry

  def update
    load_entry
    if @entry.update(entry_params) then redirect_to @entry, notice: "Guardamos los cambios. Solo vos podés ver esta entrada."
    else render :edit, status: :unprocessable_content end
  end

  def mark_ready
    load_entry
    return redirect_to(@entry) if @entry.ready?   # P-25: idempotente, sin cambios
    if @entry.mark_ready then redirect_to @entry, notice: "La entrada está lista y sigue siendo privada: solo vos podés verla."
    else render :show, status: :unprocessable_content end
  end

  private

  def load_entry
    @entry = policy_scope(FeedbackEntry).find(params[:id])
    authorize @entry
  end

  def entry_params
    params.expect(feedback_entry: %i[ occurred_on context signal dimension evidence impact confidence ])
  end
end
```

- Toda lectura por id pasa por `policy_scope(...).find`; `authorize` decide
  la acción concreta. Sin excepciones nuevas: `exceptions_spec` no cambia.
- `entry_params` no admite `status`, `author_id` ni `person_id`.
- `new` y `create` leen la persona por su alcance: una persona sin
  asignación o inactiva responde 404 antes de construir la entrada.
- `mark_ready` sobre una entrada ya lista (P-25) pasa antes por
  `load_entry`, así que la autorización de escritura se decide igual: sin
  asignación activa o con la persona inactiva responde 404. Con permiso,
  vuelve al detalle sin modificar el registro.
- **Sección de la ficha (P-21):** `PeopleController#show` obtiene las
  entradas siempre a través del alcance de entradas:

  ```ruby
  @entries = policy_scope(FeedbackEntry).where(person: @person)
                                        .order(occurred_on: :desc, created_at: :desc, id: :desc)
  ```

  `verify_policy_scoped` ya se cumple con `policy_scope(Person)` y no
  detectaría una segunda consulta sin alcance: es el límite reconocido en
  el plan, sección 6.1 (P-5). La protección es esta forma única de
  consulta, la prueba «Líder con entradas propias» y la mutación 4.

### 6. Vistas

- **Ficha (`people/show`):** debajo de rol y equipo, el enlace «Captura
  rápida»; después, la sección «Tus entradas sobre <nombre>» (P-21).
- **Captura rápida en página propia (P-22, decidida):** el enlace lleva a
  `/personas/:person_id/entradas/nueva`, una página con el título «Captura
  rápida sobre <nombre>», «← Volver a <nombre>» y el formulario, sin Turbo
  frame. Campos: el texto («¿Qué pasó?») y la fecha mostrada, no editable
  («Fecha: hoy, dd/mm/aaaa»). Botón «Guardar borrador». Al guardar,
  redirige a la ficha con el aviso y la sección actualizada; con 422,
  vuelve a mostrar la página con el error y el texto escrito. Cumple el
  acceso visible de 3.1. GL-06 elige una página propia y no adopta la
  interacción sin navegación propuesta en MVP-FE-1 (ticket propuesto en la
  entrega 1, no un criterio aprobado).
  - **Sesión vencida al enviar: por verificar.** Leyendo el flujo de GL-02
    (ver Context), un `POST` sin sesión válida se redirige al inicio de
    sesión, no se recuerda su URL y la entrada no se crea. No está
    comprobado qué ve el autor después de enviar ni si pierde el texto
    escrito. Se comprueba al implementar (prueba de peticiones del
    redireccionamiento y F17 a mano); no se diseña ninguna mitigación sin
    esa comprobación.
- **Tus entradas sobre <nombre> (P-21, decidida):** solo las entradas
  propias sobre esa persona, por fecha del hecho descendente y, en el
  mismo día, primero la creada después (`created_at` descendente, con `id`
  como desempate final). Cada fila: fecha, estado
  («Borrador · solo vos» o «Lista · solo vos») y los primeros 80 caracteres
  del contexto, con un enlace al detalle. Sin entradas: «Todavía no
  registraste entradas sobre <nombre>.» GL-07 la reemplaza por la
  cronología (P-10) con un cambio explícito de `feedback-capture`.
- **Detalle:** título «Entrada sobre <nombre>», autor («Escrita por vos»
  con el nombre de la cuenta), fecha, estado, contexto, señal, dimensión,
  evidencia, impacto y confianza; «Sin indicar» si falta un campo
  opcional. Un solo predicado decide la variante: **la persona de la
  entrada está en el alcance de personas de la cuenta**. Si está:
  «Editar», «Marcar como lista» (solo en borrador, `button_to` con
  `PATCH`) y «← Volver a <nombre>». Si no está, porque terminó la
  asignación o la persona está inactiva (P-24, decidida): todos los campos
  de la entrada, igual que arriba; de la persona, solo el nombre, sin
  enlace a la ficha, y el texto «Ya no acompañás a esta persona: podés leer
  esta entrada, pero no editarla.», sin acciones de escritura. Se llega
  solo por URL directa: no hay listado en GL-06, y 3.10 y 4.14 quedan
  parciales. Ante 422 en «Marcar como lista»: «Para marcarla como lista
  falta: dimensión y señal.» (o la que falte).
- **Edición:** campos con etiquetas; señal y dimensión como grupos de
  opciones con «Sin indicar»; confianza de 1 a 5 o vacía. Botón «Guardar
  cambios». Errores junto a cada campo y un resumen arriba.
- Ningún texto dice «Publicar». Títulos con `content_for :title`. Estilos
  en `application.css`, con las mismas reglas de GL-05 (área táctil de
  44 px, foco visible, sin depender del color para el estado).

### 7. Fecha de hoy (P-23, decidida)

`config.time_zone = "America/Argentina/Buenos_Aires"` en
`config/application.rb`, para toda la instancia, y la captura usa
`Time.zone.today`. Hoy, con UTC, una captura hecha después de las 21:00 en
Buenos Aires quedaría con la fecha de mañana. La base sigue guardando las
marcas de tiempo en UTC.

**Verificación pendiente para la implementación:** las pruebas que usan
`Time.zone.local` (`spec/requests/sessions_spec.rb:120`,
`spec/requests/rate_limit_spec.rb:6`,
`spec/requests/session_expiry_spec.rb:5`,
`spec/models/rate_limit_store_spec.rb:5` y `spec/models/session_spec.rb:5`)
pasarían a construir instantes
en otra zona. Se comprobó en la tarea 5.2 sin debilitar sus expectativas:
**pasan sin cambios** (13/11/2026, local; ver «Registro de la
implementación»).

### 8. Texto fuera de los logs

El requisito no cambia: el contexto, la evidencia y el impacto no
aparecen en el log de la petición ni en el de las consultas (F12).

Propuesta: `filter_parameters += %i[ context evidence impact ]`.
**Verificado el 13/11/2026 en local, primero solo en test** (ver
«Registro de la implementación»): esa lista también filtra los valores
registrados en el log de consultas mientras las sentencias preparadas
estén activas. En desarrollo no lo estaban (`query_log_tags_enabled`) y
el texto aparecía; corregido y cubierto por una regresión que usa la
configuración de desarrollo (por ejemplo, a través de
`ActiveRecord::Base.filter_attributes`), y qué nivel de log usa cada
entorno. Al implementar, una prueba lo comprueba sobre el log real de la
petición y de las consultas. Si las consultas mostraran el texto, se trata
como un desvío y se informa con una propuesta que cumpla el requisito,
sin relajarlo. El filtro es por coincidencia parcial: cualquier parámetro
cuyo nombre contenga `context`, `evidence` o `impact` también se filtra, y
se acepta.

### 9. Contrato con GL-07 (ajuste de P-2)

GL-06 entrega a GL-07:

- `feedback_entries` con `status`, `signal`, `dimension`, `occurred_on`,
  `author_id` y `person_id`, y el índice `(person_id, author_id)`;
- `FeedbackEntry::SIGNALS` y `FeedbackEntry::DIMENSIONS` con sus etiquetas;
- `policy_scope(FeedbackEntry)` como única fuente de entradas visibles:
  GL-07 recibe el alcance ya resuelto, nunca el modelo.

**Ajuste registrado para GL-07 (P-2):** el resumen por dimensión se
presenta con las columnas **Positivos, A mejorar, Neutrales y Total**, para
que el total sea la suma visible. Ajusta la presentación del criterio 4.1,
que nombra solo «positivos, mejoras y total». Lo implementa y lo
especifica GL-07; GL-06 no adelanta el resumen.

GL-06 **no** decide el orden de la cronología (P-10) ni si los borradores
aparecen en ella: la sección de la ficha de P-21 es provisoria, y GL-07
la reemplaza con un delta explícito de `feedback-capture`.

### 10. Pruebas existentes que cambian

| Archivo | Cambio | Por qué |
|---|---|---|
| `spec/requests/route_protection_spec.rb` (GL-02) | la lista exacta de rutas suma las seis rutas nuevas | es una lista cerrada a propósito |
| `spec/requests/authorization_coverage_spec.rb` (GL-03) | `ROUTES` suma las seis rutas, con el autor como actor autorizado y otro líder de la misma persona como actor sin permisos | rutas nuevas |
| `spec/requests/navigation_spec.rb` (GL-05) | «el único formulario es «Cerrar sesión»» se mantiene; la prohibición del texto «captura rápida» se mantiene para el listado y en la ficha pasa a exigir que el único acceso sea «Captura rápida», sin «+ Feedback», resumen, compartir ni administración | delta `MODIFIED` de `people-browsing` |
| `spec/requests/people_spec.rb` (GL-05) | sin cambios esperados; si la sección de entradas choca con una aserción, se informa antes de cambiarla | — |

Ninguna expectativa de GL-02, GL-03 ni GL-05 se debilita sin un delta
explícito.

## Verificación

### Datos de prueba

Cada prueba prepara sus datos ficticios: L1 y L2 asignados a P; L3 sin
asignación; A administradora sin asignación (y, en otra prueba, asignada a
P); una persona inactiva I con asignación de L1; una entrada borrador y una
lista de L1 sobre P, con textos únicos generados en la prueba.

### Matriz de privacidad (peticiones, por URL directa)

| Actor | Detalle | Formulario de edición | Edición | Marcar como lista | Esperado |
|---|---|---|---|---|---|
| L1 (autor) | 200 | 200 | 302 | 302 o 422 | según el escenario |
| L2 (misma persona) | 404 | 404 | 404 | 404 | igual que inexistente, sin el texto, base sin cambios |
| L3 (sin asignación) | 404 | 404 | 404 | 404 | ídem |
| A (sin asignación) | 404 | 404 | 404 | 404 | ídem |
| A (asignada a P) | 404 | 404 | 404 | 404 | ídem |
| L1 con la asignación terminada | 200 (P-24) | 404 | 404 | 404 | lectura sí, escritura no |
| L1 con P inactiva | 200 (P-24) | 404 | 404 | 404 | ídem |

Cada celda se prueba sobre el borrador y sobre la entrada lista. Crear:
L3, A y L1 sobre I responden 404 sin crear entradas. «Marcar como lista»
de L1 sobre su entrada ya lista: redirige al detalle y la entrada no
cambia (P-25).

**Trazabilidad (plan, sección 6.1: «Pruebas de 3.10 y 4.14 y de la rama
de lectura de PT-11», asignadas a GL-06):**

- La fila «L1 con la asignación terminada», sobre el borrador **y** la
  entrada lista, cubre 3.10 y 4.14 (parciales) y, de la rama de lectura de
  PT-11, la lectura de las entradas propias, incluidos los borradores:
  lectura permitida por URL directa, con todos los campos y solo el nombre
  de la persona (P-24), sin enlace a la ficha; 404 en el formulario de
  edición, la edición y marcar como lista; la ficha de P responde 404.
- La rama de lectura de PT-11 queda **resuelta** con la aclaración de
  Pablo del 14/11/2026: «con datos mínimos» se refiere a los datos de la
  persona (solo el nombre); la entrada propia se muestra completa,
  incluidos los borradores, por URL directa (P-24). PT-11 no queda
  completo: compartir, revocar y la reasignación siguen fuera.
- La fila «L1 con P inactiva» cubre P-9 (lectura conservada) y P-20; no
  traza 3.10 ni 4.14, que hablan de la asignación terminada.
- No hay fila de reasignación: la transición de PT-11 queda fuera (P-26).
  Compartir y revocar tampoco existen en este cambio.

### Mutaciones (con copia de seguridad y restauración comprobada)

1. `policy_scope(FeedbackEntry).find` → `FeedbackEntry.find`: falla la
   matriz (L2 recibe 200).
2. Sin `authorize` en `update`: falla la prueba de cobertura.
3. `update?` sin `writable_person?`: falla «Editar con la asignación
   terminada».
4. El alcance de la sección de la ficha sin el filtro por autor: falla
   «Líder con entradas propias» (aparece la entrada de L2).
5. Sin el filtro de `context` en los logs: falla la prueba de logs.
6. Sin el `CHECK` de P-3 en la migración de test: falla «Entrada lista sin
   señal» a nivel de base.

### Comprobación en navegador (manual, no automatizada)

Con los datos de GL-08, Pablo inicia sesión como Elena y como Tomás:
captura rápida desde la ficha de Ada, en su página propia; completar;
marcar como lista con datos incompletos y completos, y otra vez sobre la
entrada ya lista; y comprobar que Tomás no ve las entradas de Elena ni por
URL directa. En escritorio y a 375 px. Además, se registra qué ve el
autor si su sesión vence antes de enviar la captura (verificación
pendiente de la sección 6). Se registra como comprobación manual; la
automatizada queda para GL-09 (P-4).

### Evidencia que se registra aquí al implementar

`bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`
locales; las seis mutaciones; la comprobación manual; y, con autorización
de push, el CI remoto con su enlace y su SHA. Sin esa ejecución remota no
se da nada por comprobado en el CI.

#### Registro de la implementación (13/11/2026, local, sin commit)

Todo lo de esta sección se comprobó en **local**. Al registrarla
(13/11/2026) no había CI remoto; el del 14/11/2026 está en «CI remoto del
14/11/2026». La comprobación en navegador (F17) quedó **parcial**: ver
«Comprobación en navegador F17 (13 y 14/11/2026, parcial)».

- **Pruebas primero.** Cada grupo escribió sus pruebas y las vio fallar por
  la razón esperada antes de implementar:
  - grupo 1: `FeedbackEntry` no existía;
  - grupo 2: `FeedbackEntryPolicy` no existía;
  - grupo 3: 38 de 57 fallaban porque no había rutas ni controlador;
  - grupo 4: 7 fallaban porque la ficha no tenía la sección ni el acceso;
  - grupo 5: 4 fallaban porque la zona era `Etc/UTC` y el log de la
    petición mostraba el texto.
- **Pruebas nuevas:** `spec/models/feedback_entry_spec.rb` (30),
  `spec/policies/feedback_entry_policy_spec.rb` (11),
  `spec/requests/feedback_entries_spec.rb` (32),
  `spec/requests/person_entries_spec.rb` (6) y
  `spec/requests/feedback_entry_date_and_logs_spec.rb` (4).
- **Pruebas ajustadas:** `route_protection_spec` (seis rutas nuevas y
  `FeedbackEntry.count` en el control de efectos), `authorization_coverage_spec`
  (seis rutas; el actor sin permisos de las rutas de una entrada es otro
  líder asignado a la misma persona) y `navigation_spec` (delta de
  `people-browsing`). `exceptions_spec` y `people_spec` sin cambios.
- **Migración:** aplicada en la base de test, revertida y reaplicada, con
  `db/schema.rb` idéntico en las dos pasadas.
- **`bin/bundler-audit update` y `bin/ci`:** código de salida 0.
  - RuboCop: 99 archivos sin infracciones.
  - Sin vulnerabilidades en gemas ni en importmap; Brakeman, 0 avisos.
  - RSpec: 288 ejemplos, 0 fallos (192 antes de GL-06).
- **`openspec validate --all --strict`:** 16 válidos, 0 fallidos (19:49 UTC).

**Mutaciones** (copia de seguridad, restauración comprobada con `cmp`):

| # | Mutación | Resultado |
|---|---|---|
| 1 | `policy_scope(FeedbackEntry).find` → `FeedbackEntry.find` | detectada: 18 fallos por `Pundit::PolicyScopingNotPerformedError` en las acciones del autor. **Desvío:** la matriz **no** falla, porque `authorize` sigue negando a L2; la detecta `verify_policy_scoped`, no «L2 recibe 200» como preveía esta sección |
| 2 | sin `authorize` en `update` | detectada: 1 fallo en `authorization_coverage_spec` (PATCH `/entradas/:id`) |
| 3 | `update?` sin `writable_person?` | detectada: 6 fallos (política y peticiones con la asignación terminada y con la persona inactiva) |
| 4 | sección de la ficha sin el alcance por autor | detectada: 2 fallos en `person_entries_spec` (aparece la entrada de L2) |
| 5 | sin `:context` en `filter_parameters` | detectada: 2 fallos en la prueba de logs |
| 6 | sin el `CHECK` de P-3, solo en la base de test | detectada: 2 fallos («lista sin señal», «lista sin dimensión»). Al restaurar, la copia se buscó con otro nombre y la base de test se remigró una vez sin el `CHECK`; se restauró la migración desde la copia correcta, se recargó la base de test desde `db/schema.rb` previo y se comprobó el ciclo bajar y subir, con `db/schema.rb` idéntico |

**Verificaciones técnicas pendientes del diseño, ahora resueltas en local:**

- **Log de consultas (sección 8, F12):** con `context`, `evidence` e
  `impact` en `filter_parameters`, Rails registra esos valores enlazados
  como `[FILTERED]` en el log de consultas. **Esto se comprobó solo en
  test** y resultó insuficiente: ver «Fallo de F12 en desarrollo». Riesgo residual:
  una consulta que interpolara el texto como literal SQL no se filtraría;
  el código de GL-06 no tiene ninguna. En producción el nivel es `info`,
  que no registra SQL.
- **Pruebas con `Time.zone.local` (sección 7):** las cinco pasan sin
  cambios con la zona de P-23 (38 ejemplos).
- **Sesión vencida al enviar la captura (sección 6):** la prueba de
  peticiones «captura con la sesión vencida» adelanta el reloj 2 horas y 1
  segundo y verifica que la petición se redirige al inicio de sesión, no
  crea la entrada y no recuerda la URL del `POST`. En el navegador (F17,
  paso 16) solo hubo una **simulación sin cookie**, no una prueba manual
  de vencimiento: redirigió al inicio de sesión, no se creó la entrada y no
  hubo aviso. **No comprobado en el navegador:** el vencimiento real y si
  el texto se conserva.

**Fallo de F12 en desarrollo (detectado en F17, 13/11/2026):**

- **Qué pasó.** Durante la comprobación manual F17 (pasos 1 a 10), el log
  del servidor de desarrollo mostró el contexto en el `INSERT` y la
  evidencia y el impacto en un `UPDATE`, en texto plano (datos
  ficticios). El log de la petición sí filtraba.
- **Causa.** `config/environments/development.rb` tenía
  `config.active_record.query_log_tags_enabled = true` desde E1. Con esa
  opción, el railtie de Active Record 8.1.4.1 desactiva las sentencias
  preparadas (`ActiveRecord.disable_prepared_statements = true`): los
  valores van dentro del SQL y `filter_parameters` no los alcanza. En test
  las sentencias preparadas están activas, por eso la prueba de logs pasaba.
- **Corrección (alternativa 1, decidida por Pablo).**
  `query_log_tags_enabled = false` en desarrollo. No se relajó el filtro
  ni se cambió el nivel del log.
- **Regresión.** `spec/config/development_query_logs_spec.rb` arranca un
  proceso con `RAILS_ENV=development`, conectado a la base de **test**
  (nunca a la de desarrollo). Comprueba que las etiquetas estén
  desactivadas y las sentencias preparadas activas, y que un texto
  ficticio no aparezca en el log de consultas del `INSERT` ni del
  `UPDATE`.
  - Con la opción en `true`: 2 de 2 fallaban (etiquetas activas y texto en
    el log).
  - Con la corrección: 2 de 2 pasan.
  - Suite completa: 290 ejemplos, 0 fallos. RuboCop: 100 archivos sin
    infracciones. En ese momento `bin/ci` no se ejecutó, porque su paso
    «Setup» toca la base de desarrollo (ver «Gate local del 14/11/2026»).
- **Verificación limpia en el servidor (14/11/2026).** Con el servidor de
  desarrollo reiniciado (con autorización de Pablo) y la configuración
  corregida, una captura y una edición con un marcador ficticio único
  dejaron 0 apariciones del marcador en los logs nuevos; el `INSERT` y el
  `UPDATE` muestran `[FILTERED]`. **Verificado.**
- **Evidencia conservada.** `log/development.log` y el log del servidor de
  F17 no se borraron; sus tamaños y SHA-256 están registrados aparte.
- **Producción.** No activa las etiquetas y su nivel de log es `info`, que
  no registra SQL. Esto se leyó en la configuración, no se probó.

**Comprobación en navegador F17 (13 y 14/11/2026, parcial):**

- **Método.** Comprobación en navegador con asistencia de Claude Code:
  Claude Code manejó el navegador y Pablo inició cada sesión. **No** cumple
  «comprobado a mano por Pablo». El registro detallado, con la evidencia
  de cada paso, queda fuera del repositorio.
- **Pasan** los pasos 1 a 14: captura en su página propia, mensajes de
  falta, completar, marcar como lista y segundo marcado, sin «Publicar»,
  privacidad con Tomás (404 idéntico al de un id inexistente, solo `GET`) y
  404 de la ficha de Darío. Los pasos 7 y 9 se repitieron el 14/11 con el
  formulario corregido, sobre la entrada ficticia 2. El paso 2 no prueba la
  zona horaria: la fecha de Buenos Aires y la UTC coincidían.
- **Paso 15 (375 px), parcial.** El ancho se emuló con un `iframe`, no con
  el modo dispositivo de DevTools, sin táctil ni densidad de píxeles. Antes
  de la corrección: sin desborde en 7 páginas y el fallo del formulario
  (ver «Desvíos»). Después: solo se revisó la edición (opciones con
  etiqueta, 44 px de alto, sin desborde). **No comprobado:** cabecera,
  foco visible, 44 px de los botones, textos largos, estado a 375 px y las
  demás páginas después de la corrección.
- **Paso 16, parcial.** En el navegador, solo una simulación sin cookie
  (no un vencimiento real): redirección al inicio de sesión y ninguna
  entrada nueva. El vencimiento con el reloj adelantado lo cubre la prueba
  de peticiones, no F17. **No comprobado en el navegador:** el vencimiento
  real y si el texto se conserva.
- **Observaciones, sin investigar ni mitigar:**
  - el inicio de sesión no avisa que la captura no se guardó;
  - dos 422 por CSRF (`POST /session` y `DELETE /session`) de causa
    desconocida, posible seguimiento de GL-02.
- **Decisión de Pablo (14/11/2026): no hace más comprobaciones manuales.**
  El trabajo local se cierra con F17 **parcial**, no completa. No se
  cumplió «comprobado a mano por Pablo». Quedan sin comprobar los controles
  pendientes del paso 15 (revisado solo con `iframe`) y, en el navegador,
  el vencimiento real y la conservación del texto del paso 16 (solo hubo
  una simulación sin cookie). La prueba automatizada de sesión vencida es
  aparte: es la prueba de peticiones que adelanta el reloj, descrita en
  «Verificaciones técnicas pendientes del diseño, ahora resueltas en
  local».

**Gate local del 14/11/2026:** `bin/bundler-audit update` y `bin/ci`, los
dos con código 0. Resultado: 291 ejemplos y 0 fallos, RuboCop sin
infracciones, auditorías sin vulnerabilidades y Brakeman sin advertencias.
Antes se conservaron copias verificadas de `log/development.log` y
`log/test.log`, porque «Setup» los vacía (`log:clear`).

**CI remoto del 14/11/2026:** [PR #4](https://github.com/pablo-wpify/growth-log-ai4devs/pull/4) desde `feature/GL-06-captura-rapida`
contra `feature/entrega-2-pp`, con los commits `5de213f` (implementación
y documentación de cierre) y `b5665aa` (registro de prompts). GitHub
Actions, [ejecución 43608171520](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43608171520): **exitosa** sobre `b5665aa9481f82e9bca86e7a52b872a951d899da`, con `scan_ruby`, `scan_js`,
`lint` y `test` en verde. Vale solo para ese SHA: una actualización
posterior (por ejemplo, la aclaración de PT-11 y este registro) requiere
su propio CI.

**Desvíos:**

- **Rutas:** en lugar de `resources … only: %i[ show edit update ]`, las
  rutas de una entrada se declaran explícitas, para no exponer también
  `PUT /entradas/:id`. Las seis rutas son exactamente las de P-19.
- **`bin/ci` prepara la base de desarrollo:** su paso «Setup» corre
  `bin/setup`, que aplicó la migración a la base de desarrollo. La tabla
  quedó vacía (0 entradas) y `db/schema.rb` no cambió. Las pruebas usaron
  solo la base de test.
- **Mutación 1:** la detectó otra prueba que la prevista (ver la tabla).
- **Formulario de edición corregido durante F17 (14/11/2026).** Las
  etiquetas de señal y dimensión apuntaban a un `id` inexistente
  (`…_positive_positive`). Tocar el texto no elegía la opción, los botones
  no tenían nombre accesible y se separaban de su texto. Ahora cada botón va
  dentro de su etiqueta, y `.choices label` tiene `white-space: nowrap`. La
  regresión «asocia cada opción de señal y dimensión con su texto» fallaba
  antes y pasa después. Fue una corrección fuera de las tareas aprobadas,
  autorizada por Pablo.
- **`bin/setup` vacía los logs:** su `log:clear` deja `log/development.log`
  y `log/test.log` en cero bytes; antes de cada `bin/ci` se copiaron.

**Pendiente:**

- F17 queda **parcial** por decisión de Pablo (14/11/2026: no hace más
  comprobaciones manuales y no hay más previstas). Sin evidencia quedan:
  la comprobación a mano por Pablo; el paso 15 con DevTools en modo
  dispositivo y sus controles no comprobados; y, en el navegador, el paso
  16 con el vencimiento real y la conservación del texto;
- con autorización, integrar el PR #4; cualquier commit posterior a
  `b5665aa` necesita su propio CI remoto;
- el archivo del cambio.

## Risks / Trade-offs

- **El filtro de logs podría no cubrir las consultas** → ocurrió en
  desarrollo; se corrigió y se verificó (ver «Fallo de F12 en
  desarrollo»).
- **Cambiar `config.time_zone` afecta a todo `Time.zone`** → las marcas en
  la base siguen en UTC; se comprueban las pruebas con `Time.zone.local` y
  la suite completa, incluidas las de vencimiento de sesión de GL-02.
- **Sesión vencida al enviar la captura** → la prueba de peticiones, con
  el reloj adelantado, verifica que no se crea la entrada y que se
  redirige al inicio de sesión; en el navegador solo hubo una simulación
  sin cookie, y el inicio de sesión no avisa (observación). El vencimiento
  real en el navegador y la conservación del texto quedan sin comprobar.
  No se propone ninguna mitigación por ahora.
- **El autor sin acceso a la ficha no encuentra sus entradas** → aceptado
  por P-24: solo por URL directa; 3.10 y 4.14 quedan parciales.
- **La sección de la ficha anticipa parte de GL-07** → es provisoria, solo
  con entradas propias y sin conteos; GL-07 la reemplaza por la cronología.
- **Recorrido sin prueba automatizada en navegador** → se comprueba a mano
  (F17) hasta GL-09; las pruebas de peticiones cubren la página de captura.
- **Regla de escritura repartida entre dos políticas** → `writable_person?`
  usa `PersonPolicy::Scope`, sin duplicar la condición de asignación.
- **Longitud del texto sin límite** → ningún criterio la fija; queda fuera
  de alcance.

## Migration Plan

Una migración reversible, sin datos: se aplica en desarrollo y test y se
comprueba la reversión en la base de test. No toca los datos ficticios de
GL-08.

## Open Questions

**Decisiones:** P-19 a P-26 están decididas (13/11/2026; sección 1a). El
cambio está aprobado (13/11/2026).

**Interpretación aclarada (14/11/2026):** Pablo confirmó que la
interpretación de P-24 también se aplica a la rama de lectura de PT-11.
«Con datos mínimos» se refiere a los datos de la persona: se muestra
solo su nombre; la entrada propia se muestra completa, incluidos los
borradores; el acceso sigue siendo por URL directa, sin listado (P-24).
Esto resuelve la interpretación de la rama de lectura. No reabre P-24 ni
agrega la reasignación (P-26): compartir, revocar y la transición de
reasignación siguen fuera de GL-06, y PT-11 no queda implementado por
completo. Registro: [decisiones de GL-06](../../../docs/decisiones/2026-11-13-gl-06-captura.md).

**Verificaciones técnicas** (no cambian requisitos):

- Log de consultas (sección 8, F12): **fallaba en desarrollo** y se
  corrigió el 13/11/2026 (ver «Fallo de F12 en desarrollo»). Verificado en
  local con la configuración de test y la de desarrollo, y en el servidor
  de desarrollo el 14/11/2026.
- Pruebas con `Time.zone.local` tras P-23 (sección 7): **verificado**; pasan
  sin cambios.
- Sesión vencida al enviar la captura (sección 6): verificado por la
  prueba de peticiones que adelanta el reloj 2 horas y 1 segundo; en el
  navegador, solo una simulación sin cookie (sin entrada nueva y sin
  aviso). **Pendiente en el navegador:** el vencimiento real y si el texto
  se conserva.
- Nombre del requisito «Solo lectura y sin funciones inexistentes» de
  `people-browsing`, que ya no describe una ficha con acciones: no se
  renombra hasta verificar qué sintaxis de renombre admite OpenSpec 1.15.

Siguen pendientes, fuera de este cambio: el listado y los datos mínimos del
autor sin asignación (AM-1, P-7, I5), la transición de reasignación de
PT-11 (P-26), P-4 (ADR-6) y P-10.
