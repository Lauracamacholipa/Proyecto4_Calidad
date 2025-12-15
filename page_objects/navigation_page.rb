require_relative 'base_page'

class NavigationPage < BasePage
  # Selectors
  MENU_BUTTON = '#react-burger-menu-btn'
  MENU_CLOSE_BUTTON = '#react-burger-cross-btn'
  MENU_WRAP = '.bm-menu-wrap'
  MENU_ITEM_LIST = '.bm-item-list'
  SHOPPING_CART_LINK = '.shopping_cart_link'
  SHOPPING_CART_BADGE = '.shopping_cart_badge'

  def initialize
    super
  end

  # Open side menu
  def open_menu
    click_on_element(MENU_BUTTON)
    wait_for_element(MENU_WRAP, visible: true)
  end

  # Close side menu
  def close_menu
    click_on_element(MENU_CLOSE_BUTTON)
    element_not_present?(MENU_WRAP, visible: true)
  end

  # Check if menu is visible
  def menu_visible?
    element_present?(MENU_WRAP, visible: true)
  end

  # Check if menu is hidden
  def menu_hidden?
    element_not_present?(MENU_WRAP, visible: true)
  end

  # Click menu option by text
  def click_menu_option(option_text)
    menu_list = find_element(MENU_ITEM_LIST)
    menu_list.find('a', text: option_text).click
  end

  # Check if menu option exists
  def menu_option_exists?(option_text)
    element_present?(MENU_ITEM_LIST) && 
    text_present?(option_text)
  end

  # Logout via menu
  def logout
    open_menu unless menu_visible?
    click_menu_option('Logout')
  end

  # Go to All Items via menu
  def go_to_all_items
    open_menu unless menu_visible?
    click_menu_option('All Items')
  end

  # Go to About via menu
  def go_to_about
    open_menu unless menu_visible?
    click_menu_option('About')
  end

  # Reset app state via menu
  def reset_app_state
    open_menu unless menu_visible?
    click_menu_option('Reset App State')
  end

  # Click shopping cart
  def go_to_cart
    click_on_element(SHOPPING_CART_LINK)
  end

  # Get cart badge count
  def cart_badge_count
    if element_present?(SHOPPING_CART_BADGE, wait: 2)
      get_text(SHOPPING_CART_BADGE).to_i
    else
      0
    end
  end

  # Check if cart has items
  def cart_has_items?
    cart_badge_count > 0
  end

  # Check if on login page
  def on_login_page?
    current_url == "#{Capybara.app_host}/" &&
    element_present?('#login-button')
  end

  # Check if on products page
  def on_products_page?
    url_includes?('/inventory.html') &&
    element_present?('.title', text: 'Products')
  end
end
