# GL-08. Datos ficticios reproducibles para desarrollo

> Quinto ticket de la entrega 2 de Growth Log. Lugar en la secuencia:
> [plan de la entrega 2](../plan-entrega-2.md). Cambio de OpenSpec:
> [`gl-08-datos-ficticios`](../../openspec/changes/gl-08-datos-ficticios/proposal.md).
> **Estado (03/11/2026): planificado, sin implementar.** P-6, P-13 y P-14
> aprobadas.

## Problema

GL-03 creó personas y asignaciones sin interfaz, y las invitaciones y la
administración (GL-04) están diferidas. Para recorrer la aplicación en
desarrollo con varios líderes y comprobar a mano el aislamiento hace falta
un conjunto de datos ficticios que se pueda preparar siempre igual, sin
credenciales versionadas y sin tocar otros registros.

## Decisión P-6 (aprobada el 03/11/2026)

- Una tarea explícita de preparación de datos ficticios, habilitada solo en
  `development`.
- Cuentas, personas y asignaciones suficientes para recorrer la aplicación
  con distintos líderes y comprobar aislamiento.
- Sin contraseñas ni hashes fijos versionados.
- Contraseñas ingresadas sin eco, o generadas y entregadas por un mecanismo
  local que no las exponga en logs, capturas ni salidas del agente.
- Ningún dato se crea al arrancar la aplicación ni al ejecutar migraciones.

## Alcance

1. Tarea `bin/rails growth_log:datos_ficticios`, solo en desarrollo, que
   crea el conjunto ficticio que falte y no modifica nada existente.
2. Tabla `sample_data_records` (P-13) que identifica exclusivamente los
   registros creados por la tarea, con restricciones que impiden claves
   duplicadas y referencias ambiguas, para no adoptar cuentas ajenas por
   coincidencia de correo.
3. Tarea `bin/rails growth_log:contrasena_ficticia` (P-14), solo en
   desarrollo y solo para cuentas del conjunto ficticio: Pablo establece la
   contraseña, pedida dos veces sin eco, sin argumentos ni variables de
   entorno.
4. Modificación explícita de la spec `initial-administrator` para admitir
   esas cuentas ficticias.
5. Guía de desarrollo actualizada.

## Exclusiones

- Entradas de feedback (GL-06), invitaciones y administración (GL-04),
  pantallas, despliegue.
- Datos en los seeds, al arrancar la aplicación o en las migraciones.
- Borrar registros o un «reset»: repetir la tarea nunca lo requiere.
- Cuentas administradoras en el conjunto ficticio: la administradora se
  sigue creando con `growth_log:crear_administrador` (GL-02).
- Datos de las pruebas automatizadas: siguen en las ayudas de `spec/`.

## Datos propuestos

Correos en el dominio reservado `ficticio.example.test`; ninguna cuenta es
administradora. El detalle y los casos están en el
[diseño](../../openspec/changes/gl-08-datos-ficticios/design.md#datos-propuestos).

| Cuenta | Estado | Asignaciones activas | Caso |
|---|---|---|---|
| Elena Boceto | activa | Ada, Bruno, Darío (inactiva) | líder con varias personas; comparte a Ada |
| Tomás Borrador | activa | Ada, Carla | segundo líder de Ada |
| Inés Muestra | activa | ninguna | líder sin asignaciones (1.16) |
| Raúl Pasado | activa | ninguna; terminada con Bruno | asignación terminada (P-7) |
| Delia Inactiva | **desactivada** | Ada | cuenta desactivada con asignación (P-9) |

| Persona | Estado | Líderes activos |
|---|---|---|
| Ada Ejemplo | activa | Elena, Tomás (y Delia, desactivada) |
| Bruno Ejemplo | activa | Elena |
| Carla Ejemplo | activa | Tomás |
| Darío Ejemplo | **inactiva** | Elena |
| Eva Ejemplo | activa | ninguno |

## Criterios de aceptación

| # | Criterio | Origen |
|---|---|---|
| D1 | Fuera de `development` las dos tareas se niegan antes de consultar la base y terminan con error, comprobado también con procesos reales (`RAILS_ENV=test` y `production`) sobre una base de pruebas aislada; ni los seeds, ni las migraciones, ni el arranque de la aplicación crean datos ficticios | P-6 |
| D2 | En desarrollo y sobre una base sin el conjunto, la tarea crea exactamente las 5 cuentas, 5 personas y 7 asignaciones propuestas, con sus marcas | P-6 |
| D3 | Una segunda ejecución no crea, modifica ni borra nada: contraseñas, roles, estados, nombres y fechas quedan como estaban, también si se cambiaron a mano entre ejecuciones; no reactiva cuentas desactivadas ni asignaciones terminadas, ni crea otra asignación para un par marcado | P-6 |
| D4 | Si existe una cuenta con un correo del conjunto sin la marca de la tarea, o una asignación activa del mismo par sin marca, la tarea no adopta ni modifica nada, termina con error y no escribe ningún registro | P-13 |
| D12 | La base rechaza marcas con clave duplicada, sin referencia, con varias referencias, con un tipo distinto del de su clave o para un registro ya marcado, e impide borrar un registro marcado | P-13 |
| D13 | Un conflicto o un error a mitad de la creación revierte toda la operación: no queda ningún registro ni marca de esa ejecución | P-13 |
| D5 | Dos ejecuciones simultáneas dejan un solo conjunto | P-6 |
| D6 | Cada cuenta ficticia se crea con una contraseña aleatoria de 48 caracteres que no se guarda ni se muestra: la cuenta queda activa (salvo la desactivada) y solo admitiría esa contraseña, que nadie conoce; el hash cambia en cada creación; ninguna contraseña ni hash está versionado; la salida no muestra contraseñas | P-6, P-14, AM-5 |
| D7 | `contrasena_ficticia` establece la contraseña de una cuenta del conjunto pedida dos veces sin eco, con la política de D-GL02-3, y elimina todas sus sesiones; no cambia estado, rol ni nombre: la cuenta desactivada sigue desactivada y su inicio de sesión se rechaza; se niega para cuentas fuera del conjunto (incluida la administradora), correos desconocidos y fuera de desarrollo, también en un proceso real; nunca lee la contraseña de argumentos ni variables; la salida no la contiene | P-6, P-14, GL-02 |
| D8 | `crear_administrador` sigue funcionando igual antes y después del conjunto ficticio, y sus pruebas pasan sin modificarse tras extraer la lectura sin eco | GL-02 |
| D9 | Con el conjunto creado, el alcance de personas de GL-03 da: Elena, Ada y Bruno; Tomás, Ada y Carla; Inés, Raúl y la administradora, ninguna; Darío no aparece para nadie; Delia no puede iniciar sesión | GL-03, P-7, P-9 |
| D10 | La spec `initial-administrator` se modifica de forma explícita para admitir las cuentas ficticias | C1 del plan |
| D11 | `bin/ci` y el CI remoto pasan | GL-01 |

## Qué no comprueba GL-08

Que Elena y Tomás compartan a Ada **no** les da acceso al feedback del
otro: eso se comprueba en **GL-06**, con entradas reales, en la matriz de
privacidad del plan. GL-08 solo deja preparado el caso para recorrerlo a
mano.

## Dependencias

GL-03 cerrado (`092b548`). P-6, P-13 y P-14 aprobadas (03/11/2026).

## Relación con la entrega

Sustituye, solo para desarrollo y con datos ficticios, la carga de cuentas,
personas y asignaciones que en el MVP completo hace la administración
(GL-04). No habilita datos reales.
