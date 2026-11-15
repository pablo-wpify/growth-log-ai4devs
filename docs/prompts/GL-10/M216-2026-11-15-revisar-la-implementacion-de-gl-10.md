# M216. Revisar la implementación de GL-10

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-10` |
| Tipo | revisión de solo lectura |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `3536ee0ff018e6fe85f4cb8a30971d0a64181cfa667c535f4c7149ec43d1ef88` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M216 | 2026-11-15 00:25:06 |

## Texto original

````text
Revisá en modo de solo lectura la implementación local de GL-10 y el diff completo /tmp/claude-1000/-home-pablo/fc6b72ea-b092-4b92-9662-025005e93cf7/scratchpad/gl10/gl10-implementacion.diff.

Contrastá el código y las pruebas con design.md, tasks.md, el ticket y las specs. Inspeccioná especialmente:
- que GL-08 siga restringido a development;
- que la tarea no consulte la base antes de validar entorno e indicador;
- que detecte datos ajenos antes de escribir, y que repetición y concurrencia no adopten, sobrescriban ni borren datos;
- que las contraseñas solo se lean al crear cuentas, no aparezcan en logs y no se sobrescriban;
- que bin/render-build.sh migre antes de cargar datos y solo invoque la tarea con el indicador exacto;
- permisos ejecutables del script, migración y db/schema.rb;
- que las pruebas usen exclusivamente la base de test y no contacten Render.
Verificá rama, HEAD y git status; si la base no es feature/entrega-2-pp en e5d678f, o aparecen cambios inesperados, detenete. No edites, no ejecutes pruebas, validadores ni auditorías. No hagas stage, commit, push ni cambios en Render. Informá hallazgos bloqueantes, riesgos pendientes —incluidos Ruby 4.0.9 y la conexión desde el build— y los archivos que entrarían en cada commit.
````

## Resultado registrado (no forma parte del pedido)

- **Revisión de solo lectura** de la implementación local de GL-10. El diff revisado coincidía con el árbol, sobre `feature/entrega-2-pp` en `e5d678f`.
- **Sin hallazgos bloqueantes.** Se verificaron:
  - GL-08 sin cambios;
  - la guarda antes de consultar la base;
  - la revisión de datos ajenos antes de escribir;
  - la repetición y la concurrencia sin adoptar, sobrescribir ni borrar;
  - las contraseñas leídas solo al crear;
  - el orden del script;
  - los permisos `755` del script;
  - la migración y `db/schema.rb`;
  - las pruebas solo contra la base de test.
- **Hallazgos no bloqueantes:**
  1. el script invoca la tarea con cualquier valor del indicador, y la tarea se niega si no es el exacto;
  2. `DemoData::Stop` sin usos;
  3. faltaban los comandos de build y arranque de Render en la documentación;
  4. los identificadores R se repetían entre los criterios del ticket y los riesgos del diseño;
  5. la precedencia de `DATABASE_URL` no se probó con credenciales distintas.
- **Riesgos informados:** R1 (conexión desde el build), R9 (Ruby 4.0.9 en Render), memoria del plan Free, secretos en el panel, vencimiento de la base, P-30 y el CI remoto.
- **Commits propuestos:** `feat` con código, pruebas y documentación (25 archivos) y `docs` con los prompts.
- Sin ediciones, pruebas ni validadores.
