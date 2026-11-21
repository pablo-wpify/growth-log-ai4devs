# M397. Autorización para actualizar Ruby a 4.0.10

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-14` (entrega final) |
| Tipo | verificación (autorización de dependencia) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `29676b09d0859b15e79b5983373bc40833de186a42ba1f640b671dae88fc08e2` |
| Fecha y hora (UTC) | 2026-11-21 16:14:55 |

## Texto original

````text
Autorizo actualizar Ruby a 4.0.10 para que la versión de Brakeman requerida por bin/ci pueda ejecutarse.

Limitá el cambio al ajuste de .ruby-version y a los cambios de lockfile estrictamente necesarios. No actualices otras dependencias. Prepará el entorno local con esa versión y volvé a ejecutar bin/ci.

Dejá la tarea 3.2 abierta salvo que bin/ci termine con código 0. Registrá el cambio y el resultado en design.md y tasks.md. Si la instalación o la actualización requiere cambios adicionales de alcance, detenete y mostrame el diff antes de aplicarlos.

No hagas stage, commit, push, PR, merge, deploy ni archive. Mantené abierto el grupo 4.
````

## Resultado registrado

**Numeración:** M397, por posición en la transcripción (opción A, decidida
por Pablo en M366). Es el mensaje siguiente a M396.

Detenido antes de cambiar Ruby, como pedía el texto: la actualización
necesita más alcance que `.ruby-version` y el lockfile. `.tool-versions`
también declara 4.0.9; la spec vigente `runtime-toolchain` exige Ruby
4.0.9 y que los dos archivos coincidan; y las definiciones de
`ruby-build` instaladas llegan hasta 4.0.9, así que instalar 4.0.10
requiere actualizar el plugin de Ruby de asdf. Se mostró a Pablo el diff
propuesto. Sin cambios en Ruby, en el entorno ni en las tareas.
