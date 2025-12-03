require 'capybara/cucumber'

# Constantes para selectores 
BUTTON_SELECTORS = {
  'Add to cart' => '#add-to-cart',
  'Remove' => '#remove',
  'Back to products' => '#back-to-products'
}.freeze

# Helper methods 
def get_cart_count
  if has_css?('.shopping_cart_badge', wait: 2)
    find('.shopping_cart_badge').text.to_i
  else
    0
  end
end

Given('I am on the products page') do
  expect(page).to have_current_path('/inventory.html', wait: 5)
  expect(page).to have_css('span.title', text: 'Products', wait: 5)
end

Given('I am viewing the {string} product detail') do |product_name|
  visit('/inventory.html')
  
  find(:xpath, ".//div[text()='#{product_name}']", wait: 5).click
  
  expect(page).to have_css('#inventory_item_container', wait: 5)
end

When('I click on the {string} product image') do |product_name|
  find(:xpath, ".//img[@alt='#{product_name}']", wait: 5).click
  
  expect(page).to have_css('#inventory_item_container', wait: 5)
end

When('I click the {string} button') do |button_text|
  selector = BUTTON_SELECTORS[button_text] || "button:contains('#{button_text}')"
  find(selector, wait: 5).click
end

Then('I should see the product detail page') do
  expect(page).to have_css('#inventory_item_container', wait: 5)
end

Then('I should see the product name {string}') do |product_name|
  name_element = find('.inventory_details_name.large_size', wait: 5)
  expect(name_element.text).to eq(product_name)
end

Then('I should see the product description') do
  description_element = find('.inventory_details_desc.large_size', wait: 5)
  expect(description_element.text).not_to be_empty
end

Then('I should see the product price {string}') do |expected_price|
  price_element = find('.inventory_details_price', wait: 5)
  
  actual_price = price_element.text
  expect(actual_price).to eq(expected_price)
  
end

Then('I should see the {string} button is visible') do |button_text|
  selector = BUTTON_SELECTORS[button_text] || "button:contains('#{button_text}')"
  expect(page).to have_css(selector, wait: 5, visible: true)
end

Then('I should see the product image is displayed') do
  image_element = find('#inventory_item_container img', wait: 5)
  expect(image_element).to be_visible
  expect(image_element['src']).not_to be_empty
  expect(image_element['alt']).not_to be_empty
end

Then('the shopping cart is empty') do
  expect(get_cart_count).to eq(0)
end

Then('the button text should change to {string}') do |expected_text|
  selector = BUTTON_SELECTORS[expected_text] || "button:contains('#{expected_text}')"
  expect(page).to have_css(selector, wait: 5)
end

Then('the shopping cart badge should display {string} item') do |item_count|
  expect(get_cart_count).to eq(item_count.to_i)
end

Then('I should be able to navigate back to products') do
  expect(page).to have_css('#back-to-products', wait: 5, visible: true)
end

Then('I should return to the inventory page') do
  expect(page).to have_current_path('/inventory.html', wait: 5)
  expect(page).to have_css('span.title', text: 'Products', wait: 5)
end

Then('the cart badge should still show {string} item') do |item_count|
  expect(get_cart_count).to eq(item_count.to_i)
end