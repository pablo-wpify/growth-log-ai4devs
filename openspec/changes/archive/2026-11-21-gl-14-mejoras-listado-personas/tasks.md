# Tasks

El trabajo tiene dos fases:

- **Fase documental (grupo 0):** ticket, propuesta, specs, diseño,
  validación y revisión de Pablo. Pedida en M257. El 19/11/2026, en la
  tarea 4.4 de GL-15 (M355), se ajustó «Solo lectura y sin funciones
  inexistentes» del delta de `people-browsing`: la ficha conserva
  «Captura rápida» y permite «+ Feedback» con su formulario. El
  20/11/2026, durante la revisión (0.4), se dividieron los requisitos que
  superaban el largo del modo estricto (diseño, sección 7). El 21/11/2026
  Pablo dio su conformidad al borrador y cerró la 0.4.
- **Implementación y verificación (grupos 1 a 4):** autorizada por Pablo
  el 21/11/2026 (tarea 0.6, M395) para los grupos 1 a 3, en local. El
  grupo 4 lo autorizó en M401: publicado y archivado el mismo día. P-46 a P-53 se
  resolvieron en M258. Las pruebas se escriben primero y se ven fallar por
  la razón esperada.

## 0. Fase documental

- [x] 0.1 Separar de GL-13 los requisitos funcionales del listado y crear este cambio con el ticket, la propuesta, el diseño, los deltas de `people-browsing`, `feedback-capture` y `authorization`, y estas tareas. Evidencia: 15/11/2026, M257
- [x] 0.2 Registrar las decisiones 1 a 9 aprobadas por Pablo (P-41 a P-45) y las consecuencias abiertas P-46 a P-53 en el plan de la entrega final. Evidencia: 15/11/2026, M257
- [x] 0.3 Ejecutar `openspec validate --all --strict` y registrar el resultado. Evidencia: 15/11/2026, M257 (ver su registro)
- [x] 0.4 Revisión de Pablo del borrador. Evidencia: 21/11/2026, conformidad de Pablo sobre el diff v4 respecto de `eade6a6`, después de `openspec validate --all --strict` en 22 de 22 (diseño, sección 7)
- [x] 0.5 Decisiones de Pablo sobre P-46 a P-53 y ajuste de los deltas. Evidencia: 15/11/2026, M258
- [x] 0.5b Volver a ejecutar `openspec validate --all --strict`. Evidencia: 15/11/2026, M258 (ver su registro)
- [x] 0.5c Registrar la confirmación de las interpretaciones de P-51 y P-53 y validar de nuevo. Evidencia: 16/11/2026, M259 (ver su registro)
- [x] 0.6 Aprobación explícita de Pablo para implementar. Evidencia: 21/11/2026, M395 (autoriza los grupos 1 a 3; el grupo 4 sigue necesitando autorización para cada paso)

## 1. Pruebas primero

- [x] 1.1 Pruebas de peticiones (evidencia: 21/11/2026, M395, `spec/requests/people_listing_spec.rb` y los ajustes de la 3.1; diseño, sección 7):
  - textos de los conteos en sus cuatro casos, incluida una persona solo con borradores;
  - «Último hecho» con listas y un borrador posterior, y sin fecha con solo borradores;
  - otro líder de la misma persona, con una entrada lista posterior y un borrador, que no cambia conteos, fecha ni orden;
  - administradora asignada sin entradas;
  - «Registrar la primera» solo sin entradas y fuera del enlace de la fila, y presente igual cuando otro líder tiene entradas sobre esa persona;
  - el total de personas y el aviso, y su ausencia en el estado vacío;
  - captura por URL directa, en `new` y en `create`, con una persona fuera del alcance (404 y sin entrada)
