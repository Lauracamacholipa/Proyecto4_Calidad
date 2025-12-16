require_relative 'base_page'
require 'bigdecimal'
require 'bigdecimal/util'

class CheckoutPage < BasePage

  # =========================
  # Selectors
  # =========================
  SHOPPING_CART_LINK = '.shopping_cart_link'
  CART_TITLE = '.title'
  CHECKOUT_BUTTON = '[data-test="checkout"]'

  # Checkout Information
  FIRST_NAME_FIELD  = '#first-name'
  LAST_NAME_FIELD   = '#last-name'
  POSTAL_CODE_FIELD = '#postal-code'
  CONTINUE_BUTTON   = '#continue'
  CANCEL_BUTTON     = '#cancel'
  ERROR_MESSAGE     = '[data-test="error"]'

  # Checkout Overview
  ITEM_TOTAL_LABEL = '.summary_subtotal_label'
  TAX_LABEL        = '.summary_tax_label'
  TOTAL_LABEL      = '.summary_total_label'
  FINISH_BUTTON    = '#finish'

  # Checkout Complete
  COMPLETE_HEADER = '.complete-header'

  # =========================
  # Cart
  # =========================
  def go_to_cart
    click_on_element(SHOPPING_CART_LINK)
    wait_for_element(CART_TITLE, text: 'Your Cart')
  end

  def on_cart_page?
    url_includes?('/cart.html') &&
      element_present?(CART_TITLE, text: 'Your Cart')
  end

  # =========================
  # Checkout Step One
  # =========================
  def proceed_to_checkout
    go_to_cart unless on_cart_page?
    click_on_element(CHECKOUT_BUTTON)
    wait_for_checkout_information_page
  end

  def wait_for_checkout_information_page
    wait_for_element(CART_TITLE, text: 'Checkout: Your Information')
  end

  def on_checkout_information_page?
    url_includes?('/checkout-step-one.html') &&
      element_present?(CART_TITLE, text: 'Checkout: Your Information')
  end

  def fill_shipping_info(first_name:, last_name:, postal_code:)
    wait_for_checkout_information_page unless on_checkout_information_page?

    fill_field('first-name', first_name)
    fill_field('last-name', last_name)
    fill_field('postal-code', postal_code)
  end

  def click_continue
    click_on_element(CONTINUE_BUTTON)
  end

  def click_cancel
    click_on_element(CANCEL_BUTTON)
  end

  # =========================
  # Checkout Step Two (Overview)
  # =========================
  def continue_to_overview
    click_continue
    wait_for_checkout_overview_page
  end

  def wait_for_checkout_overview_page
    wait_for_element(CART_TITLE, text: 'Checkout: Overview')
  end

  def on_checkout_overview_page?
    url_includes?('/checkout-step-two.html') &&
      element_present?(CART_TITLE, text: 'Checkout: Overview')
  end

  def get_order_summary
    wait_for_checkout_overview_page unless on_checkout_overview_page?

    {
      item_total: extract_price(get_text(ITEM_TOTAL_LABEL)),
      tax:        extract_price(get_text(TAX_LABEL)),
      total:      extract_price(get_text(TOTAL_LABEL))
    }
  end

  def item_total
    extract_price(get_text(ITEM_TOTAL_LABEL))
  end

  def tax_amount
    extract_price(get_text(TAX_LABEL))
  end

  def total_amount
    extract_price(get_text(TOTAL_LABEL))
  end

  def verify_tax_percentage(expected_percentage)
    summary = get_order_summary
    expected_tax = (summary[:item_total] * expected_percentage / 100).round(2)
    summary[:tax] == expected_tax
  end

  def verify_total_calculation
    summary = get_order_summary
    (summary[:item_total] + summary[:tax]).round(2) == summary[:total]
  end

  # =========================
  # Checkout Complete
  # =========================
  def finish_purchase
    wait_for_checkout_overview_page unless on_checkout_overview_page?
    click_on_element(FINISH_BUTTON)
    wait_for_checkout_complete_page
  end

  def wait_for_checkout_complete_page
    wait_for_element(CART_TITLE, text: 'Checkout: Complete')
  end

  def on_checkout_complete_page?
    url_includes?('/checkout-complete.html') &&
      element_present?(CART_TITLE, text: 'Checkout: Complete')
  end

  def success_message
    get_text(COMPLETE_HEADER)
  end

  def order_completed?
    on_checkout_complete_page? &&
      text_present?('Thank you for your order!')
  end

  # =========================
  # Errors
  # =========================
  def error_message
    if element_present?(ERROR_MESSAGE, wait: 2)
      get_text(ERROR_MESSAGE)
    else
      nil
    end
  end

  def error_displayed?
    element_present?(ERROR_MESSAGE)
  end

  # =========================
  # Helpers
  # =========================
  def extract_price(text)
    BigDecimal(text.scan(/\d+\.\d+/).first)
  end

end
