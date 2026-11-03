# Design

## Context

Desde GL-03 existen `people` y `assignments`, sin interfaz. GL-05 a GL-07
se recorren con varios líderes, pero no hay forma de crear cuentas, personas
ni asignaciones salvo la consola. GL-02 dejó una única forma de crear
cuentas: `growth_log:crear_administrador`, con la contraseña pedida sin eco.
Los seeds de desarrollo (`db/seeds/development.rb`) están vacíos y
`bin/rails db:prepare` los ejecuta al crear la base.

P-6, aprobada por Pablo el 03/11/2026: tarea explícita solo en
`development`; datos suficientes para varios líderes y aislamiento; sin
contraseñas ni hashes fijos versionados; contraseñas sin eco o generadas y
entregadas por un mecanismo local que no las exponga; nada al arrancar ni
al migrar.

## Goals / Non-Goals

**Goals:**
- Un conjunto ficticio reproducible, que se puede volver a ejecutar sin
  duplicar, sin sobrescribir y sin borrar.
- Ningún registro ajeno adoptado o modificado.
- Credenciales que nunca pasan por el repositorio, la salida ni el agente.
- El procedimiento de administrador inicial intacto.

**Non-Goals:**
- Entradas de feedback, invitaciones, administración, pantallas, despliegue.
- Reset, borrado o reparación automática de datos.
- Datos de las pruebas automatizadas.

## Datos propuestos

Dominio reservado `ficticio.example.test` (subdominio de `example.test`,
RFC 2606), distinto del que usan las pruebas. Ninguna cuenta es
administradora. Cada elemento tiene una clave estable, que es la marca.

**Cuentas** (líderes; cada una con una contraseña inicial aleatoria y
descartada, decisión 5):

| Clave | Correo | Nombre | Estado | Caso que representa |
|---|---|---|---|---|
| `account:elena` | `elena.boceto@ficticio.example.test` | Elena Boceto | activa | líder con varias personas; comparte a Ada con Tomás; asignada a una persona inactiva |
| `account:tomas` | `tomas.borrador@ficticio.example.test` | Tomás Borrador | activa | segundo líder de Ada; aislamiento frente a Elena (GL-06) |
| `account:ines` | `ines.muestra@ficticio.example.test` | Inés Muestra | activa | líder sin asignaciones: mensaje vacío (1.16) y denegación |
| `account:raul` | `raul.pasado@ficticio.example.test` | Raúl Pasado | activa | asignación terminada: sin acceso a la persona (P-7) |
| `account:delia` | `delia.inactiva@ficticio.example.test` | Delia Inactiva | **desactivada** | cuenta desactivada con asignación activa: no inicia sesión (GL-02, P-9) |

**Personas:**

| Clave | Nombre | Rol | Equipo | Estado | Caso |
|---|---|---|---|---|---|
| `person:ada` | Ada Ejemplo | Desarrolladora | Equipo Faro | activa | varios líderes |
| `person:bruno` | Bruno Ejemplo | Analista | Equipo Faro | activa | un solo líder; asignación terminada de otro |
| `person:carla` | Carla Ejemplo | Diseñadora | Equipo Brújula | activa | líder distinto de Ada |
| `person:dario` | Darío Ejemplo | Desarrollador | Equipo Brújula | **inactiva** | ficha 404 con asignación activa (P-9) |
| `person:eva` | Eva Ejemplo | QA | Equipo Faro | activa | sin líderes: nadie la ve |

**Asignaciones** (fechas relativas a la primera ejecución):

| Clave | Líder | Persona | Inicio | Fin |
|---|---|---|---|---|
| `assignment:elena/ada` | Elena | Ada | hace 60 días | — |
| `assignment:tomas/ada` | Tomás | Ada | hace 45 días | — |
| `assignment:elena/bruno` | Elena | Bruno | hace 60 días | — |
| `assignment:tomas/carla` | Tomás | Carla | hace 45 días | — |
| `assignment:elena/dario` | Elena | Darío | hace 30 días | — |
| `assignment:raul/bruno` | Raúl | Bruno | hace 90 días | hace 20 días |
| `assignment:delia/ada` | Delia | Ada | hace 90 días | — |

