# M264. Autorización para implementar GL-13

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-13` (entrega final) |
| Tipo | implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `ab529f5e5497fb5c2798b3c96c8848ce28e6d1f247e6f5d3a4be355e5ceabdd6` |
| Fecha y hora (UTC) | 2026-11-16 00:50:57 |

## Texto original

````text
Autorizo implementar GL-13 en la Entrega Final, según su documentación y las decisiones registradas hasta M263. Esta autorización es solo para GL-13; GL-14 sigue sin autorización para implementar.

Antes de empezar, confirmá la rama `feature/entrega-final-pp`, el HEAD y el estado de Git. Revisá el borrador vigente y sus tareas. Si hay cambios ajenos o el estado no coincide con lo esperado, frená y reportalo. No modifiques ningún archivo de la Entrega 2.

Implementá GL-13 siguiendo su plan y las pruebas primero. Respetá las decisiones P-34 a P-40, el aviso de privacidad como única adición de texto, las etiquetas actuales por entrada y la conservación del aspecto del login. La fuente serif debe ser OFL, local, y quedar con su licencia registrada.

No implementes GL-14 ni marques sus tareas. No hagas commit, push, PR, merge, deploy ni archivo. Al terminar, ejecutá las verificaciones que exige GL-13 y reportá archivos cambiados, pruebas y validaciones, riesgos pendientes y estado de Git. Dejá el resultado listo para revisión.
````

## Resultado registrado (no forma parte del pedido)

**Comprobaciones previas:** rama `feature/entrega-final-pp`, HEAD
`eabac8e`, con solo el borrador de GL-13 y GL-14 en el árbol.

**Detenido antes de escribir pruebas o código** por una contradicción
entre requisitos:

- la spec `sign-in-presentation` de GL-11, que no está archivada, exige
  que los campos y el botón del inicio de sesión tengan el mismo borde,
  radio, fondo y foco que los de la captura rápida y los demás botones
  (P-32); su prueba de sistema lo compara con estilos calculados;
- P-34 cambia el borde de los campos a `#857870` y el foco al color de la
  paleta, y el diseño hace de «Guardar borrador» un botón principal;
- P-40, tal como quedó registrada en M261, dice que GL-13 no modifica el
  inicio de sesión.

No pueden cumplirse las tres a la vez. Se consultó a Pablo con una
pregunta en la sesión. Eligió la opción recomendada: el inicio de sesión
hereda solo el borde de campos, el foco y el botón común que exige GL-11;
no suma tarjeta, marca, fondo ni tipografía nuevos, y «Guardar borrador»
queda como botón común. Se registró como precisión de P-40 en el plan, el
ticket, la propuesta, el diseño y las tareas.

**Implementación (local, sin commit):**

- estilos calculados y capturas de antes, fuera del repositorio;
- pruebas primero: `spec/requests/visual_language_spec.rb` y
  `spec/system/visual_language_spec.rb`; 11 de 17 ejemplos fallaron por
  las razones esperadas;
- `application.css` con los tokens y las reglas de `body.app`; Noto Serif
  Display Regular (OFL 1.1, copiada del sistema) con su `OFL.txt`; el
  layout, la ficha y el detalle de entrada;
- única prueba existente modificada: el color de foco esperado en
  `spec/system/sign_in_presentation_spec.rb`.

**Verificación (local):** `bundle exec rspec`, 400 ejemplos y 0 fallos;
`bin/bundler-audit update` y `bin/ci` con código 0;
`openspec validate --all --strict`, 22 de 22.

**Desvíos:** no se implementaron las migas, el avatar, el contador, la
ayuda de la captura ni la hoja de la marca, porque sumarían o cambiarían
textos. Las dos columnas empiezan en 72 rem. La fuente va como TTF
completa (548 KB). Detalle en el diseño, sección 12.

**Pendiente:** la comprobación manual de Pablo (tarea 3.3); commit, push,
PR y CI remoto con autorización. GL-14 sigue sin autorización y sin
cambios.
