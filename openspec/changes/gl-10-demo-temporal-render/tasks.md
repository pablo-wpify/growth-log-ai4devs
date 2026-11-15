# Tasks

El trabajo tiene dos fases:

- **Fase documental (grupo 0):** ticket, propuesta, specs, diseño,
  validación y revisión de Pablo. Pedida en M212 y actualizada en M213 y M214.
- **Implementación (grupos 1 a 6):** autorizada por Pablo en M215 según el
  borrador v3, **sin modificar Render ni desplegar**. Las pruebas se
  escriben primero y se ven fallar por la razón esperada. Los pasos que
  requieren Render (5.2 y 5.3) quedan fuera de esta autorización.

## 0. Fase documental

- [x] 0.1 Proponer GL-10 en el plan (secciones 2, 3, 5, 6 y 9, única fuente) y preparar el ticket. Evidencia: 14/11/2026, M212
- [x] 0.2 Preparar la propuesta, el diseño, los deltas de `temporary-demo` e `initial-administrator` y estas tareas, con los límites de Render y sus fuentes. Evidencia: 14/11/2026, M212
- [x] 0.3 Ejecutar `openspec validate --all --strict` y registrar el resultado. Evidencia: 14/11/2026, con el cambio de GL-10 (ver los registros de M212 a M214)
- [x] 0.4 Decisiones de Pablo y actualización del borrador. Evidencia: M214, 14/11/2026:
  - P-28: build después de las migraciones; primer deploy solo de migraciones y después un deploy manual con la tarea habilitada.
  - P-29: contraseñas iniciales desde variables secretas de Render, sin imprimirlas ni sobrescribir existentes.
  - P-31: tabla de marcas propia.
  - Rama `feature/entrega-2-pp`, con despliegue manual.
  - Conjunto Lucía, Martín y Paula aceptado.
  - P-30 sigue pendiente.
- [x] 0.5 Aprobación explícita de Pablo para implementar. Evidencia: M215 (2026-11-14 23:31:03 UTC), según el borrador v3, sin modificar Render ni desplegar.
  - P-30 sigue pendiente.
  - Tras crear y verificar las cuentas demo, se retiran las variables de contraseña y se conserva el indicador.

## 1. Pruebas primero

- [x] 1.1 Escribir las pruebas de la guarda:
  - procesos reales en `development` y `test` con el indicador, y en producción sin él o con otro valor, sobre una base de pruebas aislada;
  - verificar que fallan porque la tarea no existe. Evidencia: `uninitialized constant DemoData` y «Don't know how to build task 'growth_log:datos_demo'»
- [x] 1.2 Escribir las pruebas de la base dedicada:
  - registros ajenos, correo del conjunto ya usado y entrada de un autor ajeno;
  - entradas de revisores toleradas.
- [x] 1.3 Escribir las pruebas de las contraseñas iniciales (P-29):
  - creación con las variables válidas;
  - variable ausente o fuera de la política: error sin escribir;
  - cuenta existente con la variable cambiada o ausente: contraseña sin cambios;
  - salida y errores sin el valor ni el hash.
- [x] 1.4 Escribir las pruebas del conjunto:
  - primera ejecución y repetición con ediciones y entradas nuevas;
  - atomicidad y concurrencia;
  - salida sin contraseñas.
- [x] 1.5 Escribir las pruebas de que los seeds, las migraciones y el arranque no crean datos demo. Evidencia: `spec/tasks/datos_demo_spec.rb` (seeds, y ningún archivo de `config/`, `db/` ni `config.ru` invoca la tarea)
- [x] 1.6 Escribir las pruebas del script de build (con y sin indicador, falla de migraciones y de la tarea, sin traza). Evidencia: `spec/scripts/render_build_spec.rb` falló porque el script no existía

## 2. Marcas y tarea demo

- [x] 2.1 Crear la migración de `demo_data_records` con sus restricciones (P-31). Evidencia: `20261114233500_create_demo_data_records`, aplicada en desarrollo y test
- [x] 2.2 Implementar el servicio y la tarea `growth_log:datos_demo`; verificar que pasan las pruebas del grupo 1. Evidencia: 51 ejemplos nuevos en verde
- [x] 2.3 Verificar que las pruebas de `development-sample-data` pasan sin modificarse. Evidencia: 84 ejemplos de GL-08 y GL-10 en verde; ningún archivo de prueba de GL-08 cambió

## 3. Contraseñas

- [x] 3.1 Implementar la lectura de las contraseñas iniciales desde las variables secretas, solo al crear cada cuenta, sin contraseñas en archivos, prompts, logs ni salidas. Verificar que pasan las pruebas de 1.3. Evidencia: en verde

## 4. Mutaciones

- [x] 4.1 Ejecutar y registrar las mutaciones del diseño, con copia de seguridad y restauración comprobada:
  - sin la guarda de entorno;
  - sin la revisión de registros ajenos;
  - repetición que actualiza un registro;
  - el script de build invoca siempre la tarea.
  Evidencia: M1 a M4 detectadas (10, 7, 3 y 1 fallos) y restauradas con `diff` limpio

## 5. Render

- [x] 5.1 Preparar el script de build y la configuración de producción según P-28, sin secretos en el repositorio:
  - el script migra siempre e invoca la tarea solo si `GROWTH_LOG_DEMO_INSTANCE` está configurado;
  - no usa `set -x` ni muestra el entorno.
  Evidencia: `bin/render-build.sh`; sin cambios en la configuración de producción; `assets:precompile` de producción comprobado en local
- [ ] 5.2 **Fuera de la autorización de M215.** Primer deploy, solo de migraciones. Con autorización de Pablo para ese paso, Pablo crea el servicio web sobre `feature/entrega-2-pp`, con despliegue manual y sin `GROWTH_LOG_DEMO_INSTANCE` ni las variables de contraseña; el agente no lo hace.
  - Comprobar la conexión del build a la base (riesgo R1 del diseño): migraciones aplicadas y ningún dato demo.
- [ ] 5.3 Segundo deploy, manual, con la tarea habilitada. Tras comprobar la conexión, Pablo carga el indicador y las variables de contraseña y lanza el deploy. Fuera de la autorización de M215.
  - Comprobar a mano en la URL, con fecha (criterio CA8 del ticket):
  - el recorrido con L1;
  - la rama negativa con L2;
  - un nuevo deploy manual que no cambia los datos ni las contraseñas.
- [ ] 5.4 Retirar las variables de contraseña del panel tras crear y verificar las cuentas demo, conservando `GROWTH_LOG_DEMO_INSTANCE` (decidido en M215). Lo hace Pablo.
  - Un deploy posterior sin esas variables no falla ni cambia las contraseñas.

## 6. Documentación y verificación

- [x] 6.1 Preservar los logs y ejecutar `bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`. Registrar en el diseño lo comprobado en local. Evidencia: 14/11/2026, `bin/ci` con código 0 (368 ejemplos, 0 fallos); OpenSpec 19 de 19
- [ ] 6.1b CI remoto sobre el SHA publicado. **Pendiente:** requiere autorización de commit y push
- [x] 6.2a Actualizar `docs/desarrollo.md` (sección 12), el plan, el ticket y el registro de prompts con el estado «implementado en local, sin desplegar». Evidencia: M215
- [ ] 6.2 Actualizar el README («Cómo revisar esta entrega», 0.4 y 2.4) cuando la demo exista. **Pendiente** hasta 5.3:
  - la demo es temporal, con datos ficticios y fecha de vencimiento;
  - no reemplaza la revisión local.
