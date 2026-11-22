# M411. Revisión renderizada de «Personas» con Impeccable

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | Revisión de UI de la entrega final |
| Tipo | revisión visual y funcional (UI/UX), sin cambios en el repositorio |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | texto pegado. Según declaración de Pablo, los pedidos pegados se preparan con ChatGPT en una conversación de acompañamiento que no está aportada; modelo no verificado |
| Fuente | transcripción local de la sesión de Claude Code (no publicada) |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente; solo se quitaron las etiquetas de texto pegado que agrega Claude Code |
| Omisiones | ninguna |
| SHA-256 del texto | `bb34603fbdd0816b1b33808eb4e1e5e0c27e4729244a0786fa1399ae78d4fb8b` |
| Fecha y hora (UTC) | 2026-11-21 21:21:28 |

## Texto original

````text
Hacé una revisión visual y funcional de la pantalla «Personas» de Growth Log, usando Impeccable sobre la página renderizada.

Antes de empezar:
- Leé CLAUDE.md y los registros M404–M408.
- Verificá rama, HEAD y estado de Git.
- Averiguá cómo iniciar la app localmente y qué base de datos usa. Confirmá que el entorno sea local/de desarrollo y que no apunte a Render ni a producción. No muestres valores de `.env` ni secretos.
- Usá solo datos ficticios existentes. No resetees, borres ni alteres una base con datos del usuario. Si no hay una forma segura de iniciar la app y tener datos de prueba, detenete y decime qué falta.

Si el entorno es seguro, iniciá la app según las instrucciones del proyecto y revisala en el navegador a 1280 px, 640 px, 639 px y 375 px. Comprobá:
- listado normal y filas con entradas listas, solo borradores y sin entradas;
- búsqueda, filtro, orden y «Limpiar filtros»;
- estado vacío y estado sin resultados;
- navegación con Tab y foco visible;
- que la fila abra la ficha y «Registrar la primera» abra la captura;
- disposición responsive y ausencia de desplazamiento horizontal, especialmente alrededor de 40 rem;
- contraste, legibilidad, etiquetas y tamaños de los objetivos táctiles.

Usá Impeccable para la auditoría renderizada y distinguí sus resultados automáticos de las comprobaciones manuales. Guardá capturas temporales fuera del repositorio si hace falta, siempre con datos ficticios.

No envíes capturas ni código a Stitch todavía. Indicame cuáles capturas servirían para compararlas allí y esperá mi autorización antes de subirlas.

No edites archivos del proyecto, no cambies datos persistentes, no corras pruebas ni `bin/ci`, y no hagas stage, commit, push, PR, merge, deploy ni archive. Al terminar, informá hallazgos priorizados, capturas/anchos revisados y estado de Git.
````

## Resultado registrado

**Numeración:** M411, por posición (opción A), decidida por Pablo en
M412. La respuesta siguiente de Pablo (21:23 UTC) es una respuesta breve
que no se numera: daba la contraseña de las cuentas ficticias locales
[omitido: contraseña]. Este pedido prohibía editar archivos, así que se
registró en M412.

**Entorno.** Primero se comprobó que el entorno era seguro, sin escribir
en la base y sin mostrar valores de `.env`. La base es
`growth_log_development`, en PostgreSQL local (contenedor Docker con el
puerto publicado solo en `127.0.0.1`), sin `DATABASE_URL` ni variables de
Render. Había 5 cuentas `ficticio.example.test` y 2 entradas listas, y
ningún borrador. La revisión se detuvo hasta que Pablo aportó la
contraseña.

Después se levantó `bin/rails server` en `127.0.0.1:3000` y se revisó con
Chrome 157 sin interfaz, manejado con Selenium y con anchos exactos por
CDP. Al terminar se cerraron el servidor y el navegador, y se borró el
archivo temporal con la contraseña.

**Anchos y estados revisados:**
- con la cuenta ficticia 1 (dos personas: una con 2 entradas listas y
  otra sin entradas), el listado a 1280, 640, 639 y 375 px;
