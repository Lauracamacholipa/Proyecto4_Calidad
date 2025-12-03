require 'capybara/cucumber'

Given('I have {int} products in the cart on cart page') do |count|
  # Ir a products si no estamos allí
  visit('/inventory.html') unless page.current_url.include?('inventory.html')
  
  add_buttons = all(:xpath, '//button[contains(@class, "btn_inventory") and contains(text(), "Add to cart")]')
  
  if count > add_buttons.count
    raise "Only #{add_buttons.count} products available"
  end
  
  count.times do |i|
    add_buttons[i].click
  end
  
  if count > 0
    expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{count}']", wait: 5)
  end
end

# Para mantener compatibilidad con string
Given('I have {string} products in the cart on cart page') do |str_count|
  count = str_count.to_i
  step "I have #{count} products in the cart on cart page"
end

When('I remove {int} products from the cart on cart page') do |count|
  # Ir al carrito
  find(:xpath, '//a[@class="shopping_cart_link"]').click
  expect(page).to have_xpath('//span[@class="title" and contains(text(), "Your Cart")]', wait: 5)
  
  count.times do
    remove_buttons = all(:xpath, '//button[text()="Remove"]')
    break unless remove_buttons.any?
    remove_buttons.first.click
  end
  
  # Volver a products si aún estamos en carrito
  if page.current_url.include?('cart.html')
    find(:xpath, '//button[@id="continue-shopping"]').click if has_xpath?('//button[@id="continue-shopping"]')
  end
end

Then('the cart should show {int} items on cart page') do |count|
  if count > 0
    expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{count}']", wait: 5)
  else
    expect(page).to have_no_xpath('//span[@class="shopping_cart_badge"]', wait: 5)
  end
end

Given('I have products in the cart on cart page') do
  step 'I have 1 products in the cart on cart page'
end

When('I click {string} on cart page') do |button_text|
  # Ir al carrito si no estamos allí
  unless page.current_url.include?('cart.html')
    find(:xpath, '//a[@class="shopping_cart_link"]').click
    expect(page).to have_xpath('//span[@class="title" and contains(text(), "Your Cart")]', wait: 5)
  end
  
  find(:xpath, "//button[text()='#{button_text}']").click
end

Then('I should be redirected to the products page from cart') do
  expect(page.current_url).to include('/inventory.html')
  expect(page).to have_xpath('//div[@class="inventory_list"]', wait: 5)
  expect(page).to have_xpath('//span[@class="title" and text()="Products"]', wait: 5)
end

Then('I should be redirected to checkout page') do
  expect(page.current_url).to include('/checkout-step-one.html')
  expect(page).to have_xpath('//span[@class="title" and text()="Checkout: Your Information"]', wait: 5)
end

Given('I add one more product to cart') do
  # Asumimos que estamos en products page
  add_buttons = all(:xpath, '//button[text()="Add to cart"]')
  raise 'No hay productos para agregar' unless add_buttons.any?
  
  add_buttons.first.click
  
  # Verificar que se actualizó el badge
  current_badge = find(:xpath, '//span[@class="shopping_cart_badge"]').text.to_i
  expect(current_badge).to be > 0
end