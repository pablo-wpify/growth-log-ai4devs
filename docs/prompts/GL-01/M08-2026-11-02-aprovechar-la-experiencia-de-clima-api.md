# M08. Aprovechar la experiencia de clima-api

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-01` |
| Tipo | pedido de planificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `23a44b01f446c9ad686047d49b19896a74c4a0897ecd92835a16daea79b327c5` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M08 | 2026-11-02 20:40:08 |

## Texto original

````text
Para GL-01, aprovechá también la experiencia de ~/code/clima-api, solo por lectura y sin modificar ese repositorio.

Revisá su configuración de Ruby/Rails, asdf, Bundler, RSpec y CI, junto con las especificaciones y verificaciones correspondientes. Comparala con la base del ensayo.

Proponé reutilizar las prácticas que correspondan a Growth Log, justificando las diferencias: Clima API no tiene base de datos y Growth Log necesita PostgreSQL e interfaz.

No actualices versiones automáticamente ni copies configuraciones completas. Mostrá las versiones exactas y señalá cualquier diferencia entre .tool-versions, .ruby-version, Gemfile, lockfile y CI. Proponé cómo mantenerlas coherentes.

Incorporá las comprobaciones aplicables a los criterios de aceptación de GL-01. Distinguí lo comprobado anteriormente en Clima de lo que todavía debemos ejecutar en Growth Log.
````

## Resultado registrado (no forma parte del pedido)

Ajustes del ticket y los artefactos de GL-01, sin commit en este paso; versionados en [`d117a35`](https://github.com/pablo-wpify/growth-log-ai4devs/commit/d117a35).
