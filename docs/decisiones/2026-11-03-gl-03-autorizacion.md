# Decisiones de GL-03 (aprobadas el 02/11/2026)

> Aprobadas por Pablo al revisar el
> [plan de la entrega 2](../plan-entrega-2.md#61-detalle-de-las-decisiones-que-abren-gl-03)
> antes de abrir [GL-03](../tickets/GL-03-autorizacion-minima.md). Completan
> el borrador de ADR-3 del
> [Anexo D](../../anexos/anexo-d-decisiones-arquitectura.md), que no se
> modifica.

| # | Decisión | Estado |
|---|---|---|
| ADR-3 (P-5) | Pundit 2.5.2, con política base que deniega y alcance base vacío, verificación de autorización y de alcance en cada acción, excepciones por acción concreta y 404 ante un acceso denegado, igual que ante un recurso inexistente. Las verificaciones detectan omisiones; las reglas las comprueban las pruebas de comportamiento | aprobada |
| P-7 | Se conservan PP-9 y AM-1: la lectura de las entradas propias no depende de una asignación activa; la escritura sí. El acceso desde la interfaz del autor sin asignación y sus datos mínimos quedan pendientes | aprobada |
| P-8 | Una asignación activa por par líder y persona, con un índice único parcial; una persona puede tener varios líderes | aprobada |
| P-9 | Estados independientes de persona, asignación y cuenta; la ficha de una persona inactiva responde 404 y se conserva la lectura de las entradas propias | aprobada |

**Precisión durante la implementación (03/11/2026):** las excepciones se
declaran por acción. Solo `SessionsController#new` y `#create`, que se
ejecutan sin cuenta identificada, omiten las verificaciones; el cierre de
sesión se autoriza con `SessionPolicy`.
