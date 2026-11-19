# Tasks

El trabajo tiene dos fases:

- **Fase documental (grupo 0):** ticket, propuesta, diseño, deltas,
  validación y revisión de Pablo. Los criterios de diseño de las
  secciones 4.1, 4.2 y 4.3 del diseño están cerrados (18/11/2026).
- **Implementación y verificación (grupos 1 a 3):** autorizadas por Pablo
  el 18/11/2026 (tarea 0.7) y hechas en local. La 3.1 se completó después
  del commit local bb5db27, con la base de avisos actualizada. Las
  pruebas de 1.1 a 1.4 se escribieron antes del código, pero no se vieron
  fallar antes de implementar (diseño, sección 8).
- **Publicación y cierre (grupo 4):** la 4.1 y la 4.2 se completaron
  con el CI remoto en verde, la 4.3 con el archivo del cambio y la 4.4
  con el ajuste del delta de GL-14. Queda abierta la 0.3.

## 0. Fase documental

- [x] 0.1 Crear el ticket, la propuesta, el diseño, los deltas de `feedback-capture` y `people-browsing` y estas tareas, y asignar GL-15 en el plan de la entrega final. Evidencia: 17/11/2026, pedido sin numerar todavía
- [x] 0.2 Ejecutar `openspec validate --all --strict` y registrar el resultado. Evidencia: 17/11/2026, 23 de 23 en verde, después de dividir dos requisitos que superaban el largo que admite el modo estricto
- [ ] 0.3 Revisión de Pablo del borrador
- [x] 0.4 Acuerdo de Pablo sobre los criterios de diseño (sección 4.1 del diseño) y ajuste de la documentación. Evidencia: 18/11/2026, pedido sin numerar todavía
- [x] 0.5 Decisión de Pablo sobre los puntos de la sección 4.2 (rutas, aviso al guardar como lista, «Cancelar») y ajuste de la documentación. Evidencia: 18/11/2026, pedido sin numerar todavía
- [x] 0.6 Decisión de Pablo sobre el aviso al guardar como lista (diseño, sección 4.3): el aviso es exactamente «Feedback guardado como lista.». Es genérico y solo confirma que la operación se completó: no incluye el texto del feedback ni datos que revelen su contenido o a quién se refiere. La regla de privacidad no cambia: el delta modifica «Textos que separan "lista" de "compartida"» solo en el criterio del texto de los avisos (18/11/2026, corrección previa al commit). Evidencia: 18/11/2026, pedidos sin numerar todavía
- [x] 0.7 Aprobación explícita de Pablo para implementar. Evidencia: 18/11/2026, pedido sin numerar todavía

## 1. Pruebas primero

- [x] 1.1 Pruebas de peticiones del acceso y la apertura (2.1, 2.2): la ficha de una persona asignada muestra «+ Feedback» y «Captura rápida»; el formulario responde con todos los campos y la fecha precargada con la fecha actual de la zona configurada en la aplicación (P-23), incluida la hora 22:00 de Buenos Aires; sin asignación activa o con la persona inactiva, 404 por URL directa. Evidencia: 18/11/2026, verificación local (diseño, sección 8, «Verificación local»); escrita antes del código, pero sin verla fallar antes de implementar
- [x] 1.2 Pruebas de peticiones del guardado (2.2 a 2.10, P-3): con una fecha distinta de hoy, la entrada se guarda con la fecha elegida; «Guardar borrador» válido, también sin señal ni dimensión; «Guardar como lista» válido; lista sin dimensión ni señal y con solo una de las dos (422, sin guardar, el formulario vuelve con lo cargado e indica qué falta); sin contexto o sin fecha (422, sin guardar); sin estado, borrador; estado desconocido, 422 con error de validación y sin guardar; otro autor u otra persona ignorados; al guardar, redirección a la ficha con el aviso de éxito («Feedback guardado como lista.» al guardar como lista, sin el texto del feedback ni el nombre de la persona); sin asignación, 404 sin crear; otro líder de la misma persona no ve la entrada en la ficha y recibe 404 en el detalle; avisos sin «Publicar», y el de borrador con «solo vos»; las acciones nuevas aparecen en la cobertura de autorización. Evidencia: 18/11/2026, verificación local (diseño, sección 8, «Verificación local»); escrita antes del código, pero sin verla fallar antes de implementar
- [x] 1.3 Pruebas de sistema con JavaScript (ADR-6): abrir «+ Feedback» sin que cambie la URL de la ficha; ver la fecha de hoy precargada, cambiarla y ver la entrada guardada con la fecha elegida; un error de validación se muestra dentro de la ficha; «Cancelar» cierra el formulario sin guardar y la ficha sigue en la misma URL; «Guardar como lista» con todos los campos vuelve a la ficha completa con el aviso y la entrada en la cronología (salida del frame, diseño sección 3). Evidencia: 18/11/2026, verificación local (diseño, sección 8, «Verificación local»); escrita antes del código, pero sin verla fallar antes de implementar
- [x] 1.4 Pruebas sin JavaScript (diseño, sección 4.1, punto 1): el enlace «+ Feedback» lleva a la página del formulario, un error vuelve a mostrar el formulario, guardar vuelve a la ficha con el aviso y «Cancelar» vuelve a la ficha sin crear ninguna entrada; y la prueba de `people-browsing` «Acciones disponibles en la ficha» actualizada a los dos accesos, con «Captura rápida» como acción principal. Evidencia: 18/11/2026, verificación local (diseño, sección 8, «Verificación local»); escrita antes del código, pero sin verla fallar antes de implementar

