# M239. Ajustes de redacción H1 a H7 del borrador de GL-11

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-11` |
| Tipo | corrección documental del borrador |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `0305ab48b902191b2ff11f9b2e5d4635922d61b6b8e314715f6cc25e9914ac71` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M239 | 2026-11-15 14:14:17 |

## Texto original

````text
Aplicá los ajustes de redacción H1 a H7 de la revisión de GL-11. Esta es una corrección documental del borrador; no autoriza implementación.

Antes de editar, confirmá rama, HEAD y estado de Git. Preservá los cambios existentes de GL-10 y GL-11. Si aparece algún cambio inesperado, detenete e informá. No leas ni muestres secretos ni valores de variables.

Decisiones:
- P-32 sigue pendiente: usar las pantallas internas como referencia, sin mock del login, es la recomendación, no una decisión aprobada por Pablo.
- El ancho sigue pendiente: recomendá `max-width: 24rem` y ancho fluido en pantallas menores; registralo como decisión separada en la sección 6 del plan, con el número siguiente disponible.
- No vincules la aprobación de implementar GL-11 con la aprobación de P-32 o del ancho.

Corregí:
1. Expresar explícitamente el ancho máximo y el comportamiento fluido en móvil; agregar el escenario de escritorio que lo compruebe.
2. Registrar la decisión del ancho en `docs/plan-entrega-2.md`.
3. Quitar cualquier frase que haga que aprobar GL-11 apruebe P-32 o el ancho.
4. Describir la comprobación de foco teniendo en cuenta `autofocus`; evitar criterios débiles como comprobar solo que el outline no sea `none`.
5. Atribuir correctamente a `people-browsing` el comportamiento de la cabecera cuando no hay sesión.
6. Reflejar el botón «Iniciar sesión» en la spec.
7. Añadir a las tareas una comprobación de que los estilos de las pantallas internas no cambien.

No cambies código, configuración, datos ni Render. No marques decisiones como aprobadas ni tareas de implementación como hechas. Registrá este pedido con el siguiente número disponible en `docs/prompts/` y actualizá `prompts.md`, sin reconstruir los mensajes que están marcados como no registrados.

No ejecutes pruebas, CI ni auditorías. Al terminar, ejecutá únicamente `openspec validate --all --strict` si el CLI está disponible. No hagas stage, commit, push, PR, merge ni archivo.

Entregá el diff completo, el resultado de validación y las decisiones que siguen pendientes. Dejá GL-11 sin implementar y esperando mi aprobación.
````

## Resultado registrado (no forma parte del pedido)

- **Estado previo:** rama `feature/entrega-2-pp`, HEAD `6177aef`, sin cambios staged. Los únicos cambios eran los de GL-10 (M237) y GL-11 (M236 y M238), sin alterar.
- **Ajustes aplicados al borrador de GL-11, sin implementar:**
  - **H1:** requisito «Ancho máximo del formulario»: `max-width: 24rem` con ancho fluido, y escenarios de escritorio (1280 px) y de pantalla angosta (375 px). Está en la spec, el diseño, CA2b del ticket y la tarea 1.2.
  - **H2:** P-33 (ancho del formulario) queda registrada como decisión separada en la sección 6 del plan, pendiente.
  - **H3:** se quitaron las frases que hacían que aprobar GL-11 aprobara P-32. P-32, P-33 y la aprobación para implementar quedan separadas (tareas 0.4, 0.4b y 0.5).
  - **H4:** el foco se comprueba con `autofocus` (el correo, activo al cargar) y con valores concretos del contorno: sólido, 3 px, color de foco y 2 px de separación. No basta con «no es `none`».
  - **H5:** la ausencia de cabecera sin sesión se atribuye a `people-browsing`.
  - **H6:** requisito propio «Botón "Iniciar sesión"», alineado con el borde izquierdo de los campos.
  - **H7:** tareas 1.3 y 3.1b, CA7 y la comprobación manual verifican que los estilos de las pantallas internas no cambien.
- **Validación:** `openspec validate --all --strict`, 20 de 20 válidos. No se ejecutaron pruebas, CI ni auditorías.
- **Pendiente:** P-32, P-33 y la aprobación de Pablo para implementar, por separado. Ninguna decisión se marcó como aprobada ni ninguna tarea de implementación como hecha.
- Sin código, configuración, datos ni Render. Sin stage, commit, push, PR, merge ni archivo. M218 a M235 siguen sin registrar.
