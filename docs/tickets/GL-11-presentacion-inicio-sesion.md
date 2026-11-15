# GL-11. Presentación de la página de inicio de sesión

> Ticket propuesto de la entrega 2 de Growth Log. Lugar en la secuencia:
> [plan de la entrega 2](../plan-entrega-2.md). Cambio de OpenSpec, en
> borrador: [`gl-11-presentacion-inicio-sesion`](../../openspec/changes/gl-11-presentacion-inicio-sesion/proposal.md).
> **Estado (15/11/2026): implementado en local, sin commit (M240).**
> - P-32 y P-33 aprobadas por Pablo en M240; implementación autorizada en
>   el mismo pedido.
> - Pruebas nuevas, 15 de 15; RSpec completo, 383 ejemplos y 0 fallos.
> - Estilos de las pantallas internas sin cambios.
> - **`bin/ci` con código 1** solo por avisos nuevos de gemas (`msgpack` y
>   `puma`), ajenos a GL-11
>   ([registro](../../openspec/changes/gl-11-presentacion-inicio-sesion/design.md#registro-de-la-implementación-15112026-local-sin-commit)).
> - Pendientes: el gate en código 0, la comprobación manual de Pablo, el
>   commit, el CI remoto y el archivo.
> - Historia: borrador de M236, revisado en M238 y ajustado en M239.

## Problema

Según la evidencia visual de Pablo (M236), la ficha de una persona y la
navegación con sesión se ven coherentes, pero en `/session/new` el
formulario se ve casi sin formato: etiquetas y campos quedan mal alineados
y los inputs no siguen el aspecto del resto de la aplicación.

**Causa comprobada en el código (15/11/2026, `6177aef`):**

- La hoja global sí se carga en esa página: `app/views/layouts/application.html.erb`
  incluye `stylesheet_link_tag :app` para todas las páginas, con sesión o
  sin ella, y el título, la tipografía y el botón toman los estilos de
  `app/assets/stylesheets/application.css`.
- `app/views/sessions/new.html.erb` no tiene clases de presentación: el
  formulario, sus `div` y el aviso de error (`role="alert"`) no llevan
  ninguna.
- `application.css` no da estilo a `input[type="email"]` ni a
  `input[type="password"]`: los campos solo tienen estilo dentro de
  `.entry-form` (textos, listas y fechas de GL-06). Por eso la etiqueta y
  el campo quedan en la misma línea, con el aspecto por defecto del
  navegador.

No falló la carga global del CSS: falta la presentación de esa vista.

## Objetivo

Que `/session/new` siga el lenguaje visual de las pantallas internas, con
un resultado comprobable: etiquetas sobre los campos, alineación y
espaciado consistentes, campos legibles y utilizables, foco visible,
mensajes de error accesibles y adaptación móvil sin desbordamiento
horizontal.

## Referencia visual

- **No hay un mock aprobado del inicio de sesión.** El
  [Anexo E](../../anexos/anexo-e-mocks.md) tiene mocks de la ficha, la
  captura rápida, compartir y el feed, pero ninguno de esta página (P-32,
  aprobada en M240; plan sección 6).
- La referencia son las pantallas internas ya construidas: el formulario
  de captura rápida y el de edición (`.entry-form`), el resumen de errores
  (`.error-summary`) y las reglas comunes de `application.css` (colores,
  bordes, radio, foco y áreas táctiles de 44 px).

## Alcance

- La presentación de `app/views/sessions/new.html.erb` y las reglas de
  `application.css` que necesite, reutilizando los tokens y patrones
  existentes. Sin estilos en línea, por la CSP.
- Una capability pequeña y nueva, `sign-in-presentation`, que expresa el
  resultado visual.
- Pruebas primero: una prueba de peticiones sobre la estructura y una
  prueba en navegador a 1280 px y a 375 px.

## Exclusiones

- Autenticación, sesiones, límites de intentos, rutas, mensajes,
  privacidad y CSRF. La spec `authentication` no cambia.
- Otras páginas, la cabecera con sesión y la navegación.
- Rediseño, nueva paleta, framework de CSS o JavaScript.
- Un mock del login. Si Pablo lo quiere, es otro paso.
- Render: llevar el cambio a la demo es un deploy manual de Pablo con su
  propia autorización.

## Criterios de aceptación

- **CA1.** Cada etiqueta está encima de su campo y asociada a él.
- **CA2.** Los campos de correo y contraseña ocupan el ancho del
  formulario. Tienen la misma altura mínima (44 px), borde, radio y
  tipografía que los campos de las pantallas internas. El espaciado entre
  grupos es uniforme. El botón «Iniciar sesión» queda debajo de la
  contraseña, alineado con el borde izquierdo de los campos, con al menos
  44 px de alto y el estilo común de los botones.
- **CA2b.** El formulario tiene un ancho máximo de 24 rem en escritorio y
  un ancho fluido en pantallas menores (P-33, aprobada en M240).
- **CA3.** Al cargar, el correo tiene el foco por `autofocus` y muestra el
  contorno de foco de la aplicación (sólido, de 3 px, del color de foco y
  con 2 px de separación). Con Tab, la contraseña y el botón muestran el
  mismo contorno.
- **CA4.** El aviso de fallo y el de demasiados intentos aparecen antes
  del formulario. Conservan `role="alert"` y su texto, y se distinguen
  como el resumen de errores de las pantallas internas, también sin
  depender solo del color. No marcan un campo concreto, para no revelar
  qué dato falló.
- **CA5.** A 375 px de ancho no hay desplazamiento horizontal, y los
  campos y el botón entran completos.
- **CA6.** No cambian los nombres de los campos, `autocomplete`,
  `required`, `autofocus`, `maxlength` ni el correo repetido tras un
  fallo. Tampoco cambian el título ni las respuestas de `authentication`,
  ni la ausencia de cabecera sin sesión que define `people-browsing`. Las
  pruebas existentes siguen en verde sin modificarse.
- **CA7.** Los estilos de las pantallas internas (captura rápida y edición
  de una entrada) no cambian.

## Dependencias

- GL-02 (la página y su comportamiento) y GL-05 y GL-06 (el lenguaje
  visual y la hoja de estilos).
- Ninguna decisión bloquea el borrador.
- P-32 (referencia visual) y P-33 (ancho del formulario): aprobadas por
  Pablo en M240, en forma explícita y separadas de la autorización para
  implementar, dada en el mismo pedido.

## Riesgos

- **Referencia sin mock:** el resultado se juzga contra las pantallas
  internas; si Pablo espera otro aspecto, hay que decidirlo antes.
- **Comprobar «visualmente» con pruebas:** se comprueban propiedades
  medibles (posición, desbordamiento y foco). El juicio estético queda en
  la comprobación manual.
- **Demo de Render:** hasta un deploy manual autorizado, la demo sigue
  mostrando la versión actual.

## Evidencia prevista

- La prueba de peticiones y la prueba en navegador, vistas fallar antes de
  implementar y después en verde.
- `bin/ci` con código 0 y el CI remoto con su enlace y SHA.
- La comprobación manual de Pablo en local a 1280 px y a 375 px.
