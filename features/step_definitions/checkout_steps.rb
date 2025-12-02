require 'capybara/cucumber'

Given('I have {int} product in the cart') do |n|
  n.times do |i|
    all(:xpath, '//button[contains(@class, "btn_inventory")]')[i].click
    sleep 0.3
  end
  expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{n}']")
end

When('I proceed to checkout') do
  find(:xpath, '//a[@class="shopping_cart_link"]').click
  find(:xpath, '//button[@id="checkout"]').click
  expect(page).to have_xpath('//span[contains(text(), "Checkout: Your Information")]')
end

When('I fill checkout information with {string} {string} {string}') do |first_name, last_name, postal_code|
  find(:xpath, '//input[@id="first-name"]').set(first_name)
  find(:xpath, '//input[@id="last-name"]').set(last_name)
  find(:xpath, '//input[@id="postal-code"]').set(postal_code)
  
  @args ||= []
  @args << first_name
  @args << last_name
  @args << postal_code
  
  find(:xpath, '//input[@id="continue"]').click
end

When('I complete the purchase') do
  expect(page).to have_xpath('//span[contains(text(), "Checkout: Overview")]')
  find(:xpath, '//button[@id="finish"]').click
end

Then('I should see the order confirmation') do
  expect(page).to have_xpath('//h2[contains(text(), "Thank you for your order")]')
  expect(page).to have_xpath('//div[contains(text(), "Your order has been dispatched")]')
  find(:xpath, '//button[@id="back-to-products"]').click
  expect(page).to have_xpath('//div[@class="inventory_list"]')
end

When('I try to continue with empty fields') do
  find(:xpath, '//input[@id="continue"]').click
end

Then('I should see checkout error {string}') do |error_message|
  expect(page).to have_xpath("//h3[@data-test='error' and contains(text(), '#{error_message}')]")
  find(:xpath, '//button[@class="error-button"]').click
end

When('I click cancel button on checkout page') do
  find(:xpath, '//button[@id="cancel"]').click
end

Then('I should be redirected to the cart page') do
  expect(page.current_url).to include('/cart.html')
  expect(page).to have_xpath('//span[@class="title" and contains(text(), "Your Cart")]')
end