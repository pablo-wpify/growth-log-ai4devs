# Proposal

> **Borrador documental (M408, 21/11/2026), corregido en M410 y revisado
> por Pablo en M415.** `openspec validate --all --strict`: 22 de 22
> (M410, tarea 0.2). P-54 y P-55 están aprobadas (tarea 0.3, M415;
> `docs/plan-entrega-final.md`, sección 5.4). **Implementado en local el
> 21/11/2026 (M417),** con la autorización de Pablo para los grupos 1 a 3
> (tarea 0.4): `bin/ci` en código 0 con 471 ejemplos; sin commit.
> **Conformidad visual de Pablo el 22/11/2026 (M420, tarea 3.2).** Falta
> publicar y archivar, con autorización para cada paso.

## Why

La auditoría de M407 encontró, en el listado «Personas» que dejó GL-14,
dos problemas de presentación que cuestan poco de resolver y entran en
las specs vigentes. El total y el aviso de privacidad, unidos con «·»,
se cortan en tres renglones a 375 px y se leen como una sola frase.
«Registrar la primera» es un enlace de texto junto a la píldora del
conteo: no se distingue como acción propia, un toque impreciso a su
alrededor abre la ficha y, por su alto de 44 px, esa fila es más alta
que las demás.

Fuente: `docs/tickets/GL-17-presentacion-listado-personas.md`.

## What Changes

1. **P-54.** El total («N personas que acompañás») y el aviso de
   privacidad se muestran en dos líneas apiladas, sin el separador «·».
   Sus textos y sus reglas no cambian.
2. **P-55.** «Registrar la primera» pasa a ser una acción secundaria
   pequeña, con el borde del botón común de `visual-language`, distinta
   del enlace de la fila y de la píldora del conteo, y sin aspecto de
   botón principal. Conserva los 44 px de alto.
3. **P-55.** Desde 40 rem de ancho, la fecha del último hecho, el conteo
   y «Registrar la primera» van a la derecha del nombre y de «rol ·
   equipo». Más angosto, siguen debajo, como pide «Listado en pantalla
   angosta».

Fuera de este cambio: los selects en una sola fila en móvil, que exigen
revisar «Listado en pantalla angosta»; el comportamiento de «Registrar la
primera», y cualquier texto, regla o token. Tampoco entran el listado
que empieza bajo en móvil ni el quiebre de la cabecera entre unos 600 y
767 px (M411 y M415). P-55 mejora la señal visual de «Registrar la
primera», pero no elimina que un toque fuera del botón pueda abrir la
ficha.

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `people-browsing`: se modifica «Total de personas y aviso de
  privacidad» y se agregan «"Registrar la primera" como acción
  secundaria» y «Detalles de la fila en pantalla ancha».

`feedback-capture`, `authorization` y `visual-language` no cambian.

## Impact

- **Código previsto (al implementar, con aprobación):**
  `app/views/people/index.html.erb` y las reglas del listado en
  `app/assets/stylesheets/application.css`. Sin cambios en
  controladores, helpers, consultas, rutas ni en el controlador Stimulus.
- **Pruebas previstas:** `spec/system/people_listing_spec.rb` (a 1280 y
  375 px, y a 640 y 639 px para el corte de 40 rem) y, si fijan la línea
  única del total,
  `spec/requests/people_listing_spec.rb`.
- **Sin dependencias, datos ni configuración nuevos.** Sin cambios de
  privacidad: el listado sigue mostrando lo mismo, con el mismo alcance.
