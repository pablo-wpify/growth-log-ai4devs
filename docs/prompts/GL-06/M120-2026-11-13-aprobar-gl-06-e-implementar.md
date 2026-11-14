# M120. Aprobar el cambio de GL-06 e implementarlo

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | aprobación del cambio de OpenSpec e implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. El mensaje de aprobación «Vamos para adelante» que cita el pedido no está en la transcripción de Claude Code: se registra tal como lo cita M120. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `e3380408e1d057cec8e3a3484ae68a94afec5aee16b1ffb563647a7e33b5db2e` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M120 | 2026-11-13 19:34:35 |

## Texto original

````text
Pablo aprobó el cambio OpenSpec de GL-06 con el mensaje «Vamos para adelante» (13/11/2026). Tomá P-25 y P-26 como identificadores definitivos de las decisiones cuyo contenido ya estaba confirmado. Registrá la aprobación en la tarea 0.4 y en el registro documental correspondiente.

Empezá la implementación de GL-06 siguiendo `openspec/changes/gl-06-captura-rapida/` y su orden de tareas. Antes de implementar cada grupo, escribí sus pruebas y comprobá que fallan por la razón esperada; luego implementá y verificá ese grupo.

Respetá el alcance y las decisiones registradas. En particular:
- No trates como resuelta la interpretación pendiente de «con datos mínimos» en PT-11 ni declares satisfecha esa parte.
- No agregues la transición de reasignación, compartir ni revocar.
- Conservá los requisitos de privacidad de logs; si el log de consultas los expone, detenete e informa una alternativa que mantenga el requisito.
- Conservá la página propia de captura y la zona horaria de la instancia.
- No uses la base de desarrollo para pruebas.

Al terminar cada etapa, informa archivos cambiados, pruebas y validaciones ejecutadas, resultados, riesgos y pendientes. No hagas commit, push, PR, despliegue ni archivado. Detenete e informa si una decisión documentada resulta insuficiente o contradictoria; no la resuelvas por inferencia.
````

## Resultado registrado (no forma parte del pedido)

- **Aprobación:** el cambio de OpenSpec quedó aprobado el 13/11/2026 con el
  mensaje «Vamos para adelante», según cita este pedido. Tarea 0.4
  marcada; P-25 y P-26 pasan a ser números definitivos.
- **Implementación** de los grupos 1 a 7 de `tasks.md`, con las pruebas
  escritas antes del código y vistas fallar por la razón esperada.
  Archivos:
  - migración `20261113194500_create_feedback_entries` y `db/schema.rb`;
  - `FeedbackEntry`, `FeedbackEntryPolicy`, `FeedbackEntriesController` y
    `FeedbackEntriesHelper`;
  - asociaciones en `Person` y `User`, `PeopleController#show`, rutas,
    vistas de entradas, ficha, layout (avisos) y CSS;
  - `config.time_zone` y `filter_parameters`.
- **Local:**
  - `bin/bundler-audit update` y `bin/ci` con código 0: 288 ejemplos y 0
    fallos (192 antes); RuboCop, auditorías y Brakeman sin avisos;
  - `openspec validate --all --strict`: 16 válidos;
  - las seis mutaciones, detectadas y restauradas. La 1 la detectó
    `verify_policy_scoped`, no la matriz: es un desvío registrado en el
    diseño.
- **Verificaciones:**
  - el log de consultas muestra `[FILTERED]`: se cumple el requisito;
  - las pruebas con `Time.zone.local` pasan sin cambios;
  - la sesión vencida al enviar está verificada en el servidor; la vista
    en el navegador queda para F17.
- **Desvíos:**
  - rutas explícitas, para no exponer `PUT /entradas/:id`;
  - `bin/ci` aplicó la migración a la base de desarrollo (tabla vacía;
    `db/schema.rb` sin cambios);
  - en la mutación 6, la base de test se remigró una vez sin el `CHECK`
    por un nombre de copia equivocado. Quedó restaurada y comprobada.
- **Pendiente:**
  - la comprobación manual F17;
  - con autorización, commit, push y CI remoto, y después el archivo;
  - la interpretación de «con datos mínimos» en PT-11, que no se da por
    satisfecha;
  - 3.10 y 4.14 siguen parciales (P-24).
- Sin commit, push, PR, despliegue ni archivo. M118 y M119 no están
  registrados.
