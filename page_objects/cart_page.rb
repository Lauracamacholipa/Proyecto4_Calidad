require_relative 'base_page'

class CartPage < BasePage
  # Selectors
  CART_TITLE = '.title'
  CART_ITEM = '.cart_item'
  CART_ITEM_NAME = '.inventory_item_name'
  CART_ITEM_DESCRIPTION = '.inventory_item_desc'
  CART_ITEM_PRICE = '.inventory_item_price'
  REMOVE_BUTTON = '.cart_button'
  CONTINUE_SHOPPING_BUTTON = '#continue-shopping'
  CHECKOUT_BUTTON = '#checkout'
  SHOPPING_CART_BADGE = '.shopping_cart_badge'
  
  def initialize
    super
  end
  
  # === MÉTODOS PRINCIPALES ===
  
  def on_cart_page?
    url_includes?('/cart.html') &&
    element_present?(CART_TITLE, text: 'Your Cart')
  end
  
  def ensure_on_cart_page
    navigate_to('/cart.html') unless on_cart_page?
    wait_for_element(CART_TITLE, text: 'Your Cart')
  end
  
  # === MÉTODO CENTRALIZADO (de 4 archivos diferentes) ===
  
  def get_cart_badge_count
    if element_present?(SHOPPING_CART_BADGE, wait: 2)
      get_text(SHOPPING_CART_BADGE).to_i
    else
      0
    end
  end
  
  def get_cart_item_count
    ensure_on_cart_page
    find_all_elements(CART_ITEM).count
  end
  
  def remove_item(item_index = 0)
    ensure_on_cart_page
    buttons = find_all_elements(REMOVE_BUTTON)
    buttons[item_index].click if buttons[item_index]
  end
  
  def remove_all_items
    ensure_on_cart_page
    while get_cart_item_count > 0
      remove_item(0)
      sleep 0.5
    end
  end
  
  def continue_shopping
    ensure_on_cart_page
    click_on_element(CONTINUE_SHOPPING_BUTTON)
  end
  
  def checkout
    ensure_on_cart_page
    click_on_element(CHECKOUT_BUTTON)
  end
  
  def get_cart_item_names
    ensure_on_cart_page
    find_all_elements(CART_ITEM_NAME).map(&:text)
  end
  
  def get_cart_item_prices
    ensure_on_cart_page
    find_all_elements(CART_ITEM_PRICE).map do |price_element|
      price_element.text.gsub('$', '').to_f
    end
  end
  
  def calculate_cart_total
    get_cart_item_prices.sum.round(2)
  end
  
  def cart_empty?
    ensure_on_cart_page
    get_cart_item_count == 0
  end
  
  def has_product?(product_name)
    ensure_on_cart_page
    element_present?(CART_ITEM_NAME, text: product_name)
  end
  
  def click_button(button_text)
    ensure_on_cart_page
    find('button', text: button_text, wait: 10).click
  end
end