# M14. Aprobación de decisiones e implementación de GL-02

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-02` |
| Tipo | aprobación e implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `40ed26ec73065cb795489e59c53d390af96241d4cede30b60f249aeac238eb46` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M14 | 2026-11-02 22:15:00 |

## Texto original

````text
Apruebo la propuesta de GL-02 y las decisiones D-GL02-1 a D-GL02-7, junto con email_address y la página de inicio provisoria.

Antes de implementar, precisá en los artefactos:

- El límite por correo puede ser utilizado para impedir temporalmente el acceso de otra persona. No lo presentes como una solución que elimina ese riesgo.
- Definí si los límites cuentan intentos totales o solo fallidos y cuándo se reinician. Aplicá la normalización del correo también a sus claves.
- Usá un almacén compartido entre procesos para los límites; documentá su configuración local y de producción.
- Precisá cómo se actualiza la última actividad y cómo se comprueban los dos vencimientos en el servidor.
- Las pruebas deben verificar el comportamiento genérico ante correo desconocido, contraseña incorrecta y cuenta desactivada, sin afirmar que una prueba funcional demuestra igualdad de tiempos.
- La prueba de protección de rutas debe comprobar rechazo o redirección antes de ejecutar acciones protegidas, sin provocar efectos secundarios.
- Las comparaciones con Devise y OAuth son alternativas descartadas para este alcance, no incompatibilidades generales.

Después implementá gl-02-autenticacion siguiendo SDD y los artefactos actualizados.

Incluí pruebas de:
- autenticación válida e inválida y normalización del correo;
- contraseñas fuera de los límites, incluyendo caracteres multibyte;
- protección CSRF y atributos de la cookie;
- vencimiento por inactividad y absoluto;
- invalidación al cerrar sesión y al desactivar una cuenta;
- límites de intentos y recuperación al vencer la ventana;
- creación del administrador inicial, repetición y concurrencia;
- protección de rutas y ausencia de registro y recuperación públicos.

No adelantes invitaciones, asignaciones ni políticas de recursos.

Ejecutá las comprobaciones del ticket y bin/ci. Registrá lo ejecutado y lo pendiente, sin atribuir verificaciones remotas a pruebas locales.

Guardá la planificación aprobada y la implementación en commits locales separados. Revisá el staging por nombre y evitá secretos, contraseñas y datos reales en código, pruebas y salidas.

No hagas push, PR, despliegues ni archivado del cambio. No modifiques la entrega 1 ni otros repositorios.

Terminá con commits, resultados, estado del árbol, limitaciones y el siguiente paso para verificarlo en GitHub.
````

## Resultado registrado (no forma parte del pedido)

Commits [`2286d62`](https://github.com/pablo-wpify/growth-log-ai4devs/commit/2286d62) y [`9fa7a5b`](https://github.com/pablo-wpify/growth-log-ai4devs/commit/9fa7a5b).
