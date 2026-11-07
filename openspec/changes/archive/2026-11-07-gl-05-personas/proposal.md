# Proposal

## Why

El recorrido núcleo necesita que un líder, después de iniciar sesión, elija
una persona que tiene asignada. Hoy solo hay una página provisoria, y la
regla de acceso de GL-03 no protege ninguna ruta real. Fuente:
`docs/tickets/GL-05-personas.md`, criterios 1.14, 1.16, 1.17, 1.19 y 1.21
(parcial), y el plan de la entrega 2.

## What Changes

- Listado «Personas» y ficha de una persona, solo de lectura, con
  `policy_scope` y `authorize`.
- La página de inicio pasa a ser el listado «Personas» y se elimina la
  página provisoria de GL-02 (P-15).
- Rutas `/personas` y `/personas/:id` (P-16).
- Cabecera común con «Personas», el nombre de la cuenta y «Cerrar sesión»,
  solo con sesión.
- Estilos propios en `application.css`, sin framework ni dependencias.
- `PersonPolicy#index?` permite el listado a cualquier cuenta identificada;
  lo que se lista lo decide el alcance de GL-03, que no cambia.
- Pruebas existentes que se ajustan: la lista exacta de rutas de GL-02, la
  tabla de cobertura y la lista de excepciones de GL-03, y el controlador de
  prueba del mecanismo, que usaba la política de la página provisoria.
- Fuera de este cambio: administración, feedback, resumen, otros líderes,
  prueba automatizada en navegador.

## Capabilities

### New Capabilities
- `people-browsing`: navegación con sesión, listado de personas asignadas,
  estado vacío, ficha con datos mínimos y respuesta ante una persona fuera
  del alcance.

### Modified Capabilities

Ninguna. `authorization` ya exige carga por alcance, 404 y la prueba de
cobertura; `authentication` ya lleva a «la página de inicio» tras iniciar
sesión, que pasa a ser el listado.

## Impact

- Código: `PeopleController`, vistas de personas, cabecera en el layout,
  `PersonPolicy#index?`, rutas, CSS; se eliminan `HomeController`,
  `HomePolicy` y su vista.
- Pruebas nuevas de peticiones y de presentación; ajustes en pruebas de
  GL-02 y GL-03 enumerados en el diseño.
- Sin migraciones ni dependencias.
