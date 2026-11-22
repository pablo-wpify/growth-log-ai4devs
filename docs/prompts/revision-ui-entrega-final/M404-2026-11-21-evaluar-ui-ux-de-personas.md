# M404. Evaluación de UI/UX de «Personas» con Impeccable y Stitch

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | Revisión de UI de la entrega final |
| Tipo | revisión de solo lectura (UI/UX) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `27f54cb4e372d6db3ea8f10da80c347719e384b9d72d0c81262d3d5efc3e8b4a` |
| Fecha y hora (UTC) | 2026-11-21 20:00:21 |

## Texto original

````text
Quiero evaluar si hay mejoras de UI/UX en Growlog usando Impeccable y Stitch, sin implementar cambios todavía.

1. Revisá el estado del repositorio y localizá la pantalla actual de «Personas». No cambies código ni documentos del producto.
2. Usá Impeccable para analizar la interfaz actual: jerarquía visual, espaciado, contraste, responsive y claridad de las acciones. Separá hallazgos concretos de sugerencias.
3. Usá Stitch para explorar una o dos alternativas visuales para esa misma pantalla. Conservá los flujos y la identidad visual existentes; no tomes el diseño generado como una especificación.
4. Compará las alternativas con la interfaz actual e indicá qué mejoras valdría la pena considerar y cuáles no, con sus motivos.
5. Usá únicamente capturas y datos ficticios o anonimizados. Si alguna herramienta requiere enviar datos reales de usuarios o feedback fuera del entorno local, detenete y avisá antes de hacerlo.
6. No edites ni implementes nada. No corras pruebas. No hagas stage, commit, push, PR, merge ni deploy.
7. Registrá este pedido literalmente en docs/prompts, siguiendo la numeración, el formato y los índices vigentes del repositorio. Verificá el estado de Git y mostrame el resultado del análisis, el registro y el diff.
````

## Resultado registrado

**Numeración:** M404, por posición en la transcripción (opción A, decidida
por Pablo en M366). M403, el mensaje anterior, es el diagnóstico de solo
lectura de la demo en Render y no tiene registro propio.

Detenido en el paso 2: ni Impeccable ni Stitch están disponibles en la
sesión. No hay una skill, un plugin, un servidor MCP ni un comando con esos
nombres. La pantalla «Personas» quedó localizada
(`app/views/people/index.html.erb`, con sus estilos en
`app/assets/stylesheets/application.css` y su controlador Stimulus en
`app/javascript/controllers/people_list_controller.js`). No se envió nada
fuera del entorno local, no se analizó la interfaz con otras herramientas
y no se cambiaron código ni documentos del producto. Se le preguntó a
Pablo cómo seguir.

**Continuación (M405, 21/11/2026):** Pablo eligió un análisis
equivalente. Se hizo con una **revisión local**, sin Impeccable ni Stitch,
que no estaban disponibles:
- sobre las seis capturas de «Personas» a 1280 y 375 px (listado, foco y
  sin resultados), con datos ficticios, tomadas en M395;
- y sobre los estilos y tokens del código en `ca2d5da`, con los
  contrastes calculados con la fórmula WCAG 2.x.

No se tomaron capturas nuevas, no se corrieron pruebas y no se envió nada
fuera del entorno local. La captura sin resultados es anterior al ajuste
que oculta la lista vacía.

Hallazgos:
1. A 375 px, los controles y el texto del encabezado empujan la primera
   fila a unos 500 de 760 px.
2. Las filas sin entradas son más altas por el alto mínimo de
   «Registrar la primera».
3. En móvil, el espacio de la fila alrededor de «Registrar la primera»
   abre la ficha, así que un toque impreciso lleva a otro destino.
4. El total y el aviso van en una sola línea con «·», que a 375 px se
   corta en tres renglones.
5. El separador entre filas y la píldora de conteo tienen poco contraste
   con el fondo, aunque eso es decorativo y no incumple WCAG.

Se propusieron dos alternativas como maquetas de texto, sin carácter de
especificación:
- A: controles compactos en móvil. Choca con «Listado en pantalla
  angosta» y necesitaría cambiar esa spec.
- B: estado a la derecha desde 40 rem y «Registrar la primera» como
  acción secundaria con un borde, dentro de las specs vigentes.

Sin cambios en el producto.
