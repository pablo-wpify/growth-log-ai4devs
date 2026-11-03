# Decisiones de GL-08 (aprobadas el 03/11/2026)

> Aprobadas por Pablo al planificar
> [GL-08](../tickets/GL-08-datos-ficticios.md). Detalle en el
> [plan de la entrega 2](../plan-entrega-2.md#6-decisiones-pendientes-de-aprobación).

| # | Decisión | Estado |
|---|---|---|
| P-6 | Tarea explícita de datos ficticios, solo en `development`, con cuentas, personas y asignaciones suficientes para varios líderes y aislamiento; sin contraseñas ni hashes fijos versionados; nada al arrancar ni al migrar | aprobada |
| P-13 | Tabla `sample_data_records` que identifica exclusivamente los registros creados por la tarea, con referencias tipadas y restricciones contra claves duplicadas, referencias ambiguas y marcas huérfanas | aprobada |
| P-14 | Contraseñas establecidas por Pablo con `growth_log:contrasena_ficticia`, sin eco, sin argumentos ni variables de entorno | aprobada |

**Precisiones de Pablo (03/11/2026):** una contraseña aleatoria descartada
no equivale a una cuenta deshabilitada; un conflicto revierte toda la
operación; repetir no reactiva cuentas ni asignaciones; cambiar la
contraseña no activa una cuenta desactivada y elimina sus sesiones; la
protección de entorno se comprueba también con procesos reales; la lectura
sin eco compartida conserva el comportamiento de `crear_administrador`.

**Consecuencia sobre GL-02:** la spec `initial-administrator` admite de
forma explícita las cuentas ficticias definidas en el código, sin
contraseñas ni hashes.