- [x] 1.2 Pruebas de sistema a 1280 y 375 px (evidencia: 21/11/2026, M395, `spec/system/people_listing_spec.rb`; diseño, sección 7):
  - Tab y foco visible en la fila, sin enlaces anidados;
  - búsqueda parcial sin mayúsculas ni acentos, y filtro con equipos solo de las personas asignadas y «Sin equipo indicado» cuando corresponde;
  - «Hechos más recientes» con las personas sin entradas listas al final, su desempate y el orden por nombre como predeterminado;
  - sin resultados y «Limpiar filtros», que conserva el orden;
  - vacío frente a sin resultados;
  - la URL sin cambios al buscar o filtrar, y el listado completo por nombre al recargar y sin JavaScript;
  - 375 px sin desplazamiento horizontal y con 44 px
- [x] 1.3 Ver fallar 1.1 y 1.2 por la razón esperada y registrarlo. Evidencia: 21/11/2026, M395: 62 ejemplos, 41 fallos (diseño, sección 7)

## 2. Implementación

- [x] 2.1 Lectura agregada única desde `policy_scope(FeedbackEntry)` en `PeopleController#index`. Evidencia: 21/11/2026, M395
- [x] 2.2 Textos en `people_helper.rb`: conteos y «Último hecho». Evidencia: 21/11/2026, M395
- [x] 2.3 Fila con un enlace extendido y «Registrar la primera» como enlace independiente. Evidencia: 21/11/2026, M395
- [x] 2.4 Total y aviso; búsqueda, filtro, orden, «Limpiar filtros» y sin resultados, con un controlador Stimulus (P-51). Evidencia: 21/11/2026, M395, `people_list_controller.js`
- [x] 2.5 Estilos del listado con los tokens y componentes de la spec vigente `visual-language` (GL-13, archivado). Evidencia: 21/11/2026, M395

## 3. Verificación

- [x] 3.1 Pruebas nuevas en verde. Las existentes, en verde sin modificarlas, salvo las que comprueban «0 entradas listas» (`spec/requests/people_counts_spec.rb` y `spec/requests/feedback_summary_privacy_spec.rb`), que cambian junto con sus escenarios y se registran. Evidencia: 21/11/2026, M395 (463 ejemplos, 0 fallos). Desvío aceptado por Pablo en M396: también cambió `spec/requests/people_spec.rb`, solo el selector de sus ayudas (`a[data-person-link]`), con las mismas expectativas (diseño, sección 7)
- [x] 3.2 `bin/bundler-audit update` y `bin/ci` con código 0. Evidencia: 21/11/2026, M398, con Brakeman 8.1.1 (M396) y Ruby 4.0.10 (cambio independiente `gl-16-ruby-4-0-10`): `bin/ci` en código 0, 463 ejemplos y 0 fallos (diseño, sección 7)
- [x] 3.3 Comprobación manual de Pablo del listado a 1280 y 375 px. Evidencia: 21/11/2026, conformidad de Pablo con las capturas a 1280 y 375 px (M396; diseño, sección 7)
- [x] 3.4 Registrar en el diseño lo ejecutado, los desvíos y lo pendiente. Evidencia: 21/11/2026, M395 (diseño, sección 7)

## 4. Publicación y cierre (cada paso con su autorización)

- [x] 4.1 Commit, push y PR; CI remoto con enlace y SHA. Evidencia (M401): commits `0662e70` (revisión del borrador) y `ca2d5da` (implementación), sobre `d2c6db4` (GL-16), publicados con push fast-forward en `feature/entrega-final-pp`, sin PR porque M401 no lo autorizó; CI [44938564609](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/44938564609) sobre `ca2d5da` en `success`, con Ruby 4.0.10 y 463 ejemplos, 0 fallos
- [x] 4.2 Archivo del cambio. Evidencia (M401): archivado el 21/11/2026 en `openspec/changes/archive/2026-11-21-gl-14-mejoras-listado-personas`, con los deltas aplicados a `people-browsing`, `feedback-capture` y `authorization`, y `openspec validate --all --strict` en verde
