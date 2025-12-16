require 'capybara/cucumber'
require_relative '../../page_objects/inventory_page'

# === PAGE OBJECT INSTANCE ===
def inventory_page
  @inventory_page ||= InventoryPage.new
end

# === STEPS ===
Then('I should see the products page') do
  expect(inventory_page.on_products_page?).to be true
  expect(page).to have_css('.inventory_list', wait: 5)
end

Then('I should see exactly {int} products displayed') do |product_count|
  expect(inventory_page.get_product_count).to eq(product_count)
end

Then('I should see the {string} header') do |header_text|
  expect(page).to have_css('.title', text: header_text, wait: 5)
end

Then('I should see the shopping cart icon') do
  expect(page).to have_css('.shopping_cart_link', wait: 5)
end

Then('I should see the sort dropdown with {string} selected') do |expected_option|
  expect(inventory_page.get_selected_sort_option).to eq(expected_option)
end

Then('each product should have name and {string} button') do |button_text|
  inventory_page.ensure_on_products_page
  
  products = inventory_page.find_all_elements('.inventory_item')
  
  products.each do |product|
    expect(product).to have_css('.inventory_item_name', wait: 5)
    
    button = product.all('button').find { |btn| btn.text == button_text }
    expect(button).not_to be_nil, "Producto no tiene botón '#{button_text}'"
  end
end

Then('I should see products including {string}, {string}, {string}') do |product1, product2, product3|
  product_names = inventory_page.get_product_names
  
  [product1, product2, product3].each do |product|
    expect(product_names).to include(product)
  end
end

When('I select {string} from the sort dropdown') do |sort_option|
  inventory_page.sort_products(sort_option)
end

Then('the dropdown should display {string} as selected') do |expected_selection|
  expect(inventory_page.get_selected_sort_option).to eq(expected_selection)
end

Then('I should see products sorted by {string}') do |sort_order|
  case sort_order
  when 'alphabetical ascending'
    expect(inventory_page.sorted_by_name_a_to_z?).to be true
  when 'alphabetical descending'
    expect(inventory_page.sorted_by_name_z_to_a?).to be true
  when 'price ascending'
    expect(inventory_page.sorted_by_price_low_to_high?).to be true
  when 'price descending'
    expect(inventory_page.sorted_by_price_high_to_low?).to be true
  else
    raise "Unknown sort order: #{sort_order}"
  end
end

Then('the first product should be {string}') do |expected_product|
  first_product = inventory_page.get_product_names.first
  expect(first_product).to eq(expected_product)
end

Then('the last product should be {string}') do |expected_product|
  last_product = inventory_page.get_product_names.last
  expect(last_product).to eq(expected_product)
end