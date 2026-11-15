# M241. Cambio de seguridad para los avisos de `msgpack` y Puma

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-12` |
| Tipo | documentación SDD e implementación autorizada |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `19d89fb11cca719559f083935612166ceaab04de644c63ac02c0f07a5b6b13ff` (del texto del mensaje fuente) |

| Envío | Fecha y hora (UTC) |
|---|---|
| M241 | 2026-11-15 15:07:27 |

## Texto original

````text
Autorizo tratar estos avisos en un cambio de seguridad separado de GL-11. Prepará la documentación SDD correspondiente e implementá una actualización dirigida de `msgpack` y `puma`.

Seguí `CLAUDE.md`, los `AGENTS.md` aplicables y las reglas del proyecto. No leas ni muestres `.env`, secretos, credenciales ni valores de variables.

## Preflight y aislamiento

1. Informá rama, HEAD y estado completo de Git. El estado esperado incluye cambios locales no comprometidos de GL-10 (M237) y GL-11 (M236, M238, M239 y M240). Preservalos intactos.
2. Si hay cambios inesperados, detenete e informá. No hagas checkout, reset ni stash.
3. Trabajá en el checkout actual sin modificar archivos propios de GL-11. Los únicos cambios compartidos permitidos son los necesarios en `Gemfile.lock`, el plan y el registro de prompts.
4. No borres `Gemfile.lock` ni elimines restricciones del `Gemfile`.

## SDD e implementación autorizada

- Usá el siguiente ID disponible en `docs/plan-entrega-2.md` para el ticket de seguridad.
- Prepará el ticket y los documentos OpenSpec que correspondan. Esta instrucción autoriza implementar el cambio dirigido sin esperar otra aprobación.
- Registrá este pedido con el siguiente número disponible de prompts. No reconstruyas M218–M235.

Antes de actualizar, confirmá en el lockfile las versiones y plataformas exactas de `msgpack` y `puma`, y verificá los identificadores de los avisos contra sus fuentes oficiales:

- msgpack: CVE-2026-126366 / GHSA-73v3-wf97-vpgj. El aviso describe el decoder para JRuby; registrá esa condición al evaluar su aplicabilidad. Corrección publicada: 1.8.7.
- Puma: GHSA-rf6g-xhmp-gm7v. Correcciones publicadas: 7.2.2 y 8.0.3. Comprobá si la configuración y topología de esta aplicación cambian la exposición; no des por hecha una mitigación de Render sin evidencia.

Hacé una actualización dirigida de `msgpack` y `puma` —por ejemplo, `bundle update msgpack puma`— sin resolver todas las dependencias desde cero. Conservá el lockfile y revisá cualquier cambio transitivo. Elegí una versión corregida compatible con el proyecto; si Bundler propone una versión mayor o hay conflictos, documentá la razón y el resultado, sin ampliar la actualización por tu cuenta.

## Verificación y límites

Actualizá la base de avisos con el comando previsto por el proyecto y ejecutá `bin/ci` y `openspec validate --all --strict`. Revisá el diff para confirmar que no se actualizaron gemas ajenas al alcance y que los cambios GL-10/GL-11 siguen intactos.

No cambies la interfaz ni la lógica de GL-11. No modifiques Render ni los datos demo. No hagas stage, commit, push, PR, merge, deploy ni archivo.

Al terminar, informá las versiones anteriores y nuevas, los avisos que se resolvieron o que sigan aplicando, el resultado de las verificaciones y el estado completo de Git.
````

## Resultado registrado (no forma parte del pedido)

- **Estado previo:** rama `feature/entrega-2-pp`, HEAD `6177aef`, sin cambios staged. Los cambios locales eran idénticos al estado final de M240: GL-10 (M237) y GL-11 (M236, M238 a M240).
- **Lockfile antes:** `msgpack` 1.8.6 y `puma` 8.0.2, una entrada cada una, sin variantes por plataforma (`PLATFORMS` sin `java`). Checksums iguales a los de RubyGems.
- **Avisos verificados** en la GitHub Advisory Database (`msgpack`) y en los avisos de `puma/puma`:
  - CVE-2026-126366 / GHSA-73v3-wf97-vpgj, alta, corregido en 1.8.7. Afecta al decoder de JRuby y no aplica en la práctica (CRuby 4.0.9).
  - GHSA-rf6g-xhmp-gm7v, alta, corregido en 7.2.2 y 8.0.3. Aplica.
  - De los otros seis avisos de Puma, tres aplican y uno aplica en parte (la rama de archivos de más de 64 KB). No aplican GHSA-86xc-wrr9-xmmq ni GHSA-r885-m39c-939g. No se asumió ninguna mitigación de Render.
- **Actualización:** `bundle update msgpack puma --conservative --patch` llevó `msgpack` a 1.8.7 y `puma` a 8.0.3, sin conflictos.
  - Solo cambiaron 4 líneas del lockfile, sin cambios transitivos ni en el `Gemfile`.
  - Los checksums coinciden con RubyGems.
  - Puma 8.1.x quedó fuera por ser una versión menor nueva.
- **Verificación:**
  - `bin/bundler-audit update` y `bin/bundler-audit`: «No vulnerabilities found».
  - `bin/ci` con código 0: RuboCop sin ofensas, Importmap, Brakeman con 0 avisos y RSpec con 383 ejemplos y 0 fallos.
  - `openspec validate --all --strict`: 21 de 21.
- **Documentación:** ticket `GL-12`, cambio `gl-12-avisos-msgpack-puma` con `skip_specs: true`, y el plan en las secciones 2, 3, 5 y 9. La fila de GL-11 y su pendiente en la sección 9 ahora remiten a GL-12.
- **Intactos:** los archivos de GL-10 y GL-11 (SHA-256 comparados). No se cambió la interfaz ni la lógica.
- **Pendiente, con su autorización:** commit, CI remoto, merge, el deploy en Render (la demo sigue con Puma 8.0.2) y el archivo. La tarea 3.2 de GL-11 sigue sin marcar en sus propios archivos, que este pedido no modificó.
- Sin stage, commit, push, PR, merge, deploy ni archivo. M218 a M235 siguen sin registrar.
