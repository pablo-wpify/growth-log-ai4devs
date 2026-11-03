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

## Estado actual

Rama `feature/entrega-2-pp`. Actualizado al 02/11/2026.

| | Qué | Evidencia |
|---|---|---|
| **Implementado y verificado** | Base del producto: Rails 8.1.4, Ruby 4.0.9, PostgreSQL 18.6, RSpec, `bin/ci` y GitHub Actions; chequeo de salud `GET /up` (GL-01) | [ticket](docs/tickets/GL-01-base-producto.md) |
| | Corrección de 15 avisos de seguridad de gemas (GL-01a) | [ticket](docs/tickets/GL-01a-avisos-seguridad.md) |
| | Autenticación: cuentas individuales sin registro público, inicio y cierre de sesión, sesiones con vencimiento, límites de intentos, CSRF, rutas protegidas por defecto y administrador inicial por tarea (GL-02) | [ticket](docs/tickets/GL-02-autenticacion.md); CI [41557336838](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41557336838) sobre `94e40a1` |
| | Autorización mínima: denegar por defecto, alcance por asignación y personas y asignaciones sin interfaz (GL-03). **No verifica todavía** la autorización de personas por URL (GL-05), del feedback (GL-06) ni del resumen (GL-07), que no existen | [ticket](docs/tickets/GL-03-autorizacion-minima.md); CI [41571299236](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41571299236) sobre `7263efd` |
| | Datos ficticios reproducibles para desarrollo (GL-08): tarea solo en `development`, sin contraseñas versionadas ni adopción de registros ajenos. **No verifica** el aislamiento del feedback, que llega con GL-06 | [ticket](docs/tickets/GL-08-datos-ficticios.md); CI [41621619815](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41621619815) sobre `2bd5deb` |
| **Siguiente** | «Personas» y ficha del líder (GL-05): implementado en local en la rama `feature/GL-05-personas`; faltan la comprobación manual en navegador y el CI remoto | [ticket](docs/tickets/GL-05-personas.md) |
| **Pendiente** | Personas, feedback, resumen, verificación E2E y todo el alcance diferido (invitaciones, administración, compartir, feed, despliegue) | [plan de la entrega 2](docs/plan-entrega-2.md) |

Lo pendiente sigue siendo requisito: diferirlo no lo elimina. **Hoy la
aplicación no tiene pantallas de personas ni registra feedback** y no admite
datos reales.

## Dónde está cada cosa

| Para | Ir a |
|---|---|
| Instalar y ejecutar en local | [docs/desarrollo.md](docs/desarrollo.md) |
| Secuencia vigente, alcance diferido y decisiones pendientes | [docs/plan-entrega-2.md](docs/plan-entrega-2.md) (fuente única) |
| Tickets de la entrega 2 | [docs/tickets/](docs/tickets/) |
| Requisitos vigentes (specs) | [openspec/specs/](openspec/specs/); cambios en curso en [openspec/changes/](openspec/changes/) |
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
| 0.4. URL del proyecto | **Pendiente:** no hay despliegue. |
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
[Anexo E](anexos/anexo-e-mocks.md). Todavía no hay pantallas del producto
más allá del inicio de sesión y una página de inicio provisoria.

### 1.4. Instrucciones de instalación

[docs/desarrollo.md](docs/desarrollo.md).

## 2. Arquitectura del sistema

Monolito Rails con HTML del servidor (ADR-1), implementado como base en
GL-01. Diagrama, componentes y requisitos:
[propuesta, sección 2](propuesta-mvp.md#2-arquitectura-del-sistema).

### 2.1. Diagrama de arquitectura

[Propuesta, 2.1](propuesta-mvp.md#21-diagrama-de-arquitectura).

### 2.2. Componentes principales y stack

Implementado: Ruby 4.0.9, Rails 8.1.4, PostgreSQL 18.6, Hotwire con
importmap, Propshaft, RSpec, RuboCop, Brakeman y `bundler-audit`; `bcrypt`
para contraseñas (ADR-2). Propuesta original:
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

RSpec, ejecutado por `bin/ci` en local y en el CI. Estrategia y casos de
permisos PT-1 a PT-12:
[propuesta, 2.6](propuesta-mvp.md#26-tests). La verificación E2E del
recorrido núcleo está en el [plan](docs/plan-entrega-2.md).

## 3. Modelo de datos

Implementado: `users`, `sessions` y `login_attempt_counters` (GL-02), y
`people` y `assignments` (GL-03) ([db/schema.rb](db/schema.rb)). Modelo conceptual completo:
[propuesta, sección 3](propuesta-mvp.md#3-modelo-de-datos).

### 3.1. Diagrama del modelo de datos

[Propuesta, 3.1](propuesta-mvp.md#31-diagrama-del-modelo-de-datos).

### 3.2. Descripción de entidades principales

[Propuesta, 3.2](propuesta-mvp.md#32-descripción-de-entidades-principales),
con las reglas que cruzan entidades.

## 4. Especificación de la API y rutas HTTP

Rutas HTML del monolito, sin API JSON:
[propuesta, sección 4](propuesta-mvp.md#4-especificación-de-la-api-y-rutas-http).
Hoy existen `GET /up`, el inicio y cierre de sesión y la página de inicio.

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

Todavía no hay pull requests. Los cambios de la entrega 2 se publican en
`feature/entrega-2-pp` y el CI se ejecuta en cada push; cada ticket
registra su ejecución.

## 8. Estado de confiabilidad

Matriz de 11 capas: [propuesta, sección 8](propuesta-mvp.md#8-estado-de-confiabilidad)
y [Anexo B](anexos/anexo-b-matriz-confiabilidad.md). Implementado hasta hoy:
límite de intentos de inicio de sesión (capa 1), chequeo de salud (capa 5),
CI (capa 6, sin despliegue) y autenticación (capa 10, sin invitaciones ni
desactivación por interfaz).

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
ADR-2 se decidió en GL-02 y ADR-3, para GL-03.

### 9.3. Riesgos principales

[Propuesta, 9.3](propuesta-mvp.md#93-riesgos-principales) y
[Anexo C](anexos/anexo-c-riesgos-decisiones.md).

## 10. Plan de trabajo y uso de IA

Plan vigente: [plan de la entrega 2](docs/plan-entrega-2.md). Plan
incremental del MVP completo, como referencia:
[propuesta, sección 10](propuesta-mvp.md#10-plan-de-trabajo-y-uso-de-ia) y
[Anexo G](anexos/anexo-g-plan-incremental.md). Uso de IA en la entrega 1:
[prompts.md](prompts.md).