**Alcance esperado de personas (GL-03):** Elena → Ada y Bruno; Tomás → Ada
y Carla; Inés, Raúl y cualquier administradora → ninguna; Delia → Ada, pero
no puede iniciar sesión; Darío y Eva no aparecen para nadie.

La administradora no es parte del conjunto: se crea con
`growth_log:crear_administrador`, antes o después, y queda sin
asignaciones, que es el caso «administradora sin acceso» (PP-8).

## Decisions

### 1. Una tarea, no los seeds

`bin/rails db:prepare` ejecuta los seeds al crear la base, así que poner los
datos allí los crearía al preparar el entorno. La tarea
`growth_log:datos_ficticios` es la única entrada. `DevelopmentSeeds.run`
sigue vacío; su comentario, que hoy invita a agregar datos «cuando existan
los modelos», se cambia para remitir a la tarea. Ningún initializer ni
migración la invoca.

### 2. Solo en desarrollo

`DevelopmentSampleData.new(env: Rails.env)` comprueba `env.development?`
antes de abrir una transacción o consultar la base; si no, la tarea imprime
el motivo y termina con código 1. Lo mismo hace `contrasena_ficticia`.

Dos niveles de prueba:

- **Unitario:** se inyecta el entorno para ejercitar la creación dentro de
  la base de test, en transacciones que se revierten.
- **Proceso real:** se ejecutan `bin/rails growth_log:datos_ficticios` y
  `bin/rails growth_log:contrasena_ficticia` como procesos propios con
  `RAILS_ENV=test` y con `RAILS_ENV=production`, conectados a la base de
  test (una base de pruebas aislada, no la de desarrollo). En producción la
  conexión se dirige a esa base con `DATABASE_URL` y la contraseña local
  por variable de entorno, sin imprimirla, y `SECRET_KEY_BASE_DUMMY=1`. Se
  comprueba el código de salida, el mensaje y que la base no cambió. Una
  mutación que quita la comprobación de entorno tiene que hacer fallar
  estas pruebas.

### 3. Marcas: tabla `sample_data_records` (P-13, aprobada el 03/11/2026)

Identifica exclusivamente los registros que creó la tarea. Para que no haya
claves duplicadas ni referencias ambiguas, cada tipo tiene su propia
referencia con clave foránea, en lugar de un par genérico tipo e id:

| Columna | Tipo | Restricción |
|---|---|---|
| `key` | texto | obligatoria, **única** |
| `user_id` | referencia a `users` | clave foránea; **única** |
| `person_id` | referencia a `people` | clave foránea; **única** |
| `assignment_id` | referencia a `assignments` | clave foránea; **única** |
| `created_at` | fecha | obligatoria |

Restricciones de comprobación:

- exactamente una de las tres referencias está presente
  (`num_nonnulls(user_id, person_id, assignment_id) = 1`);
- el prefijo de la clave coincide con la referencia: `account:` con
  `user_id`, `person:` con `person_id`, `assignment:` con `assignment_id`.

Las claves foráneas impiden borrar un registro marcado (borrado
restringido) y que una marca apunte a un registro inexistente: no puede
haber marcas huérfanas. Este diseño reemplaza al par `record_type` y
`record_id` de la versión anterior, que no podía garantizar la integridad
referencial.

Frente a las alternativas:

| Opción | Problema |
|---|---|
| Columna `sample_data_key` en `users`, `people` y `assignments` | mete un concepto de desarrollo en el modelo del dominio |
| Par genérico `record_type` y `record_id` | sin clave foránea: admite marcas huérfanas y tipos que no coinciden |
| Sin marcas, reconociendo por correo | no distingue una cuenta propia de una ajena con el mismo correo: adoptaría cuentas |
| Archivo local con los ids | se desincroniza con la base y no sirve si cambia la base |

La tabla existe en todos los entornos porque viene de una migración, pero
solo la llena la tarea, que solo corre en desarrollo.

