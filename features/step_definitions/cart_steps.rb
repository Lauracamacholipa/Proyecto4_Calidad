# Step para añadir N productos (para Scenario Outline)
Given('I have {string} products in the cart on cart page') do |string|
  count = string.to_i
  
  # XPATH para todos los botones "Add to cart"
  add_buttons = all(:xpath, '//button[contains(@class, "btn_inventory")]')
  
  # Verificar que hay suficientes productos
  raise "Solo hay #{add_buttons.count} productos disponibles" if count > add_buttons.count
  
  # Añadir la cantidad especificada de productos
  count.times do |i|
    add_buttons[i].click
    sleep 0.3  # Pequeña pausa para estabilidad
  end
  
  # XPATH para verificar el badge del carrito
  if count > 0
    expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{count}']")
    puts "✅ Añadidos #{count} productos al carrito"
  end
end

# Step para remover N productos (para Scenario Outline)
When('I remove {string} products from the cart on cart page') do |string|
  products_to_remove = string.to_i
  
  # XPATH para ir al carrito
  find(:xpath, '//a[@class="shopping_cart_link"]').click
  
  # Verificar que estamos en la página del carrito
  expect(page).to have_xpath('//span[@class="title" and text()="Your Cart"]')
  
  # XPATH para botones "Remove" en el carrito
  products_to_remove.times do |i|
    remove_buttons = all(:xpath, '//button[contains(@class, "cart_button")]')
    remove_buttons.first.click if remove_buttons.any?
    sleep 0.5  # Pausa para visualización
    puts "✅ Producto #{i+1} removido del carrito"
  end
end

# Step para verificar cantidad (para Scenario Outline)
Then('the cart should show {string} items on cart page') do |string|
  remaining_count = string.to_i
  
  if remaining_count > 0
    # XPATH para verificar que el badge muestra el número correcto
    expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{remaining_count}']")
    puts "✅ Carrito muestra #{remaining_count} items"
  else
    # XPATH para verificar que NO hay badge
    expect(page).to have_no_xpath('//span[@class="shopping_cart_badge"]')
    puts "✅ Carrito está vacío"
  end
end

# Step para añadir productos (sin parámetro)
Given('I have products in the cart on cart page') do
  # XPATH para añadir primer producto
  first(:xpath, '//button[contains(@class, "btn_inventory")]').click
  
  # XPATH para verificar que hay algo en el carrito
  expect(page).to have_xpath('//span[@class="shopping_cart_badge"]')
  puts "✅ Producto añadido al carrito"
end

# Step para hacer click en botón específico
When('I click {string} on cart page') do |button_text|
  # XPATH para encontrar botón por texto exacto
  find(:xpath, "//button[text()='#{button_text}']").click
  puts "✅ Click en botón: #{button_text}"
end

# Step para verificar redirección
Then('I should be redirected to the products page from cart') do
  # XPATH para verificar que estamos en la página de productos
  expect(page).to have_xpath('//div[@class="inventory_list"]')
  expect(page).to have_xpath('//span[@class="title" and text()="Products"]')
  puts "✅ Redirigido correctamente a página de productos"
end

# Steps con {int} para mantener compatibilidad
Given('I have {int} products in the cart on cart page') do |count|
  # XPATH para todos los botones "Add to cart"
  add_buttons = all(:xpath, '//button[contains(@class, "btn_inventory")]')
  
  # Añadir la cantidad especificada de productos
  count.times do |i|
    add_buttons[i].click
    sleep 0.3
  end
  
  # XPATH para verificar el badge del carrito
  if count > 0
    expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{count}']")
  end
end

When('I remove {int} products from the cart on cart page') do |products_to_remove|
  # XPATH para ir al carrito
  find(:xpath, '//a[@class="shopping_cart_link"]').click
  
  # XPATH para botones "Remove" en el carrito
  products_to_remove.times do
    first(:xpath, '//button[contains(@class, "cart_button")]').click
    sleep 0.5
  end
end

Then('the cart should show {int} items on cart page') do |remaining_count|
  if remaining_count > 0
    expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{remaining_count}']")
  else
    expect(page).to have_no_xpath('//span[@class="shopping_cart_badge"]')
  end
end