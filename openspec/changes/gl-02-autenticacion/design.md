# Design

## Context

Ver `proposal.md` y el ticket. Estado de partida en `feature/entrega-2-pp`
(`39d18c3`), observado por lectura y con `bin/rails routes` y
`bin/rails runner`:

- Rails 8.1.4 con `load_defaults 8.1`, ERB, Turbo y Stimulus por
  importmap, PostgreSQL 18.6, RSpec; sin modelos ni migraciones.
- `ApplicationController` solo tiene `allow_browser versions: :modern` y
  `stale_when_importmap_changes`. No hay ruta raíz.
- `bcrypt` está comentada en el `Gemfile` (`~> 3.1.7`); la última versión
  publicada es 3.1.22 (18/03/2026). No hay Devise, OmniAuth ni Rack::Attack.
- CSRF activo por defecto: `default_protect_from_forgery`, tokens por
  formulario y comprobación de origen. En test,
  `allow_forgery_protection` es `false`.
- Sesión de Rails en `CookieStore`; cookies `SameSite=Lax`. En producción,
  `force_ssl` y `assume_ssl`: cookies con `Secure` y HSTS.
- `filter_parameters` ya filtra `:passw` y `:email`.
- Caché: `MemoryStore` en desarrollo, `NullStore` en test y `FileStore`
  (`tmp/cache`) en producción. Puma corre un proceso con 3 hilos.
- Rutas que hoy responden sin pasar por `ApplicationController`: `GET /up`
  (`Rails::HealthController`), tres rutas de navegación nativa de Turbo
  (`Turbo::Native::NavigationController`) y Action Cable montado en
  `/cable`, sin canales.
- El generador `bin/rails generate authentication` de Rails 8.1.4 crea
  `User` (`email_address`, `password_digest`, `has_secure_password`),
  `Session` (`user`, `ip_address`, `user_agent`), `Current`, el concern
  `Authentication`, `SessionsController` con
  `rate_limit to: 10, within: 3.minutes`, recuperación de contraseña
  (`PasswordsController`, mailer y rutas) y la conexión de Action Cable.
  La cookie `session_id` es firmada, `httponly`, `same_site: :lax` y
  **permanente**, y la sesión del servidor **no vence**.

## Goals / Non-Goals

**Goals:**
- Identificar a la persona en cada petición con el menor código propio
  posible y todo lo sensible cubierto por pruebas.
- Cerrar por defecto todas las rutas del producto.
- Dejar el modelo de cuentas listo para invitaciones (GL-04) y
  desactivación (I7) sin implementarlas.

**Non-Goals:**
- Autorización sobre recursos (GL-03): GL-02 solo expone `Current.user`;
  no hay comprobaciones de `admin?` en controladores.
- Invitaciones, establecer contraseña por enlace, asignaciones (GL-04).
- Desactivar cuentas y proteger al último administrador (I7).
- Recuperación de contraseña, recordarme, MFA, bloqueo de cuentas.

## ADR-2: alternativas contrastadas con la base actual

**Aprobada: D-GL02-1** (02/11/2026). Devise y OAuth no son incompatibles con
Growth Log en general: se descartan **para este alcance** por las razones de
la tabla, comparadas con la base actual y con las decisiones D1 y AM-1 a
AM-5.

