# Proposal

## Why

Para recorrer la aplicación en desarrollo con varios líderes y comprobar a
mano el aislamiento hacen falta cuentas, personas y asignaciones, pero las
invitaciones y la administración están diferidas (GL-04). Fuente:
`docs/tickets/GL-08-datos-ficticios.md` y la decisión P-6, aprobada el
03/11/2026 (`docs/plan-entrega-2.md`).

## What Changes

- Tarea `growth_log:datos_ficticios`, solo en desarrollo, que crea un
  conjunto fijo de cuentas, personas y asignaciones ficticias, sin
  modificar nada que ya exista y sin borrar registros.
- Tabla de marcas `sample_data_records` que registra qué creó la tarea, para
  repetirla sin duplicar y para no adoptar registros ajenos (P-13).
- Tarea `growth_log:contrasena_ficticia`, solo en desarrollo y solo para
  cuentas del conjunto, que pide la contraseña dos veces sin eco (P-14).
- La lectura sin eco de `crear_administrador` se extrae a un componente
  común, sin cambiar su comportamiento.
- **Modificación explícita** de `initial-administrator`: el repositorio puede
  contener las definiciones del conjunto ficticio (correos reservados y
  nombres), nunca contraseñas ni hashes, y esas cuentas no cuentan como
  administradores.
- Fuera de este cambio: entradas de feedback, invitaciones, administración,
  pantallas, despliegue, datos en seeds o migraciones, borrado o reset.

## Capabilities

### New Capabilities
- `development-sample-data`: tarea de datos ficticios de desarrollo, su
  conjunto, su idempotencia sin sobrescritura, la protección contra la
  adopción de registros ajenos, la restricción a desarrollo y el
  establecimiento de contraseñas de esas cuentas.

### Modified Capabilities
- `initial-administrator`: el escenario «Repositorio sin credenciales» se
  precisa para admitir las cuentas ficticias definidas en el código, sin
  contraseñas ni hashes; se agrega un escenario que confirma que las
  cuentas ficticias no impiden crear el primer administrador.

## Impact

- Código nuevo: servicio del conjunto ficticio, comando de contraseña,
  componente de lectura sin eco, modelo `SampleDataRecord`, tareas de Rake.
- Migración: tabla `sample_data_records` (existe en todos los entornos y
  solo se llena en desarrollo).
- Cambio sin efecto funcional en `InitialAdministratorCommand`.
- Documentación: `docs/desarrollo.md`; `db/seeds/development.rb` solo
  cambia su comentario, para remitir a la tarea.
- Sin dependencias nuevas.
