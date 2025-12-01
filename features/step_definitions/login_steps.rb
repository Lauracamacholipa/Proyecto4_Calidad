require 'capybara/cucumber'
require 'selenium-webdriver'

# === BACKGROUND ===
Given('I am on the login page') do
  visit('/')
  expect(page).to have_xpath('//*[@id="user-name"]')
  expect(page).to have_xpath('//*[@id="login-button"]')
end

# === COMBINED LOGIN STEP ===
When('I login as {string} with password {string}') do |username, password|
  find(:xpath, '//*[@id="user-name"]').set(username)
  find(:xpath, '//*[@id="password"]').set(password)
  find(:xpath, '//*[@id="login-button"]').click
  
  @current_user = username
end

# === SUCCESS VALIDATIONS ===
Then('I should see inventory page') do
  expect(page.current_url).to include('/inventory.html')
  
  expect(page).to have_content('Products')
end

Then('I should see product {string}') do |product_name|
  product = find(:xpath, '//*[@id="item_4_title_link"]/div')
  expect(product.text).to eq(product_name)
end

# === ERROR VALIDATIONS ===
Then('I should see error {string}') do |expected_error|
  sleep 1  
  
  error_element = find(:xpath, '//*[@id="login_button_container"]/div/form/div[3]/h3')
  expect(error_element.text).to eq(expected_error)
  
  puts "Validated error: #{error_element.text}"
end

# === SHARED LOGIN FOR OTHER FEATURES ===
Given('I am logged in as {string}') do |username|
  steps %Q{
    Given I am on the login page
    When I login as "#{username}" with password "secret_sauce"
    Then I should see inventory page
  }
  
  @logged_in_user = username
end