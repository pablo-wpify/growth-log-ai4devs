# Design

> **Borrador, implementación sin aprobar** (M212, actualizado en M213 y
> M214, 14/11/2026). En M214 Pablo decidió P-28, P-29 y P-31, la rama y el
> despliegue manual, y aceptó el conjunto demo. P-30 sigue pendiente. **La
> implementación espera la aprobación explícita de Pablo.**

## Context

- **Hasta ahora:** GL-09 cerró el hito «recorrido núcleo» y la entrega se
  revisa en local. Pablo pidió (M212) preparar una demo temporal en Render.
- **Estado declarado por Pablo (M212 y M213), no verificado por el agente:**
  - La base `growth-log-entrega-2-db` existe en Render Postgres Free, en
    Virginia, y fue **creada el 14/11/2026**. Con la regla de 30 días de
    Render, vence alrededor del 14/12/2026 y, después de 14 días de gracia,
    se borra alrededor del 28/12/2026. Render avisa por correo la fecha
    exacta.
  - El formulario del servicio web quedó sin enviar.
  - **Decidido en M214:** el servicio despliega `feature/entrega-2-pp`, con
    despliegue **manual** (sin despliegue automático).
  - Este diseño no incluye ni infiere credenciales, URLs de conexión ni
    valores de variables.
- **Lo que hay en el repositorio** (leído el 14/11/2026, sin cambios):
  - **Producción:**
    - `config/environments/production.rb` usa `assume_ssl` y `force_ssl`.
    - `config/database.yml` define una base de producción con
      `GROWTH_LOG_DATABASE_PASSWORD`; Rails combina `DATABASE_URL` si
      existe.
    - `config/credentials.yml.enc` está versionado y `config/master.key`
      no.
    - No hay `Dockerfile`, `render.yaml` ni script de build.
  - **GL-08:**
    - `DevelopmentSampleData` se niega fuera de `development` antes de
      consultar la base.
    - Las marcas están en `sample_data_records`, con referencias a cuenta,
      persona o asignación, sin entradas.
    - `db/seeds.rb` solo corre `DevelopmentSeeds` en desarrollo.

## Goals / Non-Goals

**Goals:**

- Que quien revise recorra el núcleo en una URL pública, con dos líderes
  ficticios de la misma persona, y vea la privacidad entre ellos.
- Una tarea demo explícita, idempotente y segura que solo escribe en la
  base dedicada.
- Conservar intacto GL-08.

**Non-Goals:**

- Datos reales y ADR-7 (despliegue y backups).
- Modo de solo lectura.
- Alcance diferido: invitaciones, administración, compartir, feed y
  filtros.
- Decidir cómo se comparten las credenciales (P-30).
- Cambiar Render desde el agente.

## Decisions

### 1. Demo editable con datos ficticios (P-27, decidida por Pablo en M212)

Quien revise usa la aplicación como un líder: puede capturar, completar y
marcar entradas. No hay modo de solo lectura. Las reglas de autorización y
privacidad no cambian.

Consecuencia: la base acumula lo que los revisores escriben. La tarea demo
debe tolerar esas entradas (sección 4).

### 2. Capability separada: `temporary-demo`

- La tarea de GL-08 y su spec no cambian: siguen siendo solo para
  `development`.
- La tarea demo es otra (`growth_log:datos_demo`), con otro servicio, otras
  marcas y otra guarda.
- Reusar la de GL-08 relajaría P-6 y su spec, y queda descartado.

### 3. Guarda de instancia (aprobada con P-28 en M214)

La tarea escribe solo si se cumplen las dos condiciones:

- `Rails.env.production?`;
- el indicador `GROWTH_LOG_DEMO_INSTANCE` tiene el valor exacto
  `growth-log-entrega-2`.

En `development` y `test` se niega aunque el indicador exista. Así nunca
toca una base local. La comprobación ocurre antes de consultar la base.
El indicador no es un secreto: se configura en el panel de Render junto con
las demás variables.

### 4. Base dedicada y registros ajenos (propuesta)

Después de la guarda y dentro de la transacción, la tarea revisa la base.
Termina con error, sin escribir nada, si encuentra:

- una cuenta, una persona o una asignación sin marca demo;
- una entrada sin marca demo cuyo autor no es una cuenta demo.

