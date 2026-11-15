# M211. Preparar GL-10 desde un borrador

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-10` |
| Tipo | fase documental (detenida: falta el archivo de partida) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `d81563c5ab99fe267055e449238dab14d807b278976065dc8334f17a98c2c444` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M211 | 2026-11-14 22:52:42 |

## Texto original

````text
Prepará en el checkout local de Growth Log el borrador OpenSpec para una demo temporal en Render, usando GL-10-borrador-OpenSpec-demo-Render.md como propuesta de partida.

Seguí CLAUDE.md y el flujo SDD: ticket → propuesta, specs, diseño y tareas → validación → revisión de Pablo. Todavía no implementes.

Antes de editar:
- revisá rama, HEAD y git status;
- si hay cambios ajenos o inesperados, detenete e informá;
- no leas ni muestres .env, secretos ni credenciales.

Alcance:
- Proponé GL-10 como nuevo ticket; actualizá docs/plan-entrega-2.md, la única fuente de secuencia.
- Prepará ticket, proposal.md, design.md, tasks.md y el delta de OpenSpec necesario.
- Conservá intacta la restricción de GL-08: su carga de datos sigue siendo solo para development. Diseñá una capacidad separada, explícita e idempotente para una base de demo dedicada.
- Registrá que Pablo eligió una demo editable con datos exclusivamente ficticios; no agregues modo de solo lectura.
- Considerá dos líderes ficticios asignados a una persona, con ejemplos de borrador y entrada lista para el recorrido. No incluyas contraseñas en archivos, prompts, logs ni salidas.
- Dejás pendiente cómo se compartirán las credenciales de revisión; no lo decidas por Pablo.
- Reflejás Render como temporal: la base Free ya existe, vence a los 30 días y el servicio web no ofrece SSH ni trabajos puntuales. El formulario de la app sigue sin desplegarse.
- No cambies código, configuración de Render, datos ni servicios. No hagas stage, commit, push, PR, merge ni archivo.
- Registrá el pedido en docs/prompts según las reglas del proyecto.

Al terminar, ejecutá solo openspec validate --all --strict si el CLI está disponible. No ejecutes pruebas, CI ni auditorías. Entregá el diff completo, decisiones propuestas, preguntas abiertas y estado de Git. Dejá la aprobación para implementar claramente pendiente.
````

## Resultado registrado (no forma parte del pedido)

- **Detenido antes de editar.** Rama `feature/entrega-2-pp` en `e5d678f`, igual al remoto, árbol limpio.
- El archivo `GL-10-borrador-OpenSpec-demo-Render.md` que el pedido nombraba como propuesta de partida no se encontró en el repositorio, en `~/Descargas`, en `/tmp` ni en el resto del disco. No se reconstruyó su contenido.
- Sin cambios en archivos. M212 reemplazó este pedido y lo tomó como fuente de verdad.
