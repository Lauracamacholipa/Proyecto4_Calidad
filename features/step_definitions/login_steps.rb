require 'capybara/cucumber'
require 'selenium-webdriver'

Given('I am on the login page with all required elements') do
  visit('/')
  
  expect(page).to have_xpath('//*[@id="user-name"]')
  
  expect(page).to have_xpath('//*[@id="password"]')
  
  expect(page).to have_xpath('//*[@id="login-button"]')
  
  expect(page).to have_content('Accepted usernames are:')
  expect(page).to have_content('Password for all users:')
end

When('I enter username {string} in the username field') do |username|
  find(:xpath, '//*[@id="user-name"]').set(username)
end

When('I enter password {string} in the password field') do |password|
  find(:xpath, '//*[@id="password"]').set(password)
end

When('I click the login button with id {string}') do |button_id|
  find(:xpath, "//*[@id='#{button_id}']").click
end

When('I visit the inventory page directly at {string}') do |path|
  visit(path)
end

When('I wait {int} seconds for the page to load') do |seconds|
  sleep seconds
end

Then('I should be redirected to the inventory page at {string}') do |expected_path|
  expect(page.current_url).to eq("https://www.saucedemo.com#{expected_path}")
  
  expect(page).to have_xpath('//*[@id="inventory_container"]')
  expect(page).to have_xpath('//*[@class="inventory_list"]')
  
  expect(page).to have_content('Products')
end

Then('I should see the specific product {string}') do |product_name|
  product_element = find(:xpath, '//*[@id="item_4_title_link"]/div')
  expect(product_element.text).to eq(product_name)
  
  expect(page).to have_xpath('//*[@class="inventory_item"]', minimum: 1)
end

Then('I should see exact error message {string} in the error container') do |expected_message|
  sleep 1
  error_container = find(:xpath, '//*[@id="login_button_container"]/div/form/div[3]')
  error_message = find(:xpath, '//*[@id="login_button_container"]/div/form/div[3]/h3')
  expect(error_message.text).to eq(expected_message)
  expect(error_container).to be_visible
end

Given('I am logged in as {string}') do |username|
  visit('/')
  find(:xpath, '//*[@id="user-name"]').set(username)
  find(:xpath, '//*[@id="password"]').set('secret_sauce')
  find(:xpath, '//*[@id="login-button"]').click
  
  sleep 6 if username == 'performance_glitch_user'
  
  expect(page.current_url).to eq('https://www.saucedemo.com/inventory.html')
end