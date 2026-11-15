# M213. Actualizar el borrador documental de GL-10

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-10` |
| Tipo | actualización de la fase documental |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `d8a1d1f80378e1c4dbdfa59b0454ec464d4a5be9e7d89dd757498436c26e7ccb` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M213 | 2026-11-14 23:12:23 |

## Texto original

````text
Actualizá el borrador documental de GL-10, sin implementar.

Incorporá como recomendación técnica para P-28 que la tarea idempotente de datos demo se ejecute en el build de Render, después de las migraciones y bajo las dos guardas ya propuestas: entorno de producción y GROWTH_LOG_DEMO_INSTANCE con el valor exacto esperado.

La documentación oficial de Render indica que las variables de entorno están disponibles durante el build. Su guía para Rails 8 recomienda ejecutar migraciones desde el build en servicios Free, porque el pre-deploy requiere un plan pago. Aclará que si falla el build o la tarea, falla ese deploy y se conserva el último deploy exitoso. Citá las fuentes oficiales. No afirmes que ya lo probamos en este servicio.

Actualizá los datos conocidos de Render: la base growth-log-entrega-2-db fue creada el 14/11/2026, es Free y está en Virginia. No incluyas ni infieras credenciales. Dejá pendiente confirmar la rama del servicio y si el despliegue será automático o manual.

Mantené sin decidir:
- P-29: cómo se establecerán las contraseñas de las cuentas demo;
- P-30: cómo se compartirán las credenciales con quienes revisen.

Para P-31, conservá la tabla de marcas propia como recomendación, explicando que mantiene separada la capacidad demo de GL-08. No la registres como decisión de Pablo.

No cambies código, configuración de Render, datos, servicios ni archivos fuera del borrador documental ya preparado. No hagas stage, commit, push, PR, merge ni archivo. No ejecutes pruebas, CI ni auditorías. Al final ejecutá solo `openspec validate --all --strict` si el CLI está disponible y devolvé el diff completo, las decisiones que todavía necesito tomar y el estado de Git.
````

## Resultado registrado (no forma parte del pedido)

- **Borrador de GL-10 actualizado, sin implementar:** ticket, propuesta, diseño, tareas y plan (secciones 5 y 6).
- **P-28:** queda como recomendación técnica, sin aprobar: la tarea corre en el build de Render, después de las migraciones y bajo las dos guardas.
  - Fuentes oficiales de Render: variables de entorno disponibles en el build (Your First Render Deploy), migraciones en el build en Free (Deploy Rails 8) y conservación del último deploy exitoso ante una falla (Deploys).
  - Registrado como **no probado** en este servicio; R1 queda como riesgo residual.
- **Render:** `growth-log-entrega-2-db` creada el 14/11/2026, Free y en Virginia, con vencimiento aproximado el 14/12/2026. Pendiente de confirmar la rama del servicio y si el despliegue es automático o manual. Sin credenciales.
- **P-29 y P-30:** siguen sin decidir.
- **P-31:** la tabla de marcas propia queda como recomendación, no como decisión de Pablo.
- **Validación:** `openspec validate --all --strict`, 19 de 19 válidos. No se ejecutaron pruebas, CI ni auditorías.
- Sin stage, commit, push, PR, merge ni archivo.
- **Pendiente:** revisión y aprobación de Pablo.
