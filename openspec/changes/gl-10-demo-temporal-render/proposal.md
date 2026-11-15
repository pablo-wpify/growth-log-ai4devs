# Proposal

> **Borrador; implementación sin aprobar** (M212, actualizado en M213 y
> M214, 14/11/2026).
>
> - **Decidido por Pablo en M214:** P-28, P-29 y P-31, la rama y el
>   despliegue manual, y el conjunto demo.
> - **P-30 sigue pendiente.**
> - **No se implementa hasta la aprobación explícita de Pablo.**

## Why

La entrega se revisa en local y el despliegue es opcional. Pablo quiere una
demo temporal en Render, para que quien revise recorra el núcleo sin
instalar nada. GL-08 prepara datos ficticios solo en `development` y debe
seguir así. El servicio web Free de Render no ofrece shell, SSH ni trabajos
puntuales, y el pre-deploy requiere un plan pago.

Hace falta, entonces, una forma **separada, explícita e idempotente** de
preparar un conjunto ficticio en una base dedicada a la demo. Fuente:
`docs/tickets/GL-10-demo-temporal-render.md` y el plan de la entrega 2
(secciones 5 y 6).

## What Changes

- **Capability nueva `temporary-demo`:**
  - **Instancia:** una instancia demo temporal con datos exclusivamente
    ficticios, editable (P-27) y sin modo de solo lectura.
  - **Tarea `growth_log:datos_demo`:**
    - Prepara dos líderes asignados a la misma persona, con un borrador y
      entradas listas de ejemplo.
    - Se niega fuera de la instancia demo y ante registros ajenos.
    - No sobrescribe, no adopta ni borra datos.
    - No corre desde los seeds ni al arrancar Puma.
  - **Marcas (P-31, aprobada):** el conjunto demo se identifica con marcas
    propias, en una tabla separada de la de GL-08. Así la capacidad demo
    queda separada de GL-08.
  - **Contraseñas iniciales (P-29, decidida):** salen de variables secretas
    de Render, una por cuenta, y se leen solo al crearla. Se validan con la
    política antes de escribir. Nunca se imprimen y no se sobrescriben
    contraseñas existentes. Sin contraseñas ni hashes versionados.
- **Spec `initial-administrator` (MODIFIED):** el escenario «Repositorio
  sin credenciales» admite también las cuentas del conjunto demo, siempre
  sin contraseñas ni hashes.
- **Ejecución (P-28, aprobada):** la tarea corre en el build de Render,
  después de `db:migrate`, bajo las dos guardas.
  - Primer deploy solo de migraciones, sin el indicador.
  - Tras comprobar la conexión, un deploy manual con la tarea habilitada.
  - El servicio despliega `feature/entrega-2-pp` con despliegue manual.
  - Según la documentación oficial de Render, las variables de entorno
    están disponibles en el build y la guía de Rails 8 recomienda las
    migraciones en el build en Free, porque el pre-deploy es pago.
  - Si falla el build o la tarea, falla ese deploy y se conserva el último
    exitoso.
  - **No se probó todavía en este servicio.**
  - Alternativa descartada: ejecutarla desde la máquina de Pablo con la
    URL externa.
- **No incluye:**
  - cambios en `development-sample-data` ni en la tarea de GL-08;
  - datos reales;
  - modo de solo lectura;
  - ADR-7 (despliegue y backups);
  - invitaciones, administración, compartir, feed ni filtros;
  - cambios en Render hechos por el agente;
  - la forma de compartir credenciales (P-30).

## Capabilities

### New Capabilities
- `temporary-demo`: instancia demo temporal y editable con datos ficticios,
  y la tarea explícita e idempotente que prepara su conjunto en una base
  dedicada.

### Modified Capabilities
- `initial-administrator`: el repositorio admite las cuentas predefinidas
  del conjunto demo, sin contraseñas ni hashes.

## Impact

- **Código, al implementar:**
  - un servicio y una tarea nuevos en `lib/tasks/growth_log.rake`;
  - una migración para la tabla de marcas demo (P-31);
  - la configuración de producción para Render;
  - el script de build.
- **Pruebas, al implementar:** pruebas primero, también con procesos
  reales fuera de la instancia demo, como en GL-08.
- **Render:**
  - Servicio web Free en la misma región que la base (Virginia), sobre
    `feature/entrega-2-pp` y con despliegue manual.
  - Variables de entorno cargadas por Pablo en el panel, entre ellas las
    contraseñas iniciales como secretos (P-29).
  - La base `growth-log-entrega-2-db` existe, es Free, está en Virginia y
    fue creada el 14/11/2026. Vence alrededor del 14/12/2026.
- **Documentación:** README («Cómo revisar esta entrega», 0.4 y 2.4) y
  `docs/desarrollo.md`, solo cuando la demo exista.
- Sin cambios en la forma de entrega: la rama se envía por Typeform.
