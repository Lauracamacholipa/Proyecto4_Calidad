begin
  require 'rspec/expectations'
rescue LoadError
  require 'spec/expectations'
end

require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'
require 'selenium-webdriver'

# Registrar driver de Chrome con opciones que evitan popups
Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  
  # DESACTIVAR POPUPS DE GOOGLE
  options.add_argument('--no-default-browser-check')
  options.add_argument('--no-first-run')
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--disable-extensions')
  options.add_argument('--disable-notifications')
  
  # Modo incógnito (sin cookies/cache)
  options.add_argument('--incognito')
  
  # Pantalla completa
  options.add_argument('--start-maximized')
  
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Configuración principal
Capybara.default_driver = :chrome
Capybara.app_host = 'https://www.saucedemo.com'
Capybara.default_max_wait_time = 5
Capybara.save_path = 'reports/screenshots'
Capybara::Screenshot.autosave_on_failure = true

# Desactivar servidor interno
Capybara.run_server = false

# Incluir DSL de Capybara
World(Capybara)