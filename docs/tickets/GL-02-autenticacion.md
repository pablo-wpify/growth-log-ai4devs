# GL-02. Autenticación: sesión, administrador inicial y rutas protegidas

> Segundo ticket de la entrega 2 de Growth Log. Cambio de OpenSpec:
> [`gl-02-autenticacion`](../../openspec/changes/gl-02-autenticacion/proposal.md).
> **Estado (02/11/2026): implementado y verificado en local; pendiente el CI
> remoto (A14).** Resultados en el registro de evidencia del diseño.

## Problema

Después de GL-01 la aplicación arranca y responde `/up`, pero no identifica
a nadie: no hay cuentas, sesiones ni rutas protegidas. Todo lo que sigue en
el recorrido de la entrega 2 (invitar, ver personas, registrar feedback)
necesita saber quién hace cada petición.

## Origen

| Fuente | Qué exige |
|---|---|
| PP-1 ([Anexo A](../../anexos/anexo-a-historias.md#política-de-privacidad-y-criterios-que-la-aplican)) | cuentas individuales; sin contraseñas fijas ni enviadas en texto plano |
| D1 ([Anexo C](../../anexos/anexo-c-riesgos-decisiones.md#c2-decisiones-de-privacidad)) | la cuenta administradora inicial se provisiona con un procedimiento documentado, sin credenciales fijas en el repositorio |
| AM-5 ([Anexo C](../../anexos/anexo-c-riesgos-decisiones.md#c3-reglas-que-cierran-las-ambigüedades)) | sin contraseñas fijas ni en texto plano; alta del primer administrador documentada, sin secretos en el repositorio; las invitaciones son GL-04 |
| AM-2 y PP-7 | una cuenta desactivada no inicia sesión y sus sesiones dejan de valer (la acción de desactivar es posterior) |
| README §4, «Acceso a las rutas» | públicas solo el inicio de sesión y el chequeo de salud; sin registro público; el resto exige sesión con una cuenta activa, también por URL directa |
| README §2.5 | límite de intentos de inicio de sesión; HTTPS forzado; feedback y contraseñas fuera de los logs |
| [Anexo B](../../anexos/anexo-b-matriz-confiabilidad.md), capas 1 y 10 | límite de peticiones; política de contraseñas; invalidación de sesiones |
| [Anexo G](../../anexos/anexo-g-plan-incremental.md#g3-tareas-habilitadoras), E2 | sesión, cuenta administradora inicial por procedimiento documentado, sin registro público; «sin sesión, una ruta del producto no responde» |
| [Anexo D](../../anexos/anexo-d-decisiones-arquitectura.md), ADR-2 | elegir la biblioteca de autenticación |

D1 y AM-1 a AM-5 son decisiones aprobadas: este ticket las aplica y no las
reabre.

## Alcance

1. Cuentas individuales (`users`): correo único, nombre, contraseña con
   hash adaptativo, rol de administrador y estado activo.
2. Inicio de sesión con correo y contraseña; cierre de sesión.
3. Sesiones guardadas en el servidor, con vencimiento por inactividad y
   máximo absoluto, que se invalidan al cerrar sesión o al vencer.
4. Limitación de intentos de inicio de sesión.
5. Rutas del producto protegidas por defecto, con excepciones declaradas.
6. Un procedimiento reproducible para crear el primer administrador.
7. Una página de inicio mínima que confirma la sesión y permite cerrarla.

## Exclusiones

- Invitaciones, establecimiento de contraseña por enlace, asignaciones y
  vista de administración: **GL-04**.
- Políticas sobre recursos (qué puede hacer cada cuenta): **GL-03**.
  GL-02 identifica al usuario; no decide permisos.
- Acción de desactivar cuentas y protección del último administrador: I7.
- Recuperación de contraseña: mejora pendiente, fuera del alcance
  comprometido (README §1.2).
- E2E en navegador: ADR-6 sigue abierta.

## Recomendación para ADR-2

**Generador de autenticación de Rails 8.1.4, adaptado**, más la gema
`bcrypt` 3.1.22. Ver el análisis completo en el
[diseño](../../openspec/changes/gl-02-autenticacion/design.md).

## Decisiones aprobadas (02/11/2026)

Aprobadas por Pablo junto con el nombre de columna `email_address` y la
página de inicio provisoria.

| # | Decisión | Recomendación |
|---|---|---|
| D-GL02-1 | ADR-2: biblioteca de autenticación | generador de Rails 8.1.4 adaptado + `bcrypt` 3.1.22, sin recuperación de contraseña |
| D-GL02-2 | Vencimiento de sesiones | 2 horas de inactividad y 12 horas como máximo absoluto |
| D-GL02-3 | Política de contraseñas | mínimo 15 caracteres, máximo 72 bytes, sin reglas de composición |
| D-GL02-4 | Limitación de intentos | por IP, 10 intentos totales (exitosos o fallidos) en una ventana fija de 3 minutos; por correo normalizado, 5 intentos fallidos en una ventana fija de 15 minutos, reiniciada por un éxito; respuesta 429 genérica; sin bloqueo de cuentas; contadores en un almacén compartido entre procesos, con claves sin correo ni IP en claro. **El límite por correo no elimina el riesgo de que alguien impida temporalmente el acceso de otra persona**: lo acepta como contrapartida de frenar la adivinación de contraseñas |
| D-GL02-5 | Cuentas desactivadas | incluir ya `deactivated_at` y rechazar inicio de sesión y sesiones de cuentas desactivadas, sin la acción de desactivar |
| D-GL02-6 | Administrador inicial | tarea `bin/rails growth_log:crear_administrador`, con la contraseña pedida dos veces sin eco; solo si no hay administradores activos |
| D-GL02-7 | Superficie sin sesión | desactivar las rutas de navegación nativa de Turbo y no montar Action Cable (`/cable`), que hoy responden sin pasar por la autenticación |

## Criterios de aceptación

| # | Criterio | Origen |
|---|---|---|
| A1 | Sin sesión, cualquier ruta del producto redirige al inicio de sesión, también por URL directa; las únicas rutas accesibles sin sesión son `GET /up`, `GET /session/new` y `POST /session` | README §4; E2 |
| A2 | No existe ninguna ruta de registro público ni de recuperación de contraseña | PP-1; README §1.2 |
| A3 | Con correo y contraseña válidos de una cuenta activa, se crea una sesión en el servidor y se llega a la página de inicio | PP-1 |
| A4 | Con contraseña incorrecta, correo desconocido o cuenta desactivada, no se crea sesión y el estado y el mensaje son los mismos en los tres casos (no se afirma igualdad de tiempos) | README §2.5 |
| A5 | Superado cualquiera de los dos límites, la respuesta es 429 con un mensaje genérico, aunque las credenciales sean válidas; al vencer la ventana se puede volver a intentar; las variantes de un correo cuentan juntas | README §2.5; Anexo B capa 1 |
| A6 | Al cerrar sesión, la sesión del servidor se elimina y la cookie deja de servir, aunque se reenvíe | PP-1 |
| A7 | Una sesión vencida por inactividad (2 h) o por máximo absoluto (12 h) se rechaza y se elimina; ambos vencimientos se comprueban en el servidor | D-GL02-2 |
| A8 | La sesión de una cuenta desactivada se rechaza en la siguiente petición | AM-2, PP-7 |
| A9 | Una petición que modifica estado sin token CSRF válido se rechaza | README §2.5 |
| A10 | Al iniciar sesión cambia el identificador de sesión (sin fijación de sesión); la cookie es `HttpOnly`, `SameSite=Lax`, vence a las 12 h y es `Secure` por HTTPS | buena práctica |
| A11 | Las contraseñas se guardan solo como hash bcrypt y no aparecen en los logs ni en la base en texto plano | PP-1, AM-5 |
| A12 | La tarea de administrador inicial crea una cuenta administradora activa con la contraseña pedida sin eco; rechaza contraseñas que no cumplen la política o no coinciden; se niega si ya hay un administrador activo, y dos ejecuciones simultáneas crean uno solo | D1, AM-5 |
| A13 | El repositorio no contiene credenciales de ninguna cuenta; los seeds no crean cuentas | D1, AM-5 |
| A14 | `bin/ci` y el CI remoto pasan; `docs/desarrollo.md` documenta cómo crear el administrador inicial | GL-01 |

## Estrategia de pruebas

Detalle por archivo en el
[diseño](../../openspec/changes/gl-02-autenticacion/design.md#estrategia-de-pruebas).
Datos ficticios (`ana.admin@example.test`, `luis.lider@example.test`) y
contraseñas generadas en cada prueba.

| Tema | Qué se prueba | Criterios |
|---|---|---|
| Autenticación | credenciales válidas e inválidas; normalización del correo; mismo estado y mensaje en los tres fallos | A3, A4 |
| Contraseñas | 14 y 15 caracteres; más de 72 bytes; caracteres multibyte; hash bcrypt; filtrado en logs | A11 |
| CSRF y cookie | inicio y cierre sin token; atributos de la cookie por HTTPS; rotación del identificador | A9, A10 |
| Vencimiento | inactividad, máximo absoluto, renovación de la actividad | A7 |
| Invalidación | cierre de sesión y reenvío de la cookie; cuenta desactivada con sesión abierta | A6, A8 |
| Límites | por IP y por correo; recuperación al vencer la ventana; reinicio tras un éxito; claves sin datos en claro | A5 |
| Administrador inicial | creación, contraseñas distintas o cortas, repetición, concurrencia, salida sin contraseña | A12 |
| Rutas | rechazo antes de la acción y sin efectos; ausencia de registro y recuperación | A1, A2 |
| Repositorio y CI | sin credenciales ni cuentas en seeds; `bin/ci`; CI remoto | A13, A14 |

Sin pruebas de sistema en navegador: Capybara no está instalado y ADR-6
sigue abierta. Ninguna prueba demuestra igualdad de tiempos de respuesta.

## Dependencias

GL-01 cerrado (`39d18c3`). D-GL02-1 a D-GL02-7 aprobadas. Agrega la gema
`bcrypt`.

## Relación con la entrega

Tarea habilitadora E2 del Anexo G, más el límite de intentos de inicio de
sesión de E4. Primer paso del recorrido: «iniciar sesión».
