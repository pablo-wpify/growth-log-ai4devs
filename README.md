# Growth Log

Bitácora web para que **varios líderes** registren feedback fechado y
concreto sobre las personas que acompañan, y lleguen a los 1:1 y a las
evaluaciones con evidencia acumulada en lugar de memoria. Privacidad por
defecto: lo que escribe un líder es suyo hasta que decida compartirlo.
Proyecto final de AI4Devs de Pablo Peuscovich.

**Recorrido núcleo de la entrega 2:**

1. iniciar sesión;
2. elegir una persona asignada;
3. capturar una observación como borrador privado;
4. completarla y marcarla como lista (sigue privada);
5. consultar el resumen por dimensión y la cronología.

**En pocas palabras:** el recorrido núcleo funciona de punta a punta en la
rama `feature/entrega-2-pp` y está cubierto por pruebas automatizadas,
incluidas dos en un navegador real, en local y en el CI. Las cuentas, las
personas y las asignaciones se preparan con datos ficticios, porque la
administración por interfaz está diferida. No hay despliegue.

## Cómo revisar esta entrega

La entrega es la rama `feature/entrega-2-pp`, enviada por Typeform; no
requiere un pull request. El despliegue es opcional y no lo hay: el
funcionamiento se comprueba con el CI público o en local.

