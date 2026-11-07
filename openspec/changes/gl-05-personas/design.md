# Design

## Context

- **Autenticación (GL-02):** tras iniciar sesión se llega a `root_url`, hoy
  `HomeController#show`, una página provisoria con «Sesión iniciada como
  <nombre>» y «Cerrar sesión». Su comentario anuncia que la reemplaza
  «Personas» en GL-05.
- **Autorización (GL-03):** Pundit con `verify_authorized` y
  `verify_policy_scoped` en todas las acciones, 404 ante `NotAuthorizedError`
  y `RecordNotFound`, `PersonPolicy::Scope` (personas activas con asignación
  activa de la cuenta) y una tabla de cobertura de rutas con sesión.
- **Datos (GL-08):** conjunto ficticio para recorrer a mano; las pruebas no
  dependen de él.
- **Presentación:** `application.css` está vacío y no hay framework visual.
  El layout ya declara `viewport`. Mock 1 (Anexo E) muestra la ficha
  completa con resumen, cronología, «Captura rápida», «+ Feedback» y otros
  líderes; GL-05 toma solo su cabecera y la navegación lateral reducida a
  «Personas».

## Goals / Non-Goals

**Goals:**
- Listado y ficha protegidos por alcance, con 404 por URL directa.
- Una interfaz sencilla, legible y usable en un teléfono.
- Las rutas reales en la prueba de cobertura.

**Non-Goals:**
- Administración, feedback, resumen, otros líderes, conteos.
- Prueba automatizada en navegador (ADR-6, P-4).

## Decisions

### 1. La página de inicio pasa a ser «Personas» (P-15, aprobada)

`root "people#index"` y se eliminan `HomeController`, `HomePolicy` y
`app/views/home/`. Un redireccionamiento de rutas
(`root to: redirect("/personas")`) no sirve: responde sin pasar por la
autenticación y `route_protection_spec` lo rechazaría. La frase «Sesión
iniciada como <nombre>» pasa a la cabecera, así que la prueba de GL-02 que
la busca sigue valiendo sin cambios.

### 2. Rutas en español (P-16, aprobada)

```ruby
root "people#index"
resources :people, only: %i[ index show ], path: "personas"
```

Quedan `GET /`, `GET /personas` y `GET /personas/:id`. El listado responde
en `/` y en `/personas`; la navegación enlaza a `/personas`.

### 3. Controlador

```ruby
class PeopleController < ApplicationController
  def index
    authorize Person
    @people = policy_scope(Person).order(:name, :id)
  end

  def show
    @person = policy_scope(Person).find(params[:id])
    authorize @person
  end
end
```

- `PersonPolicy#index?` devuelve verdadero para una cuenta identificada:
  el listado se puede abrir, pero qué contiene lo decide el alcance.
- `show` carga por alcance: lo que está fuera no se encuentra y responde el
  404 de GL-03. `authorize` repite la regla por la política.
- No hay `skip_policy_scope` ni `skip_authorization`: la lista de
  excepciones de GL-03 pierde la entrada de `HomeController#show`.

### 4. Vistas

- **Layout:** si `authenticated?`, una cabecera con `<header>` y `<nav
  aria-label="Principal">`: «Growth Log», el enlace «Personas»
  (`aria-current="page"` en el listado y en la ficha), «Sesión iniciada
  como <nombre>» y el botón «Cerrar sesión» (`button_to ... method:
  :delete`). El contenido va en `<main>`.
- **Listado:** `<h1>Personas</h1>`; una lista `<ul>` con un enlace por
  persona; dentro, el nombre y, debajo, «rol · equipo». Estado vacío:
  «Todavía no tenés personas asignadas. Cuando te asignen una, va a
  aparecer acá.» No menciona la administración, que no existe en la
  interfaz.
- **Ficha:** enlace «← Volver a Personas», `<h1>` con el nombre y una línea
  con rol y equipo; si falta uno, «Sin rol indicado» o «Sin equipo
  indicado» (P-17, aprobada). Nada más.
- Textos en español rioplatense, sin «Publicar», sin funciones
  inexistentes. `content_for :title` con «Personas · Growth Log» y «<nombre>
  · Growth Log».

### 5. Estilos

CSS propio en `app/assets/stylesheets/application.css` (Propshaft, ya
incluido), unas 80 líneas:

- tipografía del sistema, tamaño base 1rem, interlineado 1.5, contraste
  AA;
