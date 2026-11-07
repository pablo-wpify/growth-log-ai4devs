# M38. Proponer la actualización a Rails 8.1.4.1

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-01b` |
| Tipo | pedido de planificación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `0320368c4965953e30aa858960322ff463304c7d56ac602407316bdc9d263438` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M38 | 2026-11-06 22:00:41 |

## Texto original

````text
Prepará una propuesta SDD separada para actualizar Growth Log de Rails 8.1.4 a 8.1.4.1 por los avisos de seguridad publicados el 4/11/2026.

Usá el repositorio y el estado actuales solo para inspeccionar. Leé CLAUDE.md, Gemfile, Gemfile.lock, docs/plan-entrega-2.md y la configuración de CI. No leas `.env`, credenciales ni secretos.

No modifiques archivos del repositorio ni cambies dependencias, lockfile o código. No ejecutes actualizaciones ni pruebas, y no hagas commits, push, PR ni despliegues. No mezcles esta tarea con GL-05.

Prepará en tu respuesta un borrador de ticket que incluya:
- alcance mínimo para llevar Rails y sus componentes necesarios a la versión corregida, evitando actualizaciones ajenas a la remediación;
- qué avisos podrían aplicar a Growth Log según las dependencias y funciones que efectivamente usa, y qué no se puede confirmar sin una revisión adicional;
- criterios de aceptación y plan de verificación, incluidos Bundler Audit, `bin/ci` y CI remoto;
- riesgos de compatibilidad y pasos para revisar el diff del lockfile.

Tomá como referencia el anuncio oficial:
https://rubyonrails.org/2026/11/4/Rails-8.0.5.2-and-8.1.4.1-have-been-released

Si encontrás algo que contradiga la versión objetivo o requiera ampliar el alcance, señalalo en la propuesta; no lo resuelvas modificando el proyecto. Dejá la actualización de dependencias pendiente de una autorización explícita posterior.
````

## Resultado registrado (no forma parte del pedido)

- La propuesta se entregó solo en la respuesta, sin archivos. El pedido
  prohibía modificar el repositorio, por eso este registro se hizo después,
  en M39.
- Sin cambios de dependencias, lockfile ni código; sin pruebas, commits,
  push ni PR.
- M39 corrigió la propuesta: el criterio del lockfile, la aplicabilidad
  según cada advisory, la fuente de los checksums, P-18 sin aprobar y el CI
  remoto pendiente.
