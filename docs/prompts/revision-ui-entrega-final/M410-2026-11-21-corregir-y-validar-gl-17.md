# M410. Correcciones del borrador de GL-17 y validación estricta

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | Revisión de UI de la entrega final |
| Tipo | borrador documental (SDD): correcciones y validación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `31169eb37d2598542b7e88c3bf23e9002c6028e7351e5323378af0d7da1d257d` |
| Fecha y hora (UTC) | 2026-11-21 21:16:17 |

## Texto original

````text
Corregí el borrador de GL-17 según la revisión recibida.

1. En el delta de people-browsing, acortá «Total de personas y aviso de privacidad» a menos de 500 caracteres con el criterio de OpenSpec: líneas recortadas, sin líneas vacías y unidas con saltos de línea. Conservá el alcance, los textos, el orden de las dos líneas, que el total no cambie al buscar o filtrar y el estado vacío. Usá como base esta redacción:

Con personas asignadas, «Personas» SHALL mostrar una vez, bajo el título y discretamente, el total («1 persona que acompañás» o «N personas que acompañás») y el aviso «Ves solo a quienes tenés asignados y las entradas que podés ver». El total y el aviso SHALL ir en líneas separadas, con el total arriba y sin separador. El total MUST contar las personas asignadas del alcance, sin variar con la búsqueda ni el filtro. Sin asignaciones, el mensaje vacío de 1.16 SHALL reemplazarlos.

Verificá y reportá el largo exacto. No cambies sus escenarios salvo que haya una inconsistencia necesaria.

2. Cubrí el corte responsive de 40 rem. Agregá un escenario al delta que compruebe el diseño en 40 rem y justo por debajo. Alineá con ese criterio el ticket, el diseño y las tareas 1.1 y 2.3. Mantené las pruebas a 1280 y 375 px, y los selects apilados en móvil.

3. Revisá que ticket, proposal, design, tasks y delta sigan contando lo mismo. No cambies GL-14 archivado ni las specs principales.

Después ejecutá únicamente `openspec validate --all --strict`, porque corresponde a la tarea 0.2. Pegá la salida completa y reportá el largo medido del requisito. No corras pruebas ni `bin/ci`.

Registrá este pedido y el resultado en docs/prompts según la numeración aprobada; si la ambigüedad de «logut»/«logout» impide asignar el número con seguridad, no renumeres M407 ni M408 y dejá la decisión pendiente.

No cambies código del producto, no marques la revisión 0.3 ni la aprobación 0.4, y no hagas stage, commit, push, PR, merge, deploy ni archive. Al final mostrame los archivos cambiados y el estado de Git.
````

## Resultado registrado

**Numeración:** M410, por posición (opción A; ver M407). M409
(21:11 UTC) es el pedido de copiar los documentos del borrador a
`~/Descargas/gl-17-borrador/`, sin registro propio.

- **Delta de `people-browsing`:** «Total de personas y aviso de
  privacidad» se reescribió sobre la redacción base del pedido y mide
  **482 caracteres**: líneas recortadas, sin líneas vacías y unidas con
  saltos de línea. Conserva los textos, las dos líneas con el total
  arriba, el total que no varía con la búsqueda ni el filtro, y el estado
  vacío. Sus escenarios no cambiaron. Los requisitos agregados miden 304
  («Registrar la primera» como acción secundaria) y 322 (detalles en
  pantalla ancha).
- **Corte de 40 rem:** se agregó el escenario «Corte en 40 rem», que
  compara 640 px (detalles a la derecha) con 639 px (detalles debajo),
  sin desplazamiento horizontal. Quedó alineado en el ticket (CA3 y
  riesgos), el diseño (D3 y riesgos) y las tareas 1.1 y 2.3. Se mantienen
  las pruebas a 1280 y 375 px y los selects apilados en móvil.
- **Coherencia:** se corrigieron tres diferencias. La propuesta ahora
  nombra las pruebas a 640 y 639 px. El CA1 del ticket dice «al buscar ni
  al filtrar». El diseño incluye la posición a 640 y 639 px en las
  pruebas que se suman.
- **Validación (tarea 0.2):** `openspec validate --all --strict`, con
  22 de 22 y código de salida 0, incluido
  `change/gl-17-presentacion-listado-personas`. La 0.2 quedó marcada; la
  0.3 y la 0.4 siguen abiertas. Los estados del ticket, la propuesta, el
  diseño y el plan se actualizaron.
- GL-14 archivado y las specs principales no se modificaron. Sin cambios
  de código, sin pruebas ni `bin/ci`, y sin stage, commit, push, PR,
  merge, deploy ni archivo.