- contenedor de ancho máximo 48rem con márgenes laterales;
- cabecera con `flex-wrap`: en pantallas estrechas pasa a dos líneas;
- filas del listado de ancho completo, con área táctil de al menos 44 px;
- foco visible en enlaces y botones; sin depender del color para el
  estado actual (`aria-current` y subrayado).

Sin framework visual, sin dependencias, sin JavaScript nuevo.

### 6. Pruebas existentes que cambian

| Archivo | Cambio | Por qué |
|---|---|---|
| `spec/requests/route_protection_spec.rb` (GL-02) | la lista exacta de rutas agrega `GET /personas` y `GET /personas/:id` | es una lista cerrada a propósito |
| `spec/requests/authorization_coverage_spec.rb` (GL-03) | la tabla agrega las dos rutas, y `GET /` pasa a ser el listado | rutas nuevas |
| `spec/authorization/exceptions_spec.rb` (GL-03) | sale `HomeController#show` | el controlador desaparece |
| `spec/requests/authorization_mechanism_spec.rb` (GL-03) | el controlador de prueba usa una política propia que permite, en lugar de `HomePolicy` | `HomePolicy` desaparece |

Ninguna expectativa de GL-02 o GL-03 se debilita: las listas se amplían o
pierden una entrada que ya no existe.

## Verificación

### Pruebas de peticiones (automatizadas, en el CI)

Datos propios en cada prueba, con las ayudas de `spec/support`
(`create_user`, `create_person`, `assign`) y correos `@example.test`; no
usan la base de desarrollo ni la tarea de GL-08.

| Archivo | Qué prueba | Criterios |
|---|---|---|
| `spec/requests/people_spec.rb` | listado de L1 (P y Q, ordenadas, con rol y equipo; sin la persona inactiva, sin la de asignación terminada, sin la persona sin líderes); listado de L2; estado vacío de L3 y de la administradora; administradora asignada a una persona; ficha de L1 y de L2 sobre la persona compartida, sin el nombre del otro líder; «Sin rol indicado»; 404 por URL directa para persona ajena, inactiva, asignación terminada, administradora e inexistente, con el mismo cuerpo y sin el nombre | E2 a E6 |
| `spec/requests/navigation_spec.rb` | tras iniciar sesión se llega al listado; cabecera con «Personas», nombre y «Cerrar sesión»; sin cabecera en el inicio de sesión; único formulario «Cerrar sesión»; sin textos de funciones inexistentes | E1, E7 |
| pruebas de la sección 6 | cobertura y lista de rutas | E8 |

### Mutaciones (con copia de seguridad y restauración comprobada)

1. **`policy_scope(Person).find` → `Person.find` en `show`:** la petición
   falla con `Pundit::PolicyScopingNotPerformedError` dentro de
   `people_spec`. Detecta la omisión del alcance, pero el dato no se filtra
   porque `authorize` sigue denegando: es defensa en profundidad.
2. **`Person.find` sin `authorize` y con `skip_policy_scope`:** las
   verificaciones ya no intervienen y `people_spec` falla porque la ficha
   ajena responde 200 con el nombre. Demuestra que las pruebas de
   comportamiento detectan la fuga por sí solas.
3. **Listado sin alcance** (`Person.active.order(:name)` con
   `skip_policy_scope`): falla el estado vacío de L3 y el listado de L1.
4. **`PersonPolicy#index?` en falso:** el listado responde 404 y falla la
   navegación.

### Comprobación en navegador (manual, no automatizada)

La prueba automatizada en navegador necesita resolver **ADR-6 (P-4)** y
agregar dependencias de prueba; queda para GL-09. En GL-05 no se declara
ejecutada.

En su lugar, Pablo hace una comprobación **manual** con los datos de GL-08,
y se registra como manual con fecha y navegador:

1. Iniciar sesión como Elena: llega a «Personas» y ve a Ada y a Bruno.
2. Abrir la ficha de Ada y volver con «← Volver a Personas».
3. Pedir a mano `/personas/<id de Carla>` como Elena: página 404.
4. Iniciar sesión como Inés: ve el estado vacío.
5. Repetir 1 y 4 con un ancho de 375 px (herramientas de desarrollo):
   cabecera en dos líneas, sin desplazamiento horizontal, enlaces fáciles
   de tocar.