### 4. Algoritmo y conflictos

Todo en **una sola transacción** con `pg_advisory_xact_lock` sobre una
clave fija (como `crear_administrador`), para que dos ejecuciones
simultáneas se serialicen. Un conflicto o cualquier error, también a mitad
de la creación, revierte la transacción completa: no quedan registros ni
marcas de esa ejecución.

1. Cargar las marcas existentes.
2. **Revisar antes de escribir.** Conflicto, y la tarea termina sin
   escribir nada, si:
   - falta la marca de una cuenta y ya existe una cuenta con ese correo;
   - falta la marca de una asignación y ya existe una asignación activa del
     mismo par.

   Una marca huérfana no puede existir (claves foráneas, decisión 3).
3. Crear, en orden, las personas, las cuentas y las asignaciones que no
   tienen marca, y su marca.
4. Nunca se actualiza un registro marcado: ni contraseña, rol, estado,
   nombre o fechas. Lo que alguien cambió a mano se conserva. **No se
   reactiva nada:** una cuenta desactivada sigue así; una asignación
   marcada que alguien terminó sigue terminada, y como su marca existe, no
   se crea otra para ese par.
5. Informar cada clave como «creada» o «ya existía»; en conflicto,
   informar la clave y el correo, sin otros datos de la cuenta ajena.

No hay reparación automática: un conflicto se resuelve a mano. Repetir la
tarea nunca requiere borrar datos.

### 5. Credenciales (P-14, aprobada el 03/11/2026)

**Contraseñas establecidas por Pablo con `contrasena_ficticia`, sin eco,
sin argumentos ni variables de entorno.**

**Comportamiento exacto de la contraseña inicial.** La tarea de datos crea
cada cuenta con `SecureRandom.base58(48)` como contraseña, que no se
guarda, no se muestra y se descarta; en la base solo queda su hash bcrypt,
distinto en cada ejecución. **Eso no deshabilita la cuenta:** las cuentas
quedan activas (salvo Delia, creada desactivada) y aceptarían iniciar
sesión con esa contraseña, que nadie conoce. Adivinarla exigiría acertar
una cadena aleatoria de 48 caracteres base58, con los límites de intentos
de GL-02 activos. No se afirma que sea imposible, solo que no hay ninguna
copia de la contraseña. Ninguna contraseña ni hash está versionado.
- `bin/rails growth_log:contrasena_ficticia EMAIL=elena.boceto@ficticio.example.test`
  pide la contraseña dos veces con el mismo mecanismo que
  `crear_administrador`: sin eco en una terminal; de la entrada estándar
  sin terminal; nunca de argumentos ni variables. Aplica D-GL02-3 y se
  niega fuera de desarrollo, para correos desconocidos y para cuentas sin
  marca (incluidas las administradoras). La salida solo dice si se cambió.
- **Sesiones y estado.** En una sola transacción cambia el hash y elimina
  **todas** las filas de `sessions` de la cuenta, así que cualquier cookie
  anterior deja de valer en la siguiente petición (como el cierre de sesión
  de GL-02). No toca `deactivated_at`, `admin` ni el nombre: una cuenta
  desactivada sigue desactivada, y el inicio de sesión con la contraseña
  nueva se rechaza con el mismo 422 genérico de GL-02. Si la contraseña no
  coincide o no cumple la política, no cambian ni la contraseña ni las
  sesiones.
- La lectura sin eco se extrae de `InitialAdministratorCommand` a un
  componente común (`SecretPrompt`), sin cambiar su comportamiento: las
  pruebas de GL-02 tienen que seguir pasando sin modificarse.

**Alternativa no recomendada:** generar las contraseñas y escribirlas en un
archivo local ignorado con permisos 0600. Deja un secreto en disco y
cualquier lectura del archivo, también por un agente, lo expone.

**Regla para el agente:** el agente no ejecuta `contrasena_ficticia` con
una contraseña que vea o pase por la salida de la sesión. Las pruebas
automatizadas la ejercitan con entradas en memoria y contraseñas generadas
que nunca se imprimen. El inicio de sesión manual con una cuenta ficticia
lo hace Pablo, en su terminal (con `! bin/rails ...` si es desde la
sesión, porque la contraseña se escribe sin eco).

