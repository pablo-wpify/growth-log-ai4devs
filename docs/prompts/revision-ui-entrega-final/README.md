# Prompts: Revisión de UI de la entrega final

> Índice general: [prompts.md](../../../prompts.md), sección «Entrega
> final». Cada archivo separa los metadatos, el **texto original** del
> pedido y el **resultado registrado**, que no forma parte del pedido.

## Pedidos enviados a Claude Code

| Mensaje | Fecha y hora (UTC) | Tipo | Archivo |
|---|---|---|---|
| M404 | 2026-11-21 20:00:21 | revisión de solo lectura (UI/UX) | [Evaluación de UI/UX de «Personas» con Impeccable y Stitch](M404-2026-11-21-evaluar-ui-ux-de-personas.md) |
| M406 | 2026-11-21 20:06:39 | herramientas de desarrollo | [Instalación de Impeccable y conexión con Google Stitch](M406-2026-11-21-instalar-impeccable-y-stitch.md) |
| M407 | 2026-11-21 20:56:32 | revisión de solo lectura (UI/UX) | [Auditoría de «Personas» con Impeccable y alternativa en Stitch](M407-2026-11-21-auditar-personas-con-impeccable-y-stitch.md) |
| M408 | 2026-11-21 21:03:39 | borrador documental (SDD) | [Borrador de GL-17 para la presentación del listado «Personas»](M408-2026-11-21-borrador-gl-17-presentacion-listado.md) |
| M410 | 2026-11-21 21:16:17 | borrador documental (SDD): correcciones y validación | [Correcciones del borrador de GL-17 y validación estricta](M410-2026-11-21-corregir-y-validar-gl-17.md) |
| M411 | 2026-11-21 21:21:28 | revisión visual y funcional (UI/UX) | [Revisión renderizada de «Personas» con Impeccable](M411-2026-11-21-revision-renderizada-de-personas.md) |
| M412 | 2026-11-21 21:31:46 | borrador documental (SDD): verificación, registro y validación | [Verificación de GL-17 y registro de la revisión renderizada](M412-2026-11-21-verificar-gl-17-y-registrar-revision.md) |
| M413 | 2026-11-21 21:38:21 | corrección del registro de prompts | [Numeración por posición en el registro de la revisión de UI](M413-2026-11-21-numeracion-por-posicion-del-registro.md) |
| M414 | 2026-11-21 21:41:16 | corrección del registro de prompts | [Numeración de M410 en el diseño de GL-17](M414-2026-11-21-numeracion-de-m410-en-diseno-gl-17.md) |
| M415 | 2026-11-21 21:45:53 | decisión de Pablo y actualización documental (SDD) | [Conformidad de Pablo con GL-17 y aprobación de P-54 y P-55](M415-2026-11-21-conformidad-gl-17-y-aprobacion-p54-p55.md) |
| M417 | 2026-11-21 23:00:38 | implementación (SDD), grupos 1 a 3 de GL-17 | [Implementación local de GL-17, grupos 1 a 3](M417-2026-11-21-implementar-gl-17-grupos-1-a-3.md) |
| M420 | 2026-11-22 12:49:02 | decisión de Pablo (conformidad visual, tarea 3.2) | [Conformidad visual de Pablo con GL-17](M420-2026-11-22-conformidad-visual-gl-17.md) |
| M423 | 2026-11-22 13:05:54 | publicación local (commit), sin push | [Commit local del paquete de GL-17](M423-2026-11-22-commit-local-gl-17.md) |
| M424 | 2026-11-22 13:09:29 | publicación (push) y CI remoto | [Publicación de GL-17 con push](M424-2026-11-22-push-gl-17.md) |
| M425 | 2026-11-22 13:14:34 | archivo de OpenSpec, local y sin commit | [Archivo local de GL-17](M425-2026-11-22-archivo-gl-17.md) |
| M426 | 2026-11-22 13:26:27 | publicación local (commit), sin push | [Commit local del archivo de GL-17](M426-2026-11-22-commit-archivo-gl-17.md) |

Evaluación de posibles mejoras de UI/UX de la pantalla «Personas». M404 a
M407 no implementan cambios ni pertenecen a ningún ticket: GL-13 y GL-14
están cerrados. M405 pidió seguir con un análisis equivalente en una
revisión local, sin esas herramientas, y se registra en M404 como
continuación. M407 repitió la auditoría con Impeccable y exploró una
alternativa en Stitch; como prohibía editar archivos, se registró en M408.
M408 abrió el borrador documental de GL-17 con las mejoras recomendadas.
M409 pidió copiar los documentos del borrador a `~/Descargas`, sin
registro propio. M410 corrigió el borrador según la revisión recibida y
ejecutó la validación estricta (tarea 0.2). M411 revisó la pantalla
renderizada con Impeccable y datos ficticios, y se registró en M412,
porque prohibía editar archivos. La respuesta de Pablo con la
contraseña de las cuentas ficticias (21:23 UTC) es una respuesta breve,
sin número ni registro. M412 verificó GL-17, registró M411 y validó.
M413 dejó la numeración por posición sin salvedades, y M414 hizo lo mismo
en el registro del diseño de GL-17. En M415 Pablo dio su conformidad
con GL-17 y aprobó P-54 y P-55 (tarea 0.3). M416 pidió solo la
validación estricta, sin registro propio. M417 autorizó e hizo la
implementación local de los grupos 1 a 3. Queda abierta la conformidad
visual de Pablo (tarea 3.2). M418 (copia a Descargas) y M419 (pregunta
por las imágenes) no tienen registro propio. En M420 Pablo dio su
conformidad visual y la 3.2 quedó completa. M421 y M422 prepararon y
ajustaron el stage, sin registro propio. M423 autorizó y creó el commit
local de GL-17, sin push. M424 lo publicó (`1c2f513`), con el CI
[45026017961](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/45026017961) en verde. M425 archivó
el cambio en local, con el delta aplicado a `people-browsing`, y M426
creó el commit local de ese archivo, sin push.

La numeración es por posición (opción A), confirmada por Pablo en M412
y M413. «logut» y «logout», enviados después de M406, son intentos de
comando y no se numeran; tampoco la respuesta breve con la contraseña.
