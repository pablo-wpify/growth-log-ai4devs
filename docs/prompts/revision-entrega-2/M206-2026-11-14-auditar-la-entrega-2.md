# M206. Auditar la entrega 2

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `revision-entrega-2` |
| Tipo | auditoría de solo lectura |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `91f5db1497aa6e9848b7a3575d8f9d4a553a157245a7b1c8c559034c74a93dd6` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M206 | 2026-11-14 20:28:29 |

## Texto original

````text
Hacé una auditoría exhaustiva, de solo lectura, de la Entrega 2 de Growth Log. Queremos que quede al nivel o mejor que la Entrega 1 y que un evaluador pueda entenderla, ejecutarla y verificarla sin depender de un deploy.

Revisá la rama feature/entrega-2-pp y contrastá:

1. Las reglas oficiales de las Lecciones 1 y 2 del proyecto final en la plataforma, si tenés acceso. Confirmá especialmente qué se entrega, cómo se entrega, qué debe incluir el repositorio y qué opciones hay para que el evaluador compruebe el funcionamiento. Si no podés consultar la plataforma, decilo y no inventes requisitos.
2. El README y prompts.md contra el estado real de la aplicación, el código, las rutas, las entidades, las pruebas, CI y los documentos vigentes.
3. La guía de desarrollo local: pasos desde un clon limpio, dependencias, variables, base de datos, datos y credenciales de prueba, cómo iniciar la aplicación y cómo ejecutar la suite.
4. La coherencia entre README, docs/desarrollo.md, plan, tickets, decisiones, OpenSpec y workflows. Buscá afirmaciones obsoletas, duplicadas o contradictorias, enlaces rotos, versiones distintas y requisitos pendientes presentados como terminados.
5. El checklist de Entrega 2: rama remota con el nombre requerido, documentación de Entrega 1 conservada y actualizada, scaffolds conectados, al menos un flujo principal operativo, ausencia de secretos y mecanismo claro para que LIDR pueda revisar el proyecto.
6. Qué evidencia tenemos de las pruebas automatizadas y E2E; separá lo comprobado en local, en CI remoto y en navegador.

No edites archivos ni datos. No hagas stage, commit, push, deploy, envíes el Typeform ni ejecutes pruebas, validadores o auditorías. Usá búsquedas y lecturas; si una comprobación pudiera modificar algo, no la ejecutes.

Entregá el resultado como:
- veredicto: listo / listo con ajustes / bloqueado;
- checklist requisito por requisito: cumple, parcial, no cumple o no verificable;
- hallazgos ordenados por gravedad, con archivo y línea, evidencia y corrección mínima propuesta;
- una lista corta de los cambios documentales necesarios para dejar el README y la guía claros para el evaluador;
- pasos externos pendientes, si los hay, como compartir acceso o enviar el Typeform.

No confundas tener el código en GitHub con tener la aplicación desplegada. La plataforma indica que el deploy de producción es opcional; verificá qué alternativa de revisión local o evidencia aplica para nuestro repositorio.
````

## Resultado registrado (no forma parte del pedido)

- Auditoría de solo lectura: veredicto «listo con ajustes». Sin acceso a la plataforma del curso: las reglas oficiales quedaron como no verificables. Hallazgos principales: secciones de plantilla del README desactualizadas, sin camino de revisión sin deploy, `prompts.md` con una fila obsoleta y saltos sin explicar, frase obsoleta y comando `sed` no portable en la guía, sección 9 del plan y versión de Rails.
- Sin archivos modificados, sin pruebas ni validadores.
- Registrado después, al ejecutar M207, según la regla de `CLAUDE.md`.