### 6. Administrador inicial

`crear_administrador` no cambia. Como ninguna cuenta ficticia es
administradora, su regla «solo si no hay un administrador activo» sigue
igual. La spec `initial-administrator` se modifica de forma explícita:

- «Repositorio sin credenciales»: siguen prohibidas las contraseñas y los
  hashes; las únicas cuentas predefinidas son las del conjunto ficticio,
  con correos `ficticio.example.test`, sin rol de administrador y sin
  contraseña.
- «Solo para una instalación sin administradores»: nuevo escenario, con
  solo cuentas ficticias el procedimiento crea el administrador.

La aceptación de GL-02 «los seeds no crean cuentas» (A13) sigue siendo
cierta: los seeds no cambian.

### 7. Aislamiento entre líderes de la misma persona

GL-08 deja el caso preparado (Elena y Tomás con Ada) y comprueba solo que
el alcance de personas de GL-03 los incluye a los dos (D9). **Que ninguno
acceda al feedback del otro se comprueba en GL-06**, con entradas reales y
la matriz de privacidad del plan (sección 7): detalle, edición, marcar
como lista y URL directa, borrador y entrada lista. Con el conjunto
ficticio se puede recorrer a mano después de GL-06; no reemplaza esas
pruebas.

### 8. Datos de las pruebas automatizadas

Separados de la tarea:

- Las pruebas siguen creando sus datos con las ayudas de `spec/support`
  (`create_user`, `create_person`, `assign`), con correos `@example.test`
  y contraseñas generadas en cada ejemplo, dentro de transacciones.
- La suite no ejecuta la tarea en desarrollo ni carga el conjunto en la
  base de test salvo en las pruebas propias de GL-08, que inyectan el
  entorno y se revierten.
- El CI no ejecuta la tarea.

## Estrategia de pruebas

| Archivo | Qué prueba | Criterios |
|---|---|---|
| `spec/models/sample_data_record_spec.rb` | clave duplicada, sin referencia, con dos referencias, prefijo que no coincide, registro ya marcado, borrar un registro marcado: la base lo rechaza | D12 |
| `spec/services/development_sample_data_spec.rb` | con entorno de desarrollo inyectado: crea exactamente el conjunto y sus marcas; ninguna administradora; segunda ejecución sin escrituras (comparando atributos y `updated_at`); cambios manuales conservados, sin reactivar cuentas ni asignaciones; conflictos (correo ajeno, asignación activa sin marca) sin escrituras; error a mitad: reversión completa; con entornos de test y producción inyectados, se niega sin escribir; hash distinto entre dos creaciones; alcance de GL-03 sobre el conjunto | D2 a D4, D6, D9, D13 |
| `spec/tasks/sample_data_process_spec.rb` | procesos reales `bin/rails growth_log:datos_ficticios` y `contrasena_ficticia` con `RAILS_ENV=test` y `production` sobre la base de test: código 1, mensaje y base sin cambios | D1, D7 |
| `spec/services/development_sample_data_concurrency_spec.rb` | dos ejecuciones simultáneas con conexiones distintas, la segunda bloqueada por el bloqueo consultivo hasta que la primera confirma: un solo conjunto | D5 |
| `spec/tasks/datos_ficticios_spec.rb` | la tarea de Rake en el entorno de test se niega con código 1 y no escribe; la salida no contiene contraseñas; `DevelopmentSeeds.run` no crea registros | D1, D6 |
| `spec/tasks/contrasena_ficticia_spec.rb` | cuenta activa del conjunto: cambia la contraseña, elimina sus sesiones y una cookie anterior deja de valer; cuenta desactivada: cambia la contraseña, elimina sesiones, sigue desactivada y el inicio de sesión se rechaza; contraseñas distintas o cortas sin cambios; cuenta sin marca, administradora y correo desconocido; nunca desde variables; salida sin la contraseña | D7 |
| `spec/tasks/crear_administrador_spec.rb` (sin cambios) y un ejemplo nuevo | GL-02 sigue pasando; con solo cuentas ficticias, crea el administrador | D8, D10 |
| `git grep` documentado | sin contraseñas ni hashes en el repositorio | D6 |

