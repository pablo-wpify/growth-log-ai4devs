# GL-05. «Personas» y ficha del líder

> Sexto ticket de la entrega 2 de Growth Log. Lugar en la secuencia:
> [plan de la entrega 2](../plan-entrega-2.md). Cambio de OpenSpec,
> archivado: [`2026-11-07-gl-05-personas`](../../openspec/changes/archive/2026-11-07-gl-05-personas/proposal.md).
> Spec vigente: [`people-browsing`](../../openspec/specs/people-browsing/spec.md).
> **Estado (07/11/2026): cerrado y archivado.** Integrado en
> `feature/entrega-2-pp` con el PR
> [#3](https://github.com/pablo-wpify/growth-log-ai4devs/pull/3) (merge commit `8d0e854`, CI
> [42398717466](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/42398717466) en success, 192 ejemplos).
> Comprobación manual en navegador (E10) hecha el 07/11/2026 por Pablo y
> con asistencia de Claude Code; los 375 px fueron emulados con DevTools.
> Resultados y desvíos en el
> [diseño](../../openspec/changes/archive/2026-11-07-gl-05-personas/design.md#comprobación-en-navegador-e10-07112026-local-manual).
> Cuatro pasos adicionales del procedimiento del diseño quedan como
> seguimiento sin comprobar (detalle en el plan, sección 9).
> Decisiones P-15 a P-17 aprobadas el 03/11/2026.

## Problema

Después de iniciar sesión, un líder solo ve una página provisoria con su
nombre. El segundo paso del recorrido núcleo, «elegir una persona
asignada», no existe: no hay listado ni ficha, y la regla de acceso de
GL-03 todavía no protege ninguna ruta real.

## Origen

| Fuente | Qué exige |
|---|---|
| Criterio 1.14 ([Anexo A](../../anexos/anexo-a-historias.md)) | en «Personas», solo las personas activas asignadas, ordenadas por nombre, con rol y equipo |
| 1.16 | sin personas asignadas, un mensaje que lo explica |
| 1.17 | abrir una persona asignada muestra su ficha |
| 1.19 | sin asignación activa, tampoco por URL directa, no se accede |
| 1.21 (parcial) | una cuenta administradora ve como líder solo sus personas asignadas |
| PP-2, PP-8 | acceso por asignación activa; administrar no da acceso |
| Spec [`authorization`](../../openspec/specs/authorization/spec.md) | denegación por defecto, carga por alcance, 404 igual que un inexistente, rutas en la prueba de cobertura |
| Plan, sección 7 | URL directa de persona ajena: pendiente desde GL-03 |

## Alcance

1. Navegación visible tras iniciar sesión: «Growth Log», el enlace
   «Personas», el nombre de la cuenta y «Cerrar sesión».
2. Listado «Personas» con las personas activas que la cuenta tiene
   asignadas, ordenadas por nombre, con rol y equipo.
3. Estado vacío claro para quien no tiene personas asignadas.
4. Ficha con los datos mínimos (nombre, rol y equipo) y un enlace de vuelta
   al listado.
5. Autorización con `policy_scope` y `authorize` (GL-03): 404 ante una
   persona fuera del alcance, igual que ante una inexistente; el rol de
   administrador no da acceso adicional.
6. Las rutas nuevas en la prueba de cobertura de GL-03.
7. Estilos propios, sencillos y adaptables a móvil, con el stack actual.

## Exclusiones

- Crear, editar, dar de baja o reactivar personas; asignar o terminar
  asignaciones; cualquier vista administrativa (GL-04).
- Formularios de feedback, «Captura rápida», «+ Feedback», resumen,
  cronología y conteos (GL-06, GL-07).
- Nombres de los otros líderes de la persona (1.18): se difieren con la
  compartición; no mostrarlos es más restrictivo.
- Enlaces o botones que anuncien funciones que todavía no existen.
- Interfaz del autor sin asignación (P-7, pendiente).
- Frameworks visuales o dependencias nuevas.
- Prueba automatizada en navegador: requiere ADR-6 (P-4), sin resolver.

## Datos visibles en la ficha

| Dato | Se muestra | Por qué |
|---|---|---|
| Nombre | sí, como título | 1.17 |
| Rol y equipo | sí; si falta uno, «Sin rol indicado» o «Sin equipo indicado» | 1.14 |
| Otros líderes asignados | **no** | 1.18 diferido |
| Estado, fechas de asignación, identificadores internos | **no** | no hay criterio que los pida |
| Resumen, entradas, captura rápida | **no** | GL-06 y GL-07 |

## Navegación

```
┌──────────────────────────────────────────────────────────┐
│ Growth Log   Personas        Elena Boceto [Cerrar sesión]│
├──────────────────────────────────────────────────────────┤
│ Personas                                                 │
│  Ada Ejemplo                 Desarrolladora · Equipo Faro│
│  Bruno Ejemplo               Analista · Equipo Faro      │
└──────────────────────────────────────────────────────────┘
       │ clic en una persona
       ▼
┌──────────────────────────────────────────────────────────┐
│ Growth Log   Personas        Elena Boceto [Cerrar sesión]│
├──────────────────────────────────────────────────────────┤
│ ← Volver a Personas                                      │
│ Ada Ejemplo                                              │
│ Desarrolladora · Equipo Faro                             │
└──────────────────────────────────────────────────────────┘
```

En un teléfono, la cabecera pasa a dos líneas y cada persona ocupa una fila
completa, con su rol y equipo debajo del nombre. Detalle en el
[diseño](../../openspec/changes/archive/2026-11-07-gl-05-personas/design.md).

## Criterios de aceptación

| # | Criterio | Origen |
|---|---|---|
| E1 | Tras iniciar sesión se llega a «Personas»; la cabecera muestra «Personas», el nombre de la cuenta y «Cerrar sesión» en todas las páginas con sesión, y no aparece en el inicio de sesión | alcance; GL-02 |
| E2 | El listado muestra solo las personas activas con una asignación activa de la cuenta, ordenadas por nombre, con rol y equipo | 1.14, PP-2 |
| E3 | Sin personas asignadas, el listado muestra un mensaje que lo explica | 1.16 |
| E4 | La ficha de una persona asignada muestra nombre, rol y equipo y un enlace a «Personas», y no muestra a los otros líderes | 1.17, 1.18 diferido |
| E5 | Por URL directa, la ficha de una persona sin asignación, inactiva, con la asignación terminada o inexistente responde 404 con la misma página, sin datos de la persona | 1.19, P-7, P-9, ADR-3 |
| E6 | Una administradora sin asignaciones ve el estado vacío y recibe 404 en cualquier ficha; con una asignación, ve solo esa persona | PP-8, 1.21 parcial |
| E7 | Las páginas no tienen formularios salvo «Cerrar sesión», ni enlaces o textos de funciones administrativas o de feedback | exclusiones |
| E8 | Las rutas nuevas están en la prueba de cobertura con un actor autorizado y uno sin permisos; la prueba sin sesión de GL-02 las incluye | GL-03, GL-02 |
| E9 | Mutaciones registradas: con `Person.find` en lugar de la carga por alcance, falla una prueba de peticiones; con la carga y la verificación quitadas, falla una prueba de comportamiento por mostrar la persona; con el listado sin alcance, falla la prueba del estado vacío | GL-03 |
| E10 | Las vistas se ven y funcionan en un navegador en escritorio y con un ancho de teléfono, comprobado **a mano** por Pablo con los datos de GL-08 y registrado como comprobación manual | alcance |
| E11 | `bin/ci` y el CI remoto pasan | GL-01 |

## Dependencias

GL-03 y GL-08 cerrados (`eacb16e`). P-15 a P-17 aprobadas (03/11/2026). P-4
(ADR-6) sigue abierta y solo afecta a la prueba automatizada en navegador,
que queda para GL-09.

## Relación con la entrega

Segundo paso del recorrido núcleo: «elegir una persona asignada». Tarea
T1.4 del Anexo G, sin la administración de T1.3.
