# Tasks

El trabajo tiene dos fases:

- **Fase documental (grupo 0):** ticket, propuesta, spec, diseño,
  validación y revisión de Pablo. Pedida en M236.
- **Implementación y verificación (grupos 1 a 4):** autorizadas por Pablo
  en M240, sin commit, publicación ni deploy. Las pruebas se escriben primero y se
  ven fallar por la razón esperada.

## 0. Fase documental

- [x] 0.1 Proponer GL-11 en el plan (secciones 2, 3, 5, 6 y 9, única fuente) y preparar el ticket. Evidencia: 15/11/2026, M236
- [x] 0.2 Preparar la propuesta, el diseño, la capability nueva `sign-in-presentation` y estas tareas. Evidencia: 15/11/2026, M236
- [x] 0.3 Ejecutar `openspec validate --all --strict` y registrar el resultado. Evidencia: 15/11/2026, M236 (ver su registro)
- [x] 0.3b Ajustes de redacción H1 a H7 de la revisión de M238. Evidencia: 15/11/2026, M239
- [x] 0.4 Decisión explícita de Pablo sobre P-32 (referencia sin mock del login). Evidencia: aprobada en M240 (2026-11-15 14:37:22 UTC): las pantallas internas existentes, sin mock nuevo
- [x] 0.4b Decisión explícita de Pablo sobre P-33 (ancho del formulario). Evidencia: aprobada en M240: `max-width: 24rem` en escritorio y ancho fluido en pantallas más estrechas
- [x] 0.5 Aprobación explícita de Pablo para implementar. Evidencia: M240, autorización separada de P-32 y P-33 (ambas decididas en el mismo pedido), según el ticket, el diseño, la spec y las tareas revisadas; sin commit, publicación ni deploy

## 1. Pruebas primero

- [x] 1.1 Prueba de peticiones sobre la estructura (`spec/requests/sign_in_presentation_spec.rb`, 6 ejemplos):
  - etiquetas asociadas a sus campos;
  - aviso con `role="alert"` y `error-summary` antes del formulario, en el fallo y en el 429;
  - sin `aria-invalid`;
  - atributos de los campos sin cambios.
- [x] 1.2 Prueba en navegador a 1280 px y a 375 px (`spec/system/sign_in_presentation_spec.rb`, 9 ejemplos):
  - etiquetas encima de los campos;
  - campos de al menos 44 px, del mismo ancho y con el borde, radio y tipografía calculados del campo de la captura rápida;
  - botón «Iniciar sesión» debajo de la contraseña, alineado con el borde izquierdo de los campos y de al menos 44 px;
  - a 1280 px, formulario de 24 rem; a 375 px, del ancho del contenedor (según P-33);
  - sin desplazamiento horizontal, también con un aviso;
  - foco: al cargar, el correo es el elemento activo por `autofocus` y su contorno calculado es sólido, de 3 px, del color de `--focus` y con 2 px de separación; tras Tab y Tab, la contraseña y el botón muestran los mismos valores.
- [x] 1.3 Registrar, antes de cambiar la hoja, los estilos calculados de los campos, etiquetas, botones y resumen de errores de la captura rápida y de la edición de una entrada, a 1280 px y a 375 px, como referencia de las pantallas internas. Evidencia: 19 selectores, en 8 estados (las dos pantallas, con y sin errores, a 1280 y 375 px), con una herramienta no versionada en `tmp/gl11/`
- [x] 1.4 Ver fallar 1.1 y 1.2 por la razón esperada y registrarlo. Evidencia: 13 de 15 fallaron (sin `sign-in-form`, sin `.field` ni `error-summary`, etiquetas en línea y desbordamiento a 375 px). Las 2 que pasaban son de conservación (atributos; sin estilos en línea ni cabecera). El foco del correo y la contraseña ya cumplía por la regla global

## 2. Implementación

- [x] 2.1 Clases en `app/views/sessions/new.html.erb`, sin cambiar helpers, nombres, atributos ni el orden de los campos.
- [x] 2.2 Reglas en `app/assets/stylesheets/application.css` con los tokens existentes, sin estilos en línea. Todas dentro de `.sign-in-form`; la regla de `.entry-form` no se tocó

## 3. Verificación

- [x] 3.1 Pruebas nuevas en verde; las existentes de `authentication`, navegación, CSRF y el E2E en verde sin modificarlas. Evidencia: 15 de 15; `bin/ci` corrió las 383 pruebas, con 0 fallos
- [x] 3.1b Estilos de las pantallas internas sin cambios: los estilos calculados registrados en 1.3 son iguales después del cambio. Evidencia: los JSON de antes y después son idénticos byte a byte
- [x] 3.2 `bin/bundler-audit update` y `bin/ci` con código 0. Evidencia: 15/11/2026 15:26 UTC (M242), con GL-12 en el árbol: `bin/ci` con código 0, auditoría sin vulnerabilidades y 383 ejemplos sin fallos. **Antes, bloqueada (M240):** `bin/ci` terminó con código 1 solo por la auditoría de gemas. Hay avisos nuevos en `msgpack` 1.8.6 (CVE-2026-126366) y en `puma` 8.0.2 (siete GHSA), ajenos a GL-11: `Gemfile.lock` no cambió. Pasaron estilo (sin ofensas), Importmap, Brakeman (0 avisos) y RSpec (383 ejemplos, 0 fallos). Actualizar gemas queda fuera de este cambio y lo decide Pablo
- [ ] 3.3 Comprobación manual de Pablo en local a 1280 px y a 375 px, con un aviso de error, incluida una mirada a la captura rápida y a la edición de una entrada para confirmar que no cambiaron.
- [x] 3.4 Registrar en el diseño lo ejecutado, los desvíos y lo pendiente.

## 4. Publicación y cierre (cada paso con su autorización)

- [ ] 4.1 Commit, push y PR contra `feature/entrega-2-pp`; CI remoto con enlace y SHA.
- [ ] 4.2 Merge.
- [ ] 4.3 Deploy manual en Render, si Pablo lo decide, y comprobación en la demo.
- [ ] 4.4 Archivo del cambio.
