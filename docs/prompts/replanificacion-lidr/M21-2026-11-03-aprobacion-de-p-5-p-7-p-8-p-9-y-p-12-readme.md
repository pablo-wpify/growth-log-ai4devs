# M21. Aprobación de P-5, P-7, P-8, P-9 y P-12; README, CLAUDE.md y cambio de GL-03

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `replanificacion-lidr` |
| Tipo | aprobación y planificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `90bac298ea35621b86e678fd3500968524e833428a1981364cf198c91fc77470` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M21 | 2026-11-03 01:38:44 |

## Texto original

````text
Apruebo:
- P-5: Pundit con denegación por defecto, carga por alcance y 404. Sus verificaciones detectan omisiones; las pruebas de comportamiento comprueban las reglas.
- P-7: conservar PP-9 y AM-1. La lectura propia no depende de una asignación activa; la escritura sí. El acceso desde la interfaz sin asignación queda explícitamente pendiente.
- P-8: una asignación activa por par líder/persona mediante índice único parcial.
- P-9: estados independientes de persona, asignación y cuenta. La ficha de una persona inactiva responde 404, conservando el permiso de lectura de las entradas propias.

Antes de implementar GL-03, terminemos la preparación documental:

1. Simplificá el README de esta rama:
   - explicación breve del producto y su recorrido;
   - estado actual, separando implementado y pendiente;
   - enlaces a desarrollo local, plan vigente, tickets y specs;
   - conservá accesibles los contenidos exigidos por la entrega y los antecedentes, sin duplicar el plan ni perder información.
   No modifiques la rama de entrega 1.

2. Apruebo P-12: creá CLAUDE.md breve con:
   - stack y comandos verificados;
   - ubicación del plan, tickets y specs vigentes;
   - flujo SDD y tests primero;
   - una tarea por vez;
   - privacidad, denegación por defecto y consultas con alcance;
   - distinción entre evidencia local y remota;
   - prohibición de registrar secretos o datos reales.
   Referenciá los requisitos en lugar de copiarlos. No amplíes permisos ni modifiques configuraciones personales.

3. Abrí el change OpenSpec de GL-03 con propuesta, specs, diseño y tareas a partir de las decisiones aprobadas.
   - Delimitá qué se verifica ahora y qué requiere las rutas de GL-05 y las entradas de GL-06.
   - No marques como comprobada la autorización del feedback con pruebas que todavía no usan entradas reales del producto.
   - No adelantes compartición ni interfaces administrativas.

Las demás propuestas siguen pendientes.

Validá los artefactos y los enlaces. No implementes código, instales gemas, ejecutes migraciones ni hagas commits o push todavía.

Mostrá el resumen del README, el contenido completo de CLAUDE.md y el alcance y criterios de aceptación de GL-03 para revisión.
````

## Resultado registrado (no forma parte del pedido)

README, `CLAUDE.md`, `propuesta-mvp.md` y cambio `gl-03-autorizacion-minima` sin commit en este paso; versionados en [`93b42ec`](https://github.com/pablo-wpify/growth-log-ai4devs/commit/93b42ec).
