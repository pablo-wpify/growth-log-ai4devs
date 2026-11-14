# M207. Corregir la documentación de la entrega 2

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `revision-entrega-2` |
| Tipo | correcciones documentales |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `e42fbfd0e723defe12ee79bb7fc0b07a32be2635d2f999d324aa0ff2d1e10ad7` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M207 | 2026-11-14 20:34:21 |

## Texto original

````text
Aplicá las correcciones documentales necesarias para que la Entrega 2 de Growth Log sea clara y verificable por una persona externa, siguiendo la auditoría adjunta y las reglas oficiales de las Lecciones 1 y 2.

La rama de entrega es feature/entrega-2-pp. La entrega formal es rama publicada + Typeform; no requiere PR ni cambio de rama por defecto. El deploy es opcional. El repositorio es público y la revisión local es una alternativa válida si el README explica cómo ejecutar la aplicación y usar credenciales de prueba.

Corregí como mínimo:
- Las afirmaciones desactualizadas del README sobre pantallas, modelos, rutas, PRs y confiabilidad.
- Una sección breve «Cómo revisar esta entrega», con el camino para instalar, preparar datos y contraseña ficticia, iniciar la app, ejecutar la prueba E2E del núcleo y consultar el CI.
- La versión de Rails donde las referencias actuales no coincidan con la versión real.
- La frase obsoleta de la guía de desarrollo sobre GL-09 pendiente.
- El comando de sed para que funcione también en macOS y la claridad de la guía desde un clon limpio.
- El estado de GL-06 en prompts.md y la explicación de los saltos de numeración que se puedan documentar con evidencia.
- Una selección de 3 a 5 prompts o flujos clave de la Entrega 2, indicando herramientas, modelos, contexto avanzado y decisiones o ajustes humanos, según lo que exige la plataforma.
- La sección 9 del plan y las contradicciones actuales de CLAUDE.md señaladas en la auditoría.

No cambies código, datos, logs, la rama por defecto ni archivos históricos archivados. No inventes credenciales, historia, prompts, decisiones ni evidencia. Si una afirmación no se puede verificar, dejala claramente marcada como pendiente de confirmación.

Antes de editar, comprobá la rama y el estado del árbol. Después mostrámelo: archivos cambiados, resumen del diff y cualquier punto que siga abierto. No hagas stage, commit, push, deploy ni envíes el Typeform. No ejecutes pruebas ni auditorías; si necesitás validar enlaces o texto, hacelo con comprobaciones de solo lectura.
````

## Resultado registrado (no forma parte del pedido)

- **README:** resumen en lenguaje llano, sección «Cómo revisar esta entrega» (CI público, instalación desde un clon limpio, pruebas en navegador y recorrido manual con cuentas ficticias cuya contraseña elige quien revisa) y secciones de plantilla actualizadas: pantallas, stack, pruebas, modelo de datos, rutas, pull requests, confiabilidad, ADR y uso de IA.
- **Guía de desarrollo:** paso 0 para clonar la rama, mapa de pasos, gestor de Ruby, `sed -i.bak` también para macOS (no comprobado allí) y frase obsoleta sobre GL-09 corregida.
- **`prompts.md`:** fila de GL-06 actualizada, saltos de numeración explicados, etapa «Revisión de la entrega 2» y cinco flujos clave de la entrega 2 con herramientas, modelo, contexto avanzado y criterio humano.
- **Plan (sección 9), `CLAUDE.md` y `openspec/config.yaml`:** estado al cierre de GL-09, clasificación de `prompts.md` y versión de Rails 8.1.4.1.
- Sin cambios de código, datos, logs ni archivos archivados. Enlaces revisados con un script de solo lectura. Sin pruebas, validadores, stage, commit ni push.
- **Pendiente:** confirmar si se registran M195 a M201 y M203 a M205; la spec `runtime-toolchain` sigue diciendo Rails 8.1.4 (requiere un cambio de OpenSpec).
