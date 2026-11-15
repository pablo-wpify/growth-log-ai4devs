# M215. Autorizar la implementación de GL-10

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-10` |
| Tipo | autorización de implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Sin marca de texto pegado en la transcripción; origen de la redacción no declarado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `7977b430bb18e0c69be13eb59c6701e32af40641cca9b4f5ef4ea7c04e2838fe` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M215 | 2026-11-14 23:31:03 |

## Texto original

````text
Autorizo implementar GL-10 según el borrador v3. P-30 sigue pendiente. Tras crear y verificar las cuentas demo, se retiran las variables de contraseña y se conserva el indicador de la instancia demo. Esta autorización no incluye modificar Render ni desplegar.
````

## Resultado registrado (no forma parte del pedido)

- **Implementación local de GL-10, sin commit ni deploy:**
  - migración y modelo `DemoDataRecord` (P-31);
  - servicio `DemoData` y `DemoDataCommand`;
  - tarea `growth_log:datos_demo`;
  - `bin/render-build.sh` (P-28);
  - guía `docs/desarrollo.md`, sección 12.
- **Contraseñas iniciales (P-29):** salen de `GROWTH_LOG_DEMO_PASSWORD_LUCIA` y `GROWTH_LOG_DEMO_PASSWORD_MARTIN` solo al crear cada cuenta. No se muestran ni se sobrescriben.
- **Decisión registrada:** tras crear y verificar las cuentas se retiran las variables de contraseña y se conserva `GROWTH_LOG_DEMO_INSTANCE` (tarea 5.4).
- **Pruebas primero:** fallaron por la razón esperada. Suman 51 ejemplos nuevos, incluidos procesos reales contra la base de test.
- **Mutaciones:** M1 a M4 detectadas y restauradas.
- **Local:**
  - `bin/bundler-audit update` y `bin/ci` con código 0 (368 ejemplos, 0 fallos);
  - `openspec validate --all --strict`, 19 de 19;
  - `assets:precompile` de producción comprobado y limpiado.
- **No hecho, fuera de la autorización:** nada en Render. Tampoco commit, push, CI remoto ni deploy.
- **Pendiente:**
  - P-30;
  - riesgo R1: conexión del build a la base;
  - riesgo R9: Ruby 4.0.9 en Render;
  - tareas 5.2 a 5.4 y 6.1b.
