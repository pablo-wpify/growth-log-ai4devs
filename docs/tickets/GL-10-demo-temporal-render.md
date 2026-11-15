# GL-10. Demo temporal en Render con datos ficticios

> Ticket de la entrega 2 de Growth Log. Lugar en la secuencia:
> [plan de la entrega 2](../plan-entrega-2.md). Cambio de OpenSpec
> archivado: [`2026-11-15-gl-10-demo-temporal-render`](../../openspec/changes/archive/2026-11-15-gl-10-demo-temporal-render/proposal.md).
> **Estado (15/11/2026, M243): cerrado y archivado, con la comprobación
> manual en Render parcial.**
> - **Integrado:** [PR #7](https://github.com/pablo-wpify/growth-log-ai4devs/pull/7),
>   merge commit `6177aef04a6cd64c85f27cad832cb4b5cf54e949`; CI [43660072168](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43660072168) sobre `d4fd753`, el head del PR, y CI [43660510488](https://github.com/pablo-wpify/growth-log-ai4devs/actions/runs/43660510488) sobre el merge `6177aef`,
>   ambos en `success`. La reconciliación documental se publicó en `02fe600`
>   (M242).
> - **Desplegado:**
>   - primer deploy, solo migraciones, comprobado por el agente en modo de
>     solo lectura (M235);
>   - segundo deploy, con la tarea demo, declarado por Pablo en M237
>     ([registro](../../openspec/changes/archive/2026-11-15-gl-10-demo-temporal-render/design.md#registro-del-despliegue-15112026));
>   - deploy manual de `cad6afe` (M242): Live, con la tarea demo informando
>     «0 creados, 8 existentes».
> - **Comprobado a mano (capturas de Pablo, M237):** inicio de sesión como
>   Lucía Demo y como Martín Demo, y la vista de Paula Ejemplo de cada uno
>   con entradas ficticias.
> - **CA8 cerrado como parcial (M243)**, por indicación de Pablo. Siguen sin
>   comprobar en Render el recorrido completo con L1, la rama negativa con
>   L2 por URL directa y la separación entre líderes; las pruebas
>   automatizadas cubren esas reglas.
> - **Credenciales:** las variables de contraseña se conservan en Render
>   (M237). **P-30 sigue pendiente:** cómo compartirlas con quienes evalúen.
> - **README:** actualizado con la demo, sin credenciales (M243).
> - **Historia:** pedido en M212; actualizado en M213 y M214; implementación
>   autorizada en M215; reconciliado en M237; archivado en M243.

## Problema

La entrega se revisa en local: el despliegue es opcional y no lo hay
(README, «Cómo revisar esta entrega»). Para que quien revise pueda recorrer
el núcleo sin instalar nada, Pablo quiere una **demo temporal** en Render.

Hoy nada permite preparar datos fuera de `development`. GL-08 se niega en
cualquier otro entorno, y eso **se conserva**. El servicio web Free de
Render no ofrece shell, SSH ni trabajos puntuales, y el comando de
pre-deploy requiere un plan pago. Por eso no se puede crear el conjunto a
mano en la instancia.

## Estado de Render (declarado por Pablo en M212 a M214, no verificado por el agente)

- La base `growth-log-entrega-2-db` existe en Render Postgres **Free**, en
  Virginia, y fue **creada el 14/11/2026**. Con la regla de 30 días vence
  alrededor del 14/12/2026 y, después de 14 días de gracia, se borra
  alrededor del 28/12/2026. Render avisa por correo la fecha exacta.
- **Decidido en M214:** el servicio desplegará `feature/entrega-2-pp`, con
  despliegue **manual**.
- Este ticket no incluye ni infiere credenciales, URLs de conexión ni
  valores de variables.
- El formulario del servicio web quedó **sin enviar**: no hay servicio
  web desplegado. **Actualización (15/11/2026):** el servicio web existe y
  la demo está desplegada (ver el estado al principio).
- GL-10 no cambia servicios ni configuración de Render en esta fase.

## Decisiones de Pablo (14/11/2026)

- **P-27 (M212):** la demo es **editable**: quien revise puede capturar,
  completar y marcar entradas como en local. No se agrega modo de solo
  lectura. La demo usa **datos exclusivamente ficticios**.
- **P-28 (M214):** la tarea corre en el build, después de las migraciones
  y bajo las dos guardas. Primero, un deploy solo de migraciones; tras
  comprobar la conexión, un deploy manual con la tarea demo habilitada.
- **P-29 (M214):** las contraseñas iniciales salen de variables secretas
  de Render. La tarea no las imprime ni sobrescribe contraseñas
  existentes.
- **P-31 (M214):** tabla de marcas propia.
- **Rama y despliegue (M214):** `feature/entrega-2-pp`, con despliegue
  manual.
- **Conjunto demo (M214):** Lucía, Martín y Paula, aceptados como datos
  ficticios.
- **Variables después de crear las cuentas:** el registro de M215 incluía
  retirar las variables de contraseña tras crear y verificar las cuentas.
  **Aclaración (15/11/2026, M237):** Pablo aclaró que no se iban a retirar.
  Quedan en el panel, con `GROWTH_LOG_DEMO_INSTANCE`, y no hay una tarea de
  retiro.
- **P-30 sigue pendiente:** cómo se comparten las credenciales con quienes
  revisen. No se define aquí.

## Alcance propuesto

1. Capability nueva `temporary-demo`, separada de
   `development-sample-data`. La spec de GL-08 no cambia y su tarea sigue
   siendo solo para `development`.
2. Una tarea explícita e idempotente que prepara el conjunto demo en una
   **base dedicada**:
   - Se niega fuera de la instancia demo. Termina con error si detecta
     registros ajenos.
   - No sobrescribe, no adopta ni borra datos.
   - No corre desde los seeds ni al arrancar Puma.
3. Ejecución según P-28: la tarea corre en el build de Render, después de
   las migraciones y bajo las dos guardas: entorno de producción y
   `GROWTH_LOG_DEMO_INSTANCE` con su valor exacto.
   - **Primer deploy, sin el indicador:** solo migraciones. El script de
     build no invoca la tarea.
   - **Segundo deploy, manual, con el indicador y las contraseñas
     cargadas:** migraciones y después la tarea.
   - Render documenta que las variables de entorno están disponibles en el
     build y su guía de Rails 8 recomienda las migraciones en el build en
     Free, porque el pre-deploy es pago.
   - Si falla el build o la tarea, falla ese deploy y se conserva el último
     exitoso.
   - Fuentes en el [diseño](../../openspec/changes/archive/2026-11-15-gl-10-demo-temporal-render/design.md#7-dónde-corre-la-tarea-p-28-aprobada-por-pablo-en-m214).
   - **Todavía no se probó en este servicio.** Probado el 15/11/2026: los
     dos deploys se hicieron en ese orden (ver el estado).
4. Contraseñas iniciales según P-29:
   - Variables secretas de Render, una por cuenta, leídas solo al crearla.
   - Se validan con la política antes de escribir.
   - Nunca se imprimen y no se sobrescriben contraseñas existentes.
5. Se modifica de forma explícita la spec `initial-administrator`, para que
   admita en el repositorio las cuentas demo sin contraseñas ni hashes.
6. Configuración mínima de producción para Render (conexión,
   `RAILS_MASTER_KEY` o `SECRET_KEY_BASE`, comando de build), sin secretos
   en el repositorio. Se detalla al implementar.

## Exclusiones

- Datos reales, invitaciones, administración, compartir, feed y filtros:
  siguen diferidos (plan, sección 5). La demo no habilita datos reales.
- ADR-7 (despliegue y backups) **no se cierra**. La demo es temporal y sin
  backups (la base Free no los tiene). La fila «Despliegue» de lo diferido
  sigue pendiente.
- Modo de solo lectura (descartado por Pablo).
- Cambiar la tarea o la spec de datos ficticios de GL-08.
- Cualquier contraseña en archivos, prompts, logs o salidas.
- Crear el administrador en la demo: `crear_administrador` necesita una
  terminal y no hace falta para el recorrido.

## Conjunto demo propuesto

Correos en el dominio reservado `ficticio.example.test`, con el prefijo
`demo.` para no confundirse con el conjunto de desarrollo. Ninguna cuenta es
administradora.

| Clave | Registro | Detalle |
|---|---|---|
| `demo:account:lucia` | cuenta activa | Lucía Demo, `lucia.demo@ficticio.example.test` (L1) |
| `demo:account:martin` | cuenta activa | Martín Demo, `martin.demo@ficticio.example.test` (L2) |
| `demo:person:paula` | persona activa | Paula Ejemplo, Desarrolladora, Equipo Faro |
| `demo:assignment:lucia/paula` | asignación activa | L1 → Paula |
| `demo:assignment:martin/paula` | asignación activa | L2 → Paula |
| `demo:entry:lucia/borrador` | borrador de L1 | captura sin señal ni dimensión |
| `demo:entry:lucia/lista` | entrada lista de L1 | Positivo, «Trabajo en equipo» |
| `demo:entry:martin/lista` | entrada lista de L2 | A mejorar, «Comunicación» |

Los textos son ficticios y genéricos. Lo que muestra el recorrido:

- **Cada líder ve solo lo suyo:** el resumen y la cronología de Lucía
  muestran su borrador («fuera del resumen») y su entrada lista. Los de
  Martín muestran solo la de él.
- **Por URL directa**, el detalle de una entrada del otro líder responde
  404.

Pablo aceptó los nombres en M214 como datos ficticios. Los textos de las
entradas se fijan al implementar, también ficticios y genéricos.

## Criterios de aceptación propuestos

Los criterios usan el prefijo CA; los riesgos del diseño usan R.

| # | Criterio | Origen |
|---|---|---|
| CA1 | La tarea demo se niega y termina con error antes de escribir:<ul><li>en `development` y `test`;</li><li>en producción sin el indicador explícito de instancia demo;</li><li>en una base con usuarios, personas, asignaciones o entradas que no son del conjunto demo ni entradas creadas por cuentas demo.</li></ul>Se comprueba también con procesos reales. | M212 |
| CA2 | En la base dedicada vacía, la tarea crea exactamente el conjunto demo, con sus marcas propias. | M212 |
| CA3 | Una nueva ejecución no crea, modifica ni borra nada. Las ediciones hechas en la demo se conservan, también las de los ejemplos y las entradas nuevas de los revisores. | M212, P-27 |
| CA4 | Ni los seeds ni el arranque de Puma ejecutan la tarea demo. Las migraciones no crean datos demo. | M212 |
| CA5 | Ninguna contraseña ni hash está en el repositorio, los prompts, los logs ni la salida. | M212, AM-5 |
| CA6 | `development-sample-data` sigue igual y sus pruebas pasan sin modificarse. | M212 |
| CA7 | La operación es atómica y dos ejecuciones simultáneas dejan un solo conjunto. | como GL-08 |
| CA8 | El recorrido núcleo funciona en la demo con L1 y la rama negativa con L2. Es una comprobación manual en la URL de Render, que se registra con fecha. | GL-09 |
| CA9 | `bin/ci` y el CI remoto pasan. | GL-01 |
| CA10 | Las contraseñas iniciales salen de las variables secretas de cada cuenta y solo al crearla. Si falta una variable o no cumple la política, la tarea falla sin escribir. Una nueva ejecución no cambia la contraseña de una cuenta existente, aunque cambie o falte su variable. | P-29 |
| CA11 | Un build sin el indicador migra y no invoca la tarea. Con el indicador, migra y la invoca, y si la tarea falla el build falla. | P-28 |

## Dependencias

- GL-09 cerrado (`e0ceb4e`).
- P-28, P-29 y P-31 decididas (M214); implementación autorizada (M215).
- P-30 pendiente: no bloquea la implementación, pero sí compartir la demo.
- Para desplegar hace falta otra autorización: M215 no incluye Render.

## Relación con la entrega

- **No sustituye** la revisión local ni cambia la forma de entrega: la rama
  se sigue enviando por Typeform.
- La demo es un **complemento temporal**, disponible mientras viva la base
  Free.
- No cuenta como el despliegue de ADR-7 ni como el «primer recorrido
  usable» del Anexo G.
