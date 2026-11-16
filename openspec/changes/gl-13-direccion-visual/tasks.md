# Tasks

El trabajo tiene dos fases:

- **Fase documental (grupo 0):** ticket, propuesta, spec, diseño,
  validación y revisión de Pablo. Pedida en M254.
- **Implementación y verificación (grupos 1 a 3):** **autorizadas por
  Pablo en M264**, solo para GL-13, y completas en local. Las pruebas se
  escribieron primero y se vieron fallar por la razón esperada. La
  conformidad visual de Pablo cerró la tarea 3.3 en M272.
- **Publicación y archivo (grupo 4):** la publicación (4.1) se hizo con
  la autorización de Pablo en M278. El archivo (4.2) sigue pendiente de
  su autorización.

## 0. Fase documental

- [x] 0.1 Crear `docs/plan-entrega-final.md` como única fuente de la secuencia de la entrega final, con GL-13 y P-34 a P-40, sin tocar `docs/plan-entrega-2.md`. Evidencia: 15/11/2026, M254
- [x] 0.2 Preparar el ticket, la propuesta, el diseño, la capability nueva `visual-language` y estas tareas. Evidencia: 15/11/2026, M254
- [x] 0.3 Ejecutar `openspec validate --all --strict` y registrar el resultado. Evidencia: 15/11/2026, M254 (ver su registro)
- [x] 0.2b Incorporar las mejoras del listado «Personas» como propuesta: diseño 7.2.1, deltas de `people-browsing`, `feedback-capture` y `authorization` y P-41 a P-45, con la referencia `Lista de personas@1x.png`. Evidencia: 15/11/2026, M255 y M256
- [x] 0.3b Volver a ejecutar `openspec validate --all --strict`. Evidencia: 15/11/2026, M255 (ver su registro)
- [x] 0.2c Separar a GL-14 los requisitos funcionales del listado: retirar los deltas de `people-browsing`, `feedback-capture` y `authorization`, la sección 7.2.1 del diseño, R-10 a R-13 y P-41 a P-45. Evidencia: 15/11/2026, M257
- [x] 0.3c Volver a ejecutar `openspec validate --all --strict`. Evidencia: 15/11/2026, M257 (ver su registro)
- [x] 0.4 Revisión de Pablo del borrador. Evidencia: 16/11/2026, M264. Pablo autorizó implementar GL-13 «según su documentación y las decisiones registradas hasta M263», es decir, sobre el borrador vigente. Antes había revisado partes del borrador en M261 (decisiones P-34, P-35 y P-38 a P-40) y en M263 (correcciones de los deltas). En M274 la tarea quedó abierta porque M264 no dice de forma explícita que revisó el borrador completo; Pablo indicó en M276 que M264 es esa evidencia, y con eso se cierra.
- [x] 0.5 Decisiones explícitas de Pablo sobre P-34 (dirección visual) y P-35 (tipografía). Evidencia: 16/11/2026, M261
- [x] 0.6 Decisiones de Pablo sobre P-38 a P-40 (M261); P-36 y P-37 se resolvieron en M257. Delta `ADDED` de `people-browsing` para el aviso de la ficha y validación. Evidencia: 16/11/2026, M261 (ver su registro)
- [x] 0.6b Corregir la redacción del delta de `people-browsing` y de `visual-language` sobre el aviso de la ficha, y validar. Evidencia: 16/11/2026, M263 (ver su registro)
- [x] 0.7 Aprobación explícita de Pablo para implementar. Evidencia: 16/11/2026, M264 (solo GL-13; GL-14 sigue sin autorización)

## 1. Pruebas primero

