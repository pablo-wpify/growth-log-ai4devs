# Growth Log

Monolito Rails 8.1.4 con Ruby 4.0.9, PostgreSQL 18.6, Hotwire con importmap
(sin Node), RSpec y OpenSpec 1.15. Proyecto final de AI4Devs de Pablo
Peuscovich. Todo se escribe en español rioplatense.

## Comandos

Verificados en GL-01 y GL-02 (02/11/2026), desde la raíz. Detalle en
`docs/desarrollo.md`.

- `set -a; . ./.env; set +a`: carga las variables locales en la terminal
  para ejecutar comandos. Cargarlas no autoriza a mostrarlas: no se abre,
  imprime ni copia el contenido de `.env` ni el valor de sus variables, y
  no se incorpora al contexto ni a ningún archivo o salida.
- `docker start "$GROWTH_LOG_PG_CONTAINER"`: PostgreSQL local.
- `bin/rails db:prepare` y `RAILS_ENV=test bin/rails db:prepare`.
- `bundle exec rspec`: la única suite.
- `bin/bundler-audit update` y después `bin/ci`: estilo, auditorías,
  Brakeman y pruebas; solo vale el código de salida 0.
- `openspec validate --all --strict`.

## Dónde está cada cosa

- Secuencia vigente y decisiones pendientes: `docs/plan-entrega-2.md`, la
  única fuente. No mantener planes en otros archivos.
- Ticket de cada cambio: `docs/tickets/`; decisiones: `docs/decisiones/`.
- Requisitos vigentes: `openspec/specs/`; cambio en curso:
  `openspec/changes/<cambio>/`. Contexto de OpenSpec: `openspec/config.yaml`.
- Política de privacidad, criterios y casos PT: `anexos/anexo-a-historias.md`;
  decisiones D y AM: `anexos/anexo-c-riesgos-decisiones.md`.
- Entrega 1 (`propuesta-mvp.md`, `anexos/`, `prompts.md`) y
  `openspec/changes/archive/`: referencia histórica; no se reescriben.

## Cómo se trabaja

- **Una tarea por vez:** solo el ticket o el paso pedido; lo que aparezca
  fuera de alcance se informa y no se hace.
- **SDD:** ticket → propuesta, specs, diseño y tareas de OpenSpec →
  aprobación de Pablo → implementación → verificación → archivo.
- **Pruebas primero:** cada grupo de tareas escribe sus pruebas, comprueba
  que fallan por la razón esperada y recién después implementa.
- No cambiar un requisito para acomodarlo al código; una contradicción se
  informa con una propuesta de ajuste explícita.

## Privacidad y autorización

- Las reglas son PP-1 a PP-9 y las decisiones D1, D2, D5 y AM-1 a AM-5: se
  aplican, no se reinterpretan ni se relajan sin una decisión registrada.
- Autenticación (quién es, GL-02) no es autorización (qué puede hacer,
  desde GL-03): una sesión válida no da acceso a ningún recurso.
- Denegar por defecto: toda acción del producto toma una decisión de
  autorización y lee registros solo con consultas con alcance. Las
  excepciones se declaran por acción concreta, nunca por controlador.
- Cada regla se prueba también con el actor que **no** debe acceder,
  incluida la URL directa. Llamar a la autorización no prueba que la regla
  sea correcta.

## Evidencia

- Distinguir lo comprobado en local, lo comprobado en el CI remoto (con el
  enlace de la ejecución y el SHA) y lo pendiente. Nada remoto se da por
  comprobado sin esa ejecución.
- Registrar en el diseño del cambio lo ejecutado, los desvíos y lo que
  queda pendiente.

## Límites

- No leer ni mostrar secretos, el contenido de `.env`, credenciales ni datos
  personales.
- Solo datos ficticios (`@example.test`) y contraseñas generadas en las
  pruebas; nunca contraseñas, cuentas ni datos reales en código, pruebas,
  salidas o documentos.
- Commits, push, pull requests, archivado y despliegues solo con
  autorización explícita de Pablo para ese paso. Preparar el staging por
  nombre de archivo.
- No modificar la rama `feature/entrega-1-pp`.

## Registro de prompts

- Al empezar cada tarea, guardar el pedido de Pablo en
  `docs/prompts/<etapa>/MNN-<fecha>-<tema>.md`: metadatos, y el texto en una
  sección «Texto original». Herramienta y modelo solo con evidencia.
- Al terminar, registrar el resultado en una sección separada: commits, CI,
  specs, desvíos y lo pendiente. No copiar razonamientos internos, salidas
  completas de herramientas ni transcripciones.
- No reproducir secretos ni datos personales: marcarlos como «[omitido:
  motivo]». Un texto con omisiones o redactado no se declara literal
  íntegro, y una ausencia se indica, no se reconstruye.
- Actualizar el índice de [prompts.md](prompts.md). Los archivos de prompts
  se versionan con la misma autorización que cualquier otro cambio.