Son ajenos los registros que no creó la tarea y que no pudo crear un revisor
desde la demo. Los revisores no pueden crear cuentas, personas ni
asignaciones, porque no hay administración. Sí pueden crear entradas con
las cuentas demo, y esas se toleran y se conservan.

Con eso, una base que no es la de la demo, por ejemplo con un administrador
o con datos de desarrollo, se rechaza aunque el indicador esté mal puesto.

### 5. Marcas propias (P-31, aprobada por Pablo en M214)

Una tabla de marcas propia, porque mantiene la capacidad demo separada de
GL-08. La tabla, las restricciones y la spec de `development-sample-data`
no cambian, y ninguna marca de un conjunto puede confundirse con la del
otro.

- **Tabla nueva `demo_data_records`**, con clave única y exactamente una
  referencia a una cuenta, persona, asignación o entrada.
- Tiene las mismas restricciones que `sample_data_records`: tipo según el
  prefijo de la clave, un registro con una sola marca y sin borrado
  mientras esté marcado.
- La migración crea la tabla en todos los entornos. Una tabla vacía no
  cambia nada en desarrollo ni en test.
- **Alternativa descartada:** ampliar `sample_data_records` con entradas,
  que cambiaba una tabla y una spec de GL-08.

### 6. Conjunto demo (aceptado por Pablo en M214)

El detalle está en el ticket:

- Lucía Demo (L1) y Martín Demo (L2), activos y no administradores, con
  correos `*.demo@ficticio.example.test`.
- Paula Ejemplo, asignada a ambos.
- Entradas de ejemplo:
  - un borrador de L1;
  - una entrada lista de L1: Positivo, `teamwork`;
  - una entrada lista de L2: A mejorar, `communication`.
- Las fechas del hecho son relativas a la primera ejecución, en la zona de
  P-23.

Las contraseñas iniciales de las cuentas salen de variables secretas de
Render (P-29, sección 8).

### 7. Dónde corre la tarea (P-28, aprobada por Pablo en M214)

La tarea idempotente corre en el **build de Render, después de las
migraciones**, bajo las dos guardas de la sección 3 (entorno de producción
y `GROWTH_LOG_DEMO_INSTANCE` con su valor exacto). Además se niega ante
registros ajenos (sección 4).

**Dos despliegues manuales, en orden:**

1. **Primer deploy, solo migraciones.** Pablo crea el servicio sin
   `GROWTH_LOG_DEMO_INSTANCE` ni las variables de contraseña. El script de
   build corre `bundle install`, los assets y `bin/rails db:migrate`, y
   **no invoca** la tarea demo: informa que no está habilitada. Así se
   comprueba que el build se conecta a `growth-log-entrega-2-db` (R1) sin
   escribir datos demo.
2. **Deploy manual con la tarea habilitada.** Una vez comprobada la
   conexión, Pablo carga en el panel `GROWTH_LOG_DEMO_INSTANCE` y las
   variables de contraseña, y lanza otro deploy manual. El script corre
   `db:migrate` y después `bin/rails growth_log:datos_demo`.

**Cómo decide el script si invoca la tarea (propuesta de implementación):**

- Sin `GROWTH_LOG_DEMO_INSTANCE`, no la invoca.
- Con la variable presente, la invoca siempre. Si el valor no es el
  esperado, la tarea se niega con error y el build falla.
- La tarea en sí sigue negándose con error sin el indicador, como dice la
  spec. El script solo evita llamarla en el primer deploy.

**Cada deploy posterior** vuelve a correr la tarea. Como es idempotente, no
cambia los datos cuando el conjunto ya existe.

Fundamentos en la documentación oficial de Render:

