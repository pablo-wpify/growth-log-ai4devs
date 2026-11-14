# Decisiones de GL-07 (14/11/2026)

> Decididas por Pablo para
> [GL-07](../tickets/GL-07-resumen-cronologia.md) a partir de la ficha de
> decisiones de M191 (registro de prompts de GL-07). Aprueban P-10 del
> [plan de la entrega 2](../plan-entrega-2.md#6-decisiones-pendientes-de-aprobación)
> y fijan el alcance parcial de cuatro criterios. Ajustan el ticket y el
> cambio de OpenSpec `gl-07-resumen-cronologia`. Registrarlas no autorizó
> la implementación: Pablo aprobó el cambio después, el 14/11/2026 (M194).

| # | Decisión | Alternativa descartada | Estado |
|---|---|---|---|
| P-10 | Cronología por fecha del hecho, de la más antigua a la más reciente; en empate, por `created_at` y después por `id`, ambos ascendentes. Los borradores propios aparecen marcados «Borrador · solo vos · fuera del resumen» y no cuentan en el resumen ni en el conteo. La cronología reemplaza la sección provisoria «Tus entradas» de P-21 | solo entradas listas en la cronología | aprobada |
| 4.3 (parcial) | Se muestran solo entradas propias, con el estado existente «… · solo vos». El resumen no lleva columna «Origen». Distinguir las entradas compartidas conmigo queda para I4 | columna «Origen» y etiquetas «Tuya · privada» del mock 1 | decidida |
| 4.5 | Texto del resumen: «Solo entradas listas. No es un puntaje: reúne evidencia para la conversación» | — | decidida |
| 4.4 | Sin entradas propias listas sobre la persona, en lugar del resumen se muestra «Todavía no hay entradas listas para el resumen». La cronología sin entradas reutiliza «Todavía no registraste entradas sobre <nombre>». El resumen omite las dimensiones sin datos | mostrar el mensaje solo cuando no hay ninguna entrada propia; mostrar todas las dimensiones | decidida |
| 1.15 (parcial) | Cada fila de «Personas» muestra «N entradas listas», también «0 entradas listas», contando solo las entradas propias listas | omitir el conteo cuando es 0 | decidida |

**Detalles confirmados por Pablo (14/11/2026, M193):**

| Punto | Decisión | Alternativa descartada |
|---|---|---|
| Texto del conteo | «1 entrada lista» para uno; «N entradas listas» para cero o más de uno | «1 entradas listas» |
| Ubicación del conteo | en cada fila de «Personas», después de «rol · equipo» | — |
| Contenido de la cronología | fecha del hecho, estado, señal y dimensión (como el mock 1), comienzo del contexto y enlace al detalle | sin señal ni dimensión |
| Orden del resumen | filas en el orden de la lista de dimensiones de P-1 | — |
| Títulos | «Resumen por dimensión» y «Vista cronológica», del mock 1 | — |
| Mutaciones | cuatro, enumeradas y vinculadas con la consulta y el criterio que protegen (diseño del cambio, «Mutaciones») | solo la del alcance del resumen |

**Consecuencias registradas:**

- **P-10:** el desempate invierte el de P-21 (`occurred_on`, `created_at` e
  `id`), que en la sección provisoria era descendente. El cambio elimina el
  requisito «Entradas propias en la ficha» de `feedback-capture` y agrega
  la cronología.
- **4.3, 4.2, 4.12 y 4.13 quedan parciales:** solo entradas propias. El
  origen «compartida con vos» (columna «Origen» y etiquetas de
  compartidas) sigue siendo requisito pendiente (I4).
- **1.15 queda parcial:** el conteo no incluye compartidas (I4). Con 3.3,
  un borrador no cuenta ni para su autor.
- **4.4:** con solo borradores sobre la persona, el resumen muestra el
  mensaje y la cronología muestra los borradores.

**Sin cambios:** P-1, P-2, P-3, P-11 y P-19 a P-26; PP-1 a PP-9, D1, D2,
D5 y AM-1 a AM-5. P-2 (aprobada el 12/11/2026) fija las columnas del
resumen: Positivos, A mejorar, Neutrales y Total.

**Diferido, sigue siendo requisito:** los filtros 4.6 y 4.7 (I6) y el
origen «compartida con vos» (I4).

**Fuera de GL-07:** la prueba E2E en navegador y la herramienta (P-4,
ADR-6) pertenecen a GL-09.

**Sin preguntas abiertas** después de M193.
