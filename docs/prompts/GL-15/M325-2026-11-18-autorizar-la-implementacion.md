# M325. Autorización para implementar GL-15

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `f7f9c30f132d2888bd3669cc06722f7fa3eb85c5e44ba59b6c666363d86edda6` |
| Fecha y hora (UTC) | 2026-11-18 11:40:53 |

## Texto original

````text
Autorizo implementar GL-15 («+ Feedback») según el diseño documentado y las decisiones ya cerradas.

Antes de tocar código, verificá rama, HEAD y estado del árbol. Conservá el cambio previo sin commit de docs/plan-entrega-final.md y no lo incluyas ni lo alteres. Implementá solo GL-15; no avances GL-14 ni cambies openspec/config.yaml.

Respetá estos criterios:
- Formulario en la ficha, usando Turbo Frames y los patrones de Rails que ya tiene el proyecto; sin JavaScript propio ni dependencias nuevas. Sin Turbo, el enlace y el formulario deben funcionar como páginas normales.
- Al abrirlo, la fecha se precarga con la fecha actual según la zona horaria de la aplicación y se puede editar.
- Después de guardar, volver a la ficha con el aviso «Feedback guardado como lista.». El aviso solo confirma el guardado: no incluye el contenido del feedback ni datos que identifiquen a la persona.
- «Cancelar» vuelve a la ficha sin guardar.
- «Guardar borrador» permite dejar señal y dimensión vacías. «Guardar como lista» las requiere.
- Un estado desconocido debe dar error de validación, no convertirse silenciosamente en borrador.
- «Captura rápida» conserva su jerarquía actual; «+ Feedback» es una acción secundaria.
- No cambies el delta de GL-14: la tarea 4.4 de GL-15 deja registrado que se ajustará cuando corresponda.

No ejecutes pruebas ni CI en esta etapa. No hagas stage, commit, push, PR, merge, deploy ni archive.

Al terminar, informá los archivos modificados, el diff, qué criterios implementaste y cualquier criterio que no hayas podido cumplir. Incluí el estado final de Git y los comandos de prueba recomendados, sin ejecutarlos.
````

## Resultado registrado

**Numeración:** M325, por posición en la transcripción (opción A, decidida
por Pablo en M366).

GL-15 implementado en local: rutas `GET` y `POST
/personas/:person_id/entradas/completa`, acciones `new_complete` y
`create_complete`, concern `PersonPage`, vistas del formulario, parcial
`_entry_fields` compartido con la edición, «+ Feedback» en la ficha y
estilos. Pruebas escritas sin ejecutar, como pedía el pedido. Desvío
registrado: salida del frame con `data-turbo-frame="_top"` en lugar de
`turbo-visit-control` (diseño, sección 8). El aviso de lista se
implementó como «Feedback guardado como lista. Solo vos podés verlo.»,
corregido en M326. Sin commit.
