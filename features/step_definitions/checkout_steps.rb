# Steps para checkout - SOLO XPATH (CORREGIDO)

Given('I have {int} product in the cart') do |count|
  # XPATH para añadir productos
  count.times do |i|
    all(:xpath, '//button[contains(@class, "btn_inventory")]')[i].click
    sleep 0.3
  end
  
  # XPATH para verificar carrito
  expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{count}']")
  puts "✅ #{count} producto(s) añadido(s) para checkout"
end

When('I proceed to checkout') do
  # XPATH para carrito
  find(:xpath, '//a[@class="shopping_cart_link"]').click
  
  # XPATH para botón Checkout
  find(:xpath, '//button[@id="checkout"]').click
  
  # XPATH CORREGIDO: usar contains en lugar de text() exacto
  expect(page).to have_xpath('//span[contains(text(), "Checkout: Your Information")]')
  puts "✅ Procediendo a checkout"
end

When('I fill checkout information with {string} {string} {string}') do |first_name, last_name, postal_code|
  # XPATH para formulario de checkout
  find(:xpath, '//input[@id="first-name"]').set(first_name)
  find(:xpath, '//input[@id="last-name"]').set(last_name)
  find(:xpath, '//input[@id="postal-code"]').set(postal_code)
  
  puts "✅ Información llenada: #{first_name} #{last_name}, #{postal_code}"
  
  # XPATH para botón Continue
  find(:xpath, '//input[@id="continue"]').click
end

When('I complete the purchase') do
  # XPATH para verificar página de resumen
  expect(page).to have_xpath('//span[contains(text(), "Checkout: Overview")]')
  
  # XPATH para botón Finish
  find(:xpath, '//button[@id="finish"]').click
  puts "✅ Compra completada"
end

Then('I should see the order confirmation') do
  # XPATH para verificar confirmación
  expect(page).to have_xpath('//h2[contains(text(), "Thank you for your order")]')
  expect(page).to have_xpath('//div[contains(text(), "Your order has been dispatched")]')
  
  puts "✅ Confirmación de orden visible"
  
  # XPATH para botón Back Home
  find(:xpath, '//button[@id="back-to-products"]').click
  
  # XPATH para verificar que volvimos
  expect(page).to have_xpath('//div[@class="inventory_list"]')
  puts "✅ Regresado a productos"
end

When('I try to continue with empty fields') do
  # XPATH para intentar continuar sin llenar campos
  find(:xpath, '//input[@id="continue"]').click
  puts "✅ Intentando continuar con campos vacíos"
end

Then('I should see error {string}') do |error_message|
  # XPATH para mensaje de error
  expect(page).to have_xpath("//h3[@data-test='error' and contains(text(), '#{error_message}')]")
  
  puts "✅ Error visible: #{error_message}"
  
  # XPATH para botón de cerrar error
  find(:xpath, '//button[@class="error-button"]').click
  puts "✅ Error cerrado"
end