- búsqueda, filtro, orden, «Limpiar filtros», sin resultados, recorrido
  con Tab y el clic en la fila y en «Registrar la primera», a 1280 y
  375 px;
- la cabecera de 480 a 1024 px;
- con la cuenta ficticia 3 (sin asignaciones), el estado vacío a 1280 y
  375 px.

Las capturas, con datos ficticios, quedaron fuera del repositorio, en el
scratchpad temporal de la sesión.

**Resultado automático de Impeccable** (`detect --cdp` sobre la página
renderizada, en los cuatro anchos y en el estado vacío): un solo aviso,
`cream-palette` (fondo `#faf7f2`). Es un **falso positivo**: la paleta
cálida es la decisión P-34, aprobada. Sin hallazgos de contraste bajo,
texto chico, desborde de texto, columnas desbordadas, interlineado ni
espaciado.

**Comprobaciones manuales sin problemas:**
- sin desplazamiento horizontal en ningún ancho;
- etiquetas asociadas y controles y enlaces de 44 px;
- orden de Tab lógico, con foco visible de 3 px en terracota (en la fila
  completa, cuando es una fila);
- búsqueda parcial sin cambiar la URL; «Limpiar filtros» conserva el
  orden y devuelve el foco a la búsqueda; el filtro ofrece solo los
  equipos propios;
- sin resultados, con el mensaje y el total sin cambios; estado vacío sin
  controles ni total;
- la fila abre la ficha y «Registrar la primera» abre la captura rápida,
  sin guardar nada.

**Hallazgos manuales que cubre GL-17:**
- [P2] Un toque 6 px a la derecha o 4 px arriba de «Registrar la primera»
  abre la ficha (P-55 lo reduce; no lo elimina).
- [P2] La fila sin entradas mide 132 contra 108 px a 1280, y 157 contra
  133 a 375, donde «Registrar la primera» baja a su propio renglón (P-55).
- [P2] El resumen ocupa 1 renglón a 1280 px, 2 a 640 y 639, y 3 a 375
  (P-54).
- [P3] En el corte de 40 rem, la primera fila pasa de y=325 (640 px) a
  y=487 (639 px) porque se apilan los controles, como pide la spec. GL-17
  suma en ese mismo corte el cambio de los detalles de la fila.

**Hallazgos manuales fuera de GL-17** (separados, sin cambio abierto):
- [P2] Entre unos 600 y 767 px, la cabecera se parte en dos filas (61 a
  109 px) con «Cerrar sesión» solo, a la izquierda. La regla de dos filas
  ordenadas se aplica solo hasta 30 rem, y el rango depende del largo del
  nombre de la cuenta.
- [P2] A 375 px, la lista arranca en y=503 de 760 px y «Registrar la
  primera» queda cortado al pie de la pantalla.

**Sin probar:**
- filas con solo borradores (no hay borradores);
- búsqueda con acentos, «Sin equipo indicado» y un orden «Hechos más
  recientes» con más de una persona con entradas (faltan esos datos);
- activar con Enter y toques táctiles reales (se usaron clics);
- el navegador mostró una barra de desplazamiento de 15 px, así que a
  375 px el contenido medía 360 px.

**Efecto en la base.** Al iniciar sesión, la app borra las sesiones
vencidas de esa cuenta (`start_new_session_for`). Así se eliminaron
**cinco sesiones expiradas** de las cuentas ficticias 1 y 3. Las tres
sesiones de la revisión se cerraron con «Cerrar sesión». Quedó **una fila
temporal en `login_attempt_counters`**, que vence sola; su conteo previo
**no se conoce**, porque no se midió antes. Las cuentas y las entradas no
cambiaron (5 y 2).

Sin cambios en el repositorio: el servidor escribió solo en `log/` y
`tmp/`, que Git ignora. Sin pruebas ni `bin/ci`, y sin subir nada a
Stitch. Para compararlas en Stitch se propusieron las capturas del
listado a 375 px completo, a 640, 639 y 1280 px, y la del foco a 375 px.
Quedan pendientes de la autorización de Pablo.
