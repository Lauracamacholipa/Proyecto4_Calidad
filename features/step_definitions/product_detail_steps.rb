require 'capybara/cucumber'

# === HELPERS ===
def get_cart_badge_count
  if has_css?('#shopping_cart_container > a > span', wait: 2)
    find('#shopping_cart_container > a > span').text.to_i
  else
    0
  end
end

def ensure_on_products_page
  return if page.current_url.include?('/inventory.html')
  visit('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)
end

# === STEPS ===
Given('I am on the products page') do
  ensure_on_products_page
end

Given('I am viewing the {string} product detail') do |product_name|
  ensure_on_products_page
  
  product_element = find('.inventory_item_name', text: product_name, wait: 10)
  product_element.click
  
  expect(page).to have_css('.inventory_details_container', wait: 10)
end

When('I click on the {string} product image') do |product_name|
  ensure_on_products_page
  
  # Encontrar el contenedor del producto y hacer click en la imagen
  product_element = find('.inventory_item_name', text: product_name, wait: 10)
  container = product_element.ancestor('.inventory_item')
  container.find('img.inventory_item_img').click
  
  expect(page).to have_css('.inventory_details_container', wait: 10)
end

When('I click the {string} button') do |button_text|
  case button_text
  when 'Add to cart'
    find('button', text: 'Add to cart', wait: 10).click
  when 'Remove'
    find('button', text: 'Remove', wait: 10).click
  when 'Back to products'
    find('button', text: 'Back to products', wait: 10).click
  else
    find('button', text: button_text, wait: 10).click
  end
end

Then('I should see the product detail page') do
  expect(page).to have_css('.inventory_details_container', wait: 10)
  expect(page.current_url).to include('/inventory-item.html')
end

Then('I should see the product name {string}') do |expected_name|
  product_name = find('.inventory_details_name', wait: 10).text
  expect(product_name).to eq(expected_name)
end

Then('I should see the product description') do
  description = find('.inventory_details_desc', wait: 10).text
  expect(description).not_to be_empty
  expect(description.length).to be > 0
end

Then('I should see the product price {string}') do |expected_price|
  price = find('.inventory_details_price', wait: 10).text
  expect(price).to eq(expected_price)
end

Then('I should see the {string} button is visible') do |button_text|
  expect(page).to have_css('button', text: button_text, wait: 10, visible: true)
end

Then('I should see the product image is displayed') do
  image = find('.inventory_details_img', wait: 10)
  expect(image).to be_visible
  expect(image['src']).not_to be_empty
  expect(image['alt']).not_to be_empty
end

Then('the shopping cart is empty') do
  expect(get_cart_badge_count).to eq(0)
end

Then('the button text should change to {string}') do |expected_text|
  expect(page).to have_css('button', text: expected_text, wait: 10)
end

Then('the shopping cart badge should display {string} item') do |item_count|
  expect(get_cart_badge_count).to eq(item_count.to_i)
end

Then('I should be able to navigate back to products') do
  expect(page).to have_css('button', text: 'Back to products', wait: 10, visible: true)
end

Then('I should return to the inventory page') do
  expect(page.current_url).to include('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)
end

Then('the cart badge should still show {string} item') do |item_count|
  expect(get_cart_badge_count).to eq(item_count.to_i)
end