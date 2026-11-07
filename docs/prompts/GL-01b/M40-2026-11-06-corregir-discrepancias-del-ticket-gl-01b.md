# M40. Corregir discrepancias del ticket GL-01b

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-01b` |
| Tipo | pedido de corrección de la planificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `03fb9f102d341c31602f8b69e8740a454678932aef0803ae00c18c55cd040874` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M40 | 2026-11-06 23:26:41 |

## Texto original

````text
En `docs/tickets/GL-01b-rails-8-1-4-1.md`, corregí solo estas discrepancias. No modifiques `Gemfile`, `Gemfile.lock` ni código; no ejecutes actualizaciones ni pruebas; no crees ramas, commits, push ni PR.

1. Compara la tabla actual de avisos con la propuesta original. La tabla original de “no aplican” enumeraba 10 avisos y omitía `GHSA-3f4q-8x5m-76v8`. Si ese advisory ya está agregado en el ticket nuevo, informa que se incorporó en esta revisión; no digas que ya estaba en la tabla original. Confirma que los 21 GHSA están listados una sola vez y que las cantidades coinciden.
2. No clasifiques `GHSA-2gff-2mmg-m73p` como aplicable confirmado mientras no se conozca la configuración del proxy. El uso de `request.remote_ip` está comprobado en código, pero la exposición depende también de cómo el proxy trate `Forwarded` y `X-Forwarded-For`. Déjalo como condicional o pendiente de validar y especifica qué evidencia falta.
3. Para `GHSA-8474-xrp6-wh69`, registra qué búsqueda hiciste sobre llamadas a `safe_constantize` con datos externos. Si no podés confirmar que no existe ese camino, conservá “no confirmable” y detalla la comprobación pendiente.

No cambies las demás decisiones de GL-01b. Al terminar, informa el diff del ticket y el conteo final por clasificación.
````

## Resultado registrado (no forma parte del pedido)

- **Punto 1:** la respuesta a M38, que la transcripción guarda, lista 11
  avisos en «no aplican», con GHSA-3f4q-8x5m-76v8 en la primera fila. Eso
  no coincide con la premisa del pedido; se informó a Pablo.
  - Para no afirmar nada que la evidencia no sostiene, el ticket ya no
    compara con la tabla original: solo verifica el conteo.
  - Los 21 GHSA figuran una sola vez y coinciden con los avisos de
    `bundler-audit`: 19 no aplican, 1 condicional y pendiente de validar, y
    1 no confirmable.
- **Punto 2:** GHSA-2gff-2mmg-m73p pasa a «condicional, pendiente de
  validar», con cinco evidencias faltantes sobre el proxy del despliegue.
- **Punto 3:** GHSA-8474-xrp6-wh69 sigue como «no confirmable».
  - Se registraron las búsquedas en el código propio y en las gemas de
    Rails.
  - Se encontró un camino con datos externos en `development` y `test`:
    `ActionableExceptions` con `POST /rails/actions`.
  - Quedan detalladas las comprobaciones pendientes para producción.
- Sin cambios en `Gemfile`, `Gemfile.lock` ni código; sin actualizaciones,
  pruebas, ramas, commits, push ni PR.
