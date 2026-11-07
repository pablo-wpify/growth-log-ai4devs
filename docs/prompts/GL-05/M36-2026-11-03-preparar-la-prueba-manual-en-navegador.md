# M36. Preparar la prueba manual en navegador

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-05` |
| Tipo | pedido de preparación de la comprobación manual |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `e5a78ce68a5cf710b6b463f31b0958beb01cb819791716b35fd07109ca7af14a` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M36 | 2026-11-03 17:20:21 |

## Texto original

````text
Prepará las instrucciones para que yo pruebe GL-05 en el navegador.

Sin cambiar contraseñas ni datos:
- Confirmá que estamos en feature/GL-05-personas con la implementación en d9365c6.
- Consultá únicamente los IDs y nombres de las personas ficticias Ada y Carla creadas por GL-08.
- Dame sus URL completas en localhost:3000.
- Indicá cómo arrancar el servidor con el entorno local, sin mostrar valores de .env.
- Dame el comando completo para establecer la contraseña de Inés Muestra; lo ejecutaré yo en mi terminal. La contraseña de Elena ya está configurada.

Prepará una lista breve para comprobar:
1. Elena ve a Ada y Bruno, pero no a Carla ni Darío.
2. La ficha de Ada muestra nombre, rol y equipo, sin otros líderes.
3. La URL directa de Carla responde 404 para Elena.
4. El cierre de sesión funciona.
5. Inés ve el estado vacío.
6. A 375 px no hay desplazamiento horizontal.
7. El foco es visible al navegar con teclado.

Registrá este pedido según CLAUDE.md. No marques la prueba manual como realizada hasta que te informe sus resultados.

No hagas commits, push, PR, archivado ni modificaciones de la aplicación.
````

## Resultado registrado (no forma parte del pedido)

- Rama `feature/GL-05-personas` con HEAD `d9365c6` y el árbol limpio,
  confirmados antes de empezar.
- IDs leídos en la base de desarrollo, en una transacción de solo lectura y
  por las marcas de `sample_data_records`: Ada Ejemplo tiene el id 1 y Carla
  Ejemplo el id 3.
- Se entregaron a Pablo las URL, el arranque del servidor, el comando para
  la contraseña de Inés Muestra y una lista de siete comprobaciones.
- Sin cambios en contraseñas, datos ni aplicación. Sin commits, push, PR ni
  archivado.
- **Comprobación manual en navegador (E10): pendiente** hasta que Pablo
  informe los resultados.
