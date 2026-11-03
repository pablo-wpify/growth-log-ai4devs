# Desarrollo local de Growth Log

Guía para preparar el entorno desde un clon del repositorio. Cada comando
está pensado para ejecutarse tal como está escrito, desde la raíz del
proyecto, en una terminal `bash` o `zsh`. Ticket de origen:
[GL-01](tickets/GL-01-base-producto.md).

## Prerrequisitos

- [asdf](https://asdf-vm.com/) con Ruby 4.0.9 instalado. El repositorio
  declara la versión en `.tool-versions` (lo lee asdf) y en `.ruby-version`
  (lo leen el `Gemfile` y el CI); las dos deben coincidir. No hace falta
  cambiar la configuración global de asdf.
- Docker, para el PostgreSQL 18.6 local.
- `openssl`, para generar la contraseña local.
- Acceso a internet la primera vez: instalación de gemas y base de avisos
  de seguridad.
- No hace falta Node: la aplicación usa importmap.

Comprobá la versión de Ruby:

```sh
ruby -v
```

Debe mostrar `ruby 4.0.9`. Si muestra otra, revisá que asdf esté activo en
la terminal y que no haya variables como `ASDF_RUBY_VERSION`,
`RBENV_VERSION` o `rvm_ruby_string` forzando otra versión.

## 1. Dependencias

```sh
bundle install
```

## 2. Variables locales

Las variables de conexión viven en `.env`, que Git ignora. El repositorio
solo versiona la plantilla `.env.example`, sin secretos.

```sh
cp .env.example .env
sed -i "s/^DATABASE_PASSWORD=.*/DATABASE_PASSWORD=$(openssl rand -hex 24)/" .env
chmod 600 .env
```

| Variable | Para qué sirve |
|---|---|
| `DATABASE_HOST` | host de PostgreSQL; `127.0.0.1` |
| `DATABASE_PORT` | puerto local publicado por el contenedor; `55440` por defecto |
| `DATABASE_USERNAME` | usuario de PostgreSQL; `growth_log` |
| `DATABASE_PASSWORD` | contraseña local generada; nunca se versiona |
| `GROWTH_LOG_PG_CONTAINER` | nombre del contenedor; `growthlog-pg` |
| `GROWTH_LOG_PG_VOLUME` | volumen de datos; `growthlog-pgdata` |

Si el puerto `55440` está ocupado, cambiá `DATABASE_PORT` en `.env` antes de
crear el contenedor.

Cargá las variables en **cada terminal** antes de usar Rails o Docker:

```sh
set -a; . ./.env; set +a
```

## 3. PostgreSQL 18.6

Crear el contenedor la primera vez. La contraseña se pasa por variables de
entorno, no en la línea de comandos, y el puerto se publica solo en
`127.0.0.1`:

```sh
POSTGRES_USER="$DATABASE_USERNAME" POSTGRES_PASSWORD="$DATABASE_PASSWORD" docker run -d --name "$GROWTH_LOG_PG_CONTAINER" -e POSTGRES_USER -e POSTGRES_PASSWORD -v "$GROWTH_LOG_PG_VOLUME:/var/lib/postgresql" -p "127.0.0.1:$DATABASE_PORT:5432" postgres:18.6
```

Esperar a que acepte conexiones:

```sh
until docker exec "$GROWTH_LOG_PG_CONTAINER" pg_isready -q; do sleep 1; done
```

En sesiones siguientes, si el contenedor está detenido:

```sh
docker start "$GROWTH_LOG_PG_CONTAINER"
```

Para detenerlo sin perder datos:

```sh
docker stop "$GROWTH_LOG_PG_CONTAINER"
```

## 4. Bases de datos

```sh
bin/rails db:prepare
RAILS_ENV=test bin/rails db:prepare
```

Crean o actualizan `growth_log_development` y `growth_log_test`. Se pueden
repetir. Los seeds solo crean datos en desarrollo.

## 4b. Administrador inicial

Las cuentas no se registran solas: no hay registro público. La primera
cuenta administradora se crea con una tarea que pide la contraseña dos
veces **sin mostrarla**. El correo y el nombre se pueden pasar como
variables o se piden en la terminal:

```sh
EMAIL=ana.admin@example.test NOMBRE="Ana Admin" bin/rails growth_log:crear_administrador
```

- La contraseña necesita al menos 15 caracteres y como máximo 72 bytes,
  sin reglas de composición.
- La tarea se niega si ya existe un administrador activo, y dos
  ejecuciones simultáneas crean uno solo.
- La contraseña nunca se pasa por argumentos ni por variables de entorno.
  Sin terminal, se lee de la entrada estándar (útil para automatizar).
- Usá datos ficticios en desarrollo. Las cuentas de líderes ficticias se
  preparan con la tarea del paso 4c; las invitaciones (GL-04) están
  diferidas. Ver el [plan de la entrega 2](plan-entrega-2.md).

Para iniciar sesión, levantá el servidor (paso 7) y entrá en
`http://localhost:3000`: sin sesión, cualquier página lleva a
«Iniciar sesión». La sesión vence tras 2 horas sin actividad y a las 12
horas como máximo.

**Límites de intentos.** 10 intentos por IP cada 3 minutos y 5 intentos
fallidos por correo cada 15 minutos. Los contadores se guardan en la tabla
`login_attempt_counters` de la misma base, compartida por todos los
procesos; no hace falta configurar nada más. Si en desarrollo te bloqueás,
esperá a que venza la ventana o vaciá la tabla:

```sh
bin/rails runner 'LoginAttemptCounter.delete_all'
```

## 4c. Datos ficticios de desarrollo

Para recorrer la aplicación con varios líderes hay un conjunto fijo de
cuentas, personas y asignaciones ficticias (dominio `ficticio.example.test`;
detalle en el [ticket GL-08](tickets/GL-08-datos-ficticios.md)). Se prepara
con una tarea explícita; los seeds, las migraciones y el arranque **no** lo
crean.

```sh
bin/rails growth_log:datos_ficticios
```

- Solo funciona con `RAILS_ENV=development`; en otro entorno termina con
  error sin consultar la base.
- Se puede repetir: crea solo lo que falta y **nunca** modifica, reactiva ni
  borra registros. Si cambiaste a mano una cuenta, una persona o una
  asignación del conjunto, el cambio se conserva.
- Reconoce como propios solo los registros que marcó en
  `sample_data_records`. Si ya existe una cuenta con uno de sus correos que
  la tarea no creó, termina con un conflicto y no escribe nada: no adopta
  esa cuenta. Resolvelo a mano; la tarea no repara ni borra.
- Las cuentas se crean con una contraseña aleatoria que no se guarda ni se
  muestra. Eso **no** las deshabilita: quedan activas (salvo Delia Inactiva)
  y solo admitirían esa contraseña, que nadie conoce.
- Ninguna es administradora: la administradora se crea con el paso 4b.

Para usar una cuenta ficticia, establecé su contraseña en tu terminal. Se
pide dos veces **sin eco**; nunca se pasa por argumentos ni variables de
entorno, y no aparece en la salida:

```sh
EMAIL=elena.boceto@ficticio.example.test bin/rails growth_log:contrasena_ficticia
```

- Solo para cuentas del conjunto ficticio y solo en desarrollo; se niega
  para la administradora y cualquier otra cuenta.
- Cierra todas las sesiones abiertas de esa cuenta.
- No reactiva cuentas: Delia Inactiva sigue sin poder iniciar sesión.

## 5. Pruebas

```sh
bundle exec rspec
```

Es la única suite: no hay directorio `test/`.

## 6. Análisis y verificación completa

Actualizá antes la base de avisos de seguridad: `bin/bundler-audit` audita
contra una copia local y no la actualiza solo.

```sh
bin/bundler-audit update
bin/ci
```

`bin/ci` ejecuta, en orden: preparación, RuboCop, `bundler-audit`, auditoría
de importmap, Brakeman, preparación de la base de test y RSpec. Termina con
código 0 solo si todo pasa. GitHub Actions ejecuta las mismas comprobaciones
(`.github/workflows/ci.yml`).

`bin/brakeman` se ejecuta con `--ensure-latest`: si se publica una versión
nueva de Brakeman, el análisis falla hasta actualizar la gema.

## 7. Servidor y ruta de salud

```sh
bin/rails server
```

En otra terminal:

```sh
curl -i http://localhost:3000/up
```

Debe responder `HTTP/1.1 200 OK`.

## Lo que todavía no hay

Pantallas de personas, feedback, invitaciones y administración.
Qué llega, en qué orden y qué queda diferido está en el
[plan de la entrega 2](plan-entrega-2.md).
