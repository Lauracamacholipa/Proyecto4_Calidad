require 'capybara/cucumber'
require 'selenium-webdriver'

Capybara.default_driver = :selenium
Capybara.app_host = 'https://www.saucedemo.com'
Capybara.default_max_wait_time = 10

# Steps del Background
Given('I am on the login page') do
  visit('/')
  expect(page).to have_current_path('https://www.saucedemo.com/')
end

# Steps de entrada de datos
When('I enter username {string} and password {string}') do |username, password|
  fill_in 'user-name', with: username
  fill_in 'password', with: password
end

When('I click the login button') do
  click_button 'Login'
end

# Steps de verificación - Login exitoso
Then('I should be redirected to the products page') do
  expect(page).to have_current_path('https://www.saucedemo.com/inventory.html')
end

Then('I should see the products inventory') do
  expect(page).to have_css('.inventory_list')
  expect(page).to have_content('Products')
end

Then('I should see the products page') do
  expect(page).to have_current_path('https://www.saucedemo.com/inventory.html')
  expect(page).to have_css('.inventory_list')
end

# Steps de verificación - Errores de login
Then('I should see error message {string}') do |expected_message|
  error_container = find('.error-message-container')
  expect(error_container).to have_content(expected_message)
end

Then('I should remain on the login page') do
  expect(page).to have_current_path('https://www.saucedemo.com/')
  expect(page).to have_css('.login_wrapper')
end