Mutaciones previstas, con copia de seguridad y restauración comprobada:

1. sin la comprobación de entorno: fallan la prueba unitaria de entornos y
   la de proceso real;
2. actualizar registros marcados en la segunda ejecución: falla la prueba
   de repetición;
3. reconocer cuentas por correo en lugar de por marca: falla la prueba de
   conflicto;
4. sin el bloqueo consultivo: falla la prueba de concurrencia;
5. permitir cuentas sin marca en `contrasena_ficticia`: falla su prueba.

## Registro de evidencia

Ejecutado en local el 03/11/2026 sobre la base `5025694`. Evidencias en el
directorio local de evidencias de GL-08, fuera del repositorio. **Remoto:
pendiente** hasta un push autorizado.

| Criterio | Estado | Evidencia |
|---|---|---|
| D1 | Comprobado (local) | `development_sample_data_spec`: con entornos test y producción inyectados, 0 consultas SQL y 0 escrituras. `sample_data_process_spec` (3): procesos reales `bin/rails growth_log:datos_ficticios` con `RAILS_ENV=test` y `RAILS_ENV=production` (dirigido a la base de test con `DATABASE_URL`) y `contrasena_ficticia` con `RAILS_ENV=test`: código 1, mensaje de negativa y base sin cambios. `datos_ficticios_spec`: `DevelopmentSeeds.run` no crea registros; ningún archivo de `config/` ni `db/` invoca la tarea |
| D2 | Comprobado (local) | 5 cuentas, 5 personas, 7 asignaciones y 17 marcas con los datos del diseño |
| D3 | Comprobado (local) | segunda ejecución una hora después sin cambios en ningún atributo ni `updated_at`; cambios manuales (contraseña, nombre, desactivación, persona inactiva, asignación terminada) conservados; no se reactiva nada ni se crea otra asignación para el par terminado; solo se crea lo que no tiene marca |
| D4 | Comprobado (local) | correo ajeno: conflicto, la cuenta ajena intacta y 0 registros creados; asignación activa sin marca: conflicto y base sin cambios |
| D5 | Comprobado (local) | `development_sample_data_concurrency_spec`, 5 de 5 corridas: la segunda ejecución espera el bloqueo consultivo (comprobado en `pg_stat_activity`) y no crea nada; queda un solo conjunto |
| D6 | Comprobado (local) | hash distinto entre dos creaciones; una contraseña de prueba no autentica; la salida no contiene ninguna de las contraseñas generadas; `git grep --untracked` sin contraseñas literales ni hashes bcrypt |
| D7 | Comprobado (local) | `contrasena_ficticia_spec` (9): cuenta activa (cambia, sin mostrar la contraseña, sin cambiar rol ni nombre); una cookie anterior deja de valer; Delia: cambia la contraseña, elimina sus sesiones, sigue desactivada y su inicio de sesión responde 422; contraseñas distintas o cortas sin cambios; cuenta ajena, administradora y correo desconocido rechazados; variables de entorno ignoradas; negativa fuera de desarrollo |
| D8 | Comprobado (local) | `crear_administrador_spec` de GL-02 sin modificar: 9 ejemplos en verde tras extraer `SecretPrompt`; con solo cuentas ficticias crea el administrador sin cambiarlas |
| D9 | Comprobado (local) | alcance de GL-03 sobre el conjunto, en la prueba y en la base de desarrollo |
| D10 | Hecho | delta `MODIFIED` de `initial-administrator` |
| D11 | Comprobado (local); **pendiente (remota)** | `bin/ci` código 0: 87 archivos sin infracciones, sin avisos (base `a58f1d0`), importmap limpio, Brakeman 0 advertencias, RSpec 164 ejemplos y 0 fallos (120 previos + 44 de GL-08). `openspec validate --all --strict`: 14 de 14. Base de test vacía al terminar |
| D12 | Comprobado (local) | `sample_data_record_spec` (9): clave duplicada, sin referencia, dos referencias, prefijo incoherente, registro ya marcado, sin clave, referencia inexistente y borrado de un registro marcado rechazados por la base |
| D13 | Comprobado (local) | error simulado en la tercera asignación: 0 cuentas, personas, asignaciones y marcas |

