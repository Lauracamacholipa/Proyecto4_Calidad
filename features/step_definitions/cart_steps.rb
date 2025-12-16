require 'capybara/cucumber'
require_relative '../../page_objects/inventory_page'
require_relative '../../page_objects/cart_page'
require_relative '../../page_objects/login_page'

# === PAGE OBJECT INSTANCES ===
def inventory_page
  @inventory_page ||= InventoryPage.new
end

def cart_page
  @cart_page ||= CartPage.new
end

def login_page
  @login_page ||= LoginPage.new
end

# === STEPS ===
Given('I add the first {int} products from the inventory list') do |count|
  # Usar login_page para asegurar login
  login_page.login_as('standard_user') unless @logged_in_user
  
  count.times do |i|
    inventory_page.add_product_by_index(i)
    expect(cart_page.get_cart_badge_count).to eq(i + 1)
  end
end

Given('I have {string} in the cart') do |product_name|
  # Usar login_page para asegurar login
  login_page.login_as('standard_user') unless @logged_in_user
  
  inventory_page.add_product_by_name(product_name)
  expect(cart_page.get_cart_badge_count).to be > 0
end

Given('I have {string} and {string} in the cart') do |product1, product2|
  step "I have \"#{product1}\" in the cart"
  step "I have \"#{product2}\" in the cart"
end

Given('I have an empty cart') do
  if cart_page.get_cart_badge_count > 0
    cart_page.ensure_on_cart_page
    cart_page.remove_all_items
  end
  
  expect(cart_page.get_cart_badge_count).to eq(0)
end

When('I remove {int} products from the cart') do |count|
  cart_page.ensure_on_cart_page
  
  count.times do
    if cart_page.get_cart_item_count > 0
      cart_page.remove_item(0)
      sleep 0.5
    else
      break
    end
  end
end

When('I click {string} from cart page') do |button_text|
  cart_page.ensure_on_cart_page
  cart_page.click_button(button_text)
end

When('I view the cart page') do
  cart_page.ensure_on_cart_page
end

When('I add {string} to the cart') do |product_name|
  step "I have \"#{product_name}\" in the cart"
end

When('I add another product to the cart') do
  inventory_page.ensure_on_products_page
  inventory_page.add_product_by_index(1)
end

Then('the cart badge should show {int} items') do |expected_count|
  if expected_count > 0
    expect(cart_page.get_cart_badge_count).to eq(expected_count)
  else
    expect(cart_page.get_cart_badge_count).to eq(0)
  end
end

Then('the cart badge should show {int} item') do |count|
  step "the cart badge should show #{count} items"
end

Then('I should be redirected to the products page') do
  expect(inventory_page.on_products_page?).to be true
end

Then('I should be redirected to checkout information page') do
  expect(page.current_url).to include('/checkout-step-one.html')
  expect(page).to have_css('.title', text: 'Checkout: Your Information', wait: 5)
end

Then('I should see the cart page with no items') do
  expect(cart_page.on_cart_page?).to be true
  expect(cart_page.cart_empty?).to be true
end

Then('the cart should show {string} message') do |message|
  expect(cart_page.on_cart_page?).to be true
  expect(cart_page.cart_empty?).to be true
  expect(page).to have_content(message, wait: 5)
end

When('I try to add more than {int} products to the cart') do |max_products|
  inventory_page.ensure_on_products_page
  inventory_page.add_products(max_products)
  expect(page).to have_css('button[id^="remove-"]', count: max_products, wait: 5)
end

Then('I should see only {int} products can be added') do |expected_max|
  expect(cart_page.get_cart_badge_count).to eq(expected_max)
  expect(cart_page.get_cart_item_count).to eq(expected_max)
end

When('I click the {string} button {int} times') do |button_text, times|
  times.times do
    find('button', text: button_text, wait: 5).click
    sleep 0.3
  end
end