| Criterio (Anexo D) | Devise | Generador de Rails 8.1.4 | Proveedor externo (OAuth) |
|---|---|---|---|
| Dependencias nuevas | `devise`, `warden`, `orm_adapter`, `responders`, `bcrypt`; para invitaciones, además `devise_invitable` | solo `bcrypt` | gema de OmniAuth por proveedor, más una cuenta y configuración en el proveedor |
| Sesiones invalidables en el servidor (AM-2) | no por defecto: la sesión vive en la cookie de Warden; hay que agregar una comprobación por petición | sí: tabla `sessions`; borrar la fila invalida la sesión | depende del proveedor; la sesión local sigue siendo propia |
| Vencimiento | módulo `timeoutable` | hay que agregarlo (pocas líneas, con pruebas) | hay que agregarlo |
| Límite de intentos | `lockable` bloquea la cuenta (abre la puerta a bloquear cuentas ajenas) | `rate_limit` de Rails por IP; se suma uno por correo | lo maneja el proveedor |
| Invitaciones de un solo uso (AM-5, GL-04) | `devise_invitable` | `generates_token_for` de Active Record, sin gemas | no aplica: el alta la hace el proveedor |
| Código propio sensible | poco, pero mucha configuración y comportamiento implícito | el del generador pasa a ser nuestro: unas 100 líneas legibles y probadas | poco en la aplicación; dependencia externa en un dato sensible |
| Encaje con la base | trae vistas y controladores propios que hay que adaptar a ERB y Hotwire | genera exactamente el estilo de la base (Rails 8.1.4, ERB, Hotwire) | exige que cada líder tenga cuenta en un proveedor elegido; para este alcance, el alta por invitación de AM-5 queda más simple con cuentas propias |

**Elección: el generador de Rails 8.1.4, adaptado (D-GL02-1).** Es la
opción con menos dependencias, encaja con la base generada en GL-01 y su
sesión en el servidor resuelve AM-2 sin trucos. Las invitaciones de GL-04
se pueden construir con `generates_token_for` sin otra gema.

**Costes que asumimos:**
- El código del generador pasa a ser nuestro: vencimiento, cuenta activa,
  limitación por correo y procedimiento de administrador son código propio y
  necesitan pruebas (las cubre la estrategia de abajo).
- Sin bloqueo de cuentas ni MFA de fábrica; quedan como mejoras.
- Una dependencia nueva, `bcrypt`, con extensión nativa (compila al
  instalar; requiere compilador en la máquina y en el CI).
- Cuando haya que actualizar el comportamiento, no viene en una gema: se
  revisan las notas de Rails.

## Decisions

1. **Generar y recortar (D-GL02-1).** Ejecutar
   `bin/rails generate authentication` y revisar el diff. Se eliminan la
   recuperación de contraseña (`PasswordsController`, `PasswordsMailer`,
   sus vistas y `resources :passwords`) y la conexión de Action Cable. Se
   conserva el nombre de columna `email_address` del generador: el modelo
   del README es orientativo y los nombres pueden cambiar.
2. **Modelo de cuentas.** `users`: `email_address` (único, normalizado),
   `name`, `password_digest`, `admin` (booleano, falso por defecto) y
   `deactivated_at` (nulo = activa). `admin` existe para que la tarea del
   administrador inicial lo marque; GL-02 no lo usa para autorizar.
3. **Almacenamiento de contraseñas.** `has_secure_password` con bcrypt
   (coste 12 fuera de test, el mínimo en test por velocidad). El máximo de
   72 bytes ya lo valida `has_secure_password`; se agrega el mínimo de 15
   caracteres (D-GL02-3). `User.authenticate_by` evalúa el hash aunque el
   correo no exista, lo que reduce la diferencia de tiempos entre «correo
   desconocido» y «contraseña incorrecta».
