# M412. Verificación de GL-17 y registro de la revisión renderizada

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | Revisión de UI de la entrega final |
| Tipo | borrador documental (SDD): verificación, registro y validación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `8ad69f40277963aec36ee9c61cd106343501103ef662e6c2f17f9b12b3c0e006` |
| Fecha y hora (UTC) | 2026-11-21 21:31:46 |

## Texto original

````text
Retomá GL-17 desde el estado actual. Antes, verificá rama, HEAD, stage y archivos modificados. Leé CLAUDE.md y los documentos de GL-17.

1. Actualizá el requisito MODIFIED «Total de personas y aviso de privacidad» para que quede debajo de 500 caracteres según el criterio de OpenSpec. Conservá su significado, sus textos y sus escenarios. Usá como base este texto:

Con personas asignadas, «Personas» SHALL mostrar una vez, bajo el título y discretamente, el total («1 persona que acompañás» o «N personas que acompañás») y el aviso «Ves solo a quienes tenés asignados y las entradas que podés ver». El total y el aviso SHALL ir en líneas separadas, con el total arriba y sin separador. El total MUST contar las personas asignadas del alcance, sin variar con la búsqueda ni el filtro. Sin asignaciones, el mensaje vacío de 1.16 SHALL reemplazarlos.

Medí y registrá el largo exacto con el criterio del validador. Mantené el texto igual en todos los documentos de GL-17 donde corresponda.

2. Cubrí el corte responsive de 40 rem y justo por debajo en el delta, el ticket, el diseño y las tareas 1.1 y 2.3. Conservá también las comprobaciones a 1280 y 375 px. No cambies la spec de pantalla angosta ni pongas los selects en una fila.

3. Registrá la auditoría renderizada en docs/prompts/revision-ui-entrega-final y actualizá sus índices. Incluí:
   - los anchos y estados efectivamente revisados;
   - el falso positivo de Impeccable sobre la paleta aprobada;
   - los hallazgos manuales, separando los que cubre GL-17 de los que quedan fuera;
   - los estados y datos que no se pudieron probar;
   - el efecto de la limpieza de cinco sesiones expiradas y la fila temporal en login_attempt_counters, aclarando que no se conoce su conteo previo y que las cuentas y entradas no cambiaron.
   
   Según la numeración aprobada, registrá la revisión anterior como M409 y este pedido como M410. No renumeres M407 ni M408. Contrastá los textos y SHA-256 con la transcripción local antes de registrarlos.

El quiebre de la cabecera entre 600 y 767 px y que el listado arranque bajo en móvil quedan como hallazgos separados: no los incorpores a GL-17 ni abras otro cambio.

Después ejecutá únicamente `openspec validate --all --strict` y pegá la salida completa. No corras pruebas ni `bin/ci`. No subas capturas ni código a Stitch.

No edites código del producto ni modifiques datos de la base. No marques la revisión de Pablo ni la aprobación para implementar. No hagas stage, commit, push, PR, merge, deploy ni archive. Al terminar, mostrame el diff documental, los archivos cambiados y el estado de Git.
````

## Resultado registrado

**Numeración:** el pedido proponía M409 para la revisión renderizada y
M410 para este pedido. La transcripción mostró que esos números ya
estaban usados: M409 es la copia a `~/Descargas` y M410, las correcciones
de GL-17, con su propio registro. Consultado, Pablo eligió numerar por
posición. La revisión renderizada es **M411**, su respuesta con la
contraseña es una respuesta breve sin número, y este pedido es **M412**.
M407 a M410 no se renumeraron. Los textos y los SHA-256 de M411 y M412 se
contrastaron con la transcripción local.

- **Estado inicial:** rama `feature/entrega-final-pp`, HEAD `63b86d0`,
  stage vacío y los mismos siete cambios sin commit del borrador.
- **Puntos 1 y 2:** ya estaban resueltos desde M410, así que no se
  hicieron cambios.
  - «Total de personas y aviso de privacidad» es idéntico al texto base
    y mide **482 caracteres** con el criterio del validador (líneas
    recortadas, sin líneas vacías y unidas con saltos de línea). No se
    transcribe en ningún otro documento de GL-17.
  - El corte de 640 y 639 px ya estaba en el delta, el ticket, el diseño
    y las tareas 1.1 y 2.3, junto con 1280 y 375 px. La spec de pantalla
    angosta y los selects apilados no cambiaron.
- **Punto 3:** la revisión renderizada quedó registrada en M411 y se
  actualizaron el README de la etapa y `prompts.md`. El quiebre de la
  cabecera y el arranque bajo del listado en móvil quedaron como
  hallazgos separados, fuera de GL-17 y sin cambio abierto.
- **Validación:** `openspec validate --all --strict` con 22 de 22 y
  código de salida 0.
- Sin cambios en el código del producto ni en la base; las tareas 0.3 y
  0.4 siguen abiertas. Sin pruebas ni `bin/ci`, sin subir nada a Stitch,
  y sin stage, commit, push, PR, merge, deploy ni archivo.
