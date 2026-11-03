# M35. Aprobar e implementar GL-05

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | `GL-05` |
| Tipo | aprobación e implementación |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | Texto pegado. Según declaración de Pablo, preparado con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado. |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `8e5e57bfdcad4239163a45a324a5aa3df750f0a1078dfc906ecb00e029690d38` |

| Envío | Fecha y hora (UTC) |
|---|---|
| M35 | 2026-11-03 15:44:52 |

## Texto original

````text
Apruebo P-15, P-16 y P-17 según tus recomendaciones. Autorizo implementar GL-05 en feature/GL-05-personas.

Registrá este pedido y recuperá M31 y M32 literalmente si están disponibles; si no, mantené declarada su ausencia.

Actualizá los artefactos aprobados y guardá la planificación en un commit local. Después implementá con pruebas primero:
- listado Personas como inicio autenticado;
- rutas /personas y /personas/:id;
- cabecera con sesión y cierre;
- ficha con nombre, rol y equipo;
- estado vacío y presentación adaptable a móvil;
- autorización y consultas con alcance de GL-03, con pruebas por URL directa.

Comprobá que sustituir la búsqueda por alcance por Person.find hace fallar una prueba y restaurá el archivo exactamente.

Ejecutá bin/ci y openspec validate --all --strict. Guardá la implementación en otro commit local.

No agregues feedback ni administración. No cambies contraseñas ni datos locales. No hagas push, PR, merge, despliegues ni archivado.

Informá commits, resultados y pasos para mi prueba manual en navegador.
````

## Resultado registrado (no forma parte del pedido)

Se completa al terminar el pedido.
