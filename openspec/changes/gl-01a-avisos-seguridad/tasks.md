# Tasks

## 1. Actualización conservadora

- [x] 1.1 Respaldar `Gemfile` y `Gemfile.lock` con `sha256sum` en el directorio de evidencias y guardar las especificaciones del lockfile antes del cambio; verificar que el respaldo no está vacío
- [x] 1.2 Resolver `rack` 3.2.8, `loofah` 2.25.3, `nokogiri` 1.19.5 y `rails-html-sanitizer` 1.7.2 con `bundle lock --update … --conservative` y la restricción temporal de `nokogiri`; restaurar el `Gemfile` por copia y volver a ejecutar `bundle lock`; verificar con `sha256sum -c` que el `Gemfile` es idéntico al original (S3)
- [x] 1.3 Comparar las especificaciones del lockfile antes y después y verificar que solo cambian las cuatro gemas, en todas sus plataformas, o explicar cada cambio adicional por la dependencia declarada que lo exige (S1, S2)
- [x] 1.4 Ejecutar `bundle install` y verificar con `bundle check` que las dependencias quedan satisfechas

## 2. Verificación

- [x] 2.1 Verificar con `git diff` que no cambiaron `Gemfile`, `.ruby-version`, `.tool-versions`, `config/bundler-audit.yml`, `bin/bundler-audit` ni `bin/brakeman` (S3)
- [x] 2.2 Ejecutar `bin/bundler-audit update`, registrar la base de avisos y verificar que `bin/bundler-audit` no informa avisos (S4)
- [x] 2.3 Ejecutar `bin/ci` con el PostgreSQL local del producto y verificar que termina con código 0 (S4; G6 de GL-01)
- [x] 2.4 Ejecutar `openspec validate --all --strict` y verificar que pasa (S5)
- [x] 2.5 Registrar los resultados en el registro de evidencia de este cambio y en el de GL-01 (G6), dejando G7 como pendiente remoto

## Workflow follow-up

- G7 de GL-01: push autorizado de `feature/entrega-2-pp` y ejecución del CI en GitHub.
- Archivar este cambio junto con el cierre de GL-01, después de G7 y de la revisión humana.
