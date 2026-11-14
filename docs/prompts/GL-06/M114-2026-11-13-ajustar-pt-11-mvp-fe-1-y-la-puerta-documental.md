# M114. Ajustar PT-11, MVP-FE-1 y la puerta documental de GL-06

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | ajustes documentales de una revisión |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `f1f3c559e0340d1b5bdf0b288886f0a3cd3c545a5107734abaf7db5105aae0cc` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M114 | 2026-11-13 18:58:20 |

## Texto original

````text
Aplicá únicamente los ajustes documentales de esta revisión a GL-06. No repitas el relevamiento general.

Estado conocido: GL-06 sigue preparado, sin aprobar y sin implementar. P-1, P-2, P-3 y P-11 figuran aprobadas; P-19 a P-26 están registradas como decididas. La aprobación explícita del cambio OpenSpec sigue pendiente. No escribas pruebas de implementación, código ni migraciones.

Antes de editar, revisá el estado del checkout y preservá todos los cambios locales. Trabajá solo sobre los archivos de GL-06 y sus referencias documentales necesarias. No hagas commit, push, PR ni archivado.

Ajustes:

1. PT-11 y “datos mínimos”
   - No infieras que la decisión P-24 (“todos los campos” de la entrada propia) resuelve por sí sola qué significa “datos mínimos” en PT-11.
   - Conservá la decisión explícita de P-24 para el detalle sin acceso a la ficha.
   - En el plan, ticket, diseño y specs afectados, distinguí la lectura de entradas propias —incluidos borradores— de la frase ambigua “con datos mínimos” de PT-11.
   - No declares completamente satisfecha la rama de lectura de PT-11 respecto de esa frase hasta que su alcance esté aclarado. Registra la ambigüedad como pendiente de interpretación, sin reabrir las decisiones ya confirmadas ni agregar la transición de reasignación a GL-06.
   - Mantén compartir y revocar fuera del alcance.

2. P-22 y MVP-FE-1
   - Donde diga que la página propia “no cumple” «sin salir de la página», reemplazalo por una formulación que no presente MVP-FE-1 como requisito aprobado. Usá, por ejemplo: “GL-06 elige una página propia y no adopta la interacción sin navegación propuesta en MVP-FE-1”.
   - Alineá las menciones en el plan, el registro de decisiones, el ticket y el diseño. No cambies la decisión de P-22.

3. Puerta documental en tasks.md
   - La fase documental informa como realizadas la inscripción de decisiones, la alineación de documentos y la validación OpenSpec. Marcá 0.1, 0.2 y 0.3 como completas solo si el estado actual y la evidencia registrada lo respaldan.
   - Dejá 0.4 sin marcar: revisión humana y aprobación explícita de Pablo.
   - La implementación debe seguir bloqueada hasta esa aprobación. No marques tareas de implementación.

Verificación:
- Ejecutá únicamente `openspec validate --all --strict` si los cambios afectan specs. No ejecutes pruebas, lint, migraciones ni validaciones de implementación.
- No registres nuevas decisiones de Pablo. No cambies los estados de P-19 a P-26.
- Al terminar, informa qué archivos cambiaste, el texto ajustado, la evidencia de cualquier casilla marcada y el resultado de la validación. Dejá el cambio sin aprobar, sin commit y sin autorizar implementación.
````

## Resultado registrado (no forma parte del pedido)

- **PT-11:** el plan, el registro del 13/11/2026, el ticket, el diseño, la
  spec `authorization` y `tasks.md` distinguen la lectura de las entradas
  propias, incluidos los borradores, de la frase «con datos mínimos», que
  queda **pendiente de interpretación**: P-24 no la define por sí sola, y
  la rama de lectura de PT-11 no se da por satisfecha por completo. Sin
  reabrir P-24 ni agregar la reasignación (P-26); compartir y revocar
  siguen fuera.
- **P-22:** donde decía que la página propia «no cumple» el «sin salir de
  la página» de MVP-FE-1, ahora dice que GL-06 elige una página propia y
  no adopta la interacción sin navegación propuesta en MVP-FE-1, ticket
  propuesto en la entrega 1 (plan, registro de decisiones, ticket y
  diseño).
- **`tasks.md`:** 0.1, 0.2 y 0.3 marcadas, con su evidencia; 0.4
  (aprobación de Pablo) sin marcar. Ninguna tarea de implementación
  marcada.
- `openspec validate --all --strict` (18:59 UTC): 16 elementos válidos.
- Sin decisiones nuevas ni cambios de estado en P-19 a P-26; sin pruebas,
  código ni migraciones; sin commit ni push. El cambio de OpenSpec **no**
  está aprobado y la implementación no está autorizada.
- M109 a M113 (verificaciones de solo lectura, el pedido del diff y su
  copia a Descargas) no están registrados.
