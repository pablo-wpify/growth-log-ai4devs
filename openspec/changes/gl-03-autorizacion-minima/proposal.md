# Proposal

## Why

GL-02 identifica quién hace cada petición, pero no decide qué puede hacer.
El recorrido núcleo de la entrega 2 (elegir una persona asignada, capturar,
completar y consultar feedback) expone información privada: antes de que
exista la primera ruta de personas o de entradas, la aplicación tiene que
denegar por defecto y acotar las consultas por asignación (RN-1). Fuente:
`docs/tickets/GL-03-autorizacion-minima.md` y las decisiones P-5, P-7, P-8
y P-9 aprobadas el 02/11/2026 en `docs/plan-entrega-2.md`, sección 6.1.

## What Changes

- Mecanismo de autorización con Pundit (ADR-3, P-5): políticas que deniegan
  por defecto, verificación obligatoria de autorización y de alcance en las
  acciones del producto, lista fija de excepciones y respuesta 404 ante un
  acceso denegado, igual que ante un recurso inexistente.
- Tablas mínimas `people` y `assignments`, sin interfaz de administración
  (P-8, P-9). Una sola asignación activa por par líder y persona; una
  persona puede tener varios líderes.
- Política y alcance de personas: acceso solo con persona activa y
  asignación activa; el rol de administrador no da acceso.
- Página de inicio provisoria autorizada con el mismo mecanismo.
- Regla de entradas definida en el diseño para GL-06 (P-7): lectura por
  autoría con cuenta activa, sin depender de la asignación; escritura con
  autoría y asignación activa. **No se especifica ni se comprueba aquí:**
  las entradas no existen todavía.
- Nueva dependencia: `pundit` 2.5.2.
- Fuera de este cambio: rutas e interfaz de personas (GL-05), entradas y
  su autorización (GL-06), resumen (GL-07), datos ficticios (GL-08),
  compartición (I4), interfaz del autor sin asignación (pendiente, P-7),
  invitaciones y administración (GL-04), roles o permisos configurables.

## Capabilities

### New Capabilities
- `authorization`: denegación por defecto, verificación de autorización y
  de alcance, excepciones declaradas, respuesta ante un acceso denegado y
  acceso de un líder a una persona.
- `people`: personas acompañadas y su estado activo.
- `assignments`: asignaciones entre líderes y personas, su unicidad por par
  y su estado, independiente del de la persona y del de la cuenta.

### Modified Capabilities

Ninguna. `authentication` ya exige sesión en las rutas del producto; esta
autorización actúa después, sobre peticiones con sesión válida.

## Impact

- Código nuevo: modelos `Person` y `Assignment`; `ApplicationPolicy`,
  `PersonPolicy` y la política de la página de inicio; cambios en
  `ApplicationController` y `HomeController`; migraciones de `people` y
  `assignments`.
- Dependencias: `pundit` (gema nueva, revisada con `bundler-audit`).
- Pruebas: políticas, alcance, modelos y una prueba de cobertura que
  recorre las rutas del producto con sesión.
- Documentación: `docs/decisiones/` (ADR-3 y P-5, P-7, P-8, P-9).
- Base de datos: dos tablas nuevas en `growth_log_development` y
  `growth_log_test`.
