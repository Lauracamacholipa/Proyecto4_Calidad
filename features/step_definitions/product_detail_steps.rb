require 'capybara/cucumber'
require_relative '../../page_objects/inventory_page'
require_relative '../../page_objects/product_detail_page'
require_relative '../../page_objects/cart_page'

# === PAGE OBJECT INSTANCES ===
def inventory_page
  @inventory_page ||= InventoryPage.new
end

def product_detail_page
  @product_detail_page ||= ProductDetailPage.new
end

def cart_page
  @cart_page ||= CartPage.new
end

# === STEPS ===
Given('I am on the products page') do
  inventory_page.ensure_on_products_page
end

Given('I am viewing the {string} product detail') do |product_name|
  inventory_page.ensure_on_products_page
  inventory_page.click_product_image(product_name)
  expect(product_detail_page.on_product_detail_page?).to be true
end

When('I click on the {string} product image') do |product_name|
  inventory_page.ensure_on_products_page
  inventory_page.click_product_image(product_name)
  expect(product_detail_page.on_product_detail_page?).to be true
end

When('I click the {string} button') do |button_text|
  case button_text
  when 'Add to cart'
    product_detail_page.add_to_cart
  when 'Remove'
    product_detail_page.remove_from_cart
  when 'Back to products'
    product_detail_page.back_to_products
  else
    find('button', text: button_text, wait: 5).click
  end
end

Then('I should see the product detail page') do
  expect(product_detail_page.on_product_detail_page?).to be true
  expect(page.current_url).to include('/inventory-item.html')
end

Then('I should see the product name {string}') do |expected_name|
  expect(product_detail_page.get_product_name).to eq(expected_name)
end

Then('I should see the product description') do
  description = product_detail_page.get_product_description
  expect(description).not_to be_empty
  expect(description.length).to be > 0
end

Then('I should see the product price {string}') do |expected_price|
  expect(product_detail_page.get_product_price).to eq(expected_price)
end

Then('I should see the {string} button is visible') do |button_text|
  expect(page).to have_css('button', text: button_text, wait: 5, visible: true)
end

Then('I should see the product image is displayed') do
  expect(product_detail_page.product_image_visible?).to be true
end

Then('the shopping cart is empty') do
  expect(cart_page.get_cart_badge_count).to eq(0)
end

Then('the button text should change to {string}') do |expected_text|
  expect(product_detail_page.button_text).to eq(expected_text)
end

Then('the shopping cart badge should display {string} item') do |item_count|
  expect(cart_page.get_cart_badge_count).to eq(item_count.to_i)
end

Then('I should be able to navigate back to products') do
  expect(page).to have_css('button', text: 'Back to products', wait: 5, visible: true)
end

Then('I should return to the inventory page') do
  expect(inventory_page.on_products_page?).to be true
end

Then('the cart badge should still show {string} item') do |item_count|
  expect(cart_page.get_cart_badge_count).to eq(item_count.to_i)
end