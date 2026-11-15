# M240. Aprobar P-32 y P-33 e implementar GL-11

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-11` |
| Tipo | decisiones y autorización de implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `f8c05fde0936a43e1ffd40885f1955c922750983ca00c333207b6a03d89c13c7` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M240 | 2026-11-15 14:37:22 |

## Texto original

````text
Autorizo las siguientes decisiones para GL-11:

- **P-32 aprobada:** usar las pantallas internas existentes como referencia visual, sin crear un mock nuevo del login.
- **P-33 aprobada:** limitar el formulario a `max-width: 24rem` en escritorio y permitir ancho fluido en pantallas más estrechas.
- **Autorizo implementar GL-11** según el ticket, el diseño, la spec y las tareas revisadas.

Seguí `CLAUDE.md`, los `AGENTS.md` aplicables y el flujo SDD del proyecto.

## Antes de implementar

- Confirmá rama, HEAD y estado completo de Git.
- El estado esperado es la rama `feature/entrega-2-pp`, con HEAD `6177aef`; existen cambios locales documentales de GL-10 (M237) y GL-11 (M236, M238 y M239).
- Confirmá que esos cambios coincidan con lo revisado. Si aparece algún cambio inesperado, detenete e informá. No hagas checkout, reset ni stash.
- No leas ni muestres `.env`, secretos, credenciales ni valores de variables.

## Implementación

Leé el ticket y el cambio OpenSpec de GL-11 completos antes de editar. Trabajá solo dentro de su alcance:

- Mejorá la presentación de `/session/new` con el estilo existente de Growth Log.
- Usá ancho máximo de `24rem` en escritorio y ancho fluido en móvil.
- Poné cada etiqueta encima de su campo y el botón «Iniciar sesión» debajo de la contraseña, alineado con los campos.
- Conservá foco visible, tamaños táctiles mínimos de 44 px y el aviso de error genérico.
- No señales qué credencial falló ni marques un campo específico como inválido.
- No cambies autenticación, sesiones, límites de intentos, rutas, privacidad ni el comportamiento de otras pantallas.
- Evitá selectores globales que alteren los formularios existentes.

Seguí las tareas aprobadas y el enfoque de pruebas primero del proyecto. Verificá escritorio a 1280 px y pantalla estrecha a 375 px, incluidos los estilos de las pantallas de captura y edición que las tareas indican conservar.

Actualizá las tareas y el registro documental de GL-11 con evidencia real. Registrá este prompt con el siguiente número disponible en `docs/prompts/` y actualizá `prompts.md`; no reconstruyas M218–M235. Actualizá P-32 y P-33 como aprobadas según esta autorización.

## Límites

No modifiques GL-10 salvo las secciones compartidas de `docs/plan-entrega-2.md` o `prompts.md` que deban reflejar GL-11. No archives ningún cambio.

No cambies configuración de Render, datos ni servicios. No hagas stage, commit, push, PR, merge ni deploy.

Al terminar, ejecutá las verificaciones requeridas por el proyecto, incluida `bin/ci` y `openspec validate --all --strict` si están disponibles. Informá archivos, resultados, diff completo y estado final de Git. Dejá el cambio sin commit ni publicación.
````

## Resultado registrado (no forma parte del pedido)

- **Estado previo:** rama `feature/entrega-2-pp`, HEAD `6177aef`, sin cambios staged. Los cambios locales eran idénticos a lo revisado en M239: GL-10 (M237) y GL-11 (M236, M238 y M239).
- **Decisiones registradas:** P-32 y P-33 aprobadas por Pablo (plan, sección 6; tareas 0.4 y 0.4b) y la implementación autorizada (tarea 0.5).
- **Pruebas primero:**
  - `spec/requests/sign_in_presentation_spec.rb` (6 ejemplos) y `spec/system/sign_in_presentation_spec.rb` (9 ejemplos).
  - Con la vista original fallaron 13 de 15 por la razón esperada.
  - Antes de tocar la hoja se registraron los estilos calculados de la captura rápida y de la edición de una entrada, a 1280 y 375 px.
- **Implementación:**
  - `app/views/sessions/new.html.erb`: clases `sign-in-form`, `field` y `error-summary`. El aviso conserva `role="alert"` y su texto genérico; ningún campo se marca como inválido.
  - `app/assets/stylesheets/application.css`: reglas solo dentro de `.sign-in-form`, con `max-width: 24rem` y ancho fluido.
  - Sin cambios en autenticación, rutas ni otras pantallas.
- **Verificación:**
  - Pruebas nuevas: 15 de 15.
  - Mutaciones M1 a M3 detectadas.
  - Estilos de las pantallas internas idénticos antes y después.
  - Capturas a 1280 y 375 px revisadas.
  - `bin/ci` con **código 1**, solo por la auditoría de gemas: avisos nuevos en `msgpack` 1.8.6 y `puma` 8.0.2, ajenos a GL-11 (`Gemfile.lock` sin cambios). RuboCop, Importmap, Brakeman y RSpec (383 ejemplos, 0 fallos) pasaron.
  - `openspec validate --all --strict`, 20 de 20.
- **Desvíos:**
  - Dos aserciones de la prueba de peticiones se corrigieron después de implementar (`:has` no admitido por Nokogiri y un documento que se volvía a parsear). Se confirmó de nuevo que fallan con la vista original.
  - No se agruparon selectores con `.entry-form`: se usó una regla propia.
- **Pendiente:**
  - la decisión de Pablo sobre los avisos de gemas para llevar el gate a código 0;
  - la comprobación manual (3.3);
  - el commit, el CI remoto, el merge, el deploy y el archivo, cada uno con su autorización.
- Sin cambios en Render, datos ni servicios. Sin stage, commit, push, PR, merge ni deploy. M218 a M235 siguen sin registrar.
