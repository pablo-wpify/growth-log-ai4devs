# M13. Planificar GL-02 mediante SDD

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-02` |
| Tipo | pedido de planificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `20f338335f4abfa459ec5db95e2fc59889792a734873d30a536c2f1d0b923b7d` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M13 | 2026-11-02 21:57:49 |

## Texto original

````text
Prepará GL-02 mediante SDD, sin implementar todavía.

Trabajá en ~/code/ai4devs-entrega-1-pp, rama feature/entrega-2-pp. Partí del estado actual, con GL-01 cerrado en 39d18c3.

Leé los requisitos vigentes y las decisiones aprobadas de la entrega 1 sobre autenticación, cuentas, administrador inicial e invitaciones. Conservá D1 y AM-1 a AM-5; no las reabras.

Prepará:
- Ticket local GL-02, con referencias a los requisitos de origen.
- Propuesta OpenSpec, especificaciones, diseño y tareas.
- Criterios de aceptación y estrategia de pruebas.

Alcance:
- Inicio y cierre de sesión con cuentas individuales.
- Sin registro público.
- Administrador inicial creado por un procedimiento reproducible, sin credenciales fijas en el código ni secretos versionados.
- Protección de las rutas del producto, declarando las excepciones necesarias.
- Las invitaciones y asignaciones corresponden a GL-04: no las adelantes.

Para resolver ADR-2:
- Contrastá las alternativas ya documentadas con la base Rails actual.
- Recomendá una opción concreta y explicá sus costes.
- Precisá almacenamiento de contraseñas, manejo y vencimiento de sesiones, cierre de sesión, protección CSRF, errores de autenticación y limitación de intentos.
- Separá las decisiones imprescindibles para este ticket de las mejoras posteriores.
- No agregues dependencias ni ejecutes generadores todavía.

Diferenciá autenticación de autorización: GL-02 identifica al usuario; las políticas sobre recursos se implementarán en GL-03.

Las pruebas propuestas deben cubrir acceso sin sesión, credenciales válidas e inválidas, cierre e invalidación de sesión, y creación segura del administrador inicial. Usá datos ficticios.

Validá los artefactos con OpenSpec. No hagas cambios de aplicación, migraciones, instalaciones, commits, push ni despliegues.

Terminá mostrando el alcance, la recomendación para ADR-2 y las decisiones concretas que necesiten mi aprobación antes de implementar.
````

## Resultado registrado (no forma parte del pedido)

Planificación sin commit en este paso; versionada en [`2286d62`](https://github.com/pablo-wpify/growth-log-ai4devs/commit/2286d62).
