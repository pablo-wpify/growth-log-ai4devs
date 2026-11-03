# M19. Ajustar el plan por el feedback de LIDR

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `replanificacion-lidr` |
| Tipo | pedido de planificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `3112d6d2501a749f6a5d318d23ecffde3986543a79e9b2b0829063957ed4dfe4` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M19 | 2026-11-03 01:25:39 |

## Texto original

````text
Ajustemos el plan de la entrega 2 a partir del feedback recibido de LIDR.

Trabajá en ~/code/ai4devs-entrega-1-pp, rama feature/entrega-2-pp. Primero inspeccioná el estado actual y conservá cualquier trabajo pendiente.

Decisión de producto aprobada:
- Conservamos GL-01, GL-01a y GL-02, ya cerrados.
- Priorizamos este recorrido:
  iniciar sesión → elegir una persona asignada → capturar una observación como borrador privado → completarla y marcarla como lista → consultar resumen por dimensión y cronología.
- Para el primer lote, cuentas, personas y asignaciones pueden prepararse con datos ficticios mediante semillas o consola.
- Diferimos invitaciones por correo, administración completa de personas y cuentas, protección del último administrador y revocación administrativa.
- Compartir y revocar por parte del autor quedan para un incremento posterior al núcleo.
- Lo diferido sigue siendo requisito pendiente; no se elimina ni se declara implementado.

El feedback recomienda además:
- Denegar por defecto y aplicar consultas con alcance.
- Probar que borrador y entrada lista siguen siendo privados.
- Una sola fuente de verdad para tickets y secuencia de trabajo.
- Cerrar dimensiones, señales y herramienta E2E.
- Mantener contexto de proyecto útil para la IA.

En este paso hacé únicamente planificación documental:

1. Contrastá estas decisiones con los requisitos y el plan vigentes. Identificá contradicciones y proponé los ajustes explícitos necesarios; no cambies silenciosamente reglas de privacidad.
2. Elegí un único documento como fuente vigente de la secuencia de trabajo. Aprovechá el existente si sirve y hacé que README y otros índices remitan a él, sin mantener planes duplicados.
3. Actualizá el plan y los tickets afectados:
   - autorización mínima necesaria;
   - preparación reproducible de datos ficticios;
   - selección de personas asignadas, sin CRUD administrativo;
   - captura rápida, completar y marcar como lista;
   - resumen y cronología;
   - verificación E2E del recorrido.
   Conservá los IDs existentes cuando sea posible y registrá los cambios de alcance. No reutilices un ID para un objetivo distinto sin aclararlo.
4. Delimitá GL-03 para que proteja ese recorrido sin adelantar compartición ni construir una plataforma genérica de permisos.
5. Prepará una tabla de decisiones pendientes: dimensiones, valores internos y etiquetas de señal —incluido neutral—, herramienta E2E y cualquier regla de asignación que realmente bloquee el núcleo. Recomendá opciones, sin darlas por aprobadas.
6. Revisá si existe CLAUDE.md y qué contexto aporta. Si falta o requiere cambios, proponé su contenido mínimo, sin tocar configuraciones personales ni ampliar permisos.
7. Definí qué evidencia demostrará que el recorrido funciona y que un líder no puede acceder a datos ajenos. Distinguí autenticación ya comprobada de autorización todavía pendiente.

No modifiques retrospectivamente la entrega 1 ni los archivos históricos de OpenSpec. Las aclaraciones del README se aplican solo en la rama de entrega 2.

No implementes código, semillas, migraciones ni dependencias. No hagas commits, push, PR ni despliegues.

Terminá con:
- el plan anterior frente al nuevo;
- archivos modificados;
- requisitos incluidos y diferidos;
- decisiones que necesiten aprobación;
- el próximo ticket concreto para continuar con SDD.
````

## Resultado registrado (no forma parte del pedido)

Plan y documentos sin commit en este paso; versionados en [`93b42ec`](https://github.com/pablo-wpify/growth-log-ai4devs/commit/93b42ec).
