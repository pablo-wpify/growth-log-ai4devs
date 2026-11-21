# M396. Desvío de la 3.1, conformidad visual y actualización de Brakeman

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-14` (entrega final) |
| Tipo | verificación (conformidad y autorización de dependencia) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `bc804f43b7302451f7989064f8ccb8d2713f99f09068121b5bf39fe234343897` |
| Fecha y hora (UTC) | 2026-11-21 16:10:49 |

## Texto original

````text
Acepto el desvío de la tarea 3.1: en spec/requests/people_spec.rb, el selector a[data-person-link] es el ajuste necesario para que la ayuda identifique solo el enlace de la ficha, manteniendo las mismas expectativas. Registrá el desvío y marcá 3.1 completa con esa evidencia.

Mi revisión manual de las capturas a 1280 y 375 px es conforme. Registrala y marcá 3.3 completa.

Para la tarea 3.2, autorizo actualizar únicamente Brakeman de 8.1.0 a 8.1.1 y los cambios de lockfile estrictamente necesarios. Revisá el diff de dependencias y ejecutá bin/ci después de la actualización. Marcá 3.2 completa solo si bin/ci termina con código 0. Si requiere una actualización más amplia, detenete y reportá el motivo.

Actualizá el registro de GL-14 y el prompt correspondiente según CLAUDE.md. No marques tareas sin evidencia. No hagas stage, commit, push, PR, merge, deploy ni archive; dejá abierto el grupo 4 y no cambies GL-13.
````

## Resultado registrado

**Numeración:** M396, por posición en la transcripción (opción A, decidida
por Pablo en M366). Es el mensaje siguiente a M395; entre los dos no hay
otros pedidos.

Desvío de la 3.1 registrado y 3.1 marcada; conformidad visual de Pablo
registrada y 3.3 marcada. Brakeman actualizado de 8.1.0 a 8.1.1 (solo su
versión y su checksum en `Gemfile.lock`). `bin/ci` terminó con código 1:
Brakeman 8.1.1 marca Ruby 4.0.9 por CVE-2026-132825 y pide 4.0.10. Como
eso exige actualizar Ruby, el trabajo se detuvo y la 3.2 sigue abierta
(diseño, sección 7). Sin commit.
