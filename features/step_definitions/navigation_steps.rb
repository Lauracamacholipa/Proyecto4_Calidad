require 'capybara/cucumber'

# === MENU ACTIONS ===
When('I open the side menu') do
  find(:xpath, '//button[@id="react-burger-menu-btn"]').click
  expect(page).to have_xpath('//div[@class="bm-menu-wrap"]', wait: 5)
end

Then('I should see menu options') do
  # Esperar a que el menú esté visible
  expect(page).to have_xpath('//nav[@class="bm-item-list"]', wait: 5, visible: true)
  
  # Verificar opciones específicas
  expect(page).to have_xpath('//a[@id="logout_sidebar_link" and text()="Logout"]', wait: 5)
  expect(page).to have_xpath('//a[@id="reset_sidebar_link" and text()="Reset App State"]', wait: 5)
end

When('I close the side menu') do
  find(:xpath, '//button[@id="react-burger-cross-btn"]').click
  expect(page).to have_no_xpath('//nav[@class="bm-item-list" and @aria-hidden="false"]', wait: 5)
end

Then('the menu should be closed') do
  expect(page).to have_xpath('//div[@class="bm-menu-wrap" and @aria-hidden="true"]', wait: 5)
end

# === GENERIC MENU SELECTION ===
When('I select {string} from menu') do |menu_option|
  case menu_option
  when 'Logout'
    find(:xpath, '//a[@id="logout_sidebar_link"]').click
  when 'Reset App State'
    find(:xpath, '//a[@id="reset_sidebar_link"]').click
  else
    raise "Unknown menu option: #{menu_option}"
  end
end

# === LOGOUT VALIDATION ===
Then('I should see login page') do
  expect(page.current_url).to eq('https://www.saucedemo.com/')
  expect(page).to have_xpath('//input[@id="login-button"]', wait: 5)
  expect(page).to have_content('Accepted usernames are:', wait: 5)
end

# === CART MANAGEMENT ===
Given('I have product {string} in cart') do |product_name|
  # Buscar el botón del producto específico
  # "Sauce Labs Backpack" tiene id: "add-to-cart-sauce-labs-backpack"
  # Convertir nombre a id de botón
  product_id = product_name.downcase.gsub(' ', '-').gsub('()', '')
  button_id = "add-to-cart-#{product_id}"
  
  find(:xpath, "//button[@id='#{button_id}']").click
  
  # Verificar que se agregó al carrito
  expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='1']", wait: 5)
  
  @product_in_cart = product_name
end

When('I reload page') do
  visit current_url
  # Verificar que la página cargó
  expect(page).to have_xpath('//div[@class="inventory_list"]', wait: 5) if page.current_url.include?('inventory.html')
end

Then('the cart should be empty') do
  expect(page).to have_no_xpath('//span[@class="shopping_cart_badge"]', wait: 5)
end

Then('product {string} should show {string}') do |product_name, button_text|
  # Buscar el botón del producto específico
  product_id = product_name.downcase.gsub(' ', '-').gsub('()', '')
  button_id = "add-to-cart-#{product_id}"
  
  button = find(:xpath, "//button[@id='#{button_id}']", wait: 5)
  expect(button.text).to eq(button_text)
end