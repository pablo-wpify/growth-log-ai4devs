require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GrowthLog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # GL-02 (D-GL02-7): sin app nativa ni canales, no se exponen las rutas de
    # navegación nativa de Turbo ni se monta Action Cable. Volver a montarlo
    # exige autenticar la conexión, en su propio cambio.
    config.turbo.draw_routes = false
    config.action_cable.mount_path = nil


    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # GL-06 (P-23): zona horaria de toda la instancia. Define «la fecha de hoy»
    # de la captura rápida (3.2). La base sigue guardando las marcas en UTC.
    config.time_zone = "America/Argentina/Buenos_Aires"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
