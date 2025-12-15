require 'capybara/cucumber'
require_relative '../../page_objects/navigation_page'

# Initialize page object
def navigation_page
  @navigation_page ||= NavigationPage.new
end

# === STEPS ===
Given('I add {string} to my shopping cart') do |product_name|
  visit('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)
  
  product_element = find('.inventory_item_name', text: product_name, wait: 10)
  container = product_element.ancestor('.inventory_item')
  container.find('.btn_inventory').click
  
  expect(navigation_page.cart_has_items?).to be true
end

When('I click the menu button') do
  navigation_page.open_menu
end

When('I click the close menu button') do
  navigation_page.close_menu
end

Then('I should see menu options including {string} and {string}') do |option1, option2|
  expect(navigation_page.menu_visible?).to be true
  expect(navigation_page.menu_option_exists?(option1)).to be true
  expect(navigation_page.menu_option_exists?(option2)).to be true
end

Then('the menu should not be visible') do
  expect(navigation_page.menu_hidden?).to be true
end

When('I click {string} in side menu') do |option_text|
  navigation_page.click_menu_option(option_text)
end

Then('I should be redirected to the login page') do
  expect(navigation_page.on_login_page?).to be true
end

Given('I go to the cart page') do
  navigation_page.go_to_cart
  expect(page).to have_css('.title', text: 'Your Cart', wait: 10)
end

When('I click the {string} button in cart page') do |button_text|
  navigation_page.go_to_cart unless page.current_url.include?('/cart.html')
  find('button', text: button_text, wait: 10).click
end

Then('I should be on products page') do
  expect(navigation_page.on_products_page?).to be true
end

When('I return to products page using inventory link') do
  if page.current_url.include?('/cart.html')
    find('#continue-shopping', wait: 10).click
  else
    visit('/inventory.html')
  end
  expect(navigation_page.on_products_page?).to be true
end

When('I use browser back button') do
  page.go_back
  sleep 1
end

Then('the URL should contain {string}') do |expected_url_part|
  expect(navigation_page.url_includes?(expected_url_part)).to be true
end

Then('the cart should be empty') do
  expect(navigation_page.cart_has_items?).to be false
end

Then('{string} should show {string} button') do |product_name, button_text|
  product_element = find('.inventory_item_name', text: product_name, wait: 10)
  container = product_element.ancestor('.inventory_item')
  button = container.find('button', wait: 10)
  expect(button.text).to eq(button_text)
end