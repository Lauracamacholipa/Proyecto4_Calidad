# Step definitions for product_detail.feature

# Given I am on the products page
Given('I am on the products page') do
  expect(page).to have_current_path('/inventory.html')
  expect(page).to have_css('.inventory_list')
end

# Given I am viewing the "Sauce Labs Backpack" product detail
Given('I am viewing the {string} product detail') do |product_name|
  visit('/inventory.html')
  # Click on the product name to go to detail page
  product_link = find(:xpath, "//div[contains(@class, 'inventory_item_name') and text()='#{product_name}']")
  product_link.click
  # Wait for navigation to complete
  sleep(2)
  expect(page.current_path).to include('/inventory-item.html')
end

# When I click on the "Sauce Labs Backpack" product image
When('I click on the {string} product image') do |product_name|
  # Click directly on the product name link
  product_link = find(:xpath, "//div[@class='inventory_item_name ' and text()='#{product_name}']")
  product_link.click
end

# When I click the "Add to cart" button
When('I click the {string} button') do |button_text|
  case button_text
  when 'Add to cart'
    # Find the Add to cart button using class instead of specific ID
    add_button = find(:xpath, '//*[contains(@class, "btn_primary") and contains(@class, "btn_inventory")]')
    add_button.click
  when 'Remove'
    # Find the Remove button using class
    remove_button = find(:xpath, '//*[contains(@class, "btn_secondary") and contains(@class, "btn_inventory")]')
    remove_button.click
  when 'Back to products'
    click_button('back-to-products')
  else
    click_button(button_text.downcase.gsub(' ', '-'))
  end
end

# Then I should see the product detail page
Then('I should see the product detail page') do
  expect(page.current_path).to include('/inventory-item.html')
  expect(page).to have_css('.inventory_details')
end

# Then I should see the product name "Sauce Labs Backpack"
Then('I should see the product name {string}') do |product_name|
  product_name_element = find(:xpath, '//*[@class="inventory_details_name large_size"]')
  puts "ONLY FOR TEST PURPOSES: Product name found: #{product_name_element.text}"
  if product_name_element.text != product_name
    raise "Product name should be #{product_name} but found #{product_name_element.text}"
  end
end

# Then I should see the product description
Then('I should see the product description') do
  description_element = find(:xpath, '//*[@class="inventory_details_desc large_size"]')
  puts "ONLY FOR TEST PURPOSES: Description found: #{description_element.text}"
  expect(description_element.text).not_to be_empty
end

# Then I should see the product price "$29.99"
Then('I should see the product price {string}') do |expected_price|
  price_element = find(:xpath, '//*[@class="inventory_details_price"]')
  puts "ONLY FOR TEST PURPOSES: Price found: #{price_element.text}"
  if price_element.text != expected_price
    raise "Product price should be #{expected_price} but found #{price_element.text}"
  end
end

# Then I should see the "Add to cart" button is visible
Then('I should see the {string} button is visible') do |button_text|
  case button_text
  when 'Add to cart'
    button_element = find(:xpath, '//*[contains(@class, "btn_primary") and contains(@class, "btn_inventory")]')
  when 'Back to products'
    button_element = find(:xpath, '//*[@id="back-to-products"]')
  else
    button_element = find(:xpath, "//*[contains(@class, 'btn') and contains(text(), '#{button_text}')]")
  end
  expect(button_element).to be_visible
end

# Then I should see the product image is displayed
Then('I should see the product image is displayed') do
  image_element = find(:xpath, '//*[contains(@class, "inventory_details_img")]//img')
  expect(image_element).to be_visible
  expect(image_element['src']).not_to be_empty
end

# Then the shopping cart is empty
Then('the shopping cart is empty') do
  cart_badge = page.all(:xpath, '//*[@class="shopping_cart_badge"]')
  if cart_badge.any?
    expect(cart_badge.first.text).to eq('0').or be_empty
  end
end

# Then the button text should change to "Remove"
Then('the button text should change to {string}') do |expected_text|
  case expected_text
  when 'Remove'
    # Find the Remove button using class
    button_element = find(:xpath, '//*[contains(@class, "btn_secondary") and contains(@class, "btn_inventory")]')
    expect(button_element.text).to eq('Remove')
  else
    button_element = find(:xpath, "//*[contains(@class, 'btn') and text()='#{expected_text}']")
    expect(button_element).to be_visible
  end
end

# Then the shopping cart badge should display "1" item
Then('the shopping cart badge should display {string} item') do |item_count|
  cart_badge = find(:xpath, '//*[@class="shopping_cart_badge"]')
  puts "ONLY FOR TEST PURPOSES: Cart badge shows: #{cart_badge.text}"
  if cart_badge.text != item_count
    raise "Cart badge should show #{item_count} but shows #{cart_badge.text}"
  end
end

# Then I should be able to navigate back to products
Then('I should be able to navigate back to products') do
  back_button = find(:xpath, '//*[@id="back-to-products"]')
  expect(back_button).to be_visible
end

# Then I should return to the inventory page
Then('I should return to the inventory page') do
  expect(page).to have_current_path('/inventory.html')
  expect(page).to have_css('.inventory_list')
end

# Then the cart badge should still show "1" item
Then('the cart badge should still show {string} item') do |item_count|
  cart_badge = find(:xpath, '//*[@class="shopping_cart_badge"]')
  puts "ONLY FOR TEST PURPOSES: Cart badge still shows: #{cart_badge.text}"
  if cart_badge.text != item_count
    raise "Cart badge should still show #{item_count} but shows #{cart_badge.text}"
  end
end