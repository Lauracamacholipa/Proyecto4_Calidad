# Step definitions for products.feature

# Given I am on the login page
Given('I am on the login page') do
  page.driver.browser.manage.window.maximize
  visit('/')
  expect(page).to have_css('#login_button_container')
end

# When I login with username "standard_user" and password "secret_sauce"
When('I login with username {string} and password {string}') do |username, password|
  fill_in('user-name', with: username)
  fill_in('password', with: password)
  click_button('login-button')
end

# Then I should see the products page
Then('I should see the products page') do
  expect(page).to have_current_path('/inventory.html')
  expect(page).to have_css('.inventory_list')
end

# Then I should see exactly 6 products displayed
Then('I should see exactly {int} products displayed') do |product_count|
  products = page.all(:xpath, '//*[@class="inventory_item"]')
  puts "ONLY FOR TEST PURPOSES: Found #{products.count} products"
  if products.count != product_count
    raise "Expected #{product_count} products but found #{products.count}"
  end
end

# Then I should see the "Products" header
Then('I should see the {string} header') do |header_text|
  header_element = find(:xpath, '//*[@class="title" and text()="Products"]')
  puts "ONLY FOR TEST PURPOSES: Header found: #{header_element.text}"
  if header_element.text != header_text
    raise "Header should be '#{header_text}' but found '#{header_element.text}'"
  end
end

# Then I should see the shopping cart icon
Then('I should see the shopping cart icon') do
  cart_icon = find(:xpath, '//*[@class="shopping_cart_link"]')
  expect(cart_icon).to be_visible
end

# Then I should see the sort dropdown with "Name (A to Z)" selected
Then('I should see the sort dropdown with {string} selected') do |selected_option|
  dropdown = find(:xpath, '//*[@class="product_sort_container"]')
  selected_value = dropdown.value
  # Map values to text
  value_to_text = {
    'az' => 'Name (A to Z)',
    'za' => 'Name (Z to A)', 
    'lohi' => 'Price (low to high)',
    'hilo' => 'Price (high to low)'
  }
  selected_text = value_to_text[selected_value] || selected_value
  puts "ONLY FOR TEST PURPOSES: Dropdown selected: #{selected_text}"
  if selected_text != selected_option
    raise "Dropdown should show '#{selected_option}' but shows '#{selected_text}'"
  end
end

# Then each product should have a name, description, price and "Add to cart" button
Then('each product should have a name, description, price and {string} button') do |button_text|
  products = page.all(:xpath, '//*[@class="inventory_item"]')
  products.each_with_index do |product, index|
    # Check name
    name = product.find('.inventory_item_name')
    expect(name.text).not_to be_empty
    
    # Check description
    description = product.find('.inventory_item_desc')
    expect(description.text).not_to be_empty
    
    # Check price
    price = product.find('.inventory_item_price')
    expect(price.text).to match(/\$\d+\.\d{1,2}/)
    
    # Check button
    button = product.find('[class*="btn_inventory"]')
    expect(button.text).to eq(button_text)
    
    puts "ONLY FOR TEST PURPOSES: Product #{index + 1} - Name: #{name.text}, Price: #{price.text}"
  end
end

# Then I should see products including "Sauce Labs Backpack", "Sauce Labs Bike Light", "Sauce Labs Bolt T-Shirt"
Then('I should see products including {string}, {string}, {string}') do |product1, product2, product3|
  expected_products = [product1, product2, product3]
  found_products = page.all(:xpath, '//*[contains(@class, "inventory_item_name")]').map(&:text)
  
  expected_products.each do |expected_product|
    if !found_products.include?(expected_product)
      raise "Expected to find product '#{expected_product}' but it was not found. Found products: #{found_products}"
    end
  end
  puts "ONLY FOR TEST PURPOSES: All expected products found: #{expected_products}"
end

# When I select "<sort_criteria>" from the sort dropdown
When('I select {string} from the sort dropdown') do |sort_option|
  dropdown = find(:xpath, '//*[@class="product_sort_container"]')
  dropdown.select(sort_option)
end

# Then the dropdown should display "<sort_criteria>" as selected
Then('the dropdown should display {string} as selected') do |expected_selection|
  dropdown = find(:xpath, '//*[@class="product_sort_container"]')
  selected_value = dropdown.value
  # Convert value to text
  selected_text = dropdown.find("option[value='#{selected_value}']").text
  puts "ONLY FOR TEST PURPOSES: Dropdown now shows: #{selected_text}"
  if selected_text != expected_selection
    raise "Dropdown should show '#{expected_selection}' but shows '#{selected_text}'"
  end
end

# Then I should see products sorted by "<expected_order>"
Then('I should see products sorted by {string}') do |sort_order|
  product_names = page.all(:xpath, '//*[@class="inventory_item_name"]').map(&:text)
  product_prices = page.all(:xpath, '//*[@class="inventory_item_price"]').map { |p| p.text.gsub('$', '').to_f }
  
  case sort_order
  when 'alphabetical ascending'
    sorted_names = product_names.sort
    if product_names != sorted_names
      raise "Products not sorted alphabetically ascending. Found: #{product_names}, Expected: #{sorted_names}"
    end
  when 'alphabetical descending'
    sorted_names = product_names.sort.reverse
    if product_names != sorted_names
      raise "Products not sorted alphabetically descending. Found: #{product_names}, Expected: #{sorted_names}"
    end
  when 'price ascending'
    sorted_prices = product_prices.sort
    if product_prices != sorted_prices
      raise "Products not sorted by price ascending. Found: #{product_prices}, Expected: #{sorted_prices}"
    end
  when 'price descending'
    sorted_prices = product_prices.sort.reverse
    if product_prices != sorted_prices
      raise "Products not sorted by price descending. Found: #{product_prices}, Expected: #{sorted_prices}"
    end
  end
  puts "ONLY FOR TEST PURPOSES: Products correctly sorted by #{sort_order}"
end

# Then the first product should be "<first_product>"
Then('the first product should be {string}') do |expected_first_product|
  first_product = find(:xpath, '(//*[@class="inventory_item_name "])[1]').text
  puts "ONLY FOR TEST PURPOSES: First product is: #{first_product}"
  if first_product != expected_first_product
    raise "First product should be '#{expected_first_product}' but found '#{first_product}'"
  end
end

# Then the last product should be "<last_product>"
Then('the last product should be {string}') do |expected_last_product|
  last_product = find(:xpath, '(//*[@class="inventory_item_name "])[6]').text
  puts "ONLY FOR TEST PURPOSES: Last product is: #{last_product}"
  if last_product != expected_last_product
    raise "Last product should be '#{expected_last_product}' but found '#{last_product}'"
  end
end