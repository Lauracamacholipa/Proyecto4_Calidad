require 'capybara/cucumber'

Given('I have {int} product in the cart') do |n|
  # Ir a products si no estamos allí
  visit('/inventory.html') unless page.current_url.include?('inventory.html')
  
  add_buttons = all(:xpath, '//button[contains(@class, "btn_inventory") and contains(text(), "Add to cart")]')
  
  if n > add_buttons.count
    raise "Only #{add_buttons.count} products available"
  end
  
  n.times do |i|
    add_buttons[i].click
  end
  
  if n > 0
    expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{n}']", wait: 5)
  end
end

When('I proceed to checkout') do
  find(:xpath, '//a[@class="shopping_cart_link"]').click
  expect(page).to have_xpath('//span[@class="title" and contains(text(), "Your Cart")]', wait: 5)
  
  find(:xpath, '//button[@id="checkout"]').click
  expect(page).to have_xpath('//span[@class="title" and contains(text(), "Checkout: Your Information")]', wait: 5)
end

When('I fill checkout information with {string} {string} {string}') do |first_name, last_name, postal_code|
  find(:xpath, '//input[@id="first-name"]').set(first_name)
  find(:xpath, '//input[@id="last-name"]').set(last_name)
  find(:xpath, '//input[@id="postal-code"]').set(postal_code)
  
  # Guardar información para validaciones posteriores (si es necesario)
  @checkout_info = {
    first_name: first_name,
    last_name: last_name,
    postal_code: postal_code
  }
  
  find(:xpath, '//input[@id="continue"]').click
end

When('I complete the purchase') do
  # Primero verificar que estamos en Overview
  expect(page).to have_xpath('//span[@class="title" and contains(text(), "Checkout: Overview")]', wait: 5)
  
  if has_xpath?('//div[@class="summary_total_label"]')
    total_label = find(:xpath, '//div[@class="summary_total_label"]').text
    puts "Total a pagar: #{total_label}"  # Para debug
  end
  
  find(:xpath, '//button[@id="finish"]').click
end

Then('I should see the order confirmation') do
  expect(page).to have_xpath('//h2[contains(text(), "Thank you for your order")]', wait: 5)
  expect(page).to have_xpath('//div[contains(text(), "Your order has been dispatched")]', wait: 5)
  
  # Volver a productos
  find(:xpath, '//button[@id="back-to-products"]').click
  expect(page).to have_xpath('//div[@class="inventory_list"]', wait: 5)
end

When('I try to continue with empty fields') do
  find(:xpath, '//input[@id="continue"]').click
end

Then('I should see checkout error {string}') do |error_message|
  expect(page).to have_xpath("//h3[@data-test='error' and contains(text(), '#{error_message}')]", wait: 5)
  
  # Cerrar mensaje de error si existe
  if has_xpath?('//button[@class="error-button"]')
    find(:xpath, '//button[@class="error-button"]').click
  end
end

When('I click cancel button on checkout page') do
  find(:xpath, '//button[@id="cancel"]').click
end

Then('I should be redirected to the cart page') do
  expect(page.current_url).to include('/cart.html')
  expect(page).to have_xpath('//span[@class="title" and contains(text(), "Your Cart")]', wait: 5)
end

# Validar total de compra (para llegar a 40 pruebas)
Then('I should see the correct payment total including tax') do
  # Verificar que estamos en Overview
  expect(page).to have_xpath('//span[@class="title" and contains(text(), "Checkout: Overview")]', wait: 5)
  
  # Verificar subtotal (sin impuesto)
  expect(page).to have_xpath('//div[@class="summary_subtotal_label"]')
  
  # Verificar impuesto
  expect(page).to have_xpath('//div[@class="summary_tax_label"]')
  
  # Verificar total
  expect(page).to have_xpath('//div[@class="summary_total_label"]')
  
  # Calcular que subtotal + impuesto = total
  if has_xpath?('//div[@class="summary_subtotal_label"]') && 
     has_xpath?('//div[@class="summary_tax_label"]') &&
     has_xpath?('//div[@class="summary_total_label"]')
    
    subtotal_text = find(:xpath, '//div[@class="summary_subtotal_label"]').text
    tax_text = find(:xpath, '//div[@class="summary_tax_label"]').text
    total_text = find(:xpath, '//div[@class="summary_total_label"]').text
    
    # Extraer números
    subtotal = subtotal_text.scan(/\d+\.\d+/).first.to_f
    tax = tax_text.scan(/\d+\.\d+/).first.to_f
    total = total_text.scan(/\d+\.\d+/).first.to_f
    
    # Validar que subtotal + tax = total (con margen de error pequeño)
    expect((subtotal + tax).round(2)).to eq(total.round(2))
  end
end