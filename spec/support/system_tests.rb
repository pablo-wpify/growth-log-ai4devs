# Pruebas en navegador (GL-09, P-4): pruebas de sistema de RSpec con
# Capybara y selenium-webdriver sobre Chrome sin interfaz, en la misma suite.
# Capybara levanta la aplicación con Puma en un hilo de este proceso; Rails
# comparte la conexión de la base con ese hilo, así que las transacciones de
# cada prueba siguen deshaciendo sus datos. Requiere Chrome instalado;
# Selenium Manager resuelve el chromedriver.
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1280, 900 ]
  end
end

Capybara.server = :puma, { Silent: true }
