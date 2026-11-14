# M174. Preparar los ajustes previos a la publicación

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | propuestas para revisión |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `f0c49ad32b8b994f76ebe8334e30b0dae2021fe3232ac599af6314b7426bb299` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M174 | 2026-11-14 14:19:37 |
| M175 | 2026-11-14 14:41:56 |

## Texto original

````text
Antes de stage o publicación, prepará estos ajustes locales para revisar:

1. Alineá README y plan con el estado actual: gate local de 291 ejemplos y F17 parcial por decisión de Pablo.
2. Proponé el ajuste de docs/desarrollo.md para advertir que bin/ci ejecuta log:clear y vacía los logs correspondientes.
3. Identificá los prompts sin registrar y proponé su registro en un diff separado. No inventes ni reconstruyas mensajes que no estén disponibles.
4. Inspeccioná la base de la rama y el rango que incluiría un PR desde feature/entrega-2-pp. Recomendá una rama y base para GL-06 siguiendo el precedente de GL-05, pero no crees la rama todavía.
5. Proponé separar el commit de GL-06 del registro de prompts. Omití Co-Authored-By salvo que encuentres una convención explícita del proyecto.

No hagas stage, commit, fetch, push, CI remoto ni archivo. No ejecutes pruebas, validadores ni auditorías. Informá los diffs propuestos, la separación de commits y la base/rango del PR para revisión.
````

## Resultado registrado (no forma parte del pedido)

- **M174:** pedido en curso al preparar esta propuesta; el resultado se registra al terminar.
- **M175:** segundo envío del mismo texto (mismo SHA-256); no se repitió el trabajo: se sumó este envío a la propuesta de registro.
- Registrado después de su ejecución, en la propuesta de M174; el detalle está en la transcripción y en el diseño de GL-06.