4. **Sesiones y vencimiento (D-GL02-2).** `sessions`: `user_id`,
   `ip_address`, `user_agent`, `created_at` y `last_active_at` (no nulo,
   igual a `created_at` al crearla). En cada petición, `resume_session`
   busca la fila por el identificador de la cookie firmada y, con
   `now = Time.current`, la rechaza si se cumple cualquiera de estas
   condiciones:
   - inactividad: `last_active_at <= now - 2.hours`;
   - máximo absoluto: `created_at <= now - 12.hours`;
   - cuenta desactivada: `user.deactivated_at` no es nulo.

   Al rechazarla borra la fila, borra la cookie y trata la petición como sin
   sesión. Si la acepta y `last_active_at <= now - 5.minutes`, ejecuta un
   único `UPDATE` de `last_active_at` (`update_column`, sin callbacks ni
   cambio de `updated_at`). Consecuencia documentada: como la actividad se
   registra con una granularidad de 5 minutos, una sesión puede vencer por
   inactividad entre 1 h 55 min y 2 h después de su última petición. Los
   dos vencimientos se calculan en el servidor con los datos de la fila; el
   vencimiento de la cookie (12 h) es solo una ayuda para el navegador. La
   cookie `session_id` está firmada, es `httponly`, `same_site: :lax`,
   `secure` cuando la petición es HTTPS (en producción, siempre, por
   `assume_ssl` y `force_ssl`) y vence a las 12 horas. Rails firma el
   vencimiento junto con el valor: una cookie reenviada después de las 12
   horas se rechaza por la firma, aunque alguien la haya conservado. Como en
   ese caso el servidor no sabe a qué fila correspondía, la fila se borra
   cuando la cuenta inicia una nueva sesión (`user.sessions.expired`). Las
   filas de cuentas que no vuelven a entrar quedan hasta una limpieza
   periódica, que es una mejora posterior; no sirven para entrar.
5. **Inicio de sesión.** Ante éxito, `reset_session` (descarta la sesión
   anónima de Rails y evita la fijación), crea la fila de `sessions` y
   redirige con 303. Ante cualquier fallo vuelve a mostrar el formulario
   con estado 422 y el mensaje «Correo o contraseña incorrectos.», también
   para cuentas desactivadas. Solo se guarda la URL de retorno para
   peticiones `GET`.
6. **Cierre de sesión.** `DELETE /session` desde un botón con token CSRF:
   borra la fila, borra la cookie, `reset_session` y redirige con 303 al
   inicio de sesión.
7. **CSRF.** Se mantienen los valores por defecto de Rails (token por
   formulario y comprobación de origen); el inicio de sesión también lleva
   token, lo que evita forzar a alguien a entrar con una cuenta ajena. Una
   prueba activa `allow_forgery_protection` y comprueba el rechazo.
