# M407. Auditoría de «Personas» con Impeccable y alternativa en Stitch

## Metadatos (no forman parte del pedido)

| Campo | Valor |
|---|---|
| Etapa | Revisión de UI de la entrega final |
| Tipo | revisión de solo lectura (UI/UX) |
| Destino | Claude Code (CLI) |
| Ejecución | Claude Code con `claude-opus-5-5`, según el campo de modelo de las respuestas en la transcripción |
| Preparación | mensaje escrito en Claude Code, sin etiquetas de texto pegado; herramienta de preparación no verificada |
| Fuente | transcripción local de la sesión de Claude Code (no publicada); sesión distinta de la de M404 a M406 |
| Fidelidad | literal: el texto es idéntico al del mensaje fuente |
| Omisiones | ninguna |
| SHA-256 del texto | `fd2cbfe6671daf7ea98d321ac925454be23d1083ae84b33332c63bc7fca605f4` |
| Fecha y hora (UTC) | 2026-11-21 20:56:32 |

## Texto original

````text
Retomá la revisión de UI/UX de «Personas» (M404/M405). Usá Impeccable para auditar la pantalla actual y Stitch para explorar una alternativa visual a los problemas priorizados. Revisá las capturas existentes de 1280 y 375 px, que usan datos ficticios. No edites archivos del proyecto. Presentame los hallazgos y la alternativa para decidir antes de cambiar código.
````

## Resultado registrado

**Numeración:** M407, por posición (opción A, decidida por Pablo en M366
y confirmada para esta etapa en M412 y M413). Después de M406, la sesión
anterior tiene dos entradas sueltas, «logut» y «logout» (20:24 UTC): son
intentos de comando y no se numeran, igual que las respuestas breves.

Revisión de solo lectura, registrada en M408 porque este pedido prohibía
editar archivos. Base: las seis capturas de M395 a 1280 y 375 px, con
datos ficticios, y el código en `ca2d5da`. HEAD era `63b86d0`, sin cambios
en `app/` desde entonces. La captura sin resultados es anterior al ajuste
que oculta la lista vacía.

- **Impeccable** (skill del proyecto, 4.10.0; motor 0.1.27): se cargó el
  contexto con `--target app/views/people/index.html.erb` (sin
  PRODUCT.md ni DESIGN.md: refinamiento sobre la implementación vigente)
  y se siguió el playbook `audit`.
  - El detector se corrió solo sobre la vista y la hoja de estilos, con
    reglas de texto. Las reglas de página renderizada (contraste, texto
    chico) no corrieron porque requieren la app levantada. Encontró un
    hallazgo fuera de «Personas»: la barra lateral de `.flash-notice`.
  - Los contrastes se calcularon con la fórmula WCAG 2.x sobre los tokens.
  - El informe no se guardó con `audit-storage` de Impeccable, porque
    escribe en el proyecto.
  - Impeccable avisó que su hook de diseño no está instalado; no se
    corrigió.
- **Puntaje:** 14/20, «Good». Accesibilidad 3, rendimiento 4, theming 3,
  responsive 2 e integridad 3. Sin P0 ni P1.
- **Hallazgos:**
  1. [P2] A 375 px, la primera fila aparece a unos 500 de 760 px
     (cabecera de dos filas, resumen de tres renglones y tres controles
     apilados).
  2. [P2] «Registrar la primera» es un enlace de texto junto a la
     píldora: un toque impreciso a su alrededor abre la ficha, y la fila
     mide unos 132 px contra 109.
  3. [P2] El total y el aviso, unidos con «·», se cortan en tres renglones
     a 375 px y se leen como una sola frase.
  4. [P3] La píldora (1,17:1) y los separadores (1,31:1) tienen poco
     contraste con la tarjeta; es decorativo y el texto de la píldora
     tiene 13,1:1.
- **Stitch:** proyecto privado «Growth Log · Personas (exploración
  M404/M405)», ID `2213536355539089131`, con una pantalla móvil generada
  desde una descripción en texto con los tokens y nombres ficticios. No se
  enviaron código, capturas ni datos reales. La maqueta, que no es una
  especificación, sube la primera fila a unos 280 px.
  - Valen la pena: el total y el aviso en dos líneas.
  - Con cuidado: «Equipo» y «Orden» en una fila en móvil, porque choca con
    «Listado en pantalla angosta» y cortaría «Hechos más recientes».
  - No: «Registrar la primera» como botón a todo el ancho (agranda la fila
    y compite como acción principal), la pestaña subrayada, las etiquetas
    en negrita y el placeholder nuevo.
- **Recomendación:** dentro de las specs vigentes, el resumen en dos
  líneas y la alternativa B de M405 para «Registrar la primera».

Sin cambios en el repositorio (`git status` igual antes y después), sin
pruebas ni validaciones.
