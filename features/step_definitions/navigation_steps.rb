require 'capybara/cucumber'
require_relative '../../page_objects/navigation_page'
require_relative '../../page_objects/inventory_page'
require_relative '../../page_objects/cart_page'

# Initialize page object
def navigation_page
  @navigation_page ||= NavigationPage.new
end

def inventory_page
  @inventory_page ||= InventoryPage.new
end

def cart_page
  @cart_page ||= CartPage.new
end

# === STEPS REFACTORIZADOS PARA USAR POM ===

Given('I add {string} to my shopping cart') do |product_name|
  inventory_page.add_product_by_name(product_name)
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
  expect(cart_page.on_cart_page?).to be true
end

When('I click the {string} button in cart page') do |button_text|
  cart_page.ensure_on_cart_page
  cart_page.click_button(button_text)
end

Then('I should be on products page') do
  expect(inventory_page.on_products_page?).to be true
end

When('I return to products page using inventory link') do
  if cart_page.on_cart_page?
    cart_page.continue_shopping
  else
    inventory_page.ensure_on_products_page
  end
  page.refresh
  expect(inventory_page.on_products_page?).to be true
end

When('I use browser back button') do
  page.go_back
  sleep 1
end

Then('the URL should contain {string}') do |expected_url_part|
  expect(page.current_url).to include(expected_url_part)
end

Then('the cart should be empty') do
  expect(navigation_page.cart_has_items?).to be false
end

Then('{string} should show {string} button') do |product_name, button_text|
  expect(inventory_page.product_button_text(product_name)).to eq(button_text)
end