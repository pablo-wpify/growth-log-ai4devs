# Proposal

> **Estado (18/11/2026): implementado en local, sin commit.** Decisiones
> de diseño cerradas; verificación local (specs y `bin/ci` en código 0) y
> conformidad visual de Pablo registradas (diseño, sección 8). Sin
> publicar, integrar ni archivar.

## Why

H2 pide registrar una entrada completa desde la ficha. Hoy solo existe la
captura rápida (GL-06), que pide el texto y guarda un borrador en una
página propia (P-22). Los criterios 2.1, 2.2 y 2.7 siguen sin cubrir desde
que P-11 difirió el formulario «+ Feedback» en la entrega 2. Es la tarea
T2.1 del Anexo G, que depende solo de T1.6, ya cumplida.

Fuente: `docs/tickets/GL-15-formulario-feedback.md`.

## What Changes

- La ficha de una persona asignada y activa ofrece «+ Feedback» como
  acción secundaria, además de «Captura rápida», que sigue como acción
  principal.
- «+ Feedback» abre en la misma página un formulario con todos los campos
  de una entrada: fecha del hecho (precargada con la fecha actual según
  la zona horaria de la aplicación, editable, y se guarda la elegida),
  contexto, señal,
  dimensión, evidencia, impacto y confianza. Sin JavaScript, el enlace y
  el formulario funcionan como una página común.
- El formulario se guarda con «Guardar borrador» o «Guardar como lista».
  En un borrador, señal y dimensión son opcionales; como lista, se exigen
  las dos (P-3). Un estado desconocido es un error de validación.
- Al guardar, vuelve a la ficha con un aviso de éxito; con errores, el
  formulario se vuelve a mostrar con los errores. «Cancelar» vuelve a la
  ficha sin guardar.
- Las rutas siguen la convención existente de la aplicación; la URL no es
  un requisito de producto.
- La entrada creada tiene la misma autoría, privacidad y autorización que
  las de la captura rápida.
- La ficha deja de prohibir «+ Feedback» entre sus acciones.

No cambian la captura rápida, P-22, el modelo ni la base. La técnica es
una decisión de implementación: Turbo Frames con las versiones de Rails y
Turbo que ya tiene el proyecto, sin dependencias nuevas, sin JavaScript
propio y sin Turbo Streams (diseño, sección 3).

## Capabilities

### New Capabilities

Ninguna.

### Modified Capabilities

- `feedback-capture`: se agregan seis requisitos: el acceso
  «+ Feedback», el formulario completo en la ficha, la fecha de hoy, la
  restricción a la asignación activa, el guardado como borrador o como
  lista y sus validaciones. Además, «Textos que separan "lista" de
  "compartida"» cambia solo en el criterio del texto de los avisos, para
  admitir el aviso genérico «Feedback guardado como lista.»; la regla de
  privacidad no cambia.
- `people-browsing`: el requisito «Solo lectura y sin funciones
  inexistentes» suma «+ Feedback» a las acciones de la ficha y lo quita de
  las funciones inexistentes.

## Trazabilidad

| Criterio (Anexo A) | Requisito | Tareas |
|---|---|---|
| 2.1 | `feedback-capture`: «Acceso visible a "+ Feedback"» y «Formulario completo en la ficha»; `people-browsing`: «Solo lectura y sin funciones inexistentes» | 1.1, 1.3, 1.4, 2.1, 2.2, 2.4 |
| 2.2 | `feedback-capture`: «Fecha de hoy en el formulario» | 1.1, 1.2, 1.3, 2.2, 2.3 |
| 2.7 | `feedback-capture`: «Guardar como borrador o como lista» | 1.2, 1.3, 2.3 |
| 2.3 (incluido en T2.1) | `feedback-capture`: «Validaciones del formulario completo» | 1.2, 2.3 |
| 2.4, 2.5 (incluidos en T2.1) | `feedback-capture`: «Formulario completo en la ficha» | 1.1, 1.2, 2.2 |
| 2.6 y P-3 | `feedback-capture`: «Validaciones del formulario completo» | 1.2, 2.3 |
| 2.8, 2.9 | `feedback-capture`: «Guardar como borrador o como lista» | 1.2, 2.3 |
| 2.10 y P-20 (incluido en T2.1) | `feedback-capture`: «Formulario solo con asignación activa» | 1.1, 1.2, 2.1 |

## Impact

- **Código, cuando se autorice:** rutas de entradas bajo la persona, el
  controlador de entradas, la vista de la ficha y una vista nueva del
  formulario. Sin migraciones.
- **Pruebas:** de peticiones y de sistema, con y sin JavaScript.
- **Specs:** deltas de `feedback-capture` y `people-browsing`.
- **Superposición con GL-14:** los dos cambios modifican el mismo
  requisito de `people-browsing`. GL-15 va primero; al completarlo se
  ajusta el delta de GL-14 para que los dos queden compatibles (diseño,
  sección 6).