8. **Limitación de intentos (D-GL02-4).** Dos límites en
   `SessionsController#create`, evaluados antes de buscar la cuenta o
   comparar la contraseña:
   - **Por IP:** `rate_limit` de Rails, 10 cada 3 minutos. Cuenta **todos**
     los intentos, exitosos o fallidos. La clave usa el SHA-256 de
     `request.remote_ip`, no la IP en claro.
   - **Por correo:** contador propio, 5 **intentos fallidos** cada 15
     minutos, estricto también con peticiones simultáneas. Cada intento
     **reserva** un lugar con un incremento atómico antes de buscar la
     cuenta o comparar la contraseña; solo se evalúan las credenciales si la
     reserva queda dentro del límite (valor 5 o menor). Un intento fallido
     conserva su reserva, que es el fallo contado; un inicio de sesión
     exitoso borra el contador de su correo. La clave usa el SHA-256 del
     correo normalizado con la misma regla que `User` (sin espacios
     alrededor y en minúsculas), así que las variantes cuentan juntas.
     La primera versión implementada comprobaba el contador, evaluaba y
     recién después contaba el fallo: con 8 peticiones simultáneas, las 8
     llegaban a evaluar credenciales. Se corrigió antes de publicar.
   - **Por IP:** `rate_limit` incrementa y después compara, sobre el mismo
     incremento atómico, así que también es estricto bajo concurrencia.

   **Ventanas:** fijas. Empiezan con el primer intento contado y se
   reinician cuando vencen. Al superar cualquiera de los dos límites, estado
   429 y «Demasiados intentos. Probá de nuevo en unos minutos.». No se
   bloquean cuentas.

   **Riesgo que no se elimina:** quien conozca el correo de una persona
   puede provocar 5 fallos y dejarla sin poder entrar durante 15 minutos,
   repetidamente. El límite reduce el riesgo de adivinar contraseñas a costa
   de ese otro riesgo. Mitigaciones posteriores posibles: aviso al
   administrador, MFA o una vía de acceso alternativa.

   **Almacén compartido: tabla `login_attempt_counters` de PostgreSQL**
   (`key` como clave primaria, `count`, `expires_at`), usada a través de
   `LoginAttemptStore`, que ofrece la parte de la interfaz de
   `ActiveSupport::Cache` que usan `rate_limit` y el contador por correo. El
   incremento es un único `INSERT … ON CONFLICT DO UPDATE … RETURNING`:
   atómico entre procesos y también entre instancias. Si la fila venció, el
   mismo `UPSERT` reinicia el conteo y la ventana. Cada incremento borra
   antes las filas vencidas (índice en `expires_at`), así que la tabla no
   crece sin límite.
   - **Local y test:** la misma tabla en `growth_log_development` y
     `growth_log_test`; en test, cada ejemplo la deja vacía al revertir su
     transacción.
   - **Producción:** la misma tabla en la base de producción; no depende
     del disco de la instancia ni de un caché.

   **Cambio respecto del diseño aprobado:** la propuesta original usaba un
   `FileStore` en `tmp/rate_limits`. La prueba con procesos reales lo
   refutó: con 4 procesos y 100 incrementos, el contador terminó en 58 y
   en 50. `FileStore` bloquea con `flock` el archivo de la clave, pero
   escribe con un archivo temporal y renombrado, así que los procesos
   terminan bloqueando archivos distintos. La tabla cumple el requisito
   aprobado («almacén compartido entre procesos») sin dependencias nuevas;
   la prueba entre procesos pasó 5 de 5 veces.

   Con un proxy delante, `remote_ip` depende de declarar los proxies de
   confianza (ADR-7).
9. **Rutas protegidas.** `include Authentication` en
   `ApplicationController`: todo controlador que herede exige sesión
   mediante un `before_action` que redirige antes de la acción. Excepciones
   declaradas: `SessionsController#new` y `#create`, y `GET /up`, que no
   hereda de `ApplicationController`. Se desactivan las rutas de navegación
   nativa de Turbo (`config.turbo.draw_routes = false`) y no se monta Action
   Cable (`config.action_cable.mount_path = nil`) (D-GL02-7). La prueba de
   rutas recorre `Rails.application.routes`, reemplaza los segmentos
   dinámicos por valores ficticios y, para cada ruta fuera de las
   excepciones, hace la petición sin sesión con la acción del controlador
   reemplazada por un doble que falla si se ejecuta; comprueba la
   redirección al inicio de sesión y que el número de filas de `users` y
   `sessions` no cambió.
10. **Página de inicio.** `root` a una página mínima que muestra «Sesión
    iniciada como <nombre>» y el botón «Cerrar sesión». No es la vista de
    «Personas» (GL-05).
11. **Administrador inicial (D-GL02-6).** Tarea
    `bin/rails growth_log:crear_administrador`. Correo y nombre se piden
    por la terminal o se pasan como `EMAIL` y `NOMBRE` (no son secretos).
    La contraseña se pide dos veces sin eco con `IO.console.getpass`; sin
    terminal (pruebas, automatización) se lee de la entrada estándar, nunca
    de argumentos ni variables de entorno. La lógica vive en un servicio
    probado; la creación ocurre en una transacción con un bloqueo
    `pg_advisory_xact_lock` para que dos ejecuciones simultáneas no creen
    dos administradores. Funciona en cualquier entorno; los seeds no crean
    cuentas.
12. **Logs.** `filter_parameters` ya cubre `password`,
    `password_confirmation` y `email_address`; una prueba lo comprueba.

## Imprescindible en GL-02 y mejoras posteriores

