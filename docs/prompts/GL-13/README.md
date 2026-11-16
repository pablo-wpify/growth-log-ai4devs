# Prompts: GL-13. Dirección visual (entrega final)

> Índice general: [prompts.md](../../../prompts.md), sección «Entrega
> final». Cada archivo separa los metadatos, el **texto original** del
> pedido y el **resultado registrado**, que no forma parte del pedido.

## Pedidos enviados a Claude Code

| Mensaje | Fecha y hora (UTC) | Tipo | Archivo |
|---|---|---|---|
| M254 | 2026-11-15 21:23:46 | fase documental | [Borrador SDD de la dirección visual](M254-2026-11-15-borrador-sdd-de-la-direccion-visual.md) |
| M255 y M256 | 2026-11-15 22:22:11 y 22:23:36 | ampliación del borrador | [Mejoras del listado «Personas»](M255-2026-11-15-mejoras-del-listado-personas.md) |
| M257 | 2026-11-15 23:39:46 | separación del borrador | «Separación de GL-13 y GL-14», registrado en GL-14: `docs/prompts/GL-14/M257-2026-11-15-separacion-gl-13-y-gl-14.md`. Las mejoras funcionales del listado pasaron a ese ticket |
| M261 | 2026-11-16 00:19:51 | decisiones | [Decisiones P-34, P-35 y P-38 a P-40](M261-2026-11-16-decisiones-p34-p35-y-p38-a-p40.md) |
| M263 | 2026-11-16 00:43:40 | corrección documental | [Correcciones del aviso de privacidad de la ficha](M263-2026-11-16-correcciones-aviso-de-la-ficha.md) |
| M264 | 2026-11-16 00:50:57 | implementación | [Autorización para implementar GL-13](M264-2026-11-16-autorizacion-implementacion-gl-13.md) |
| M265 | 2026-11-16 10:50:16 | implementación | [Correcciones de la revisión visual](M265-2026-11-16-correcciones-revision-visual.md) |
| M266 | 2026-11-16 11:35:52 | decisión | [Precisión de P-40: el botón y los campos del login](M266-2026-11-16-precision-p40-boton-login.md). Incluye las capturas de M265 como evidencia del estado sin cambios (agregado en M267) y la verificación posterior con `bin/ci` (agregado en M271) |
| M267 | 2026-11-16 11:59:10 | documentación | [Evidencia visual de M265 en el registro de M266](M267-2026-11-16-evidencia-visual-m265-en-m266.md) |
| M270 | 2026-11-16 12:18:49 | verificación | [Verificación de `bin/ci` después de M266](M270-2026-11-16-verificacion-bin-ci-despues-de-m266.md). Registrado en M271 |
| M271 | 2026-11-16 12:24:16 | documentación | [Registro de la verificación de `bin/ci`](M271-2026-11-16-registro-verificacion-bin-ci.md) |
| M272 | 2026-11-16 12:30:16 | conformidad | [Conformidad visual de Pablo con GL-13](M272-2026-11-16-conformidad-visual-de-pablo.md). Cierra la tarea 3.3 sobre las capturas de M265 |
| M274 | 2026-11-16 13:26:03 | documentación | [Preparación de GL-13 para la revisión final de publicación](M274-2026-11-16-preparacion-revision-final-publicacion.md) |
| M276 | 2026-11-16 15:44:12 | documentación | [Candidato actualizado de publicación de GL-13](M276-2026-11-16-candidato-actualizado-publicacion.md). El pedido decía M275; Pablo eligió la numeración por posición |
| M277 | 2026-11-16 15:55:34 | documentación | [Ajuste del candidato de GL-13 para que sea autosuficiente](M277-2026-11-16-ajuste-autosuficiencia-del-candidato.md) |

## Mensajes previos de esta etapa, sin archivo propio

| Mensaje | Fecha y hora (UTC) | Texto o motivo |
|---|---|---|
| M250 | 2026-11-15 21:19:26 | Primera versión del pedido. Ubicaba la secuencia en `docs/plan-entrega-2.md` y el registro según la entrega 2. **Reemplazada por M254**, por eso no se archiva por separado. Antes del reemplazo quedaron escritos el delta de la spec, el ticket y la propuesta, que después se corrigieron |
| M251 | 2026-11-15 21:22:59 | «espera» (literal) |
| M252 | 2026-11-15 21:23:29 | «me equivoque con el prompt» (literal) |
| M253 | 2026-11-15 21:23:43 | «debe ir este, estamos en la entrega final» (literal) |
| M260 | 2026-11-16 00:12:29 | Revisión de solo lectura de P-34, P-35 y P-38 a P-40. El pedido prohibía editar archivos, así que no se registró al hacerse; su registro queda pendiente de la autorización de Pablo |
| M262 | 2026-11-16 00:39:12 | «podes poner los diff en Descargas?» (literal). Se copiaron los diffs a `~/Descargas`, fuera del repositorio |
| M268 | 2026-11-16 12:06:54 | «guardaste capturas?» (literal). Respuesta sin cambios: en M267 no se guardaron capturas nuevas; las de M265 están en la carpeta temporal de la sesión y en `~/Descargas/gl-13-capturas/m265/` |
| M269 | 2026-11-16 12:13:02 | Revisión final de solo lectura de GL-13: estado de Git, alcance, registros M264 a M267, capturas y validaciones. El pedido prohibía modificar archivos, así que no se registró al hacerse; su registro queda pendiente de la autorización de Pablo, como M260 |
| M273 | 2026-11-16 13:12:45 | Paquete de revisión separado por alcance, generado en `~/Descargas` (dos patches y dos inventarios de texto). El pedido prohibía modificar el repositorio, así que no se registró al hacerse; su registro queda pendiente de la autorización de Pablo, como M269 |
| M275 | 2026-11-16 13:46:04 | Reenvío idéntico de M274 (mismo SHA-256, `3f02392d…4cec`). Respuesta sin cambios en el repositorio: se comprobó que el estado y el candidato de M274 seguían vigentes. Su texto es el de M274 |

**Numeración.** El número sale de la posición en la transcripción, con el
mismo procedimiento que en la entrega 2. M251 y M254 llegaron en cola
mientras se ejecutaba el pedido anterior. Se numeran por su hora de
entrada.

## Conversación de acompañamiento

**No aportada.** Según declaración de Pablo, los pedidos pegados se
prepararon con ChatGPT en una conversación de acompañamiento que no está
aportada como archivo. Su modelo no está verificado y no se reconstruye.