**Mutaciones** (copia de seguridad, restauración y hash idéntico en cada
caso):

| Mutación | Resultado |
|---|---|
| 1. Sin la comprobación de entorno | 4 fallos: las dos pruebas unitarias de entorno y los dos procesos reales de `datos_ficticios` |
| 2. Actualizar personas marcadas al repetir | 1 fallo: cambios manuales conservados |
| 3. Reconocer cuentas por correo y adoptarlas | 1 fallo: conflicto por correo ajeno |
| 4. Sin el bloqueo consultivo | 1 fallo: la segunda ejecución no esperó |
| 5. Contraseña para cualquier cuenta | 1 fallo: cuenta ajena y administradora |

**Base local de desarrollo** (autorizado por Pablo): antes no tenía
registros en `users`, `sessions`, `people`, `assignments`,
`sample_data_records` ni `login_attempt_counters`. La migración de
`sample_data_records` se aplicó antes de la huella; solo crea la tabla.
Primera ejecución: 17 creados, código 0. Segunda: 0 creados y 17
existentes, código 0; las filas de la primera ejecución quedaron idénticas
(hash por tabla) y ninguna tabla cambió de cantidad. No se establecieron
contraseñas ni se mostraron credenciales.

**Límites de lo comprobado:**

- El aislamiento del feedback entre Elena y Tomás **no está comprobado**:
  no hay entradas hasta GL-06.
- La entrada sin eco en una terminal real no se ejercitó en GL-08: usa el
  mismo componente que `crear_administrador`, comprobado en GL-02 con una
  pseudoterminal. Las pruebas usan entradas en memoria.
- El inicio de sesión manual con una cuenta ficticia queda para Pablo,
  después de establecer su contraseña.

**Desvíos e incidencias:**

- `datos_ficticios_spec` tuvo dos ajustes antes de registrar su fallo
  esperado: requerir `db/seeds/development.rb`, que no se carga solo, y
  buscar invocaciones de la tarea en lugar de menciones (el comentario de
  la migración la nombra).
- La primera ejecución del guion de mutaciones no aplicó ninguna (zsh no
  separa una variable en palabras) y la segunda falló en 2 a 4 por los
  `\n` de `echo`; en ambos casos los archivos quedaron con hash idéntico.
  Se repitieron con una función y heredocs literales.
- El ejemplo nuevo de `crear_administrador` está en un archivo aparte, para
  no modificar las pruebas de GL-02.

## Risks / Trade-offs

- **Tabla de marcas en todos los entornos** → vacía fuera de desarrollo;
  documentada como herramienta de desarrollo.
- **Conflicto que bloquea la tarea** → es la protección contra adopciones;
  el mensaje indica qué clave y qué correo lo causan.
- **Fechas relativas a la primera ejecución** → al no actualizarse, se
  alejan con el tiempo; no afecta los casos.
- **Cuentas ficticias en una base que después recibe datos reales** →
  la tarea no corre fuera de desarrollo, y cargar datos reales sigue
  bloqueado por GL-04, I7, I8 e I9.

## Migration Plan

Una migración reversible sin datos (`sample_data_records`); se comprueba la
reversión en la base de test. Ejecutar la tarea en la base de desarrollo
es un paso manual de Pablo, fuera de este cambio.

## Open Questions

Ninguna. P-13 y P-14 aprobadas el 03/11/2026, con las precisiones de
Pablo: comportamiento exacto de la contraseña descartada, marcas sin
ambigüedad, reversión completa, sin reactivar, sesiones al cambiar la
contraseña y prueba de entorno en procesos reales.
