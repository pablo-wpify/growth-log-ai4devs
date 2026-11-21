# M383. Decisión sobre los textos de GL-14 y revisión de los requisitos

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-14` (entrega final) |
| Tipo | revisión de solo lectura (decisión) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `0f7ba25cb3c1c353a30788197d65fd6c335768105f0aa77732141d2c0d454336` |
| Fecha y hora (UTC) | 2026-11-21 12:28:54 |

## Texto original

````text
Tomo la decisión de conservar en el delta de GL-14 los textos de escenarios que describen el comportamiento esperado después del cambio. No copies literalmente los THEN de la spec vigente si describen el comportamiento anterior: al archivar, la spec principal debe reflejar el estado final de GL-14.

Hacé una revisión de solo lectura de los tres requisitos MODIFIED y los tres ADDED que se discutieron. Confirmá que:
- los escenarios originales estén conservados por nombre en los requisitos MODIFIED;
- sus resultados describan el comportamiento previsto por GL-14;
- los requisitos ADDED tengan escenarios propios y no contradigan ese comportamiento;
- `proposal.md` describa correctamente cómo quedaron distribuidos.

La validación estricta ya pasó 22 de 22; no la repitas. No edites archivos, no marques 0.4 ni 0.6, no corras pruebas y no hagas stage, commit ni push. Mostrame las conclusiones y el estado de Git.
````

## Resultado registrado

**Numeración:** M383, por posición en la transcripción (opción A, decidida
por Pablo en M366).

Decisión de Pablo: los escenarios restaurados en los requisitos
`MODIFIED` conservan los textos de GL-14 y no los `THEN` de la spec
vigente, que describen el comportamiento anterior. La revisión de solo
lectura confirmó que los escenarios originales siguen por nombre en los
requisitos `MODIFIED`, que sus resultados describen el comportamiento de
GL-14, que los requisitos `ADDED` tienen escenarios propios sin
contradecirlo y que `proposal.md` describe bien la distribución. Señaló
dos detalles menores de redacción: «sin textos de pantalla» en la
propuesta y la falta de «Limpiar filtros» en el escenario «Acciones
disponibles». Sin cambios en archivos ni validación.
