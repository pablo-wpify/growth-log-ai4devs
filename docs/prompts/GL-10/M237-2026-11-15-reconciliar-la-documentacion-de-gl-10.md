# M237. Reconciliar la documentación de GL-10 con lo ocurrido

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-10` |
| Tipo | actualización documental |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `5fd004dcc71ce281704fb2fbcd90cbf186279fa8080667c6ead532a84243ec21` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M237 | 2026-11-15 13:53:07 |

## Texto original

````text
Trabajá en el checkout local de Growth Log y seguí `CLAUDE.md`, los `AGENTS.md` aplicables y las reglas de registro de prompts.

## Antes de editar

- No leas ni muestres `.env`, secretos, credenciales ni valores de variables de Render.
- Informá rama, HEAD y estado completo de Git, incluidos cambios staged, unstaged y untracked.
- El borrador SDD local de GL-11 es trabajo esperado y debe conservarse intacto: revisá el estado para reconocer sus archivos antes de editar.
- Si hay cambios ajenos o inesperados, detenete e informá. No hagas checkout, reset, stash, pull, commit ni push.
- El merge commit conocido de GL-10 es `6177aef04a6cd64c85f27cad832cb4b5cf54e949`; confirmá que sigue integrado.

## Alcance: reconciliar la documentación de GL-10 con lo ocurrido

Pablo confirma que la aplicación y los datos demo **ya están desplegados en Render**. Las capturas compartidas muestran el inicio de sesión como Lucía Demo y Martín Demo, y sus vistas de Paula Ejemplo con entradas ficticias. El informe anterior que decía que el despliegue con la tarea demo seguía pendiente quedó desactualizado.

Pablo también aclara que **no íbamos a retirar las variables de contraseña**. No las inspecciones ni las cambies. No registres su retiro como tarea pendiente ni atribuyas a Pablo la decisión de retirarlas.

1. Inspeccioná el ticket, el plan, el cambio OpenSpec activo de GL-10 y sus tareas para localizar cada estado que contradice estos hechos.
2. Actualizá únicamente la documentación de GL-10 para distinguir:
   - lo implementado, fusionado y desplegado;
   - lo comprobado manualmente en las capturas;
   - lo que siga pendiente y tenga evidencia de estarlo.
3. Si las tareas 5.2–5.4 no describen bien lo que pasó, propón una redacción que refleje el despliegue y la verificación observados. No marques como hecha una comprobación que las capturas no demuestren.
4. Conservá P-30 como pendiente si sigue sin decisión. No decidas cómo compartir credenciales.
5. Si M215 afirma que Pablo decidió retirar las variables, no reescribas su texto histórico. Agregá una aclaración fechada en el lugar documental apropiado y registrá este pedido en `docs/prompts/` con el siguiente número según `prompts.md`.
6. Actualizá `docs/plan-entrega-2.md` y `prompts.md` sin borrar ni sobrescribir las adiciones de GL-11. Revisá el diff completo de ambos archivos para confirmar que los dos cambios quedan preservados.

## Límites

- No cambies código, configuración, datos ni servicios.
- No inspecciones Render ni sus valores secretos.
- No modifiques el ticket, diseño, tareas, proposal, prompts ni OpenSpec de GL-11.
- No archives GL-10 ni GL-11.
- No hagas stage, commit, push, PR ni merge.
- No ejecutes pruebas, CI ni auditorías. Al terminar, podés ejecutar únicamente `openspec validate --all --strict` si el CLI está disponible.

Entregá el diff documental completo, los estados que corregiste, las tareas que siguen pendientes con su evidencia y el estado final de Git. Dejá GL-11 sin implementar y esperando su aprobación.
````

## Resultado registrado (no forma parte del pedido)

- **Estado previo:**
  - Rama `feature/entrega-2-pp`, HEAD `6177aef`, sin cambios staged. El merge de GL-10 sigue integrado y la rama está igual a la remota.
  - Los únicos cambios locales eran el borrador de GL-11 (M236), sin alterar.
- **Documentación de GL-10 reconciliada** (ticket, propuesta, diseño, tareas, plan y `docs/desarrollo.md`, sección 12):
  - **Integrado:** PR #7, merge `6177aef`; CI 43660072168 sobre el head `d4fd753` y CI 43660510488 sobre el merge, ambos en `success`. Tarea 6.1b marcada.
  - **Primer deploy (5.2):** comprobado por el agente en modo de solo lectura en M235. Ruby 4.0.9, migraciones desde el build sin error y la tarea no invocada. Quedan resueltos R1 y R9.
  - **Segundo deploy (5.3):** declarado por Pablo en M237.
  - **Comprobación manual (5.3b, CA8), parcial:** inicio de sesión como Lucía Demo y Martín Demo y la vista de Paula de cada uno, según las capturas descriptas. Siguen pendientes el recorrido completo, la rama negativa, la separación entre líderes y un deploy repetido.
- **Aclaración fechada (15/11/2026):** el registro de M215 incluía retirar las variables de contraseña. Pablo aclaró en M237 que no se iban a retirar. La tarea 5.4 queda sin efecto y el texto de M215 no se modificó. Las variables no se inspeccionaron.
- **Corrección observada:**
  - Render fija `WEB_CONCURRENCY=1` por defecto y Puma arranca en modo cluster con un worker, según el log del primer deploy.
  - Corregido en el diseño y en la guía.
- **Pendientes:** el resto de CA8, el README (6.2), P-30 y el archivo.
- **Validación:** `openspec validate --all --strict`, 20 de 20 válidos. No se ejecutaron pruebas, CI ni auditorías.
- **Sin otros cambios:** ninguno en código, configuración, datos ni Render, y ninguno en los archivos de GL-11. Sin stage, commit, push, PR ni merge.
