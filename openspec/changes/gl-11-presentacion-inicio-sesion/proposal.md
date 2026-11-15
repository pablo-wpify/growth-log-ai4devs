# Proposal

> **Implementación autorizada por Pablo en M240 e implementada en local,
> sin commit.** P-32 y P-33 aprobadas en M240. Historia: borrador de M236,
> ajustado en M239.

## Why

En `/session/new` el formulario se ve casi sin formato, mientras las
pantallas con sesión siguen un lenguaje visual coherente (evidencia visual
de Pablo, M236). En el código, la hoja global se carga en todas las
páginas. La vista de login no tiene clases de presentación y
`application.css` no da estilo a los campos de correo ni de contraseña:
solo los de `.entry-form`. Es la primera página que ve cualquier persona,
también en la demo temporal de GL-10. Fuente:
`docs/tickets/GL-11-presentacion-inicio-sesion.md` y el plan de la entrega
2 (secciones 5 y 9).

## What Changes

- **Capability nueva `sign-in-presentation`:** el resultado visual
  comprobable de la página de inicio de sesión:
  - etiquetas sobre los campos;
  - campos con el aspecto y el área táctil de las pantallas internas;
  - el botón «Iniciar sesión» debajo de los campos y alineado con ellos;
  - un ancho máximo de 24 rem con ancho fluido en pantallas menores
    (P-33, aprobada en M240);
  - espaciado uniforme;
  - foco visible;
  - avisos de error accesibles que no señalan qué dato falló;
  - adaptación a 375 px sin desbordamiento horizontal;
  - y la regla de que la presentación no cambia el comportamiento.
- **Al implementar:**
  - clases en `app/views/sessions/new.html.erb`;
  - reglas en `app/assets/stylesheets/application.css` con los tokens
    existentes, sin estilos en línea ni dependencias nuevas.
- **No incluye:**
  - cambios en la spec `authentication` ni en su comportamiento:
    sesiones, límites de intentos, mensajes, rutas, CSRF y privacidad;
  - otras páginas ni la cabecera;
  - un mock del login (P-32, aprobada: las pantallas internas son la
    referencia);
  - rediseño, framework de CSS o JavaScript;
  - deploys en Render.

## Capabilities

### New Capabilities
- `sign-in-presentation`: presentación de la página de inicio de sesión
  con el lenguaje visual de la aplicación, sin cambiar su comportamiento.

### Modified Capabilities
- Ninguna. `authentication` sigue igual y `people-browsing` ya exige que la
  página de inicio de sesión no muestre la cabecera.

## Impact

- **Código, al implementar:** `app/views/sessions/new.html.erb` y
  `app/assets/stylesheets/application.css`. Controlador, rutas y modelos
  sin cambios.
- **Pruebas, al implementar:** primero una prueba de peticiones sobre la
  estructura (etiquetas asociadas, aviso antes del formulario, atributos
  sin cambios) y una prueba en navegador a 1280 px y 375 px (posición de
  las etiquetas, altura de los campos, foco y desbordamiento). Las pruebas
  existentes de `authentication` no se modifican.
- **Render:** ninguno en este cambio. La demo muestra la versión nueva
  solo después de un deploy manual que Pablo autorice aparte.
