# M29. Inventario del registro de prompts

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `registro-prompts` |
| Tipo | pedido de análisis |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `cd31574cddf91db8dfbff09728bb49bdd94fe139a2df42a46b388a2fff7462d4` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M29 | 2026-11-03 11:08:24 |

## Texto original

````text
Revisemos el registro de prompts de la entrega 2.

En ~/code/ai4devs-entrega-1-pp, inspeccioná primero la rama y el estado del árbol. Conservá cualquier trabajo pendiente.

Hacé un inventario desde GL-01 hasta GL-08, incluyendo GL-01a y los ajustes de planificación posteriores al feedback de LIDR.

Buscá en los archivos del proyecto y en el historial de esta conversación que tengas disponible. No leas configuraciones personales, credenciales ni transcripciones externas de otras sesiones.

Para cada ticket o etapa, informá:
- Qué prompts están guardados y dónde.
- Si son literales, extractos o reconstrucciones.
- Qué pedidos de aprobación o corrección se conservan.
- Herramienta y modelo, solo cuando haya evidencia.
- Referencias a specs, commits y CI.
- Qué falta y qué podemos recuperar literalmente del contexto disponible.

No confundas tickets, specs o resúmenes de resultados con los prompts que los originaron. No reconstruyas textos ni completes datos por inferencia.

Proponé una organización sencilla:
- prompts.md como índice, conservando el registro histórico de la entrega 1.
- docs/prompts/<ticket>/ para los nuevos textos.
- Separación entre prompts enviados a Claude Code y pedidos de la conversación de acompañamiento.
- Identificación explícita de ausencias y de cualquier redacción de secretos, sin reproducirlos.

Proponé también una regla breve para CLAUDE.md: guardar los nuevos prompts al comenzar cada tarea y registrar su resultado al terminar, sin copiar razonamientos internos ni datos sensibles.

En este paso solo devolvé el inventario y la propuesta. No modifiques archivos, no hagas commits, push, PR ni cambios de rama. No implementes GL-05 todavía.
````

## Resultado registrado (no forma parte del pedido)

Inventario y propuesta en la conversación. Sin cambios en el repositorio.
