# M214. Decisiones de Pablo sobre GL-10

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-10` |
| Tipo | decisiones (P-28, P-29, P-31, rama y despliegue, conjunto demo) y actualización de la fase documental |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Sin marca de texto pegado en la transcripción; origen de la redacción no declarado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `f9201bbfdd461e7c7a727b69dbe2734bdc22f5257b9cbf2f36c27f9f542d8741` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M214 | 2026-11-14 23:24:10 |

## Texto original

````text
Apruebo P-28 con primer deploy solo de migraciones y, tras comprobar la conexión, un deploy manual con la tarea demo habilitada. Para P-29, usá variables secretas de Render para las contraseñas iniciales; la tarea no debe imprimirlas ni sobrescribir contraseñas existentes. P-30 sigue pendiente: no definas cómo compartir las credenciales. Apruebo P-31 con una tabla de marcas propia. El servicio usará feature/entrega-2-pp con despliegue manual. Acepto Lucía, Martín y Paula como datos ficticios. Actualizá el borrador y dejá la implementación esperando mi aprobación explícita.
````

## Resultado registrado (no forma parte del pedido)

- **Decisiones registradas en el plan (sección 6), el ticket y el cambio:**
  - **P-28 aprobada:** build después de las migraciones, bajo las dos guardas. Primer deploy solo de migraciones, sin el indicador; tras comprobar la conexión, un deploy manual con la tarea habilitada. El script de build invoca la tarea solo con el indicador configurado.
  - **P-29 decidida:** contraseñas iniciales desde variables secretas de Render (nombres propuestos: `GROWTH_LOG_DEMO_PASSWORD_LUCIA` y `GROWTH_LOG_DEMO_PASSWORD_MARTIN`, sin valores). Se leen solo al crear cada cuenta y se validan con la política antes de escribir. La tarea no las imprime ni sobrescribe contraseñas existentes.
  - **P-31 aprobada:** tabla de marcas propia.
  - **Rama y despliegue:** `feature/entrega-2-pp`, con despliegue manual.
  - **Conjunto demo:** Lucía, Martín y Paula, aceptados como datos ficticios.
- **P-30 sigue pendiente:** no se definió cómo compartir las credenciales.
- **Spec `temporary-demo`:** requisitos nuevos de contraseñas iniciales desde secretos y de ejecución en el build habilitada por el indicador.
- **Tareas:** 0.4 marcada (decisiones de M214); 0.5, la aprobación explícita para implementar, **pendiente**.
- **Validación:** `openspec validate --all --strict`, 19 de 19 válidos. No se ejecutaron pruebas, CI ni auditorías. Sin stage, commit, push, PR, merge ni archivo.
