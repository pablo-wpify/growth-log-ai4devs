# M329. Capturas para la revisión visual

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | verificación visual |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `84a4b23be7a32a972938a6dff0dc8b2a4e70782e7150536e230120f17ca605d3` |
| Fecha y hora (UTC) | 2026-11-18 13:13:32 |

## Texto original

````text
Prepará una serie de capturas para mi revisión visual manual de GL-15. No modifiques archivos, datos, configuración ni el plan.

Usá la aplicación local y capturá el navegador en estos tamaños:
- Escritorio: viewport 1280 × 800.
- Móvil: viewport 375 × 812.

En cada tamaño, capturá:
1. La ficha de una persona, mostrando la jerarquía entre «Captura rápida» y «+ Feedback».
2. El formulario «+ Feedback» abierto dentro de la ficha, con la fecha precargada, los campos y las acciones visibles.
3. El formulario con errores de validación al intentar guardar como lista sin señal o dimensión. Incluí la URL visible para comprobar qué pasa después del error.

No guardes un feedback ni edites o borres datos persistentes. Si algún estado no se puede mostrar sin hacerlo, dejalo sin capturar y explicá por qué.

Guardá las imágenes en una carpeta nueva dentro de ~/Descargas, con nombres que indiquen viewport y estado. No sobrescribas capturas anteriores. No ejecutes pruebas ni CI, y no hagas stage, commit, push, PR, merge, deploy ni archive.

Al terminar, informá las rutas de las capturas y cualquier problema visual observado. No declares la tarea 3.3 completada: las capturas son evidencia para que yo las revise.
````

## Resultado registrado

**Numeración:** M329, por posición en la transcripción (opción A, decidida
por Pablo en M366).

Capturas a 1280 × 800 y 375 × 812 de la ficha, el formulario abierto y
los errores, en un entorno de prueba efímero dentro de una transacción
revertida, sin guardar datos persistentes (Pablo eligió «Entorno
efímero»). Guardadas en `~/Descargas/gl-15-capturas-20261118-101529`,
fuera del repositorio. Sin cambios en el repositorio.
