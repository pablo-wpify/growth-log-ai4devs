# M242. Commit, push y deploy manual de GL-10, GL-11 y GL-12

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `publicacion-gl-10-a-gl-12` |
| Tipo | publicación y deploy autorizados |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `c33c72bbbda42af1df6e6d2c27ea94834bb5c0c6d6600b93e12bbbf877402209` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M242 | 2026-11-15 15:24:22 |

## Texto original

````text
Autorizo hacer commit, push y deploy manual de los cambios locales de GL-10, GL-11 y GL-12 en `feature/entrega-2-pp`, y verificar visualmente el formulario desplegado. No autorizo abrir PR, hacer merge ni archivar cambios.

Seguí `CLAUDE.md` y los `AGENTS.md` aplicables. No leas ni muestres `.env`, secretos, credenciales ni valores de variables.

## 1. Preflight

- Confirmá rama, HEAD y estado completo de Git. Se esperan cambios locales de GL-10 (M237), GL-11 (M236, M238–M240) y GL-12 (M241), sobre `6177aef`.
- Comprobá que no haya cambios inesperados y que la rama remota no haya avanzado desde ese HEAD. Si el estado no coincide, detenete e informá.
- No hagas checkout, reset ni stash.
- Leé el ticket y el diseño de GL-12. Hacé una única comprobación acotada de los avisos Puma que allí se mencionan: contrastá sus identificadores completos y rangos afectados con Puma 8.0.3 y la configuración efectiva de la app. Si alguno sigue afectando a esa versión y configuración, detenete antes del deploy e informá solo ese hallazgo. No amplíes la revisión a otras dependencias.
- Confirmá que el servicio de Render sigue apuntando a `feature/entrega-2-pp` y que el deploy es manual. No abras ni muestres valores de variables.

## 2. Verificación final y documentación

- Ejecutá `bin/bundler-audit update`, `bin/ci` y `openspec validate --all --strict`.
- Actualizá la tarea 3.2 de GL-11 con la evidencia de `bin/ci` en verde. Conservá como pendientes las tareas que no hayas comprobado.
- Registrá este pedido con el siguiente número disponible en `docs/prompts/` y actualizá `prompts.md`. No reconstruyas M218–M235.
- Revisá el diff completo para confirmar que GL-10, GL-11 y GL-12 están completos y que no hay cambios ajenos.

Si las verificaciones locales pasan, prepará commits lógicos separados por ticket. Staging solo por nombre de archivo; revisá cada stage con `git diff --cached` antes de confirmarlo. No uses `git add -A`.

## 3. Push, CI remoto y deploy

- Pusheá los commits a `growth-log-publico/feature/entrega-2-pp`.
- Esperá a que el CI remoto termine. Si falla cualquier job, no despliegues; informá el error.
- Con el CI en verde, iniciá el deploy manual del último SHA en el servicio existente de Render. No cambies configuración ni variables.
- Si el deploy falla, detenete y reportá el fallo. No alteres la configuración para remediarlo.

## 4. Comprobación visual

Cuando el servicio esté Live, abrí `/session/new` y comprobá el formulario a 1280 px y 375 px: etiquetas sobre los campos, ancho máximo de 24 rem en escritorio, ancho adaptable en móvil, botón debajo y alineado, y foco visible. No inicies sesión ni envíes credenciales.

Informá los commits y SHA, resultado del CI remoto, SHA desplegado, estado del deploy y resultado visual. No archives GL-10, GL-11 ni GL-12.
````

## Resultado registrado (no forma parte del pedido)

- **Preflight:** rama `feature/entrega-2-pp`, HEAD `6177aef`, igual a la remota (0 adelante, 0 atrás). Las 31 entradas de `git status` eran las esperadas de GL-10 (M237), GL-11 (M236, M238 a M240) y GL-12 (M241).
- **Avisos de Puma:** los siete avisos del diseño de GL-12 tienen el rango afectado `>= 8.0.0, < 8.0.3` en la línea 8, según el repositorio `puma/puma`. Puma 8.0.3, la versión efectiva, queda fuera. No hubo motivo para detenerse.
- **Render:** el servicio apunta a `feature/entrega-2-pp` con Auto-Deploy en Off. No se abrieron valores de variables.
- **Verificación local:** `bin/bundler-audit update` y `bin/ci` con código 0 (383 ejemplos, 0 fallos; auditoría sin vulnerabilidades); `openspec validate --all --strict`, 21 de 21. Tarea 3.2 de GL-11 marcada.
- **Commits, CI remoto y deploy:** en curso; se completa con la evidencia final.
