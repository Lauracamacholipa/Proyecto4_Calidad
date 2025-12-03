require 'capybara/cucumber'

Given('I am on the login page') do
  visit('/')
  expect(page).to have_xpath('//*[@id="user-name"]', wait: 5)
  expect(page).to have_xpath('//*[@id="login-button"]', wait: 5)
end

When('I login as {string} with password {string}') do |username, password|
  find(:xpath, '//*[@id="user-name"]').set(username)
  find(:xpath, '//*[@id="password"]').set(password)
  find(:xpath, '//*[@id="login-button"]').click
  
  @current_user = username
end

Then('I should see inventory page') do
  expect(page.current_url).to include('/inventory.html')
  expect(page).to have_xpath('//span[@class="title" and text()="Products"]', wait: 5)
end

# Busca CUALQUIER producto
Then('I should see product {string}') do |product_name|
  expect(page).to have_xpath("//div[text()='#{product_name}']", wait: 5)
end

Then('I should see error {string}') do |expected_error|
  error_element = find(:xpath, '//*[@id="login_button_container"]/div/form/div[3]', wait: 5)
  expect(error_element.text).to eq(expected_error)
end

Given('I am logged in as {string}') do |username|
  steps %Q{
    Given I am on the login page
    When I login as "#{username}" with password "secret_sauce"
    Then I should see inventory page
  }
  
  @logged_in_user = username
end