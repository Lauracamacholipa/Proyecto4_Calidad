require 'capybara/cucumber'

# === HELPER METHOD ===
def wait_for_ui(seconds = 1)
  sleep seconds
end

# === MENU ACTIONS ===
When('I open the side menu') do
  wait_for_ui(1)
  find(:xpath, '//*[@id="react-burger-menu-btn"]').click
  wait_for_ui(1)
end

Then('I should see menu options') do
  expect(page).to have_xpath('//*[@id="menu_button_container"]/div/div[2]/div[1]', visible: true)
  
  expect(page).to have_content('Logout')
  expect(page).to have_content('Reset App State')
end

When('I close the side menu') do
  find(:xpath, '//*[@id="react-burger-cross-btn"]').click
  wait_for_ui(1)
end

Then('the menu should be closed') do
  expect(page).to have_no_xpath('//*[@id="menu_button_container"]/div/div[2]/div[1]', visible: true)
end

# === GENERIC MENU SELECTION ===
When('I select {string} from menu') do |menu_option|
  case menu_option
  when 'Logout'
    find(:xpath, '//*[@id="logout_sidebar_link"]').click
  when 'Reset App State'
    find(:xpath, '//*[@id="reset_sidebar_link"]').click
  else
    raise "Unknown menu option: #{menu_option}"
  end
  wait_for_ui(1)
end

# === LOGOUT VALIDATION ===
Then('I should see login page') do
  expect(page.current_url).to eq('https://www.saucedemo.com/')
  
  expect(page).to have_xpath('//*[@id="login-button"]')
  expect(page).to have_content('Accepted usernames are:')
end

# === CART MANAGEMENT ===
Given('I have product {string} in cart') do |product_name|
  find(:xpath, '//*[@id="add-to-cart-sauce-labs-backpack"]').click
  wait_for_ui(1)
  
  cart_count = find(:xpath, '//*[@id="shopping_cart_container"]/a/span', visible: true)
  expect(cart_count.text).to eq('1')
  
  @product_in_cart = product_name
end

When('I reload page') do
  visit current_url
  wait_for_ui(2)
end

Then('the cart should be empty') do
  expect(page).to have_no_xpath('//*[@id="shopping_cart_container"]/a/span')
end

Then('product {string} should show {string}') do |product_name, button_text|
  button = find(:xpath, '//*[@id="add-to-cart-sauce-labs-backpack"]')
  expect(button.text).to eq(button_text)
end