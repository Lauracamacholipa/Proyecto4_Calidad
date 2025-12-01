begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'
require 'selenium-webdriver'

Capybara.default_driver = :selenium

Capybara.app_host = ENV["CAPYBARA_HOST"]

Capybara.default_max_wait_time = 15
Capybara.default_driver = :selenium
Capybara.app_host = "https://www.saucedemo.com"

class CapybaraDriverRegistrar
  def self.register_selenium_driver(browser)
    Capybara.register_driver :selenium do |app|
      if browser == :chrome
        # SOLO MODO INCOGNITO
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--incognito')
        
        Capybara::Selenium::Driver.new(app, :browser => :chrome, :options => options)
      else
        Capybara::Selenium::Driver.new(app, :browser => browser)
      end
    end
  end
end

CapybaraDriverRegistrar.register_selenium_driver(:chrome)
Capybara.run_server = false
World(Capybara)

Capybara.save_path = "reports/screenshots"
Capybara::Screenshot.autosave_on_failure = true