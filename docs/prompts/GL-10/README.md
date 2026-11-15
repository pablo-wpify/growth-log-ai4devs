# Prompts: GL-10. Demo temporal en Render

> Índice general: [prompts.md](../../../prompts.md). Cada archivo
> separa los metadatos, el **texto original** del pedido y el **resultado
> registrado**, que no forma parte del pedido.

## Pedidos enviados a Claude Code

| Mensaje | Fecha y hora (UTC) | Tipo | Archivo |
|---|---|---|---|
| M211 | 2026-11-14 22:52:42 | fase documental (detenida: falta el archivo de partida) | [Preparar GL-10 desde un borrador](M211-2026-11-14-preparar-gl-10-desde-un-borrador.md) |
| M212 | 2026-11-14 22:59:34 | fase documental | [Borrador documental de GL-10](M212-2026-11-14-borrador-documental-de-gl-10.md) |
| M213 | 2026-11-14 23:12:23 | actualización de la fase documental | [Actualizar el borrador de GL-10](M213-2026-11-14-actualizar-el-borrador-de-gl-10.md) |
| M214 | 2026-11-14 23:24:10 | decisiones y actualización de la fase documental | [Decisiones de Pablo sobre GL-10](M214-2026-11-14-decisiones-de-gl-10.md) |
| M215 | 2026-11-14 23:31:03 | autorización de implementación | [Autorizar la implementación de GL-10](M215-2026-11-14-autorizar-la-implementacion-de-gl-10.md) |
| M216 | 2026-11-15 00:25:06 | revisión de solo lectura | [Revisar la implementación de GL-10](M216-2026-11-15-revisar-la-implementacion-de-gl-10.md) |
| M217 | 2026-11-15 00:43:31 | correcciones de revisión | [Corregir hallazgos de la revisión de GL-10](M217-2026-11-15-corregir-hallazgos-de-la-revision-de-gl-10.md) |
| M237 | 2026-11-15 13:53:07 | actualización documental | [Reconciliar la documentación de GL-10](M237-2026-11-15-reconciliar-la-documentacion-de-gl-10.md) |

M211 pidió el borrador de OpenSpec a partir de un archivo que no estaba
disponible; el trabajo se detuvo antes de editar. M212 lo reemplazó, tomó
su propio texto como fuente de verdad y pidió el ticket, el cambio de
OpenSpec, la actualización del plan y este registro, sin implementar. M213
actualizó el borrador:

- P-28 pasa a recomendación técnica, con las fuentes oficiales de Render.
- Se registran los datos conocidos de la base.
- P-29 y P-30 siguen sin decidir.
- P-31 queda como recomendación.

M214 decidió:

- P-28, con un primer deploy solo de migraciones y después un deploy
  manual con la tarea habilitada.
- P-29: contraseñas iniciales desde variables secretas de Render.
- P-31: tabla de marcas propia.
- La rama `feature/entrega-2-pp`, con despliegue manual.
- El conjunto demo.

M215 autorizó la implementación según el borrador v3, sin modificar Render
ni desplegar. Además decidió retirar las variables de contraseña tras crear
y verificar las cuentas, y conservar el indicador. P-30 sigue pendiente.

**Aclaración (15/11/2026, M237).** Pablo aclaró que no se iban a retirar las
variables de contraseña. El retiro no es una tarea pendiente (la tarea 5.4
quedó sin efecto) y el texto de M215 se conserva sin cambios.

M216 pidió una revisión de solo lectura. M217 corrigió tres hallazgos:

- se eliminó una constante sin usos;
- se documentaron los comandos de Render;
- se renombraron los criterios del ticket a CA1–CA11.

M217 pedía registrarse como M216, pero por posición le corresponde M217.

M218 a M235 (publicación, merge y primer deploy) no están registrados; ver
[prompts.md](../../../prompts.md). M237 reconcilió la documentación con lo
ocurrido: GL-10 integrado y desplegado, con la comprobación manual parcial.

**Numeración.** El número sale de la posición en la transcripción; el
SHA-256 de M206 a M209 coincide con sus registros. M210 (publicación de
las correcciones documentales de la entrega 2, commit `e5d678f`) no está
registrado: **pendiente de confirmación** si se agrega. Las notificaciones
automáticas de tareas en segundo plano y los resúmenes automáticos de
contexto no son pedidos y no tienen número.

## Conversación de acompañamiento

**No aportada.** Según declaración de Pablo, los pedidos pegados se
prepararon con ChatGPT en una conversación de acompañamiento y después se
pegaron en Claude Code. Esa conversación no está aportada como archivo y su
modelo no está verificado. No se reconstruye.
