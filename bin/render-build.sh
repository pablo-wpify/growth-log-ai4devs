#!/usr/bin/env bash
# Build de la instancia demo temporal en Render (GL-10, P-28).
# Render Free no ofrece pre-deploy: las migraciones y la tarea demo corren
# aquí. Si cualquier paso falla, falla el build y Render conserva el último
# deploy exitoso. La tarea demo se invoca solo cuando el panel tiene
# GROWTH_LOG_DEMO_INSTANCE; la tarea comprueba además su valor exacto.
# No activar el modo de traza ni mostrar variables: el entorno del build
# contiene secretos.
set -o errexit
set -o nounset
set -o pipefail

bundle install
bin/rails assets:precompile
bin/rails assets:clean
bin/rails db:migrate

if [ -n "${GROWTH_LOG_DEMO_INSTANCE:-}" ]; then
  bin/rails growth_log:datos_demo
else
  echo "Tarea demo no habilitada: falta GROWTH_LOG_DEMO_INSTANCE. Solo se aplicaron las migraciones."
fi
