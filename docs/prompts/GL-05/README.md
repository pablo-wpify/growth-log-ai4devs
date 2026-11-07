# Prompts: GL-05. «Personas» y ficha del líder

> Índice general: [prompts.md](../../../prompts.md). Cada archivo
> separa los metadatos, el **texto original** del pedido y el **resultado
> registrado**, que no forma parte del pedido.

## Pedidos enviados a Claude Code

| Mensaje | Fecha y hora (UTC) | Tipo | Archivo |
|---|---|---|---|
| M28 | 2026-11-03 11:02:36 | pedido de planificación | [Planificar GL-05 mediante SDD](M28-2026-11-03-planificar-gl-05-mediante-sdd.md) |
| M33 | 2026-11-03 14:38:10 | pedido de planificación | [Retomar GL-05 y preparar su rama](M33-2026-11-03-retomar-gl-05-y-preparar-su-rama.md) |
| M35 | 2026-11-03 15:44:52 | aprobación e implementación | [Aprobar e implementar GL-05](M35-2026-11-03-aprobar-e-implementar-gl-05.md) |
| M36 | 2026-11-03 17:20:21 | preparación de la comprobación manual | [Preparar la prueba manual en navegador](M36-2026-11-03-preparar-la-prueba-manual-en-navegador.md) |
| M37 | 2026-11-06 21:52:03 | pedido de implementación | [Implementar GL-05 «Personas»](M37-2026-11-06-implementar-gl-05-personas.md) |
| M61 | 2026-11-07 14:26:30 | pedido de integración local | [Integrar GL-01b en GL-05 y probar](M61-2026-11-07-integrar-gl-01b-y-probar.md) |
| M62 | 2026-11-07 14:33:54 | pedido de integración local | [Continuar la validación de GL-05](M62-2026-11-07-continuar-la-validacion.md) |
| M63 | 2026-11-07 14:38:35 | pedido de verificación | [Inspeccionar la integración](M63-2026-11-07-inspeccionar-la-integracion.md) |
| M64 | 2026-11-07 14:52:06 | pedido de verificación | [Completar el informe de integración](M64-2026-11-07-completar-el-informe-de-integracion.md) |
| M65 | 2026-11-07 14:54:48 | autorización de commit local | [Crear el commit de integración](M65-2026-11-07-crear-el-commit-de-integracion.md) |
| M66 | 2026-11-07 15:07:51 | pedido de verificación | [Revisar la rama de integración](M66-2026-11-07-revisar-la-rama-de-integracion.md) |
| M67 | 2026-11-07 17:20:09 | pedido de verificación | [Comparar las copias sin versionar](M67-2026-11-07-comparar-las-copias-sin-versionar.md) |
| M68 | 2026-11-07 17:26:18 | autorización de integración local | [Avance rápido de GL-05](M68-2026-11-07-avance-rapido-de-gl-05.md) |
| M69 | 2026-11-07 17:30:49 | autorización de limpieza local | [Eliminar el worktree auxiliar](M69-2026-11-07-eliminar-el-worktree-auxiliar.md) |
| M70 | 2026-11-07 17:38:30 | autorización de documentación y publicación | [Completar y publicar GL-05](M70-2026-11-07-completar-y-publicar-gl-05.md) |
| M71 | 2026-11-07 17:45:26 | pedido de verificación | [Verificar la publicación de GL-05](M71-2026-11-07-verificar-la-publicacion-de-gl-05.md) |
| M72 | 2026-11-07 17:47:45 | autorización de commit documental y publicación | [Actualizar el resultado de M70](M72-2026-11-07-actualizar-el-resultado-de-m70.md) |
| M73 | 2026-11-07 17:55:18 | autorización de merge | [Fusionar el PR #3](M73-2026-11-07-fusionar-el-pr-3.md) |
| M74 | 2026-11-07 20:17:21 | pedido de cierre | [Cerrar GL-01b y GL-05](M74-2026-11-07-cerrar-gl-01b-y-gl-05.md) |
| M75 | 2026-11-07 20:44:28 | pedido de comprobación manual | [Ejecutar la comprobación manual E10](M75-2026-11-07-ejecutar-la-comprobacion-manual-e10.md) |
| M76 | 2026-11-07 21:08:48 | pedido de comprobación manual | [Ejecutar la comprobación manual E10 (segundo envío)](M76-2026-11-07-ejecutar-la-comprobacion-manual-e10-segundo-envio.md) |
| M77 | 2026-11-07 21:18:15 | pedido de verificación | [Revisar la conexión a la base para establecer contraseñas](M77-2026-11-07-revisar-la-conexion-a-la-base.md) |
| M78 | 2026-11-07 21:51:32 | autorización de archivo y documentación | [Registrar E10 y archivar GL-05](M78-2026-11-07-registrar-e10-y-archivar-gl-05.md) |
| M79 | 2026-11-07 21:59:38 | pedido de revisión documental | [Revisar la numeración y los pendientes de E10](M79-2026-11-07-revisar-la-numeracion-y-los-pendientes-de-e10.md) |
| M80 | 2026-11-07 22:13:20 | autorización de commit documental y publicación | [Publicar el cierre de GL-01b y GL-05](M80-2026-11-07-publicar-el-cierre-de-gl-01b-y-gl-05.md) |
| M81 | 2026-11-07 22:19:15 | autorización de commit documental y publicación | [Registrar M80](M81-2026-11-07-registrar-m80.md) |

M28 y M33 produjeron la planificación; M35 aprobó P-15 a P-17 y autorizó la implementación en la rama local `feature/GL-05-personas`. M61 a M69 integraron GL-01b (Rails 8.1.4.1) en esa rama (`a60fb8e`); M70 a M72 la documentaron y publicaron (PR #3); M73 la fusionó en `feature/entrega-2-pp` (`8d0e854`); M74 cerró GL-01b y dejó pendiente la comprobación manual E10; M75 la pidió y quedó bloqueado, M76 la repitió con éxito en una sesión nueva y M77 resolvió la conexión a la base para establecer contraseñas; M78 registró E10 y archivó GL-05; M79 corrigió la numeración y registró los pendientes de seguimiento, M80 publicó el cierre (`6b9577f`, CI 42419660424), y M81 publicó el registro de M80 (`4bac6e4`, CI 42420116093). Las respuestas operativas breves de esas sesiones no tienen número (criterio en [prompts.md](../../../prompts.md)).

## Conversación de acompañamiento

**No aportada.** Según declaración de Pablo, los pedidos pegados se
prepararon con ChatGPT en una conversación de acompañamiento y después se
pegaron en Claude Code. Esa conversación no está aportada como archivo y su
modelo no está verificado. No se reconstruye.