| Imprescindible (este ticket) | Mejora posterior |
|---|---|
| cuentas con hash bcrypt y política de longitud | lista de contraseñas comprometidas |
| inicio y cierre de sesión con mensaje genérico | «cerrar todas mis sesiones» y listado de sesiones |
| sesión en servidor con vencimiento por inactividad y absoluto | «recordarme» |
| límite por IP y por correo | límite delante de la aplicación (proxy), según ADR-7 |
| rechazo de cuentas desactivadas | acción de desactivar e invalidar (I7) |
| CSRF y rotación del identificador | registro de inicios de sesión |
| rutas cerradas por defecto con prueba de recorrido | MFA |
| administrador inicial por tarea | recuperación de contraseña |
| | CSP y demás controles de E4 |

## Estrategia de pruebas

Datos ficticios (`ana.admin@example.test`, `luis.lider@example.test`) y
contraseñas generadas con `SecureRandom` en cada prueba; ninguna contraseña
literal reutilizable. Las pruebas de errores comprueban que el estado, el
mensaje y la ausencia de sesión son iguales en los tres casos; **no
demuestran igualdad de tiempos**, que no se mide en este ticket.

| Prueba | Tipo | Escenarios |
|---|---|---|
| `spec/models/user_spec.rb` | modelo | correo normalizado (espacios y mayúsculas) y único sin distinguir mayúsculas; nombre obligatorio; 14 caracteres rechazado y 15 aceptado, también con caracteres multibyte (`ñ`, emoji); más de 72 bytes rechazado aunque tenga menos de 72 caracteres; `password_digest` bcrypt distinto de la contraseña; `active?` |
| `spec/models/session_spec.rb` | modelo | vencida por inactividad y por máximo absoluto, en los bordes, con `travel_to` |
| `spec/requests/sessions_spec.rb` | peticiones | credenciales válidas, también con el correo en mayúsculas y con espacios; contraseña incorrecta, correo desconocido y cuenta desactivada con el mismo estado, mensaje y sin fila nueva; vuelta a la página pedida; cierre de sesión y reenvío de la cookie; rotación de la cookie de sesión anónima; atributos de la cookie por HTTPS |
| `spec/requests/session_expiry_spec.rb` | peticiones | renovación de la actividad pasados 5 minutos; inactividad; máximo absoluto con actividad constante; cuenta desactivada con sesión abierta: redirección y fila borrada |
| `spec/requests/rate_limit_spec.rb` | peticiones | 11.º intento por IP con credenciales válidas: 429; recuperación al vencer los 3 minutos; 6.º intento por correo tras 5 fallos desde IP distintas y con variantes de mayúsculas: 429; recuperación a los 15 minutos; reinicio del conteo tras un éxito; claves sin correo ni IP en claro |
| `spec/requests/csrf_spec.rb` | peticiones | con `allow_forgery_protection` activado: inicio y cierre de sesión sin token rechazados; el formulario incluye el token |
| `spec/requests/route_protection_spec.rb` | peticiones | recorre todas las rutas: sin sesión, redirigen antes de ejecutar la acción y sin efectos en la base, salvo las excepciones; no existen rutas de registro ni de contraseñas |
| `spec/requests/parameter_filtering_spec.rb` | peticiones | el log de un intento de inicio de sesión no contiene la contraseña |
| `spec/tasks/crear_administrador_spec.rb` | tarea y servicio | creación correcta con entrada simulada; contraseñas distintas; contraseña corta; repetición con un administrador ya activo; dos ejecuciones concurrentes en conexiones distintas crean un solo administrador; la salida no contiene la contraseña |

## Registro de evidencia

Directorio de evidencias: `~/growth-log-evidencias/gl-02.kEsYcV2c` (no versionado).
Todo lo de esta tabla se ejecutó en local el 02/11/2026; nada es remoto.

