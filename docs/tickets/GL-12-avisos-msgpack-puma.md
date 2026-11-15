# GL-12. `msgpack` 1.8.7 y Puma 8.0.3 por los avisos de seguridad de noviembre de 2026

> Ticket de seguridad separado de GL-11, como
> [GL-01a](GL-01a-avisos-seguridad.md) y [GL-01b](GL-01b-rails-8-1-4-1.md).
> Lugar en la secuencia: [plan de la entrega 2](../plan-entrega-2.md).
> Cambio de OpenSpec: [`gl-12-avisos-msgpack-puma`](../../openspec/changes/gl-12-avisos-msgpack-puma/proposal.md).
> **Estado (15/11/2026): implementado en local, sin commit (M241).**
> - Pedido y autorizado por Pablo en M241: documentación SDD e
>   implementación dirigida, sin esperar otra aprobación.
> - `bin/ci` con código 0 (383 ejemplos, 0 fallos; auditoría sin
>   vulnerabilidades).
> - Pendientes: commit, CI remoto, merge, deploy en Render y archivo, cada
>   uno con su autorización.

## Problema

El 15/11/2026, durante la verificación de GL-11 (M240), `bin/ci` terminó
con código 1 solo por la auditoría de gemas. Después de
`bin/bundler-audit update`, la base de avisos informaba ocho avisos:

- `msgpack` 1.8.6: CVE-2026-126366 (GHSA-73v3-wf97-vpgj);
- `puma` 8.0.2: siete avisos publicados el 13/11/2026.

`Gemfile.lock` no había cambiado desde el merge `6177aef`, cuyo CI había
pasado. Los avisos se publicaron después. Mientras sigan, `bin/ci` y el CI
remoto fallan para cualquier cambio, también para GL-11.

## Objetivo

Volver a satisfacer la auditoría de gemas de `bin/ci` con una actualización
dirigida de `msgpack` y `puma` a versiones corregidas, sin tocar el
`Gemfile` ni otras gemas.

## Alcance

- `Gemfile.lock`: `msgpack` de 1.8.6 a 1.8.7 y `puma` de 8.0.2 a 8.0.3, con
  `bundle update msgpack puma --conservative --patch`.
- Evaluación de la exposición de la aplicación a cada aviso, en el
  [diseño](../../openspec/changes/gl-12-avisos-msgpack-puma/design.md).

## Exclusiones

- El `Gemfile`, otras gemas, Ruby, Bundler y la configuración de Puma.
- Puma 8.1.x: es una versión menor nueva, no necesaria para corregir los
  avisos (ver el diseño, decisión 1).
- La interfaz y la lógica de GL-11, y los archivos de GL-10.
- Render: el deploy de la versión corregida en la demo lo hace Pablo, con
  su autorización.

## Criterios de aceptación

- **CA1.** `Gemfile.lock` cambia solo en `msgpack` y `puma` (versión y
  checksum). Ninguna dependencia transitiva cambia.
- **CA2.** Los checksums nuevos coinciden con los publicados en RubyGems.
- **CA3.** Con la base de avisos actualizada, `bin/bundler-audit` no
  informa vulnerabilidades.
- **CA4.** `bin/ci` termina con código 0 y `openspec validate --all
  --strict` pasa.
- **CA5.** El `Gemfile` y los cambios locales de GL-10 y GL-11 quedan
  intactos.

## Dependencias

- Ninguna decisión bloquea el cambio: la autorización está en M241, que
  pide elegir una versión corregida compatible (ver el diseño).

## Riesgos

- **Puma 8.0.3 en Render:** la demo de GL-10 sigue con 8.0.2 hasta un
  deploy manual. Entre tanto, la exposición evaluada en el diseño sigue
  aplicando allí.
- **Cambios de comportamiento en un parche de Puma:** se cubren con la
  suite completa. Las pruebas de sistema corren sobre Puma.
