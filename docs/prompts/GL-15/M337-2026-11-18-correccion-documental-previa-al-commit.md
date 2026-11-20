# M337. Corrección documental previa al commit

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-15` (entrega final) |
| Tipo | documentación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `ef0ff52b6f80e0eebdb875f15c19dfcc17f8eeceed6b09f338681b88a450a7d3` |
| Fecha y hora (UTC) | 2026-11-18 15:26:58 |

## Texto original

````text
Prepará una corrección documental previa al commit, sin hacer stage ni commit.

1. Actualizá docs/plan-entrega-final.md para reflejar el estado real de GL-15: implementado localmente, decisiones de diseño cerradas, verificaciones locales y conformidad visual registradas. No digas que está integrado, archivado ni publicado remotamente.
2. Actualizá los encabezados y estados obsoletos de los documentos GL-15. Reemplazá «sin implementar» o «sin autorizar» por estados precisos, sin afirmar integración o publicación.
3. En el delta de GL-15, resolvé la diferencia entre el aviso acordado «Feedback guardado como lista.» y el requisito vigente sobre el texto de los avisos. Conservá la privacidad de la entrada; dejá explícito que el aviso genérico modifica el criterio del texto del aviso, no la regla de privacidad. No cambies el aviso acordado.
4. En design.md, sección 3, corregí la descripción obsoleta del comportamiento del formulario para que coincida con la sección 8 y la implementación actual.
5. Registrá que las opciones de Señal y Dimensión se apilan verticalmente cuando hay errores, como observación visual pendiente; no cambies ese comportamiento.

No cambies código, GL-14, openspec/config.yaml ni el registro de prompts. No corras pruebas. Mostrame los diffs y el estado de Git. Dejá 3.1 y las tareas del grupo 4 abiertas, y no prepares el stage.
````

## Resultado registrado

**Numeración:** M337, por posición en la transcripción (opción A, decidida
por Pablo en M366).

Plan con GL-15 en local, sin commit; encabezados del ticket, la
propuesta, el diseño y las tareas con el estado preciso; sección
`MODIFIED Requirements` del delta de `feedback-capture` para el aviso
genérico; sección 3 del diseño alineada con la implementación. Sin stage
ni commit.
