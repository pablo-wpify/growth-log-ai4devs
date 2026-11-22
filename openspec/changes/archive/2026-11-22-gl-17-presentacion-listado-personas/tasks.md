# Tasks

El trabajo tiene dos fases:

- **Fase documental (grupo 0):** ticket, propuesta, delta, diseño,
  validación y revisión de Pablo. Pedida en M408, corregida en M410 y
  revisada por Pablo en M415.
- **Implementación y verificación (grupos 1 a 3):** necesitan la
  aprobación explícita de Pablo (tarea 0.4). Las pruebas se escriben
  primero y se ven fallar por la razón esperada.

## 0. Fase documental

- [x] 0.1 Crear este cambio con el ticket, la propuesta, el delta de `people-browsing`, el diseño y estas tareas, y registrar P-54 y P-55 como propuestas en el plan de la entrega final. Evidencia: 21/11/2026, M408
- [x] 0.2 Ejecutar `openspec validate --all --strict` y registrar el resultado. Evidencia: 21/11/2026, M410: 22 de 22, código de salida 0 (diseño, «Registro»)
- [x] 0.3 Revisión de Pablo del borrador y decisión sobre P-54 y P-55. Evidencia: 21/11/2026, M415: conformidad de Pablo con el borrador y aprobación de P-54 y P-55, con el límite aceptado de P-55 (un toque fuera del botón puede abrir la ficha) y fuera de GL-17 el listado que empieza bajo en móvil y el quiebre de la cabecera entre 600 y 767 px
- [x] 0.4 Aprobación explícita de Pablo para implementar. Evidencia: 21/11/2026, M417 (autoriza la implementación local de los grupos 1 a 3; la comprobación manual queda a cargo de Pablo y el grupo 4, publicación y archivo, sigue necesitando autorización para cada paso)

## 1. Pruebas primero

- [x] 1.1 Pruebas de sistema a 1280, 640, 639 y 375 px en `spec/system/people_listing_spec.rb`, vistas fallar antes de implementar: el total y el aviso en líneas distintas y sin «·»; «Registrar la primera» con borde, al menos 44 px de alto y más angosta que la fila; los detalles a la derecha del nombre a 1280 y 640 px (40 rem), y debajo a 639 y 375 px, sin desplazamiento horizontal en ningún ancho; el foco del enlace de la persona antes que el de «Registrar la primera» a 1280 y 375 px. Evidencia: 21/11/2026, M417: bloque «presentación (GL-17)» en `spec/system/people_listing_spec.rb`, 8 ejemplos (2 por ancho), vistos fallar antes de implementar por «·» en el resumen y por «Registrar la primera» sin borde; el orden de foco a 1280 y 375 px ya lo cubre la prueba de GL-14 «cada fila recibe el foco una vez…» (diseño, «Registro»)
- [x] 1.2 Revisar que las pruebas de peticiones de `spec/requests/people_listing_spec.rb` sigan fijando el total, el aviso y `a[data-first-entry]`, y registrar las que cambien. Evidencia: 21/11/2026, M417: revisadas; siguen fijando el total, el aviso y `a[data-first-entry]` y no dependen de la línea única, así que no cambian

## 2. Implementación

- [x] 2.1 Total y aviso en dos líneas en `app/views/people/index.html.erb` y sus estilos, sin el «·» (D1). Verificación: pruebas de la 1.1 en verde. Evidencia: 21/11/2026, M417: dos párrafos dentro de `.people-summary`, sin el «·»; `spec/system/people_listing_spec.rb` y `spec/requests/people_listing_spec.rb` en verde (43 ejemplos, 0 fallas)
- [x] 2.2 «Registrar la primera» con el botón común en variante compacta, sin tokens nuevos (D2). Verificación: pruebas de la 1.1 en verde y contraste del borde de al menos 3:1. Evidencia: 21/11/2026, M417: clase `button` más `.person-first-entry` (0,875 rem y relleno de 0,25 × 0,75 rem), sin tokens nuevos; borde `--field-border` sobre `--surface` de 4,27:1; pruebas de la 1.1 en verde
- [x] 2.3 Grilla de la fila en tres columnas desde 40 rem (640 px de ventana), sin cambiar el orden del DOM y con los selects apilados por debajo de ese ancho (D3). Verificación: pruebas de la 1.1 en verde a 640 px, con los detalles a la derecha, y a 639 px, con los detalles debajo. Evidencia: 21/11/2026, M417: `@media (min-width: 40rem)` con las áreas «name details chevron» y «meta details chevron», sin cambiar el DOM; los selects siguen apilados por debajo de 40 rem; pruebas de la 1.1 en verde a 1280, 640, 639 y 375 px

## 3. Verificación

- [x] 3.1 `bin/bundler-audit update` y `bin/ci` en código 0, y registro en el diseño. Evidencia: 21/11/2026, M417: `bin/bundler-audit update` (1406 avisos, base del 21/11/2026) y `bin/ci` con código 0: RuboCop, bundler-audit, auditoría de importmap y Brakeman sin advertencias; RSpec con 471 ejemplos y 0 fallas (diseño, «Registro»)
- [x] 3.2 Capturas a 1280 y 375 px con datos ficticios (listado, foco y sin resultados) y conformidad visual de Pablo. Evidencia: 22/11/2026, M420: conformidad visual de Pablo sobre las 14 capturas de M417 con datos ficticios (listado a 1280, 640, 639 y 375 px, también de página completa; foco a 1280 y 375; sin resultados a 1280 y 375; estado vacío a 1280 y 375), copiadas en `~/Descargas/gl-17-implementacion/capturas/`, fuera del repositorio
- [x] 3.3 Registrar lo ejecutado, los desvíos y lo pendiente en el diseño. Evidencia: 21/11/2026, M417: diseño, «Registro», entrada M417 (ejecutado, desvíos, límites y lo pendiente)

## 4. Publicación y archivo

Cada paso necesita la autorización explícita de Pablo. Antes figuraban
como viñetas sin casilla («Workflow follow-up»); pasaron a tareas en M425,
con el mismo patrón que GL-14.

- [x] 4.1 Commit, push y CI remoto, con enlace y SHA. Evidencia: 22/11/2026, M423 y M424: commit `1c2f513` (`1c2f51395570fa28b51984a5bb648a2890274158`), publicado con push fast-forward en `feature/entrega-final-pp` desde `63b86d0`; CI [45026017961](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/45026017961) en verde sobre ese SHA (scan_ruby, scan_js, lint y test, con 471 ejemplos y 0 fallas). PR: no aplica, porque `feature/entrega-final-pp` es la rama de integración de la entrega final (como en GL-14)
- [x] 4.2 Archivo del cambio con los deltas aplicados a las specs principales y `openspec validate --all --strict`. Evidencia: 22/11/2026, M425: archivado con `openspec archive gl-17-presentacion-listado-personas -y` en `openspec/changes/archive/2026-11-22-gl-17-presentacion-listado-personas`, con el delta aplicado a `people-browsing` (2 requisitos agregados y 1 modificado); `openspec validate --all --strict` en 21 de 21. Archivo local, sin commit
