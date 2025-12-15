require 'capybara/cucumber'
require_relative '../../page_objects/login_page'

# Initialize page object
def login_page
  @login_page ||= LoginPage.new
end

Given('I am on the login page') do
  login_page.open
end

When('I login as {string} with password {string}') do |username, password|
  login_page.login(username, password)
  @current_user = username
end

Then('I should see inventory page') do
  expect(login_page.on_inventory_page?).to be true
end

Then('I should see product {string}') do |product_name|
  expect(login_page.product_visible?(product_name)).to be true
end

Then('I should see error {string}') do |expected_error|
  expect(login_page.error_message).to eq(expected_error)
end

Given('I am logged in as {string}') do |username|
  login_page.login_as(username)
  @logged_in_user = username
end

When('I click the login button') do
  login_page.click_login
end