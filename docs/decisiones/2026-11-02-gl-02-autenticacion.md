# Decisiones de GL-02 (02/11/2026)

> Aprobadas por Pablo al aprobar la propuesta de
> [GL-02](../tickets/GL-02-autenticacion.md). Completan el borrador de ADR-2
> del [Anexo D](../../anexos/anexo-d-decisiones-arquitectura.md), que no se
> modifica.

| # | Decisión | Estado |
|---|---|---|
| ADR-2 (D-GL02-1) | Generador de autenticación de Rails 8.1.4, adaptado, con `bcrypt` 3.1.22. Sin recuperación de contraseña. Devise y OAuth se descartan **para este alcance**, no en general | aprobada |
| D-GL02-2 | Sesiones en el servidor: vencen tras 2 h sin actividad y a las 12 h; ambos vencimientos se comprueban en el servidor | aprobada |
| D-GL02-3 | Contraseñas de 15 caracteres a 72 bytes, sin reglas de composición | aprobada |
| D-GL02-4 | Límites: por IP, 10 intentos totales cada 3 min; por correo normalizado, 5 fallidos cada 15 min, reiniciados por un éxito; ventanas fijas; 429 genérico; sin bloqueo de cuentas. **No elimina** el riesgo de que alguien impida temporalmente el acceso de otra persona | aprobada |
| D-GL02-5 | `deactivated_at` incluido; cuentas desactivadas rechazadas al iniciar sesión y en sesiones abiertas | aprobada |
| D-GL02-6 | Tarea `growth_log:crear_administrador`, con bloqueo consultivo | aprobada |
| D-GL02-7 | Sin rutas nativas de Turbo ni Action Cable montado | aprobada |
| Supuestos | Columna `email_address`; página de inicio provisoria | aprobados |

**Cambio durante la implementación (02/11/2026):** el almacén de los
límites pasó de un `FileStore` en `tmp/rate_limits` a la tabla
`login_attempt_counters` de PostgreSQL. Una prueba con procesos reales
mostró que los incrementos de `FileStore` no son atómicos entre procesos
(58 y 50 de 100). La tabla cumple el requisito aprobado de un almacén
compartido entre procesos, sin dependencias nuevas.
