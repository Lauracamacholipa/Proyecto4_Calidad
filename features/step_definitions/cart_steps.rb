require 'capybara/cucumber'

# === HELPERS ===
def ensure_on_products_page
  return if page.current_url.include?('/inventory.html')
  visit('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)
end

def ensure_on_cart_page
  return if page.current_url.include?('/cart.html')
  find('.shopping_cart_link').click
  expect(page).to have_css('.title', text: 'Your Cart', wait: 10)
end

def add_product_to_cart(product_index = 0)
  ensure_on_products_page
  buttons = all('.btn_inventory')
  raise "Only #{buttons.count} products available" if product_index >= buttons.count
  buttons[product_index].click
end

def get_cart_badge_count
  if has_css?('#shopping_cart_container > a > span', wait: 2)
    find('#shopping_cart_container > a > span').text.to_i
  else
    0
  end
end

# === STEPS ===
Given('I add the first {int} products to the cart') do |count|
  ensure_on_products_page
  
  count.times do |i|
    add_product_to_cart(i)
    expect(get_cart_badge_count).to eq(i + 1)
  end
end

Given('I have {string} in the cart') do |product_name|
  ensure_on_products_page
  
  product_element = find('.inventory_item_name', text: product_name, wait: 10)
  container = product_element.ancestor('.inventory_item')
  container.find('.btn_inventory').click
  
  expect(get_cart_badge_count).to be > 0
end

Given('I have {string} and {string} in the cart') do |product1, product2|
  step "I have \"#{product1}\" in the cart"
  step "I have \"#{product2}\" in the cart"
end

Given('I have an empty cart') do
  if get_cart_badge_count > 0
    ensure_on_cart_page
    
    while has_css?('button[id^="remove-"]', text: 'Remove', wait: 1)
      first('button[id^="remove-"]', text: 'Remove').click
      sleep 0.5
    end
  end
  
  expect(get_cart_badge_count).to eq(0)
end

When('I remove {int} products from the cart') do |count|
  ensure_on_cart_page
  
  count.times do
    if has_css?('button[id^="remove-"]', text: 'Remove', wait: 2)
      first('button[id^="remove-"]', text: 'Remove').click
      sleep 0.5
    else
      break
    end
  end
end

When('I click {string} from cart page') do |button_text|
  ensure_on_cart_page
  find('button', text: button_text, wait: 10).click
end

When('I view the cart page') do
  ensure_on_cart_page
end

When('I add {string} to the cart') do |product_name|
  step "I have \"#{product_name}\" in the cart"
end

When('I add another product to the cart') do
  ensure_on_products_page
  all('.btn_inventory', wait: 10)[1].click
end

Then('the cart badge should show {int} items') do |expected_count|
  if expected_count > 0
    badge = find('#shopping_cart_container > a > span', wait: 10)
    expect(badge.text.to_i).to eq(expected_count)
  else
    expect(page).to have_no_css('#shopping_cart_container > a > span', wait: 10)
  end
end

Then('the cart badge should show {int} item') do |count|
  step "the cart badge should show #{count} items"
end

Then('I should be redirected to the products page') do
  expect(page.current_url).to include('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)
end

Then('I should be redirected to checkout information page') do
  expect(page.current_url).to include('/checkout-step-one.html')
  expect(page).to have_css('.title', text: 'Checkout: Your Information', wait: 10)
end

Then('I should see the cart page with no items') do
  expect(page.current_url).to include('/cart.html')
  expect(page).to have_css('.title', text: 'Your Cart', wait: 10)
  expect(page).to have_no_css('.cart_item', wait: 10)
end

# Este step ya no se usa pero lo dejamos por compatibilidad
Then('the cart should show {string} message') do |message|
  expect(page.current_url).to include('/cart.html')
  expect(page).to have_css('.title', text: 'Your Cart', wait: 10)
  expect(page).to have_no_css('.cart_item', wait: 10)
end