- **Variables en el build:** las variables de entorno de un servicio web
  están disponibles en el build y en la ejecución
  ([Your First Render Deploy](https://render.com/docs/your-first-deploy)).
- **Migraciones en el build en Free:** la guía de Rails 8 dice que el
  pre-deploy requiere un plan de cómputo pago y que en el plan Free se
  puede mantener la lógica de migraciones en el script de build
  ([Deploy Rails 8](https://render.com/docs/deploy-rails-8)).
- **Fallas:** si el build falla, Render cancela el deploy y la instancia
  anterior sigue funcionando. Si falla o vence cualquier comando, falla
  todo el deploy y el servicio sigue con su último deploy exitoso, si lo
  hay ([Deploys](https://render.com/docs/deploys)).
  - En la demo, si fallan las migraciones o la tarea, falla ese deploy y se
    conserva el último exitoso.
  - En el **primer** deploy no hay uno anterior: el servicio no queda
    disponible hasta que un build termine bien.
- Nada corre al arrancar Puma.

**Sin probar en este servicio.** Nada de esto se ejecutó todavía en Render.
El primer deploy, solo con migraciones, es la comprobación de R1.

**Alternativa descartada:** ejecutar la tarea desde la máquina de Pablo con
la URL externa de la base.

### 8. Contraseñas iniciales (P-29, decidida en M214) y credenciales para revisores (P-30, pendiente)

**P-29 (decidida por Pablo en M214):** las contraseñas iniciales de las
cuentas demo salen de **variables secretas de Render**, cargadas por Pablo
en el panel.

- **Nombres propuestos**, sin valores:
  `GROWTH_LOG_DEMO_PASSWORD_LUCIA` y `GROWTH_LOG_DEMO_PASSWORD_MARTIN`.
- **Solo al crear la cuenta:** la tarea lee la variable de una cuenta
  únicamente cuando la crea. **No sobrescribe contraseñas existentes:** si
  la cuenta ya existe, no lee su variable ni cambia su contraseña, aunque
  el valor del panel haya cambiado.
- **Validación antes de escribir:** si falta la variable de una cuenta que
  hay que crear, o su valor no cumple la política de contraseñas, la tarea
  termina con error antes de escribir. La operación es atómica: no queda
  ningún registro.
- **Nunca se muestra:** la tarea no imprime el valor ni un hash, ni en la
  salida, ni en los errores, ni en los logs. El script de build no usa
  `set -x` ni muestra el entorno.
- **Sin rastro en el repositorio:** el repositorio, los prompts registrados
  y este diseño no contienen valores.
- **Relación con GL-08:** la spec de GL-08 prohíbe leer contraseñas de
  variables de entorno **para su propia tarea**, y eso no cambia. La regla
  de la tarea demo es distinta y se define en `temporary-demo`.
- **Después de crear las cuentas (decidido en M215):** una vez creadas y
  verificadas las cuentas demo, Pablo retira las variables de contraseña
  del panel y conserva `GROWTH_LOG_DEMO_INSTANCE`. Los deploys siguientes
  corren la tarea sin esas variables. Como las cuentas ya existen, la tarea
  no las necesita y no falla.

**P-30**, cómo se comparten las credenciales con quienes revisen: **sigue
pendiente y lo decide Pablo.** Este diseño no propone canal.

### 9. Configuración de Render (al implementar, con aprobación)

- **Servicio web:** Free, en la misma región que la base (Virginia), para
  usar la URL interna.
- **Comandos del servicio** (confirmados contra el repositorio el
  15/11/2026; todavía no ejecutados en Render):
  - Language: **Ruby**. La versión sale de `Gemfile.lock`, `ruby 4.0.9`
    (riesgo R9).
  - Build Command: **`bin/render-build.sh`**. Es el script versionado, con
    permiso de ejecución.
  - Start Command: **`bin/rails server`**.
    - Es el que indica la guía de Rails 8 de Render
      ([Deploy Rails 8](https://render.com/docs/deploy-rails-8)).
    - Arranca Puma con `config/puma.rb`, que toma el puerto de `PORT` (lo
      define Render) y los hilos de `RAILS_MAX_THREADS` (3 por defecto).
    - Fuera de `development`, `rails server` escucha en `0.0.0.0`.
    - El repositorio no tiene `Procfile` ni Thruster: Puma atiende
      directamente.
- **Variables en el panel**, cargadas por Pablo:
  - `DATABASE_URL`, con la URL interna;
  - `RAILS_MASTER_KEY` o `SECRET_KEY_BASE`;
  - `GROWTH_LOG_DEMO_INSTANCE`, recién en el segundo deploy;
  - `GROWTH_LOG_DEMO_PASSWORD_LUCIA` y `GROWTH_LOG_DEMO_PASSWORD_MARTIN`,
    secretos, recién en el segundo deploy;
  - `WEB_CONCURRENCY`: la guía de Render lo recomienda en 2, pero
    **no tiene efecto con este repositorio**, porque `config/puma.rb` no
    define workers. Puma corre en un solo proceso, con hilos. No hace falta
    cargarla.
- **Rama y despliegue (decididos en M214):** `feature/entrega-2-pp`, con
  despliegue automático desactivado. Cada deploy lo lanza Pablo a mano.
- **Configuración que se revisa al implementar, sin cambiarla ahora:**
  `config.hosts` y `force_ssl`, que Render termina con TLS.

## Límites de Render verificados

Fuentes: documentación oficial de Render, consultada el 14/11/2026. Las
páginas no muestran fecha de actualización. Las cifras de precios pueden
cambiar, y Render indica confirmarlas en su página de precios.

| Tema | Límite | Fuente |
|---|---|---|
| Servicio web Free: inactividad | se suspende tras 15 minutos sin tráfico entrante; reanudar tarda alrededor de un minuto | [Deploy for Free](https://render.com/docs/free) |
| Servicio web Free: horas | 750 horas de instancia Free por espacio de trabajo y mes; al agotarse se suspenden los servicios Free hasta el mes siguiente | [Deploy for Free](https://render.com/docs/free) |
| Servicio web Free: acceso | sin shell (SSH ni panel), sin trabajos puntuales, sin escalar a más de una instancia; Render puede reiniciarlo en cualquier momento; sistema de archivos efímero | [Deploy for Free](https://render.com/docs/free) |
| Pre-deploy | disponible para servicios web pagos; la guía de Rails dice que requiere un plan pago y que en Free las migraciones pueden ir en el script de build | [Deploys](https://render.com/docs/deploys), [Deploy Rails](https://render.com/docs/deploy-rails) |
| Variables en el build | las variables de entorno de un servicio web están disponibles en el build y en la ejecución | [Your First Render Deploy](https://render.com/docs/your-first-deploy) |
| Build y base | el pipeline corre en cómputo separado, sin acceso a los recursos de la instancia; la guía de Rails 8 admite las migraciones en el build en Free; la conexión de este servicio a su base durante el build **no se probó** (R1) | [Build Pipeline](https://render.com/docs/build-pipeline), [Deploy Rails 8](https://render.com/docs/deploy-rails-8) |
| Fallas de deploy | si el build falla, Render cancela el deploy y la instancia anterior sigue funcionando; si falla cualquier comando, falla el deploy y el servicio sigue con su último deploy exitoso, si lo hay | [Deploys](https://render.com/docs/deploys) |
| Postgres Free | una por espacio de trabajo; 1 GB; **vence a los 30 días de su creación**; 14 días de gracia para pasarla a un plan pago y después se borra con sus datos; sin backups | [Deploy for Free](https://render.com/docs/free) |
| Conexión | URL interna solo para servicios de la misma cuenta y región; URL externa con `sslmode=require`; lista de IPs permitidas por defecto `0.0.0.0/0` | [Postgres](https://render.com/docs/postgresql-creating-connecting) |
| Ancho de banda | Hobby: 5 GB salientes por mes; el excedente se cobra a USD 0,15 por GB; **sin medio de pago**, Render suspende los servicios del espacio de trabajo hasta el mes siguiente | [Outbound Bandwidth](https://render.com/docs/outbound-bandwidth), [Deploy for Free](https://render.com/docs/free) |
| Minutos de build | Hobby: 500 por mes; el excedente se compra automáticamente; **sin medio de pago** o al llegar al límite de gasto se detienen los builds hasta el mes siguiente, y los servicios siguen con lo último construido | [Build Pipeline](https://render.com/docs/build-pipeline), [Deploy for Free](https://render.com/docs/free) |
| Tráfico | Render puede suspender un servicio Free con un volumen de tráfico inusual | [Deploy for Free](https://render.com/docs/free) |

**Riesgo de cargos.** El servicio web Free y la base Free no tienen cargo
propio. Los cargos posibles son por ancho de banda y minutos de build por
encima de lo incluido, y solo se generan si el espacio de trabajo tiene un
medio de pago. Sin medio de pago, el excedente suspende los servicios o los
builds en lugar de cobrar.

No consta en el repositorio el plan del espacio de trabajo de Pablo
(se supone Hobby) ni si tiene un medio de pago. Queda como pregunta
abierta. Si lo tiene, conviene fijar un límite de gasto para el pipeline.

## Verificación (al implementar)

- **Pruebas primero, como en GL-08:**
  - con procesos reales en `development` y `test`, y en producción sin
    indicador, sobre una base de pruebas aislada;
  - registros ajenos;
  - primera ejecución y repetición con ediciones y entradas de revisores;
  - atomicidad y concurrencia;
  - salida sin contraseñas.
- **Regresión:** las pruebas de `development-sample-data` pasan sin
  modificarse.
- **Mutaciones:**
  - quitar la guarda de entorno;
  - quitar la revisión de registros ajenos;
  - hacer que la repetición actualice un registro.
- **Gate:** `bin/bundler-audit update`, `bin/ci` y
  `openspec validate --all --strict`.
- **Comprobación manual en la URL de Render** (criterio CA8 del ticket, con fecha): recorrido
  con L1, rama negativa con L2 y una repetición del build sin cambios en
  los datos.

### Registro de la implementación (14/11/2026, local, sin commit)

Autorizada en M215 según el borrador v3, sin modificar Render ni desplegar.

**Pruebas primero.** Se escribieron antes del código y fallaron por la razón
esperada:

- `spec/services/demo_data_spec.rb`, `spec/models/demo_data_record_spec.rb`,
  `spec/tasks/datos_demo_spec.rb` y `spec/services/demo_data_concurrency_spec.rb`
  no cargaron: `uninitialized constant DemoData` y `DemoDataRecord`.
- `spec/scripts/render_build_spec.rb` falló porque `bin/render-build.sh` no
  existía.
- La tarea de Rake no existía: «Don't know how to build task
  'growth_log:datos_demo'».

**Implementación:**

- **Migración** `20261114233500_create_demo_data_records`:
  - referencias a cuenta, persona, asignación o entrada;
  - exactamente una referencia y prefijo `demo:` coherente;
  - claves y referencias únicas;
  - sin borrado de registros marcados.
- **Modelo** `DemoDataRecord`.
- **Servicio** `DemoData`, con la guarda de instancia antes de consultar la
  base, la revisión de registros ajenos, las contraseñas iniciales desde
  `GROWTH_LOG_DEMO_PASSWORD_LUCIA` y `GROWTH_LOG_DEMO_PASSWORD_MARTIN` solo
  al crear, una transacción y un bloqueo consultivo.
- **Interfaz:** `DemoDataCommand` y la tarea `growth_log:datos_demo`.
- **Build:** `bin/render-build.sh`, con `bundle install`, assets,
  `db:migrate` y la tarea solo si `GROWTH_LOG_DEMO_INSTANCE` está presente.
  Usa `errexit`, `nounset` y `pipefail`, sin traza.
- **Guía:** `docs/desarrollo.md`, sección 12.
- **Sin cambios:** la configuración de producción. `DATABASE_URL` se
  combina con `config/database.yml`, como ya comprueban los procesos reales
  de GL-08 y GL-10.

**Pruebas nuevas, 51 ejemplos:**

- **Instancia:** se niega en `development` y `test` con el indicador, y en
  producción sin él o con otro valor. Con el servicio, se comprueba sin
  ninguna consulta SQL; con procesos reales, sin cambios en la base.
- **Proceso real en producción**, contra la base de test:
  - crea el conjunto y no muestra las contraseñas;
  - se niega ante un registro ajeno.
- **Base dedicada:**
  - cuenta ajena;
  - correo del conjunto sin marca;
  - persona ajena;
  - datos del conjunto de desarrollo;
  - entrada de un autor que no es cuenta demo.
- **Repetición:** sin cambios. Se conservan las ediciones y las entradas de
  quienes revisan, y las contraseñas no cambian aunque la variable cambie o
  falte.
- **Contraseñas:** variable ausente o fuera de la política provoca un error
  sin escribir y sin mostrar el valor.
- **Robustez:** atomicidad, concurrencia y restricciones de las marcas.
- **Seeds y configuración:** no invocan la tarea.
- **Script de build:** se ejecuta en una copia aislada con `bundle` y
  `bin/rails` simulados.

**Mutaciones**, con copia de seguridad y restauración comprobada con
`diff`. Todas fueron detectadas:

| # | Mutación | Resultado |
|---|---|---|
| M1 | la guarda de instancia siempre deja pasar | 10 fallos |
| M2 | sin revisión de registros ajenos | 7 fallos |
| M3 | la repetición sobrescribe la contraseña de una cuenta existente | 3 fallos |
| M4 | el script de build invoca siempre la tarea | 1 fallo |

**Gate local:**

- Logs copiados antes de correr el gate.
- `bin/bundler-audit update` y `bin/ci` con código 0: 368 ejemplos, 0
  fallos; RuboCop sin ofensas; sin vulnerabilidades; Brakeman sin avisos.
- Las pruebas de GL-08 pasan sin modificarse.
- `RAILS_ENV=production bin/rails assets:precompile` (con
  `SECRET_KEY_BASE_DUMMY`) terminó bien y los assets se borraron después
  con `assets:clobber`.

**No comprobado (fuera de la autorización de M215):**

- nada en Render: servicio, variables, deploys (tareas 5.2 a 5.4);
- el CI remoto;
- la conexión del build a la base (R1);
- la versión de Ruby en Render (R9).

## Risks / Trade-offs

- **R1. Residual: la conexión del build a la base no se probó en este
  servicio** (sección 7). La documentación respalda la decisión, pero no
  reemplaza la prueba. Mitigación: el primer deploy solo migra. Si falla,
  Pablo decide cómo seguir antes de habilitar la tarea.
- **R2. Vencimiento:** la base, creada el 14/11/2026, vence alrededor del
  14/12/2026 y, después de la gracia, se borra con todo lo escrito,
  alrededor del 28/12/2026. La demo se presenta como temporal y no reemplaza la revisión
  local.
- **R3. Demo editable y pública:**
  - Quien tenga las credenciales puede escribir textos arbitrarios.
  - La base no tiene backups ni reset.
  - Una entrada inapropiada solo se corrige por consola, que el plan Free
    no ofrece.
  - Lo acepta Pablo con P-27; P-30 limita quién recibe las credenciales.
- **R4. Indicador mal configurado:** la revisión de registros ajenos
  (sección 4) impide escribir en una base que no es la demo.
- **R5. Arranque en frío:** la primera visita tras 15 minutos tarda
  alrededor de un minuto. Se advierte en el README cuando la demo exista.
- **R6. Cargos:** ver «Riesgo de cargos».
- **R7. Spec `initial-administrator`:** sin el delta, las cuentas demo
  predefinidas violarían el escenario «Repositorio sin credenciales».
- **R8. Contraseñas en el panel de Render (P-29):**
  - El valor queda guardado en Render y disponible en el entorno del build y
    de la ejecución.
  - Mitigaciones:
    - la tarea no lo imprime;
    - el script no muestra el entorno;
    - el valor no se versiona;
    - la tarea no lo vuelve a leer para cuentas existentes.
- **R9. Ruby 4.0.9 en Render:**
  - Render toma la versión de `Gemfile.lock` (`ruby 4.0.9`).
  - Su página de versiones no lista las admitidas. Solo indica el mínimo
    (3.1.0) y la versión por defecto (3.4.12)
    ([Ruby Version](https://render.com/docs/ruby-version)).
  - Que 4.0.9 esté disponible se comprueba en el primer deploy. Si no lo
    está, falla el build y hace falta una decisión de Pablo.

## Migration Plan

- La migración agrega `demo_data_records` y no toca tablas existentes.
- Revertir la demo es borrar el servicio web en Render, a cargo de Pablo.
  La base vence sola.

## Open Questions

1. **P-30:** ¿cómo se comparten las credenciales con quienes revisen? Lo
   decide Pablo; no bloquea la implementación, sí compartir la demo.
2. ¿Qué plan tiene el espacio de trabajo de Render y tiene un medio de
   pago? Define si un excedente cobra o suspende.
3. ~~¿Se retiran las variables de contraseña?~~ Resuelta en M215: se
   retiran tras crear y verificar las cuentas, y se conserva el indicador.
4. ~~Aprobación para implementar.~~ Dada en M215 según el borrador v3, sin
   modificar Render ni desplegar.

Resueltas en M214: P-28, P-29, P-31, la rama `feature/entrega-2-pp` con
despliegue manual, y los nombres del conjunto demo.