6. Navegar solo con el teclado: el foco se ve en cada enlace y botón.
7. Cerrar sesión desde la cabecera.

El agente no inicia sesión con cuentas ficticias porque no conoce sus
contraseñas.

### Ejecución (03/11/2026, local)

**Comprobado en local**, en la rama `feature/GL-05-personas`:

- **Pruebas primero:** con `people_spec`, `navigation_spec` y los ajustes de
  la sección 6 escritos, 31 de 44 ejemplos fallaron por la razón esperada:
  - no existían `people_path` ni `person_path`;
  - la tabla de cobertura no coincidía con las rutas;
  - sobraba la excepción de `HomeController#show`.

  Con la implementación, los 44 pasan.
- **Mutaciones** (evidencia local `~/growth-log-evidencias/gl-05-mutaciones.txt`;
  cada archivo se restauró desde una copia y su SHA-256 quedó idéntico):

  | # | Mutación | Resultado |
  |---|---|---|
  | 1 | `Person.find` en lugar de `policy_scope(Person).find` en `show` | 6 fallas por `Pundit::PolicyScopingNotPerformedError` con el actor autorizado. Las fichas ajenas siguen en 404 porque `authorize` deniega: defensa en profundidad |
  | 2 | `Person.find` con `skip_authorization` y `skip_policy_scope` | 6 fallas de comportamiento: las fichas fuera del alcance responden 200 |
  | 3 | listado con `Person.active` y `skip_policy_scope` | 9 fallas, entre ellas el estado vacío y la cobertura del actor sin permisos |
  | 4 | `PersonPolicy#index?` en falso | 11 fallas: el listado responde 404 y la navegación falla |
- **Verificación completa:** `bin/bundler-audit update` y después `bin/ci`
  con código 0:
  - RuboCop sin ofensas, sin vulnerabilidades y Brakeman sin avisos;
  - 192 ejemplos y 0 fallas;
  - `openspec validate --all --strict` con 15 de 15.

**Desvío:** el primer intento de mutaciones con un script de shell no ejecutó
las pruebas, porque zsh no separó la lista de archivos de spec, y una de las
ediciones tuvo un error de sintaxis. Ningún archivo quedó modificado: las
restauraciones dieron el mismo SHA. Se repitió con un script de Python, y
ese es el resultado registrado.

**Pendiente:**

- la comprobación manual en navegador (E10), a cargo de Pablo, que el
  agente no declara ejecutada;
- el CI remoto (E11), que requiere autorizar el push;
- la revisión humana y el archivo del cambio.

### Integración de GL-01b (07/11/2026, local)

- **Integración:** `feature/entrega-2-pp` en `8ae8723` (merge del PR #2,
  Rails 8.1.4.1) se fusionó sobre `d9365c6` sin conflictos.
  - Primero se probó en un worktree aparte, con `git merge --no-commit
    --no-ff`.
  - Después se confirmó como merge commit `a60fb8e` en una rama local.
  - Por último se llevó `feature/GL-05-personas` a ese commit con
    `git merge --ff-only`.
- **Diff:** solo trae `Gemfile.lock` y la documentación de GL-01b.
- **Verificación en el árbol integrado, antes del commit:**
  - `bin/rails runner` imprimió 8.1.4.1;
  - `bin/ci` registró «Continuous Integration passed», con RuboCop sin
    ofensas, sin vulnerabilidades, Brakeman sin avisos y 192 ejemplos con
    0 fallas.
- **Copias previas:** las seis copias sin versionar de GL-01b que había en
  el worktree principal se movieron a un respaldo fuera del repositorio,
  verificado por SHA-256, antes del avance rápido.
- **Pendiente:** la comprobación manual en navegador y el CI remoto.

## Risks / Trade-offs

- **Dos URL para el listado** (`/` y `/personas`) → simple y sin
  redireccionamiento sin sesión; la cobertura incluye las dos.
- **Pruebas de GL-02 y GL-03 modificadas** → solo se amplían o pierden lo
  que ya no existe; se revisan en el diff.
- **Sin prueba automatizada en navegador** → el CSS y la adaptación a
  móvil quedan con comprobación manual hasta GL-09.

## Migration Plan

Sin migraciones ni datos.

## Open Questions

P-15, P-16 y P-17 se aprobaron el 03/11/2026 según la recomendación.

- P-4 (ADR-6): sigue abierta; solo afecta a la prueba automatizada en
  navegador.
