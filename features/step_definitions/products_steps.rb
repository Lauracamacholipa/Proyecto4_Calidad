require 'capybara/cucumber'

# Constantes para selectores (estilo magister)
SELECTORS = {
  inventory_list: '.inventory_list',
  inventory_item: '.inventory_item',
  title_header: 'span.title',
  shopping_cart: '.shopping_cart_link',
  sort_dropdown: '.product_sort_container',
  product_name: '.inventory_item_name',
  product_price: '.inventory_item_price',
  product_button: '.btn_inventory'
}.freeze

# Mapeo de valores del dropdown
DROPDOWN_VALUES = {
  'az' => 'Name (A to Z)',
  'za' => 'Name (Z to A)',
  'lohi' => 'Price (low to high)',
  'hilo' => 'Price (high to low)'
}.freeze

# === PRODUCTS PAGE VALIDATIONS ===
Then('I should see the products page') do
  expect(page.current_url).to include('/inventory.html')
  expect(page).to have_css(SELECTORS[:inventory_list], wait: 5)
  expect(page).to have_css(SELECTORS[:title_header], text: 'Products', wait: 5)
end

Then('I should see exactly {int} products displayed') do |product_count|
  products = page.all(SELECTORS[:inventory_item], wait: 5)
  expect(products.count).to eq(product_count)
end

Then('I should see the {string} header') do |header_text|
  expect(page).to have_css(SELECTORS[:title_header], text: header_text, wait: 5)
end

Then('I should see the shopping cart icon') do
  expect(page).to have_css(SELECTORS[:shopping_cart], wait: 5)
end

Then('I should see the sort dropdown with {string} selected') do |expected_option|
  dropdown = find(SELECTORS[:sort_dropdown], wait: 5)
  selected_text = DROPDOWN_VALUES[dropdown.value] || dropdown.value
  expect(selected_text).to eq(expected_option)
end

Then('each product should have name and {string} button') do |button_text|
  products = page.all(SELECTORS[:inventory_item], wait: 5)
  
  products.each do |product|
    expect(product).to have_css(SELECTORS[:product_name])
    expect(product).to have_button(button_text, wait: 2)
  end
end

Then('I should see products including {string}, {string}, {string}') do |product1, product2, product3|
  product_names = page.all(SELECTORS[:product_name], wait: 5).map(&:text)
  
  [product1, product2, product3].each do |product|
    expect(product_names).to include(product)
  end
end

# === SORTING FUNCTIONALITY ===
When('I select {string} from the sort dropdown') do |sort_option|
  dropdown = find(SELECTORS[:sort_dropdown], wait: 5)
  dropdown.select(sort_option)
  # Esperar a que se reordenen los productos
  expect(page).to have_css(SELECTORS[:inventory_item], wait: 5)
end

Then('the dropdown should display {string} as selected') do |expected_selection|
  dropdown = find(SELECTORS[:sort_dropdown], wait: 5)
  selected_text = DROPDOWN_VALUES[dropdown.value] || dropdown.value
  expect(selected_text).to eq(expected_selection)
end

Then('I should see products sorted by {string}') do |sort_order|
  case sort_order
  when 'alphabetical ascending'
    product_names = page.all(SELECTORS[:product_name], wait: 5).map(&:text)
    expect(product_names).to eq(product_names.sort)
  when 'alphabetical descending'
    product_names = page.all(SELECTORS[:product_name], wait: 5).map(&:text)
    expect(product_names).to eq(product_names.sort.reverse)
  when 'price ascending'
    product_prices = page.all(SELECTORS[:product_price], wait: 5).map do |price|
      price.text.gsub('$', '').to_f
    end
    expect(product_prices).to eq(product_prices.sort)
  when 'price descending'
    product_prices = page.all(SELECTORS[:product_price], wait: 5).map do |price|
      price.text.gsub('$', '').to_f
    end
    expect(product_prices).to eq(product_prices.sort.reverse)
  end
end

Then('the first product should be {string}') do |expected_product|
  first_product = page.first(SELECTORS[:product_name], wait: 5).text
  expect(first_product).to eq(expected_product)
end

Then('the last product should be {string}') do |expected_product|
  products = page.all(SELECTORS[:product_name], wait: 5)
  last_product = products.last.text
  expect(last_product).to eq(expected_product)
end