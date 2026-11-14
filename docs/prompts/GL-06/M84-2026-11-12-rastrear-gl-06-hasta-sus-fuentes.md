# M84. Rastrear GL-06 hasta sus fuentes

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-06` |
| Tipo | pedido de análisis (solo lectura) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `a11a349c38de61bad743537ea57b3f549edb32194e8ed4e1903e9658c86788ec` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M84 | 2026-11-12 20:37:59 |

## Texto original

````text
Vamos a preparar GL-06 con el nivel de detalle de TASK-012, pero iterando sobre las definiciones existentes de Growth Log.

Hacé primero un rastreo de solo lectura en `~/code/ai4devs-entrega-1-pp`, sobre la rama actual `feature/entrega-2-pp`. Usá también el worktree auxiliar solo si contiene fuentes necesarias que no estén en la rama principal. No hagas `fetch`, no cambies de rama y no modifiques archivos.

Rastreá GL-06 hacia atrás hasta sus fuentes:
- H2 y los criterios 2.1–2.10 y 4.8, 4.9 y 4.11;
- T1.5, T2.1 y T1.7;
- la lista de dimensiones y las decisiones P-1, P-2, P-3 y P-11;
- las decisiones y specs aprobadas de privacidad, acceso, borradores, estados y logging;
- GL-05, como dependencia ya integrada;
- GL-07, para detectar qué contrato necesita GL-06 y qué corresponde dejar fuera.

Leé las fuentes completas que sean pertinentes: plan vigente, specs OpenSpec, ADRs, criterios, tickets y registros de decisiones. No tomes `growth-log-alcance-entrega-2.md` como fuente vigente sin contrastarlo: hay una revisión posterior que detectó errores en ese análisis.

Devolveme primero un mapa de trazabilidad con estas columnas:
1. Requisito o decisión.
2. Fuente y sección exacta.
3. Estado: aprobado, implementado, propuesto, abierto o contradictorio.
4. Efecto concreto sobre GL-06.
5. Evidencia textual breve.

Para P-1, P-2, P-3 y P-11, transcribí su pregunta y opciones tal como aparecen en las fuentes, indicá si hay propuestas previas y señalá qué decisión falta. No elijas opciones ni conviertas propuestas en aprobaciones. Conservá las decisiones cerradas sin reabrirlas.

Después proponé un esqueleto de spec/ticket GL-06, no su versión final: objetivo, alcance, exclusiones, dependencias, contratos por capa, escenarios de aceptación, privacidad, pruebas y Definition of Done. Marcá como bloqueados los puntos que dependan de decisiones todavía abiertas. Usá TASK-012 solo como referencia de rigor; no copies decisiones, stack ni estructura que no correspondan a Growth Log.

No edites ni crees archivos. No ejecutes la app ni las pruebas; no marques tareas, commits, push ni PR. Si una fuente no existe o no podés verificarla, decilo y seguí con lo que sí se pueda documentar.
````

## Resultado registrado (no forma parte del pedido)

- Mapa de trazabilidad y esqueleto de GL-06 entregados en la
  conversación, sin modificar archivos.
- Hallazgos: el GL-06 vigente sigue el camino de H3 (T1.5, T1.6, T1.7 y
  T2.2), no el de H2 del plan anterior; P-1, P-2, P-3 y P-11 sin aprobar;
  la regla de entradas de GL-03 solo estaba en su diseño; la spec
  `people-browsing` prohíbe la captura rápida en la ficha; el filtro de
  logs no cubre el texto del feedback; seis puntos sin decisión, que M85
  convirtió en las propuestas P-19 a P-24.
- TASK-012 no se identificó como fuente única (varios archivos con ese
  nombre en otros repositorios); se usó solo como referencia de rigor.
- Registrado al ejecutar M85, según la regla de `CLAUDE.md`; M85 no lo pidió de forma explícita.