## 2. Implementación

- [x] 2.1 Rutas del formulario según la convención de la sección 4.2, punto 1, del diseño (anidadas bajo la persona, segmento en español, `only:` con GET y POST, separadas de la captura), con autorización y alcance en cada acción; registrar en el diseño la ruta elegida. Evidencia: 18/11/2026, verificación local (diseño, sección 8, «Verificación local»); ruta `/personas/:person_id/entradas/completa`
- [x] 2.2 Acción y vista del formulario: Turbo frame en la ficha con HTML renderizado por Rails y la misma vista como página sin JavaScript, todos los campos, la fecha precargada con `Time.zone.today` y editable, y el enlace «Cancelar» a la ficha (2.1 a 2.5). Sin dependencias nuevas, sin JavaScript propio y sin Turbo Streams. Evidencia: 18/11/2026, verificación local (diseño, sección 8, «Verificación local»)
- [x] 2.3 Guardado con «Guardar borrador» y «Guardar como lista»: el estado del botón elegido, validado por el modelo (ausente, borrador; desconocido, error); errores con 422 dentro del frame o en la página; se guarda la fecha enviada; al guardar, la ficha completa con el aviso (2.2, 2.3, 2.6 a 2.10). Evidencia: 18/11/2026, verificación local (diseño, sección 8, «Verificación local»); desvío de la salida del frame en el diseño, sección 8
- [x] 2.4 Acceso «+ Feedback» en la ficha como acción secundaria común, con «Captura rápida» como principal (diseño, sección 4.1, punto 6), y áreas táctiles de 44 px. Evidencia: 18/11/2026, verificación local (diseño, sección 8, «Verificación local»); los 44 px de «+ Feedback» vienen del botón común (`.button`), sin una prueba propia

## 3. Verificación

- [x] 3.1 `bin/bundler-audit update` y `bin/ci` en código 0, con el número de ejemplos. Evidencia: 18/11/2026, con autorización de Pablo y después del commit local bb5db27: base de avisos actualizada a e755a81 (1378 avisos) y `bin/ci` en código 0, con 428 ejemplos y 0 fallos (diseño, sección 8, «Verificación con la base de avisos actualizada»)
- [x] 3.2 `openspec validate --all --strict`. Evidencia: 18/11/2026, 23 de 23 en verde según el reporte de implementación de GL-15 (diseño, sección 8, «Verificación local»)
- [x] 3.3 Comprobación manual de Pablo en local a 1280 y 375 px: abrir el formulario en la ficha, guardar un borrador y una lista, y ver un error. Evidencia: 18/11/2026, conformidad visual de Pablo sobre las capturas a 1280 × 800 y 375 × 812 de la ficha, el formulario abierto y los errores (diseño, sección 8, «Conformidad visual»); pedido sin numerar todavía
- [x] 3.4 Registrar en este diseño lo ejecutado, los desvíos y lo pendiente. Evidencia: 18/11/2026, diseño, sección 8

## 4. Publicación y cierre (cada paso con autorización de Pablo)

- [x] 4.1 Commit, push y CI remoto con enlace y SHA. Evidencia: 18/11/2026, con autorización de Pablo: commits bb5db27 y 44d91b2 publicados en `feature/entrega-final-pp`; CI habilitado en la rama con fda7c00; corrida https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/44426945336 sobre fda7c0055bd25cd7e8cffa89db0a511396c11e86, en verde, con 428 ejemplos y 0 fallos (diseño, sección 8, «CI remoto»)
- [x] 4.2 Integración según la rama que se defina para la entrega final. Decisión de Pablo (18/11/2026): la rama de integración de la entrega final es `feature/entrega-final-pp`, y la integración se cumple cuando el cambio queda incorporado y publicado en ella. Evidencia: 18/11/2026, commits bb5db27, 44d91b2, fda7c00 y cebc659 publicados en `feature/entrega-final-pp`; CI remoto en verde sobre cebc659dacd80ac88154084a5bf25d4938d27684 (https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/44427603213)
- [x] 4.3 Archivo del cambio. Evidencia: 19/11/2026, con autorización de Pablo: `openspec archive` movió el cambio a `openspec/changes/archive/2026-11-19-gl-15-formulario-feedback/` y aplicó sus deltas (feedback-capture: 6 requisitos agregados y 1 modificado; people-browsing: 1 modificado). Pablo aprobó un ajuste de redacción en «Textos que separan "lista" de "compartida"» para respetar el largo del modo estricto, igual en la spec y en este delta. `openspec validate --all --strict`: 22 de 22 en verde
- [x] 4.4 Con el pedido de Pablo, ajustar el delta de `people-browsing` de GL-14 sobre la spec que deje GL-15, para que los dos requisitos queden compatibles (diseño, sección 6). Evidencia: 19/11/2026, con el pedido de Pablo: en el delta de GL-14, «Solo lectura y sin funciones inexistentes» admite «+ Feedback» en la ficha y el escenario «Acciones disponibles en la ficha» coincide con la spec vigente; GL-14 sin archivar. `openspec validate --all --strict`: 22 de 22 en verde (diseño, sección 8, «Integración, archivo y ajuste de GL-14»)
