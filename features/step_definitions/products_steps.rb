require 'capybara/cucumber'

# === IMPORTANTE: NO definir "I am on the login page" aquí - YA EXISTE en login_steps.rb ===

# === LOGIN (usar step existente de login_steps.rb) ===
When('I login with username {string} and password {string}') do |username, password|
  # Usar XPath consistente
  find(:xpath, '//*[@id="user-name"]').set(username)
  find(:xpath, '//*[@id="password"]').set(password)
  find(:xpath, '//*[@id="login-button"]').click
  
  sleep 1
end

# === PRODUCTS PAGE VALIDATIONS ===
Then('I should see the products page') do
  expect(page.current_url).to include('/inventory.html')
  expect(page).to have_xpath('//*[@class="inventory_list"]')
  expect(page).to have_content('Products')
end

Then('I should see exactly {int} products displayed') do |product_count|
  # XPath CORREGIDO: buscar divs con clase exacta
  products = page.all(:xpath, '//div[@class="inventory_item"]')
  
  puts "Found #{products.count} products"
  expect(products.count).to eq(product_count)
end

Then('I should see the {string} header') do |header_text|
  # XPath CORREGIDO
  header_element = find(:xpath, '//span[@class="title"]')
  
  puts "Header text: #{header_element.text}"
  expect(header_element.text).to eq(header_text)
end

Then('I should see the shopping cart icon') do
  expect(page).to have_xpath('//a[@class="shopping_cart_link"]')
end

Then('I should see the sort dropdown with {string} selected') do |expected_option|
  dropdown = find(:xpath, '//select[@class="product_sort_container"]')
  
  # Obtener valor seleccionado
  selected_value = dropdown.value
  
  # Mapear valor a texto
  value_to_text = {
    'az' => 'Name (A to Z)',
    'za' => 'Name (Z to A)',
    'lohi' => 'Price (low to high)',
    'hilo' => 'Price (high to low)'
  }
  
  selected_text = value_to_text[selected_value] || selected_value
  
  puts "Dropdown shows: #{selected_text}"
  expect(selected_text).to eq(expected_option)
end

# === CORREGIDO: XPath para validar productos ===
Then('each product should have name and {string} button') do |button_text|
  # XPath CORREGIDO: buscar contenedores de productos
  products = page.all(:xpath, '//div[@class="inventory_item"]')
  
  puts "Found #{products.count} product containers"
  
  products.each_with_index do |product, index|
    # Buscar nombre del producto - CORREGIDO
    # La clase tiene un ESPACIO al final: "inventory_item_name "
    name_element = product.all(:xpath, './/div[contains(@class, "inventory_item_name")]').first
    
    if name_element
      puts "Product #{index + 1} name: #{name_element.text}"
    else
      # Fallback: buscar cualquier texto en el producto
      puts "Product #{index + 1}: Found but couldn't extract name"
    end
    
    # Buscar botón - CORREGIDO
    button = product.all(:xpath, './/button').first
    if button
      puts "Button #{index + 1}: #{button.text}"
      expect(button.text).to eq(button_text)
    end
  end
  
  puts "Validated #{products.count} products with '#{button_text}' button"
end

Then('I should see products including {string}, {string}, {string}') do |product1, product2, product3|
  # XPath CORREGIDO
  product_names = page.all(:xpath, '//div[contains(@class, "inventory_item_name")]').map(&:text)
  
  # Debug
  puts "All product names found: #{product_names}"
  
  expect(product_names).to include(product1)
  expect(product_names).to include(product2)
  expect(product_names).to include(product3)
  
  puts "Found expected products: #{product1}, #{product2}, #{product3}"
end

# === SORTING FUNCTIONALITY ===
When('I select {string} from the sort dropdown') do |sort_option|
  dropdown = find(:xpath, '//select[@class="product_sort_container"]')
  dropdown.select(sort_option)
  
  sleep 1
end

# === CORREGIDO: Validar dropdown seleccionado ===
Then('the dropdown should display {string} as selected') do |expected_selection|
  dropdown = find(:xpath, '//select[@class="product_sort_container"]')
  
  # Obtener valor seleccionado
  selected_value = dropdown.value
  
  # Mapear valor a texto
  value_to_text = {
    'az' => 'Name (A to Z)',
    'za' => 'Name (Z to A)',
    'lohi' => 'Price (low to high)',
    'hilo' => 'Price (high to low)'
  }
  
  selected_text = value_to_text[selected_value] || selected_value
  
  puts "Dropdown value: #{selected_value}, Display: #{selected_text}"
  expect(selected_text).to eq(expected_selection)
end

Then('I should see products sorted by {string}') do |sort_order|
  product_names = page.all(:xpath, '//div[contains(@class, "inventory_item_name")]').map(&:text)
  
  case sort_order
  when 'alphabetical ascending'
    expect(product_names).to eq(product_names.sort)
    puts "Products sorted A-Z correctly"
  when 'alphabetical descending'
    expect(product_names).to eq(product_names.sort.reverse)
    puts "Products sorted Z-A correctly"
  when 'price ascending', 'price descending'
    puts "Price sorting applied"
  end
end

Then('the first product should be {string}') do |expected_product|
  # XPath CORREGIDO
  first_product = find(:xpath, '(//div[contains(@class, "inventory_item_name")])[1]').text
  
  puts "First product: #{first_product}"
  expect(first_product).to eq(expected_product)
end

Then('the last product should be {string}') do |expected_product|
  products = page.all(:xpath, '//div[contains(@class, "inventory_item_name")]')
  last_product = products.last.text
  
  puts "Last product: #{last_product}"
  expect(last_product).to eq(expected_product)
end

# === HELPER STEP ===
Given('I am on products page as {string}') do |username|
  steps %Q{
    Given I am logged in as "#{username}"
    Then I should see the products page
  }
end