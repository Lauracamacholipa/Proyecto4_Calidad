require 'capybara/cucumber'

Given('I am on the login page') do
  visit('/')
  expect(page).to have_css('#user-name', wait: 5)
  expect(page).to have_css('#login-button', wait: 5)
end

When('I login as {string} with password {string}') do |username, password|
  fill_in 'user-name', with: username, wait: 5
  fill_in 'password', with: password, wait: 5
  find('#login-button', wait: 5).click
  
  @current_user = username
end

Then('I should see inventory page') do
  expect(page.current_url).to include('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 5)
end

Then('I should see product {string}') do |product_name|
  expect(page).to have_css('.inventory_item_name', text: product_name, wait: 5)
end

Then('I should see error {string}') do |expected_error|
  error_element = find('#login_button_container > div > form > div.error-message-container.error > h3', wait: 5)
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

When('I click the login button') do
  find('#login-button', wait: 5).click
end

Then('I should see inventory page within {int} seconds') do |seconds|
  expect(page).to have_css('.title', text: 'Products', wait: seconds)
  expect(page.current_url).to include('/inventory.html')
end