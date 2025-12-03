require 'capybara/cucumber'

# === HELPERS ===
def open_side_menu
  find('#react-burger-menu-btn').click
  expect(page).to have_css('.bm-menu-wrap', visible: true, wait: 5)
end

def close_side_menu
  find('#react-burger-cross-btn').click
  expect(page).to have_no_css('.bm-menu-wrap', visible: true, wait: 5)
end

def click_menu_option(option_text)
  find('.bm-item-list').find('a', text: option_text).click
end

def get_cart_badge_count
  if has_css?('#shopping_cart_container > a > span', wait: 2)
    find('#shopping_cart_container > a > span').text.to_i
  else
    0
  end
end

# === STEPS ===
Given('I add {string} to my shopping cart') do |product_name|
  visit('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)
  
  product_element = find('.inventory_item_name', text: product_name, wait: 10)
  container = product_element.ancestor('.inventory_item')
  container.find('.btn_inventory').click
  
  expect(page).to have_css('#shopping_cart_container > a > span', wait: 5)
end

When('I click the menu button') do
  open_side_menu
end

When('I click the close menu button') do
  close_side_menu
end

Then('I should see menu options including {string} and {string}') do |option1, option2|
  expect(page).to have_css('.bm-item-list', visible: true, wait: 5)
  expect(page).to have_content(option1, wait: 5)
  expect(page).to have_content(option2, wait: 5)
end

Then('the menu should not be visible') do
  expect(page).to have_no_css('.bm-menu-wrap', visible: true, wait: 5)
end

When('I click {string} in the menu') do |option_text|
  click_menu_option(option_text)
end

Then('I should be redirected to the login page') do
  expect(page.current_url).to eq(Capybara.app_host + '/')
  expect(page).to have_css('#login-button', wait: 10)
end

When('I return to products page using inventory link') do
  if page.current_url.include?('/cart.html')
    find('#continue-shopping', wait: 10).click
  else
    visit('/inventory.html')
  end
  expect(page).to have_css('.title', text: 'Products', wait: 10)
end

Then('the cart should be empty') do
  expect(page).to have_no_css('#shopping_cart_container > a > span', wait: 10)
end

Then('{string} should show {string} button') do |product_name, button_text|
  product_element = find('.inventory_item_name', text: product_name, wait: 10)
  container = product_element.ancestor('.inventory_item')
  button = container.find('button', wait: 10)
  expect(button.text).to eq(button_text)
end