| Criterio | Estado | Resultado |
|---|---|---|
| A1 | Comprobado (local) | `route_protection_spec`: las 5 rutas declaradas; sin sesión, todas las que no son excepción redirigen antes de la acción (un doble falla si se ejecuta) y sin cambios en `users`, `sessions` ni `login_attempt_counters`. Antes de D-GL02-7 fallaba por `/cable` y las 3 rutas de Turbo. Mutación: con `allow_unauthenticated_access` en la página de inicio, la prueba falla con «GET / ejecutó HomeController#show sin sesión» |
| A2 | Comprobado (local) | `bin/rails routes` y `route_protection_spec`: sin rutas de registro ni de contraseñas |
| A3 | Comprobado (local) | `sessions_spec`: 303 a la página de inicio y una sesión; correo con mayúsculas y espacios; vuelta a la página pedida con `GET` y `HEAD` |
| A4 | Comprobado (local) | `sessions_spec`: contraseña incorrecta, correo desconocido y cuenta desactivada con el mismo estado (422), el mismo mensaje y sin sesión. No se mide ni se afirma igualdad de tiempos |
| A5 | Comprobado (local) | `email_limit_concurrency_spec`: 8 peticiones simultáneas reales para un correo, con la evaluación retenida en una barrera; solo 5 evalúan credenciales (422) y 3 reciben 429 sin evaluar, 5 de 5 corridas. Con la implementación anterior evaluaban las 8. `rate_limit_spec` (10 ejemplos): 11.º intento por IP, también contando éxitos; 6.º por correo desde IP distintas y con variantes; recuperación a los 3 y 15 minutos; reinicio tras un éxito; otras IP y correos no afectados; claves sin correo ni IP en claro. `rate_limit_store_spec`: 4 procesos × 25 incrementos = 100, 5 de 5 corridas (con `FileStore`: 58 y 50) |
| A6 | Comprobado (local) | `sessions_spec`: tras cerrar sesión no queda fila y la cookie reenviada redirige al inicio de sesión |
| A7 | Comprobado (local) | `session_spec` (bordes exactos) y `session_expiry_spec`: renovación solo pasados 5 min; 2 h sin actividad; cookie conservada rechazada a las 12 h; máximo absoluto por los datos guardados con cookie vigente; limpieza al iniciar sesión |
| A8 | Comprobado (local) | `session_expiry_spec`: cuenta desactivada con sesión abierta, redirección y fila borrada |
| A9 | Comprobado (local) | `csrf_spec` con la protección activada: inicio y cierre sin token, 422; el formulario incluye el token |
| A10 | Comprobado (local) | `sessions_spec`: cambia el identificador de la sesión anónima (mutación sin `reset_session`: falla); cookie `HttpOnly`, `SameSite=Lax`, `Secure` por HTTPS, vence a las 12 h; sin `Secure` por HTTP |
| A11 | Comprobado (local) | `user_spec`: hash `$2a$` sin la contraseña en ninguna columna; 14 y 15 caracteres, también con `ñ`; 72 bytes con emoji aceptado y 76 rechazado. `parameter_filtering_spec`: contraseña y correo filtrados. Log de desarrollo sin parámetros `password` sin filtrar |
| A12 | Comprobado (local) | `crear_administrador_spec` (9 ejemplos): creación, correo y nombre pedidos, contraseñas distintas, contraseña corta, sin lectura desde variables, repetición sin modificar cuentas, tarea de Rake, espera del bloqueo y negativa (mutación sin bloqueo: falla), dos ejecuciones simultáneas con un solo administrador. En una pseudoterminal real: 0 apariciones de la contraseña en la salida e inicio de sesión correcto contra el servidor local |
| A13 | Comprobado (local) | `git grep`: sin contraseñas literales reutilizables ni hashes fijos; seeds sin cuentas; la contraseña local de la base no aparece |
| A14 | Comprobado (local y remota) | `bin/ci` código 0: RuboCop sin infracciones, sin avisos (base `a58f1d0`), importmap limpio, Brakeman 0 advertencias, RSpec 73 ejemplos y 0 fallos (dos corridas); tras la corrección del límite por correo, 74 ejemplos y 0 fallos. Reversión de las 3 migraciones en test. `openspec validate --all --strict`. Remota: CI de GitHub [run 41551853981](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/41551853981) (evento `push`, SHA `9131b29bc590cf166866ee058aef9b68f516155d`), conclusión `success`; jobs `scan_ruby` (Brakeman 0 advertencias, bundler-audit sin avisos), `scan_js` (importmap sin paquetes vulnerables), `lint` y `test` (74 ejemplos, 0 fallos) en `success` |

