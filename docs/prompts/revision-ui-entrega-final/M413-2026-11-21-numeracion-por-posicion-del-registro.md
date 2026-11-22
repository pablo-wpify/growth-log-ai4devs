# M413. Numeración por posición en el registro de la revisión de UI

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | Revisión de UI de la entrega final |
| Tipo | corrección del registro de prompts |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `c025ecab11ebaffd094c3a345fc5be8d4b55c597c6582c41500d9065be1cbaa6` |
| Fecha y hora (UTC) | 2026-11-21 21:38:21 |

## Texto original

````text
Corregí únicamente la documentación del registro de prompts de la revisión UI de GL-17.

La numeración adoptada es por posición. Verificá la transcripción y dejá consistente la secuencia:
- M407: auditoría inicial.
- M408: borrador de GL-17.
- M409: pedido de copia a Descargas, sin archivo propio.
- M410: correcciones del borrador de GL-17.
- M411: revisión renderizada.
- La respuesta breve que contenía la contraseña no se numera ni se transcribe.
- M412: verificación de GL-17 y registro de la revisión.
- Este pedido es M413.

Quitá las referencias a que M409 es provisional y a que la numeración de M407/M408 sigue pendiente. Actualizá todos los lugares que expresen esas salvedades, incluidos el resultado de M407, el resultado de M408, el README de la etapa y prompts.md. No cambies los textos originales de los pedidos ni sus SHA-256, y no renumeres ningún registro existente.

Registrá este pedido y su resultado como M413 siguiendo el formato habitual; verificá el texto y el SHA-256 contra la transcripción.

Antes de editar, informá rama, HEAD y estado de Git. Al terminar, mostrame los diffs y los archivos modificados. No cambies documentos del producto, código ni el cambio GL-17. No repitas openspec validate, no corras pruebas ni bin/ci, y no hagas stage, commit, push, PR, merge, deploy ni archive.
````

## Resultado registrado

**Numeración:** M413, por posición (opción A; ver M407).

- **Estado inicial:** rama `feature/entrega-final-pp`, HEAD `63b86d0`,
  stage vacío y los mismos siete cambios sin commit.
- **Secuencia verificada** contra la transcripción local:
  - M407 (20:56 UTC), auditoría inicial;
  - M408 (21:03), borrador de GL-17;
  - M409 (21:11), copia a `~/Descargas`, sin archivo propio;
  - M410 (21:16), correcciones del borrador;
  - M411 (21:21), revisión renderizada;
  - respuesta breve con la contraseña (21:23), sin número ni
    transcripción;
  - M412 (21:31), verificación de GL-17 y registro de la revisión;
  - M413 (21:38), este pedido.

  «logut» y «logout», de la sesión anterior, no se numeran.
- **Salvedades quitadas:** los avisos de que M409 era provisional y de
  que la numeración de M407 y M408 estaba pendiente. Se corrigieron en el
  resultado de M407, M408 y M410, en el README de la etapa y en
  `prompts.md`.
- Los textos originales, sus SHA-256 y los números existentes no
  cambiaron.
- **Fuera del alcance:** el registro del diseño de GL-17
  (`openspec/changes/gl-17-presentacion-listado-personas/design.md`,
  entrada M410) todavía dice que M410 es un número provisional. No se
  corrigió porque el pedido excluía el cambio de GL-17.
- Sin cambios en documentos del producto, código ni el cambio de GL-17.
  Sin `openspec validate`, pruebas ni `bin/ci`, y sin stage, commit,
  push, PR, merge, deploy ni archivo.
