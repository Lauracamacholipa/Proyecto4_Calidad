require 'capybara/cucumber'
require 'rspec/expectations'

require_relative '../../page_objects/checkout_page'
require_relative '../../page_objects/navigation_page'

# =========================
# Page Objects
# =========================
def checkout_page
  @checkout_page ||= CheckoutPage.new
end

def navigation_page
  @navigation_page ||= NavigationPage.new
end

# =========================
# GIVEN
# =========================
Given('I have the following products in cart:') do |table|
  visit('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)

  table.raw.flatten.each do |product_name|
    product_element = find('.inventory_item_name', text: product_name, wait: 10)
    container = product_element.ancestor('.inventory_item')
    container.find('.btn_inventory').click

    expect(navigation_page.cart_has_items?).to be true, "Product #{product_name} was not added to cart"
  end
end

Given('I have product {string} in the cart') do |product_name|
  visit('/inventory.html')
  expect(page).to have_css('.title', text: 'Products', wait: 10)

  product_element = find('.inventory_item_name', text: product_name, wait: 10)
  container = product_element.ancestor('.inventory_item')
  container.find('.btn_inventory').click

  expect(navigation_page.cart_has_items?).to be true, "Product #{product_name} was not added to cart"
end

# =========================
# WHEN
# =========================
When('I proceed to checkout from cart') do
  checkout_page.proceed_to_checkout
end

When('I fill checkout information with first name {string}, last name {string} and zip code {string}') do |first_name, last_name, postal_code|
  checkout_page.fill_shipping_info(
    first_name: first_name,
    last_name: last_name,
    postal_code: postal_code
  )
end

When('I click {string}') do |button_text|
  case button_text
  when 'Continue'
    checkout_page.click_continue
  when 'Cancel'
    checkout_page.click_cancel
  else
    find('button, input, a', text: button_text, wait: 10).click
  end
end

When('I continue to checkout overview') do
  checkout_page.continue_to_overview
end

When('I complete the purchase') do
  checkout_page.finish_purchase
end

When('I cancel checkout') do
  checkout_page.click_cancel
end

# =========================
# THEN
# =========================
Then('I should see {string}') do |expected_text|
  expect(page).to have_content(expected_text, wait: 10)
end

Then('the order total should be ${float} including tax') do |expected_total|
  if checkout_page.on_checkout_overview_page?
    summary = checkout_page.get_order_summary
    expect(summary[:item_total] + summary[:tax]).to eq(summary[:total])
    expect(summary[:total]).to eq(expected_total)
  elsif checkout_page.on_checkout_complete_page?
    expect(checkout_page.order_completed?).to be true
  else
    raise "Not on checkout overview or complete page"
  end
end

Then('I should see checkout error {string}') do |error_message|
  expect(checkout_page.error_message).to include(error_message)
end

Then('I should be redirected to the cart page') do
  expect(checkout_page.on_cart_page?).to be true
end

Then('I should see item total of ${float}') do |expected_total|
  expect(checkout_page.item_total).to eq(expected_total)
end

Then('I should see tax of ${float}') do |expected_tax|
  expect(checkout_page.tax_amount).to eq(expected_tax)
end

Then('I should see total of ${float}') do |expected_total|
  expect(checkout_page.total_amount).to eq(expected_total)
end

Then('the tax should be {int}% of item total') do |tax_percentage|
  expect(checkout_page.verify_tax_percentage(tax_percentage)).to be true
end

Then('the total should be item total plus tax') do
  expect(checkout_page.verify_total_calculation).to be true
end

Then('the item total should be ${float}') do |expected_total|
  expect(checkout_page.item_total).to eq(expected_total)
end