**Desvíos e incidencias registrados:**
- Grupo 2: la primera corrida de `user_spec` falló por migraciones pendientes,
  no por una aserción concreta.
- Grupo 3: la página de inicio provisoria se implementó con este grupo
  porque las pruebas de vencimiento la necesitan.
- Almacén de los límites: `FileStore` reemplazado por PostgreSQL (decisión 8).
- Brakeman señaló confusión de verbo (`request.get?` sin `HEAD`): se corrigió
  el código y se agregó una prueba; no se ignoró la advertencia.
- Tarea 7.3: el primer intento pasó la contraseña por tubería antes de que
  la tarea desactivara el eco; la terminal la repitió en la salida, y esa
  salida se mostró en la sesión de trabajo. La contraseña era aleatoria y
  exclusiva de una cuenta ficticia de desarrollo (`ana.admin@example.test`),
  que se eliminó. Se tachó en el archivo local de evidencia, lo que **no
  elimina su exposición histórica** en el registro de la sesión de trabajo.
  No se usó en ninguna otra cuenta ni sistema. La prueba se repitió con una
  contraseña nueva escrita solo después de cada pedido (0 apariciones); esa
  segunda cuenta también se eliminó, porque su contraseña no quedó guardada.
- La prueba de dos ejecuciones simultáneas sin coordinar pasa también sin el
  bloqueo (no fuerza la carrera); la garantía la da la prueba determinista.
- Límite por correo bajo concurrencia: la primera implementación no cumplía
  el máximo de 5 con peticiones simultáneas (evaluaba las 8); corregida con
  una reserva atómica y una prueba determinista, antes de publicar.

## Risks / Trade-offs

- [Código de autenticación propio] → pruebas por escenario y revisión del
  diff del generador antes de adaptarlo.
- [Una escritura en la base por intento de inicio de sesión] → aceptable
  para el volumen del MVP; con mucho tráfico, el límite podría moverse
  delante de la aplicación (ADR-7).
- [Reserva de un intento que falla por un error inesperado] → la reserva
  queda contada como fallo; el límite se vuelve más estricto, nunca más
  laxo.
- [Granularidad de la actividad] → la inactividad puede vencer hasta 5
  minutos antes de las 2 horas exactas; se documenta.
- [Límite por correo usado para impedir el acceso de otra persona] → **no se
  elimina**: quien conozca un correo puede impedir su acceso durante 15
  minutos, repetidamente. Se acepta para el MVP y queda como riesgo
  registrado; ver la decisión 8.
- [`bcrypt` con extensión nativa] → `bundle install` compila; el CI ya
  instala dependencias con `bundler-cache`.
- [Sesión de 12 horas como máximo] → obliga a iniciar sesión cada día;
  aceptable para datos sensibles de personas.
- [Desactivar Action Cable y las rutas de Turbo] → si más adelante hacen
  falta Turbo Streams por WebSocket, se vuelve a montar Action Cable con
  autenticación en la conexión, en su propio cambio.

## Migration Plan

Tres migraciones nuevas (`users`, `sessions`, `login_attempt_counters`),
reversibles; se prueban hacia atrás en la base de test. Sin datos que migrar.

## Open Questions

Ninguna. D-GL02-1 a D-GL02-7 aprobadas el 02/11/2026, junto con `email_address`
y la página de inicio provisoria.
