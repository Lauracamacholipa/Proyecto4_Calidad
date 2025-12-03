require 'capybara/cucumber'

# === HELPERS ===
def ensure_on_products_page
  return if page.current_url.include?('/inventory.html')
  visit('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)
end

def get_product_names
  page.all('.inventory_item_name', wait: 10).map(&:text)
end

def get_product_prices
  page.all('.inventory_item_price', wait: 10).map do |price|
    price.text.gsub('$', '').to_f
  end
end

# Mapeo de valores del dropdown (valor interno -> texto visible)
DROPDOWN_MAPPING = {
  'az' => 'Name (A to Z)',
  'za' => 'Name (Z to A)',
  'lohi' => 'Price (low to high)',
  'hilo' => 'Price (high to low)'
}.freeze

# === STEPS ===
Then('I should see the products page') do
  expect(page.current_url).to include('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)
  expect(page).to have_css('.inventory_list', wait: 10)
end

Then('I should see exactly {int} products displayed') do |product_count|
  products = page.all('.inventory_item', wait: 10)
  expect(products.count).to eq(product_count)
end

Then('I should see the {string} header') do |header_text|
  expect(page).to have_css('.title', text: header_text, wait: 10)
end

Then('I should see the shopping cart icon') do
  expect(page).to have_css('.shopping_cart_link', wait: 10)
end

Then('I should see the sort dropdown with {string} selected') do |expected_option|
  dropdown = find('.product_sort_container', wait: 10)
  
  # Obtener el valor interno seleccionado
  selected_value = dropdown.value
  
  # Convertir a texto visible usando nuestro mapeo
  selected_text = DROPDOWN_MAPPING[selected_value] || selected_value
  
  expect(selected_text).to eq(expected_option)
end

Then('each product should have name and {string} button') do |button_text|
  products = page.all('.inventory_item', wait: 10)
  
  products.each do |product|
    expect(product).to have_css('.inventory_item_name', wait: 5)
    expect(product).to have_css('button', text: button_text, wait: 5)
  end
end

Then('I should see products including {string}, {string}, {string}') do |product1, product2, product3|
  product_names = get_product_names
  
  [product1, product2, product3].each do |product|
    expect(product_names).to include(product)
  end
end

When('I select {string} from the sort dropdown') do |sort_option|
  dropdown = find('.product_sort_container', wait: 10)
  dropdown.select(sort_option)
  
  # Esperar a que se reordenen los productos
  sleep 1
  expect(page).to have_css('.inventory_item', wait: 10)
end

Then('the dropdown should display {string} as selected') do |expected_selection|
  dropdown = find('.product_sort_container', wait: 10)
  
  # Obtener el valor interno
  selected_value = dropdown.value
  
  # Convertir a texto visible
  selected_text = DROPDOWN_MAPPING[selected_value] || selected_value
  
  expect(selected_text).to eq(expected_selection)
end

Then('I should see products sorted by {string}') do |sort_order|
  case sort_order
  when 'alphabetical ascending'
    product_names = get_product_names
    expect(product_names).to eq(product_names.sort)
    
  when 'alphabetical descending'
    product_names = get_product_names
    expect(product_names).to eq(product_names.sort.reverse)
    
  when 'price ascending'
    product_prices = get_product_prices
    expect(product_prices).to eq(product_prices.sort)
    
  when 'price descending'
    product_prices = get_product_prices
    expect(product_prices).to eq(product_prices.sort.reverse)
    
  else
    raise "Unknown sort order: #{sort_order}"
  end
end

Then('the first product should be {string}') do |expected_product|
  first_product = page.first('.inventory_item_name', wait: 10).text
  expect(first_product).to eq(expected_product)
end

Then('the last product should be {string}') do |expected_product|
  products = page.all('.inventory_item_name', wait: 10)
  last_product = products.last.text
  expect(last_product).to eq(expected_product)
end