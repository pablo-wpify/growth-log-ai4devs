# M25. Planificar GL-08 mediante SDD

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-08` |
| Tipo | pedido de planificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `10ada85c83a580586d0deb22607946e6382915e7d8273cbc0d5ac96c1ccb33c5` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M25 | 2026-11-03 09:55:57 |

## Texto original

````text
Prepará GL-08 mediante SDD, sin implementar todavía.

Trabajá en ~/code/ai4devs-entrega-1-pp, rama feature/entrega-2-pp. Confirmá el estado actual antes de escribir.

Apruebo P-6 con este alcance:
- Una tarea explícita de preparación de datos ficticios, habilitada solo en development.
- Cuentas, personas y asignaciones suficientes para recorrer la aplicación con distintos líderes y comprobar aislamiento.
- Sin contraseñas ni hashes fijos versionados.
- Contraseñas ingresadas sin eco o generadas y entregadas mediante un mecanismo local que no las exponga en logs, capturas ni salidas del agente.
- No crear datos automáticamente al arrancar la aplicación ni al ejecutar migraciones.

Prepará ticket, propuesta OpenSpec, specs, diseño y tareas.

Precisá:
1. Qué cuentas, personas y asignaciones se crean y qué casos representa cada una.
2. Cómo se ejecuta dos veces sin duplicar registros ni sobrescribir contraseñas, roles o datos existentes.
3. Cómo se distingue el conjunto ficticio de otros registros, sin adoptar cuentas existentes por coincidencia de correo.
4. Cómo se impide su ejecución fuera de development.
5. Cómo se conserva el procedimiento de administrador inicial de GL-02 y qué modificación explícita requiere su spec para permitir estas cuentas ficticias.
6. Cómo se verificará que dos líderes asignados a la misma persona no obtienen por eso acceso al feedback del otro. Esa comprobación sobre entradas queda para GL-06.
7. Cómo se prepararán los datos de pruebas automatizadas, separados de esta tarea de desarrollo.

No agregues entradas de feedback, invitaciones, pantallas administrativas ni despliegue. No borres registros ni propongas un reset como requisito para repetir la tarea.

Validá los artefactos. No implementes código, ejecutes la tarea, cambies bases, instales dependencias ni hagas commits o push.

Terminá con los datos propuestos, el manejo de credenciales, los criterios de aceptación y cualquier decisión pendiente.
````

## Resultado registrado (no forma parte del pedido)

Planificación sin commit en este paso; versionada en [`5025694`](https://github.com/pablo-wpify/growth-log-ai4devs/commit/5025694).
