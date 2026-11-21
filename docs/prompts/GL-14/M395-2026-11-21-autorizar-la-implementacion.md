# M395. Autorización para implementar GL-14 (tarea 0.6)

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-14` (entrega final) |
| Tipo | implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `094c09c70c08906f2c9b6391bf5f750fc238b395e531dd45c01746b4faea7246` |
| Fecha y hora (UTC) | 2026-11-21 15:53:33 |

## Texto original

````text
Autorizo explícitamente la tarea 0.6 de GL-14 e iniciar su implementación local, siguiendo el orden de tasks.md.

Primero verificá la rama, el HEAD y el estado de Git. El commit documental esperado es 0662e70; no pierdas ni sobrescribas cambios ajenos.

Trabajá en los grupos 1 a 3:
1. Escribí primero las pruebas de peticiones y de sistema previstas en tasks.md.
2. Ejecutalas y registrá que fallen por las razones esperadas.
3. Implementá el comportamiento de GL-14 para que pasen.
4. Ejecutá las verificaciones locales previstas en el grupo 3 y registrá resultados y desvíos en design.md.

No empieces el grupo 4: no hagas commit, push, PR, merge, archivo ni deploy. No cambies GL-13 ni otros cambios fuera del alcance aprobado de GL-14. Mantené la 0.6 registrada como autorización para implementar y dejá abiertas las tareas que no estén cubiertas por evidencia. Al final, mostrame el diff y el estado de Git.
````

## Resultado registrado

**Numeración:** M395, por posición en la transcripción (opción A, decidida
por Pablo en M366).

Tarea 0.6 marcada como autorización para los grupos 1 a 3. Pruebas
escritas primero: 62 ejemplos y 41 fallos por la razón esperada. GL-14
implementado en local: consulta agregada, helper, vista, controlador
Stimulus y estilos. Suite completa con 463 ejemplos y 0 fallos.
`bin/ci` en código 1 solo por la versión de Brakeman (8.1.0 frente a
8.1.1), sin advertencias de seguridad. Desvío: un ajuste no previsto en
`spec/requests/people_spec.rb`. Quedan abiertas la 3.1, la 3.2, la 3.3 y
el grupo 4 (diseño, sección 7). Sin commit.