- [x] 1.1 Registrar, antes de cambiar la hoja, los estilos calculados y las capturas de referencia de cada pantalla existente a 1280 y 375 px: inicio de sesión con y sin aviso (para comprobar que no cambia, P-40), «Personas» con y sin personas, ficha con borrador y lista, captura con error, detalle y edición. Evidencia: 16/11/2026, M264: 32 archivos (estilos calculados en JSON y capturas) fuera del repositorio; ver el diseño, sección 12
- [x] 1.2 Prueba de peticiones: ninguna vista tiene atributos `style`, y los textos exigidos por `people-browsing`, `feedback-capture` y `feedback-summary` siguen presentes. Evidencia: 16/11/2026, M264: `spec/requests/visual_language_spec.rb`
- [x] 1.3 Pruebas de sistema a 1280 y 375 px (`spec/system/visual_language_spec.rb`, Evidencia: 16/11/2026, M264):
  - contraste calculado de texto ≥ 4,5:1;
  - borde de los campos y foco ≥ 3:1;
  - el borrador con un tratamiento distinto del de la entrada lista;
  - el resumen sin barras, porcentajes ni color por fila;
  - la cabecera arriba, con `aria-current` y sin «Feedback» ni «Administración»;
  - sin desplazamiento horizontal;
  - 44 px en la navegación y las acciones;
  - recursos de estilo, tipografía e íconos del mismo origen, y la licencia OFL de la fuente versionada;
  - el azul solo en enlaces y etiquetas de compartido, no en las señales;
  - el aviso de privacidad una sola vez en la ficha, sin panel «Quién ve qué» y con las etiquetas de cada entrada intactas;
  - el inicio de sesión con el mismo fondo, la misma tipografía y la misma estructura que antes, y solo el borde de campos, el foco y el botón común nuevos
- [x] 1.4 Ver fallar 1.2 y 1.3 por la razón esperada y registrarlo. Evidencia: 16/11/2026, M264: 11 de 17 fallaron por las razones esperadas (diseño, sección 12)

## 2. Implementación

- [x] 2.1 Tokens en `:root` de `app/assets/stylesheets/application.css`, según P-34 y P-35, y la fuente serif OFL en `app/assets/fonts` con su licencia
- [x] 2.2 Componentes: botones, etiquetas, tarjetas, borrador, tabla del resumen, avisos y campos
- [x] 2.3 Cabecera en el layout y las vistas, sin cambiar textos exigidos, rutas, formularios ni autorización. Las migas no se implementaron: cambiarían el texto «← Volver a …» (diseño, sección 12)
- [x] 2.4 Aviso de privacidad en la ficha (P-38). El inicio de sesión solo hereda el borde de campos, el foco y el botón común (P-40, M264). Evidencia: 16/11/2026, M264

## 3. Verificación

- [x] 3.1 Pruebas nuevas en verde; las existentes, incluido el E2E, en verde sin modificarlas. Evidencia: 16/11/2026, M264: 400 ejemplos, 0 fallos. Única prueba existente modificada: el color de foco esperado en `spec/system/sign_in_presentation_spec.rb`, que pasa a ser el de la paleta (P-40, M264)
- [x] 3.2 `bin/bundler-audit update` y `bin/ci` con código 0. Evidencia: 16/11/2026, M264 (en local)
- [x] 3.3 Comprobación manual de Pablo a 1280 y 375 px de las pantallas existentes. La tarea 3.3 de GL-11 se registra aparte, en su cambio, y el listado de GL-14 en el suyo. Evidencia: 16/11/2026, M272: conformidad visual de Pablo («Doy mi conformidad») sobre las 16 capturas de M265 a 1280 y 375 px (diseño, sección 15)
- [x] 3.4 Registrar en el diseño lo ejecutado, los desvíos y lo pendiente. Evidencia: 16/11/2026, M264 (sección 12)
- [x] 3.5 Correcciones de la revisión visual (M265): la cabecera en dos filas como máximo a 375 px, los radios de `body.app` en terracota con foco visible, y el texto de los campos del login con su color previo, porque GL-11 no lo comparte. Pruebas primero: fallaron 6 ejemplos por las razones esperadas. Capturas repetidas a 1280 y 375 px. Evidencia: 16/11/2026, M265 (diseño, sección 13)
- [x] 3.6 Precisión de P-40 (M266): «Iniciar sesión» es un botón común, con su fondo, su borde y su color de texto `#2b2320`, sin ser principal ni terracota; los campos del login conservan el texto negro y comparten solo el borde y el foco. Prueba del login ampliada; sin cambios de CSS. Evidencia: 16/11/2026, M266 (diseño, sección 14)

## 4. Publicación y cierre (cada paso con su autorización)

- [x] 4.1 Commit, push y PR; CI remoto con enlace y SHA. Evidencia: 16/11/2026, M278. Commit `c7d41654dc6549602d6f99ade854ad16efd42bc9`; PR [#8](https://github.com/pablo-wpify/growth-log-ai4devs/pull/8); CI [43903787327](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43903787327) en verde: 403 ejemplos, 0 fallos y cuatro jobs aprobados
- [ ] 4.2 Archivo del cambio
