# Tasks

Trabajo en dos fases:

- **Fase documental (grupo 0):** decisión de P-4, ticket, propuesta,
  specs, diseño y validación de OpenSpec.
- **Implementación (grupos 1 a 5):** autorizada por Pablo en M202. Las
  pruebas se escriben antes de la herramienta y se ven fallar por la
  razón esperada. Preparan sus propios datos ficticios y no usan la base
  de desarrollo.

## 0. Fase documental

- [x] 0.1 Registrar P-4 y las dependencias de prueba en el plan (sección 6, única fuente) y en `docs/decisiones/`. Evidencia: 14/11/2026, M202; `docs/decisiones/2026-11-14-gl-09-e2e.md`
- [x] 0.2 Preparar el ticket, la propuesta, el diseño, las specs y estas tareas. Evidencia: 14/11/2026, M202
- [x] 0.3 Ejecutar `openspec validate --all --strict` y registrar el resultado. Evidencia: 14/11/2026, 19 de 19 válidos, con el cambio de GL-09
- [x] 0.4 Aprobación: Pablo autorizó la implementación en M202, en el mismo pedido; la revisión humana del cambio queda pendiente antes del commit. Evidencia: M202 (2026-11-14 19:41:16 UTC)

## 1. Pruebas primero

- [x] 1.1 Escribir `spec/system/core_journey_spec.rb` con el recorrido núcleo (E1 a E5) y la rama negativa (N1 y N2); verificar que fallan por la falta de la herramienta. Evidencia: «capybara is not part of the bundle»

## 2. Herramienta

- [x] 2.1 Agregar `capybara` y `selenium-webdriver` al grupo `:test` e instalarlas. Evidencia: capybara 3.40.0 y selenium-webdriver 4.52.0
- [x] 2.2 Configurar las pruebas de tipo `system` con Chrome sin interfaz en `spec/support/system_tests.rb`; verificar que las dos pruebas pasan. Evidencia: 2 de 2 pasan

## 3. Mutaciones

- [x] 3.1 Ejecutar y registrar las mutaciones M1 a M4 del diseño, con copia de seguridad y restauración comprobada. Evidencia: M1 a M4 detectadas y restauradas (ver el diseño)

## 4. CI

- [x] 4.1 Subir las capturas de pantalla como artefacto cuando falla el job `test`. Evidencia: `.github/workflows/ci.yml`; se comprueba en el CI remoto

## 5. Documentación y verificación

- [x] 5.1 Documentar en `docs/desarrollo.md` el requisito de Chrome y cómo correr las pruebas en navegador. Evidencia: prerrequisitos, sección 5 y sección 11
- [x] 5.2 Preservar los logs, ejecutar `bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`, y registrar en el diseño lo comprobado y lo pendiente. Evidencia: 14/11/2026; `bin/ci` con código 0 (317 ejemplos, 0 fallos); OpenSpec 19 de 19
- [x] 5.3 Actualizar el plan, el README, el ticket, `openspec/config.yaml` y el registro de prompts. Evidencia: estado «implementado en local, sin commit»; M202 registrado

## Workflow follow-up

- Con autorización, commit, push, PR y verificación del CI remoto.
- Archivar `gl-09-e2e-recorrido-nucleo` después del CI remoto y de la revisión humana, con autorización.
