# M15. Cerrar la discrepancia del límite por correo

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-02` |
| Tipo | corrección |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `d8eb0726c1bfb184b327c20b4f2f7771b26b0dedb01fb540c7520a6a9cd2f937` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M15 | 2026-11-02 22:40:43 |

## Texto original

````text
Antes de publicar GL-02, cerrá la discrepancia del límite por correo.

Revisá el requisito aprobado:
- Si exige como máximo cinco intentos fallidos por ventana, la implementación debe hacerlo cumplir también bajo concurrencia. Corregí y agregá una prueba determinista.
- Si el requisito admite un límite aproximado, mostrámelo con su referencia y explicá cuánto puede excederse. No cambies el requisito para acomodarlo al código ni des por aceptada una tolerancia nueva.

Conservá PostgreSQL como almacén compartido: la evidencia presentada justifica reemplazar FileStore.

Sobre la contraseña expuesta:
- Registrá que era exclusiva de una cuenta ficticia ya eliminada.
- No la reproduzcas.
- No afirmes que tachar la evidencia elimina la exposición histórica.

Si hace falta corregir código, ejecutá las pruebas correspondientes y bin/ci, y guardá la corrección en un commit local separado.

No hagas push ni archives todavía. Informá el resultado y el SHA final que debemos publicar.
````

## Resultado registrado (no forma parte del pedido)

Commit [`9131b29`](https://github.com/pablo-wpify/growth-log-ai4devs/commit/9131b29). La exposición de una contraseña ficticia ocurrió en una salida de herramienta de esta etapa, no en este pedido; está registrada en el diseño archivado de GL-02 y no se reproduce aquí.
