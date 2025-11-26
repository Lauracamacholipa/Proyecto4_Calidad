require 'capybara/cucumber'
require 'selenium-webdriver'

# Configuración de Capybara
Capybara.configure do |config|
  config.default_driver = :selenium_chrome
  config.app_host = 'https://www.saucedemo.com'
  config.default_max_wait_time = 10
end

# Configuración de Selenium para Chrome
Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--start-maximized')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--no-sandbox')
  
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Configuración adicional
World(Capybara::DSL)