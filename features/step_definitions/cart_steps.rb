require 'capybara/cucumber'

Given('I have {string} products in the cart on cart page') do |n|
  count = n.to_i
  add_buttons = all(:xpath, '//button[contains(@class, "btn_inventory")]')
  
  if count > add_buttons.count
    raise "Only #{add_buttons.count} products available"
  end
  
  @args ||= []
  count.times do |i|
    add_buttons[i].click
    @args << i
    sleep 0.2
  end
  
  if count > 0
    expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{count}']")
  end
end

When('I remove {string} products from the cart on cart page') do |n|
  products_to_remove = n.to_i
  find(:xpath, '//a[@class="shopping_cart_link"]').click
  expect(page).to have_xpath('//span[@class="title" and contains(text(), "Your Cart")]')
  
  @args ||= []
  products_to_remove.times do
    remove_buttons = all(:xpath, '//button[text()="Remove"]')
    if remove_buttons.any?
      remove_buttons.first.click
      @args.pop if @args.any?
      sleep 0.3
    else
      break
    end
  end
  
  if page.current_url.include?('cart.html')
    find(:xpath, '//button[@id="continue-shopping"]').click rescue nil
  end
end

Then('the cart should show {string} items on cart page') do |n|
  remaining_count = n.to_i
  if remaining_count > 0
    expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{remaining_count}']")
  else
    expect(page).to have_no_xpath('//span[@class="shopping_cart_badge"]')
  end
end

Given('I have products in the cart on cart page') do
  add_buttons = all(:xpath, '//button[contains(@class, "btn_inventory")]')
  if add_buttons.any?
    add_buttons.first.click
    @args ||= []
    @args << 0
    expect(page).to have_xpath('//span[@class="shopping_cart_badge"]')
  end
end

When('I click {string} on cart page') do |op|
  unless page.current_url.include?('cart.html')
    find(:xpath, '//a[@class="shopping_cart_link"]').click
    sleep 0.5
  end
  find(:xpath, "//button[text()='#{op}']").click
end

Then('I should be redirected to the products page from cart') do
  expect(page.current_url).to include('/inventory.html')
  expect(page).to have_xpath('//div[@class="inventory_list"]')
  expect(page).to have_xpath('//span[@class="title" and text()="Products"]')
end

Then('I should be redirected to checkout page') do
  expect(page.current_url).to include('/checkout-step-one.html')
  expect(page).to have_xpath('//span[@class="title" and text()="Checkout: Your Information"]')
end

Given('I have {int} products in the cart on cart page') do |n|
  add_buttons = all(:xpath, '//button[contains(@class, "btn_inventory")]')
  if n > add_buttons.count
    raise "Only #{add_buttons.count} products available"
  end
  
  @args ||= []
  n.times do |i|
    add_buttons[i].click
    @args << i
    sleep 0.2
  end
  
  if n > 0
    expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{n}']")
  end
end

When('I remove {int} products from the cart on cart page') do |n|
  find(:xpath, '//a[@class="shopping_cart_link"]').click
  expect(page).to have_xpath('//span[contains(@class, "title") and contains(text(), "Cart")]')
  
  @args ||= []
  n.times do
    remove_buttons = all(:xpath, '//button[text()="Remove"]')
    if remove_buttons.any?
      remove_buttons.first.click
      @args.pop if @args.any?
      sleep 0.3
    else
      break
    end
  end
end

Then('the cart should show {int} items on cart page') do |n|
  if n > 0
    expect(page).to have_xpath("//span[@class='shopping_cart_badge' and text()='#{n}']")
  else
    expect(page).to have_no_xpath('//span[@class="shopping_cart_badge"]')
  end
end

Given('I add one more product to cart') do
  add_buttons = all(:xpath, '//button[text()="Add to cart"]')
  if add_buttons.any?
    add_buttons.first.click
    @args ||= []
    @args << (@args.last.to_i + 1) if @args.any?
  end
end