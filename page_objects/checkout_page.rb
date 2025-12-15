require_relative 'base_page'

class CheckoutPage < BasePage
  # Selectors
  SHOPPING_CART_LINK = '.shopping_cart_link'
  CART_TITLE = '.title'
  CHECKOUT_BUTTON = '[data-test="checkout"]'
  
  # Checkout Information Form
  FIRST_NAME_FIELD = '#first-name'
  LAST_NAME_FIELD = '#last-name'
  POSTAL_CODE_FIELD = '#postal-code'
  CONTINUE_BUTTON = '#continue'
  CANCEL_BUTTON = '#cancel'
  ERROR_MESSAGE = '[data-test="error"]'
  
  # Checkout Overview
  ITEM_TOTAL_LABEL = '.summary_subtotal_label'
  TAX_LABEL = '.summary_tax_label'
  TOTAL_LABEL = '.summary_total_label'
  FINISH_BUTTON = '#finish'
  
  # Checkout Complete
  COMPLETE_HEADER = '.complete-header'
  COMPLETE_TEXT = '.complete-text'
  
  def initialize
    super
  end

  # Navigate to cart
  def go_to_cart
    click_on_element(SHOPPING_CART_LINK)
    wait_for_element(CART_TITLE, text: 'Your Cart')
  end

  # Check if on cart page
  def on_cart_page?
    url_includes?('/cart.html') &&
    element_present?(CART_TITLE, text: 'Your Cart')
  end

  # Click checkout button from cart
  def proceed_to_checkout
    go_to_cart unless on_cart_page?
    click_on_element(CHECKOUT_BUTTON)
    wait_for_checkout_information_page
  end

  # Wait for checkout information page
  def wait_for_checkout_information_page
    wait_for_element(CART_TITLE, text: 'Checkout: Your Information')
  end

  # Check if on checkout information page
  def on_checkout_information_page?
    url_includes?('/checkout-step-one.html') &&
    element_present?(CART_TITLE, text: 'Checkout: Your Information')
  end

  # Fill shipping information
  def fill_shipping_info(first_name:, last_name:, postal_code:)
    wait_for_checkout_information_page unless on_checkout_information_page?
    
    fill_field('first-name', first_name)
    fill_field('last-name', last_name)
    fill_field('postal-code', postal_code)
  end

  # Click continue button
  def click_continue
    click_on_element(CONTINUE_BUTTON)
  end

  # Click cancel button
  def click_cancel
    click_on_element(CANCEL_BUTTON)
  end

  # Continue to overview page
  def continue_to_overview
    click_continue
    wait_for_checkout_overview_page
  end

  # Wait for checkout overview page
  def wait_for_checkout_overview_page
    wait_for_element(CART_TITLE, text: 'Checkout: Overview')
  end

  # Check if on checkout overview page
  def on_checkout_overview_page?
    url_includes?('/checkout-step-two.html') &&
    element_present?(CART_TITLE, text: 'Checkout: Overview')
  end

  # Get order summary information
  def get_order_summary
    wait_for_checkout_overview_page unless on_checkout_overview_page?
    
    {
      item_total: extract_price(get_text(ITEM_TOTAL_LABEL)),
      tax: extract_price(get_text(TAX_LABEL)),
      total: extract_price(get_text(TOTAL_LABEL))
    }
  end

  # Extract price from text
  def extract_price(text)
    text.scan(/\d+\.\d+/).first.to_f
  end

  # Get item total
  def item_total
    extract_price(get_text(ITEM_TOTAL_LABEL))
  end

  # Get tax amount
  def tax_amount
    extract_price(get_text(TAX_LABEL))
  end

  # Get total amount
  def total_amount
    extract_price(get_text(TOTAL_LABEL))
  end

  # Verify tax percentage
  def verify_tax_percentage(expected_percentage)
    summary = get_order_summary
    expected_tax = (summary[:item_total] * expected_percentage / 100).round(2)
    summary[:tax] == expected_tax
  end

  # Verify total calculation
  def verify_total_calculation
    summary = get_order_summary
    calculated_total = (summary[:item_total] + summary[:tax]).round(2)
    summary[:total] == calculated_total
  end

  # Click finish button
  def click_finish
    click_on_element(FINISH_BUTTON)
  end

  # Complete purchase
  def finish_purchase
    wait_for_checkout_overview_page unless on_checkout_overview_page?
    click_finish
    wait_for_checkout_complete_page
  end

  # Wait for checkout complete page
  def wait_for_checkout_complete_page
    wait_for_element(CART_TITLE, text: 'Checkout: Complete')
  end

  # Check if on checkout complete page
  def on_checkout_complete_page?
    url_includes?('/checkout-complete.html') &&
    element_present?(CART_TITLE, text: 'Checkout: Complete')
  end

  # Get success message
  def success_message
    get_text(COMPLETE_HEADER)
  end

  # Check if order completed successfully
  def order_completed?
    on_checkout_complete_page? &&
    text_present?('Thank you for your order!')
  end

  # Get error message
  def error_message
    get_text(ERROR_MESSAGE) if element_present?(ERROR_MESSAGE)
  end

  # Check if error is displayed
  def error_displayed?
    element_present?(ERROR_MESSAGE)
  end

  # Complete full checkout flow
  def complete_checkout(first_name:, last_name:, postal_code:)
    proceed_to_checkout unless on_checkout_information_page?
    fill_shipping_info(first_name: first_name, last_name: last_name, postal_code: postal_code)
    continue_to_overview
    finish_purchase
  end
end