**1. CI público.** Cada push a la rama ejecuta estilo, auditorías de
seguridad y la suite completa, incluidas las pruebas en navegador:
[ejecuciones de `feature/entrega-2-pp`](https://github.com/pablo-wpify/growth-log-ai4devs/actions/workflows/ci.yml?query=branch%3Afeature%2Fentrega-2-pp).
La última comprobada antes de esta revisión documental es la
[43635435427](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43635435427), sobre `188bc2a`: 317 ejemplos y
0 fallos.

**2. Instalar en local, desde un clon limpio.** Hace falta Ruby 4.0.9
(declarada en `.ruby-version` y `.tool-versions`), Docker para PostgreSQL
18.6 y Google Chrome para las pruebas en navegador; no hace falta Node.
Cada paso está explicado en la [guía de desarrollo](docs/desarrollo.md).

```sh
git clone --branch feature/entrega-2-pp https://github.com/pablo-wpify/growth-log-ai4devs.git
cd growth-log-ai4devs
bundle install

# Variables locales: .env no se versiona; la contraseña de la base se genera.
cp .env.example .env
sed -i.bak "s/^DATABASE_PASSWORD=.*/DATABASE_PASSWORD=$(openssl rand -hex 24)/" .env && rm .env.bak
chmod 600 .env
set -a; . ./.env; set +a

# PostgreSQL 18.6 en Docker, publicado solo en 127.0.0.1.
POSTGRES_USER="$DATABASE_USERNAME" POSTGRES_PASSWORD="$DATABASE_PASSWORD" docker run -d --name "$GROWTH_LOG_PG_CONTAINER" -e POSTGRES_USER -e POSTGRES_PASSWORD -v "$GROWTH_LOG_PG_VOLUME:/var/lib/postgresql" -p "127.0.0.1:$DATABASE_PORT:5432" postgres:18.6
until docker exec "$GROWTH_LOG_PG_CONTAINER" pg_isready -q; do sleep 1; done

bin/rails db:prepare
RAILS_ENV=test bin/rails db:prepare
```

**3. Ejecutar las pruebas.**

```sh
bundle exec rspec spec/system   # recorrido núcleo y rama negativa, en Chrome sin interfaz
bundle exec rspec               # suite completa
```

`bin/ci` agrega estilo, auditorías y Brakeman; antes conviene
`bin/bundler-audit update`. Ojo: `bin/ci` vacía `log/development.log` y
`log/test.log` (ver la [guía, sección 6](docs/desarrollo.md#6-análisis-y-verificación-completa)).

**4. Recorrido manual con datos ficticios.** El repositorio no trae
credenciales: no hay registro público ni contraseñas versionadas (PP-1,
AM-5). Quien revisa elige la contraseña de cada cuenta ficticia; se pide
dos veces sin eco, necesita al menos 15 caracteres y solo funciona en
desarrollo.

```sh
bin/rails growth_log:datos_ficticios
EMAIL=elena.boceto@ficticio.example.test bin/rails growth_log:contrasena_ficticia
EMAIL=tomas.borrador@ficticio.example.test bin/rails growth_log:contrasena_ficticia
bin/rails server
```

En `http://localhost:3000`:

1. Iniciar sesión como `elena.boceto@ficticio.example.test` y abrir «Ada
   Ejemplo» desde «Personas».
2. «Captura rápida» → escribir qué pasó → «Guardar borrador». La
   «Vista cronológica» la muestra como «Borrador · solo vos · fuera del
   resumen».
3. Abrir la entrada → «Editar» → elegir señal y dimensión → «Guardar
   cambios» → «Marcar como lista».
4. Volver a la ficha: la entrada cuenta en el «Resumen por dimensión» y la
   cronología la muestra como «Lista · solo vos».
5. «Cerrar sesión» y entrar como `tomas.borrador@ficticio.example.test`,
   que también acompaña a Ada: no ve la entrada de Elena, y la URL de esa
   entrada (`/entradas/<id>`) responde 404.

Las pruebas en navegador de GL-09 automatizan este recorrido con sus propios
datos. Con estas cuentas ficticias, la captura se comprobó a mano en GL-06
(F17, parcial); el resumen y la cronología no tienen una comprobación
manual registrada.

**Qué no incluye:** invitaciones, administración por interfaz, compartir,
filtros, feed y despliegue. Siguen siendo requisitos pendientes
([plan](docs/plan-entrega-2.md)).

## Estado actual

Rama `feature/entrega-2-pp`. Actualizado al 14/11/2026.

| | Qué | Evidencia |
|---|---|---|
| **Implementado y verificado** | Base del producto: Rails 8.1.4 (8.1.4.1 desde GL-01b), Ruby 4.0.9, PostgreSQL 18.6, RSpec, `bin/ci` y GitHub Actions; chequeo de salud `GET /up` (GL-01) | [ticket](docs/tickets/GL-01-base-producto.md) |
| | Corrección de 15 avisos de seguridad de gemas (GL-01a) | [ticket](docs/tickets/GL-01a-avisos-seguridad.md) |
| | Rails 8.1.4.1 por los 21 avisos de seguridad del 04/11/2026 (GL-01b) | [ticket](docs/tickets/GL-01b-rails-8-1-4-1.md); CI [42380986492](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/42380986492) sobre `8ae8723` |
| | Autenticación: cuentas individuales sin registro público, inicio y cierre de sesión, sesiones con vencimiento, límites de intentos, CSRF, rutas protegidas por defecto y administrador inicial por tarea (GL-02) | [ticket](docs/tickets/GL-02-autenticacion.md); CI [41557336838](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41557336838) sobre `94e40a1` |
| | Autorización mínima: denegar por defecto, alcance por asignación y personas y asignaciones sin interfaz (GL-03). La autorización de personas por URL directa se verificó en GL-05. La de las entradas de feedback se comprueba con las pruebas automatizadas de GL-06 (matriz de privacidad por URL directa), no en este ticket; la del resumen, la cronología y el conteo, con las de GL-07 | [ticket](docs/tickets/GL-03-autorizacion-minima.md); CI [41571299236](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41571299236) sobre `7263efd` |
| | Datos ficticios reproducibles para desarrollo (GL-08): tarea solo en `development`, sin contraseñas versionadas ni adopción de registros ajenos. **No verifica** el aislamiento del feedback: los datos ficticios no traen entradas, y ese aislamiento lo cubren las pruebas automatizadas de GL-06 | [ticket](docs/tickets/GL-08-datos-ficticios.md); CI [41621619815](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41621619815) sobre `2bd5deb` |
| | «Personas» y ficha del líder (GL-05): listado y ficha de solo lectura con autorización por alcance y 404 por URL directa; comprobación manual en navegador (E10) del 07/11/2026, con 375 px emulados | [ticket](docs/tickets/GL-05-personas.md); CI [42398717466](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/42398717466) sobre `8d0e854` |
| **Integrado, con verificación en navegador parcial** | Captura rápida, completar y marcar como lista (GL-06): entradas de feedback privadas del autor, con lectura por autoría, escritura con asignación y persona activas y 404 por URL directa; integrado en `feature/entrega-2-pp` con el [PR #4](https://github.com/pablo-wpify/growth-log-ai4devs/pull/4) (merge commit `8c2f2ad`, 14/11/2026) y archivado como `2026-11-14-gl-06-captura-rapida`. Gate local del 14/11/2026 con 291 ejemplos. Verificado con pruebas automatizadas, gate local y CI remoto; la comprobación en navegador (F17) quedó **parcial** por decisión de Pablo (asistida por Claude Code, 375 px solo con `iframe` y la sesión vencida en el navegador solo como simulación sin cookie). PT-11: la interpretación de su rama de lectura está aclarada, pero PT-11 no está completo (compartir, revocar y reasignación fuera; listado de AM-1 pendiente) | [ticket](docs/tickets/GL-06-captura-rapida.md); CI [43609790733](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43609790733) sobre `d65a66a` (head del PR) y CI [43610547250](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43610547250) sobre el merge `8c2f2ad` |
| **Integrado** | Resumen por dimensión, vista cronológica y conteo de entradas listas en «Personas» (GL-07): solo entradas propias; el resumen y el conteo solo cuentan las listas; integrado en `feature/entrega-2-pp` con el [PR #5](https://github.com/pablo-wpify/growth-log-ai4devs/pull/5) (merge commit `b835bde`, 14/11/2026) y archivado como `2026-11-14-gl-07-resumen-cronologia`. Gate local del 14/11/2026 con 315 ejemplos. Verificado con pruebas automatizadas, mutaciones, gate local y CI remoto; el resumen y la cronología se verifican en navegador con GL-09; el conteo, no | [ticket](docs/tickets/GL-07-resumen-cronologia.md); CI [43631292881](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43631292881) sobre `8f36845` (head del PR) y CI [43632097169](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43632097169) sobre el merge `b835bde` |
| **Integrado: hito «recorrido núcleo»** | Verificación E2E del recorrido núcleo (GL-09, P-4): pruebas en navegador (Capybara y `selenium-webdriver`, Chrome sin interfaz) del recorrido de un líder (inicio de sesión, ficha, captura, completar, marcar como lista, resumen y cronología) y de la rama negativa de otro líder de la misma persona (ficha y URL directa con 404); integrado en `feature/entrega-2-pp` con el [PR #6](https://github.com/pablo-wpify/growth-log-ai4devs/pull/6) (merge commit `e0ceb4e`, 14/11/2026) y archivado como `2026-11-14-gl-09-e2e-recorrido-nucleo`. Gate local con 317 ejemplos. En verde en el CI remoto: alcanza el hito «recorrido núcleo» del plan, que **no equivale** al «primer recorrido usable» del Anexo G ni cubre lo diferido. La forma de entrega (esta rama, enviada por Typeform; deploy opcional; revisión local) la contrastó Pablo con la plataforma del curso (M208) | [ticket](docs/tickets/GL-09-e2e-recorrido-nucleo.md); CI [43634781960](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43634781960) sobre `2f192ab` (head del PR) y CI [43635205495](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43635205495) sobre el merge `e0ceb4e` |
| **Siguiente** | La secuencia del plan termina en GL-09; no hay un ticket siguiente decidido. Lo que queda es el alcance diferido (fila «Pendiente») | [plan de la entrega 2](docs/plan-entrega-2.md) |
| **Pendiente** | Todo el alcance diferido (invitaciones, administración, compartir, feed, despliegue) | [plan de la entrega 2](docs/plan-entrega-2.md) |

Lo pendiente sigue siendo requisito: diferirlo no lo elimina. GL-06 registra
feedback privado; GL-07 suma el resumen, la cronología y el conteo, y GL-09
verifica el recorrido núcleo en un navegador. El resto del alcance del MVP
sigue pendiente.

## Dónde está cada cosa

| Para | Ir a |
|---|---|
| Instalar y ejecutar en local | [docs/desarrollo.md](docs/desarrollo.md) |
| Secuencia vigente, alcance diferido y decisiones pendientes | [docs/plan-entrega-2.md](docs/plan-entrega-2.md) (fuente única) |
| Tickets de la entrega 2 | [docs/tickets/](docs/tickets/) |
| Requisitos vigentes (specs) | [openspec/specs/](openspec/specs/); cambios archivados en [openspec/changes/archive/](openspec/changes/archive/) |
| Decisiones del producto | [docs/decisiones/](docs/decisiones/) |
| Contexto para asistentes de IA | [CLAUDE.md](CLAUDE.md) |
| Propuesta completa del MVP (entrega 1) | [propuesta-mvp.md](propuesta-mvp.md) |
| Criterios, matriz, riesgos, ADR, mocks, prompts y plan incremental | [anexos/](anexos/) y [prompts.md](prompts.md) |

## Contenido de la entrega

Cada sección de la plantilla remite a su contenido completo. Los números y
títulos se conservan para que los enlaces de los anexos sigan funcionando.

## 0. Ficha del proyecto

| Campo | Valor |
|---|---|
| 0.1. Nombre completo | Pablo Peuscovich |
| 0.2. Nombre del proyecto | Growth Log. Proyecto personal de Pablo Peuscovich, autor de la idea. |
| 0.3. Descripción breve | Bitácora para que varios líderes registren feedback concreto sobre las personas que acompañan y lo usen en 1:1 y evaluaciones, con privacidad por defecto y compartición explícita. |
| 0.4. URL del proyecto | No hay despliegue (es opcional). Para revisar el funcionamiento: [Cómo revisar esta entrega](#cómo-revisar-esta-entrega). |
| 0.5. Repositorio | [github.com/pablo-wpify/growth-log-ai4devs](https://github.com/pablo-wpify/growth-log-ai4devs). Entrega 1: [`feature/entrega-1-pp`](https://github.com/pablo-wpify/growth-log-ai4devs/tree/feature/entrega-1-pp). Entrega 2: [`feature/entrega-2-pp`](https://github.com/pablo-wpify/growth-log-ai4devs/tree/feature/entrega-2-pp). |

## 1. Descripción general del producto

Objetivo, usuarios, hipótesis de valor y política de privacidad PP-1 a
PP-9: [propuesta, sección 1](propuesta-mvp.md#1-descripción-general-del-producto).

### 1.1. Objetivo

[Propuesta, 1.1](propuesta-mvp.md#11-objetivo). Las hipótesis HV-1 a HV-6
siguen sin medir.

### 1.2. Características y funcionalidades principales

[Propuesta, 1.2](propuesta-mvp.md#12-características-y-funcionalidades-principales):
las cinco historias, los estados borrador, lista y compartida, y la
política completa. El recorrido núcleo de la entrega 2 está arriba.

### 1.3. Diseño y experiencia de usuario

Mocks del recorrido, con datos ficticios:
[propuesta, 1.3](propuesta-mvp.md#13-diseño-y-experiencia-de-usuario) y
[Anexo E](anexos/anexo-e-mocks.md). Pantallas implementadas (GL-05 a
GL-07): inicio de sesión; «Personas», con el conteo de entradas listas; la
ficha de la persona, con «Captura rápida», «Resumen por dimensión» y «Vista
cronológica»; la captura rápida; y el detalle, la edición y «Marcar como
lista» de una entrada. Diferidas: administración, compartir, feed y
filtros.

### 1.4. Instrucciones de instalación

[docs/desarrollo.md](docs/desarrollo.md).

## 2. Arquitectura del sistema

Monolito Rails con HTML del servidor (ADR-1), implementado como base en
GL-01. Diagrama, componentes y requisitos:
[propuesta, sección 2](propuesta-mvp.md#2-arquitectura-del-sistema).

### 2.1. Diagrama de arquitectura

[Propuesta, 2.1](propuesta-mvp.md#21-diagrama-de-arquitectura).

### 2.2. Componentes principales y stack

Implementado: Ruby 4.0.9, Rails 8.1.4.1, PostgreSQL 18.6, Hotwire con
importmap, Propshaft, Pundit para la autorización (ADR-3, GL-03), RSpec con
Capybara y `selenium-webdriver` para las pruebas en navegador (ADR-6, GL-09),
RuboCop, Brakeman y `bundler-audit`; `bcrypt` para contraseñas (ADR-2). Propuesta original:
[2.2](propuesta-mvp.md#22-componentes-principales-y-stack).

### 2.3. Estructura de ficheros

Estructura estándar de Rails, más `docs/` (guía, plan, tickets,
decisiones), `openspec/` (specs y cambios), `anexos/` y `ensayo/`
(procedencia de la base). [Propuesta, 2.3](propuesta-mvp.md#23-estructura-de-ficheros).

### 2.4. Infraestructura y despliegue

Sin despliegue (ADR-7 abierta). CI en GitHub Actions en cada push a
`feature/entrega-2-pp` y en cada pull request.
[Propuesta, 2.4](propuesta-mvp.md#24-infraestructura-y-despliegue).

### 2.5. Seguridad

Requisitos: [propuesta, 2.5](propuesta-mvp.md#25-seguridad). Implementado y
especificado en [`authentication`](openspec/specs/authentication/spec.md),
[`user-accounts`](openspec/specs/user-accounts/spec.md),
[`initial-administrator`](openspec/specs/initial-administrator/spec.md) y
[`secrets-handling`](openspec/specs/secrets-handling/spec.md). Autorización
(GL-03): [`authorization`](openspec/specs/authorization/spec.md),
[`people`](openspec/specs/people/spec.md) y
[`assignments`](openspec/specs/assignments/spec.md). Datos ficticios de
desarrollo (GL-08): [`development-sample-data`](openspec/specs/development-sample-data/spec.md).

### 2.6. Tests

Una sola suite de RSpec (`bundle exec rspec`), ejecutada por `bin/ci` en
local y en GitHub Actions: 317 ejemplos al 14/11/2026. Incluye pruebas de
modelos, políticas y peticiones (con la matriz de privacidad por URL directa
de GL-06 y GL-07) y dos pruebas en navegador
([`spec/system/core_journey_spec.rb`](spec/system/core_journey_spec.rb),
GL-09). Los diseños de cada cambio registran mutaciones que comprueban que
las pruebas detectan fallas. Estrategia y casos de permisos PT-1 a PT-12:
[propuesta, 2.6](propuesta-mvp.md#26-tests); evidencia por ticket en el
[plan, sección 7](docs/plan-entrega-2.md#7-evidencia-del-recorrido-y-del-aislamiento-entre-líderes).

## 3. Modelo de datos

Implementado ([db/schema.rb](db/schema.rb)): `users`, `sessions` y
`login_attempt_counters` (GL-02); `people` y `assignments` (GL-03);
`sample_data_records`, marcas del conjunto ficticio (GL-08); y
`feedback_entries` (GL-06): autor, persona, fecha del hecho, contexto,
estado (`draft` o `ready`), señal, dimensión, evidencia, impacto y
confianza, con restricciones `CHECK` para los valores permitidos y para
exigir señal y dimensión en una entrada lista. La compartición, las
invitaciones y lo demás del modelo conceptual siguen pendientes:
[propuesta, sección 3](propuesta-mvp.md#3-modelo-de-datos).

### 3.1. Diagrama del modelo de datos

[Propuesta, 3.1](propuesta-mvp.md#31-diagrama-del-modelo-de-datos).

### 3.2. Descripción de entidades principales

[Propuesta, 3.2](propuesta-mvp.md#32-descripción-de-entidades-principales),
con las reglas que cruzan entidades.

## 4. Especificación de la API y rutas HTTP

Rutas HTML del monolito, sin API JSON:
[propuesta, sección 4](propuesta-mvp.md#4-especificación-de-la-api-y-rutas-http).
Rutas implementadas ([config/routes.rb](config/routes.rb)):

- `GET /up`: chequeo de salud;
- `GET /session/new`, `POST /session` y `DELETE /session`: inicio y cierre de sesión (GL-02);
- `GET /` y `GET /personas`: «Personas»; `GET /personas/:id`: ficha (GL-05);
- `GET /personas/:person_id/entradas/nueva` y `POST /personas/:person_id/entradas`: captura rápida (GL-06);
- `GET /entradas/:id`, `GET /entradas/:id/editar`, `PATCH /entradas/:id` y `PATCH /entradas/:id/marcar-lista`: detalle, edición y «Marcar como lista» (GL-06).

Toda ruta del producto exige sesión y autorización; un recurso fuera del
alcance responde 404, igual que uno inexistente.

## 5. Historias de usuario

H1 a H5, con sus criterios:
[propuesta, sección 5](propuesta-mvp.md#5-historias-de-usuario) y los 67
criterios en el [Anexo A](anexos/anexo-a-historias.md).

## 6. Tickets de trabajo

Tickets de la plantilla, que describen el alcance completo:
[propuesta, sección 6](propuesta-mvp.md#6-tickets-de-trabajo). Los tickets
en ejecución son los GL-xx de [docs/tickets/](docs/tickets/), en el orden
del [plan](docs/plan-entrega-2.md).

### MVP-DB-1. Modelo de administración, asignaciones, autoría y compartición (base de datos)

[Ver en la propuesta](propuesta-mvp.md#mvp-db-1-modelo-de-administración-asignaciones-autoría-y-compartición-base-de-datos).

### MVP-BE-2. Administración mínima: cuentas, personas y asignaciones (backend)

[Ver en la propuesta](propuesta-mvp.md#mvp-be-2-administración-mínima-cuentas-personas-y-asignaciones-backend).

### MVP-BE-1. Autorización de lectura, edición y compartición de entradas en el servidor (backend)

[Ver en la propuesta](propuesta-mvp.md#mvp-be-1-autorización-de-lectura-edición-y-compartición-de-entradas-en-el-servidor-backend).

### MVP-FE-1. Captura rápida accesible desde la ficha (frontend)

[Ver en la propuesta](propuesta-mvp.md#mvp-fe-1-captura-rápida-accesible-desde-la-ficha-frontend).

## 7. Pull requests

Seis pull requests contra `feature/entrega-2-pp`, todos integrados con
merge commit: [#1](https://github.com/pablo-wpify/growth-log-ai4devs/pull/1) (registro de prompts), [#2](https://github.com/pablo-wpify/growth-log-ai4devs/pull/2)
(GL-01b), [#3](https://github.com/pablo-wpify/growth-log-ai4devs/pull/3) (GL-05), [#4](https://github.com/pablo-wpify/growth-log-ai4devs/pull/4) (GL-06),
[#5](https://github.com/pablo-wpify/growth-log-ai4devs/pull/5) (GL-07) y [#6](https://github.com/pablo-wpify/growth-log-ai4devs/pull/6) (GL-09). GL-01, GL-01a, GL-02,
GL-03 y GL-08 se publicaron directamente en la rama. El CI se ejecuta en
cada pull request y en cada push a la rama; cada ticket registra su
ejecución.

## 8. Estado de confiabilidad

Matriz de 11 capas: [propuesta, sección 8](propuesta-mvp.md#8-estado-de-confiabilidad)
y [Anexo B](anexos/anexo-b-matriz-confiabilidad.md). Implementado hasta hoy,
todo de forma parcial respecto de la matriz:

- límite de intentos de inicio de sesión (capa 1);
- índices de entradas por autor y por persona (capa 4);
- chequeo de salud (capa 5);
- CI en cada pull request y push (capa 6, sin despliegue);
- feedback filtrado de los logs de peticiones y consultas (capa 8, sin
  seguimiento de errores);
- autorización en el servidor que deniega por defecto, con consultas con
  alcance y pruebas de acceso permitido y denegado (capa 9, sin Row Level
  Security);
- autenticación (capa 10, sin invitaciones ni desactivación por interfaz).

## 9. Decisiones abiertas y riesgos

Decisiones de privacidad, ADR y riesgos:
[propuesta, sección 9](propuesta-mvp.md#9-decisiones-abiertas-y-riesgos).
Las decisiones tomadas después de la entrega 1 están en
[docs/decisiones/](docs/decisiones/) y las pendientes, en el
[plan](docs/plan-entrega-2.md#6-decisiones-pendientes-de-aprobación).

### 9.1. Decisiones de privacidad

[Propuesta, 9.1](propuesta-mvp.md#91-decisiones-de-privacidad).

### 9.2. Decisiones de arquitectura y de producto

[Propuesta, 9.2](propuesta-mvp.md#92-decisiones-de-arquitectura-y-de-producto).
ADR-2 se decidió en GL-02; ADR-3, para GL-03 (P-5); y ADR-6, para GL-09 (P-4: pruebas de sistema de RSpec con Capybara y `selenium-webdriver`). ADR-5, ADR-7 y ADR-8 siguen abiertas.

### 9.3. Riesgos principales

[Propuesta, 9.3](propuesta-mvp.md#93-riesgos-principales) y
[Anexo C](anexos/anexo-c-riesgos-decisiones.md).

## 10. Plan de trabajo y uso de IA

Plan vigente: [plan de la entrega 2](docs/plan-entrega-2.md). Plan
incremental del MVP completo, como referencia:
[propuesta, sección 10](propuesta-mvp.md#10-plan-de-trabajo-y-uso-de-ia) y
[Anexo G](anexos/anexo-g-plan-incremental.md). Uso de IA en las dos
entregas, con los prompts clave de la entrega 2:
[prompts.md](prompts.md).
