require 'capybara/cucumber'
require 'selenium-webdriver'

# === HELPER METHODS ===
def close_password_popup
  begin
    sleep 1
    page.driver.browser.action.send_keys(:escape).perform
    sleep 0.5
    page.driver.browser.action.send_keys(:escape).perform
  rescue
  end
end

# === MENU ACTIONS ===
When('I click the hamburger menu button') do
  close_password_popup
  sleep 1
  find(:xpath, '//*[@id="react-burger-menu-btn"]').click
  sleep 1
end

Then('I should see the side menu with all options') do
  expect(page).to have_xpath('//*[@id="menu_button_container"]/div/div[2]/div[1]', visible: true)
  
  expect(page).to have_xpath('//*[@id="inventory_sidebar_link"]', text: 'All Items', visible: true)
  expect(page).to have_xpath('//*[@id="about_sidebar_link"]', text: 'About', visible: true)
  expect(page).to have_xpath('//*[@id="logout_sidebar_link"]', text: 'Logout', visible: true)
  expect(page).to have_xpath('//*[@id="reset_sidebar_link"]', text: 'Reset App State', visible: true)
end

When('I click the close menu button') do
  find(:xpath, '//*[@id="react-burger-cross-btn"]').click
  sleep 1
end

Then('the side menu should not be visible') do
  expect(page).to have_no_xpath('//*[@id="menu_button_container"]/div/div[2]/div[1]', visible: true)
  expect(page).to have_no_xpath('//*[@id="react-burger-cross-btn"]', visible: true)
end

# === LOGOUT ===
When('I click the logout option') do
  find(:xpath, '//*[@id="logout_sidebar_link"]').click
  sleep 1
end

Then('I should be redirected to the login page at {string}') do |expected_path|
  expect(page.current_url).to eq("https://www.saucedemo.com#{expected_path}")
end

Then('I should see the login form elements') do
  expect(page).to have_xpath('//*[@id="user-name"]')
  expect(page).to have_xpath('//*[@id="password"]')
  expect(page).to have_xpath('//*[@id="login-button"]')
  expect(page).to have_content('Accepted usernames are:')
end

# === RESET APP STATE ===
Given('I have added {string} to the cart') do |product_name|
  find(:xpath, '//*[@id="add-to-cart-sauce-labs-backpack"]').click
  sleep 1
  @product_name = product_name
end

Given('the cart shows {string} item') do |item_count|
  if item_count.to_i > 0
    expect(page).to have_xpath('//*[@id="shopping_cart_container"]/a/span', text: item_count)
  else
    expect(page).to have_no_xpath('//*[@id="shopping_cart_container"]/a/span')
  end
end

When('I click the reset app state option') do
  find(:xpath, '//*[@id="reset_sidebar_link"]').click
  sleep 1
end

When('I reload the current page') do
  visit current_url
  sleep 2
end

Then('the {string} product should show {string} button') do |product_name, button_text|
  button = find(:xpath, '//*[@id="add-to-cart-sauce-labs-backpack"]')
  expect(button.text).to eq(button_text)
  expect(button).to be_visible
end

Then('the cart should show {string} items') do |item_count|
  if item_count.to_i > 0
    expect(page).to have_xpath('//*[@id="shopping_cart_container"]/a/span', text: item_count)
  else
    expect(page).to have_no_xpath('//*[@id="shopping_cart_container"]/a/span')
  end
end

# === ABOUT PAGE ===
When('I click the about option') do
  find(:xpath, '//*[@id="about_sidebar_link"]').click
  sleep 2
end

Then('I should be redirected to the Sauce Labs website') do
  expect(page.current_url).to start_with('https://saucelabs.com/')
end

Then('I should see the text {string}') do |expected_text|
  sauce_ai_element = find(:xpath, '//*[@id="__next"]/div[1]/div/div/div/div[1]/p')
  expect(sauce_ai_element.text).to include(expected_text)
end