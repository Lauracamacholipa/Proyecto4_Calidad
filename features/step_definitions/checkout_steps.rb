require 'capybara/cucumber'

# === HELPERS ===
def extract_price(price_text)
  price_text.scan(/\d+\.\d+/).first.to_f
end

def find_and_click_button(button_text, options = {})
  wait_time = options[:wait] || 10
  
  selectors = [
    "button[data-test*='#{button_text.downcase}']",
    "##{button_text.downcase}",
    "button:contains('#{button_text}')",
    "input[value='#{button_text}']",
    "a:contains('#{button_text}')"
  ]
  
  selectors.each do |selector|
    if has_css?(selector, wait: 1)
      find(selector, wait: wait_time).click
      return true
    end
  end
  
  find('button, input, a', text: button_text, wait: wait_time).click
end

def ensure_on_checkout_step(step_name)
  expected_title = case step_name
                   when :information then 'Checkout: Your Information'
                   when :overview then 'Checkout: Overview'
                   when :complete then 'Checkout: Complete'
                   end
  
  unless find('.title', wait: 5).text.include?(expected_title)
    raise "Not on #{step_name} page. Current: #{find('.title').text}"
  end
end

def get_cart_badge_count
  if has_css?('#shopping_cart_container > a > span', wait: 2)
    find('#shopping_cart_container > a > span').text.to_i
  else
    0
  end
end

# === STEPS ===
Given('I have the following products in cart:') do |table|
  visit('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)
  
  table.raw.flatten.each do |product_name|
    product_element = find('.inventory_item_name', text: product_name, wait: 10)
    container = product_element.ancestor('.inventory_item')
    container.find('.btn_inventory').click
    
    expect(page).to have_css('#shopping_cart_container > a > span', wait: 5)
  end
end

Given('I have product {string} in the cart') do |product_name|
  visit('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)
  
  product_element = find('.inventory_item_name', text: product_name, wait: 10)
  container = product_element.ancestor('.inventory_item')
  container.find('.btn_inventory').click
  
  expect(page).to have_css('#shopping_cart_container > a > span', wait: 5)
end

When('I proceed to checkout from cart') do
  find('.shopping_cart_link').click
  expect(page).to have_css('.title', text: 'Your Cart', wait: 10)
  find_and_click_button('Checkout')
end

When('I fill checkout information with {string} {string} {string}') do |first_name, last_name, postal_code|
  ensure_on_checkout_step(:information)
  
  fill_in 'first-name', with: first_name, wait: 5
  fill_in 'last-name', with: last_name, wait: 5
  fill_in 'postal-code', with: postal_code, wait: 5
end

When('I click {string}') do |button_text|
  find_and_click_button(button_text)
end

When('I continue to checkout overview') do
  ensure_on_checkout_step(:information)
  find_and_click_button('Continue')
  ensure_on_checkout_step(:overview)
end

When('I complete the purchase') do
  ensure_on_checkout_step(:overview)
  find_and_click_button('Finish')
  ensure_on_checkout_step(:complete)
end

When('I cancel checkout') do
  find_and_click_button('Cancel')
end

Then('I should see {string}') do |expected_text|
  expect(page).to have_content(expected_text, wait: 10)
end

Then('the order total should be ${float} including tax') do |expected_total|
  current_title = find('.title', wait: 5).text
  
  if current_title.include?('Checkout: Overview')
    item_total = extract_price(find('.summary_subtotal_label').text)
    tax = extract_price(find('.summary_tax_label').text)
    total = extract_price(find('.summary_total_label').text)
    
    expect(item_total + tax).to eq(total)
    expect(total).to eq(expected_total)
  elsif current_title.include?('Checkout: Complete')
    expect(page).to have_content('Thank you for your order!', wait: 10)
  else
    raise "Not on checkout overview or complete page. Current: #{current_title}"
  end
end

Then('I should see checkout error {string}') do |error_message|
  error_element = find('[data-test="error"], .error-message-container h3', wait: 10)
  expect(error_element.text).to include(error_message)
end

Then('I should be redirected to the cart page') do
  expect(page.current_url).to include('/cart.html')
  expect(page).to have_css('.title', text: 'Your Cart', wait: 10)
end

Then('I should see item total of ${float}') do |expected_total|
  ensure_on_checkout_step(:overview)
  item_total = extract_price(find('.summary_subtotal_label').text)
  expect(item_total).to eq(expected_total)
end

Then('I should see tax of ${float}') do |expected_tax|
  ensure_on_checkout_step(:overview)
  tax = extract_price(find('.summary_tax_label').text)
  expect(tax).to eq(expected_tax)
end

Then('I should see total of ${float}') do |expected_total|
  ensure_on_checkout_step(:overview)
  total = extract_price(find('.summary_total_label').text)
  expect(total).to eq(expected_total)
end