# M326. Corrección del aviso y comprobación del helper

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | implementación (corrección dentro de la autorización de M325) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `13127e5c947d55e19a055e7c5c2d23c532ac6ac328cfd49334345abc6975aad8` |
| Fecha y hora (UTC) | 2026-11-18 11:54:07 |

## Texto original

````text
El informe que acabás de devolver no refleja las instrucciones acordadas. Corregí solo estos dos puntos, sin repetir la implementación:

1. El aviso debe ser exactamente «Feedback guardado como lista.». En la sección 4.3 y la tarea 0.6, aclarà que este aviso genérico no revela contenido ni identidad y por eso no es una excepción al requisito general de privacidad. No afirmes «Solo vos podés verlo.» ni cambies la regla general de privacidad.
2. Confirmá estáticamente que config/routes.rb define el helper person_complete_feedback_entry_path usado por las vistas. Leé el archivo de rutas directamente; no cargues .env ni arranques la aplicación. Si no podés confirmarlo estáticamente, decilo sin suponer.

No cambies otros criterios ni archivos fuera de GL-15. No ejecutes pruebas, CI ni auditorías; no actualices la base de avisos de bundler-audit. No hagas stage, commit, push, PR, merge, deploy ni archive. Mostrame únicamente el diff de esta corrección y el estado final de Git.
````

## Resultado registrado

**Numeración:** M326, por posición en la transcripción (opción A, decidida
por Pablo en M366).

El aviso de lista quedó exactamente en «Feedback guardado como lista.»
en el controlador, las pruebas y la documentación, con el delta
`MODIFIED` de «Textos que separan "lista" de "compartida"» limitado al
criterio del texto de los avisos. El nombre del helper
`person_complete_feedback_entry_path` se comprobó leyendo el código de
`actionpack`, sin cargar `.env`. Sin pruebas ni commit.
