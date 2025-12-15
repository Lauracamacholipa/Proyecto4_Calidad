require_relative 'base_page'

class InventoryPage < BasePage
  # Selectors
  PRODUCTS_TITLE = '.title'
  PRODUCT_CONTAINER = '.inventory_item'
  PRODUCT_NAME = '.inventory_item_name'
  PRODUCT_DESCRIPTION = '.inventory_item_desc'
  PRODUCT_PRICE = '.inventory_item_price'
  ADD_TO_CART_BUTTON = '.btn_inventory'
  REMOVE_BUTTON = '.btn_inventory.btn_secondary'
  SORT_DROPDOWN = '[data-test="product_sort_container"]'
  
  def initialize
    super
  end
  
  # Check if on inventory page
  def on_products_page?
    url_includes?('/inventory.html') &&
    element_present?(PRODUCTS_TITLE, text: 'Products')
  end
  
  # Ensure we're on products page
  def ensure_on_products_page
    unless on_products_page?
      navigate_to('/inventory.html')
      wait_for_element(PRODUCTS_TITLE, text: 'Products')
    end
  end
  
  # Get number of products
  def get_product_count
    ensure_on_products_page
    find_all_elements(PRODUCT_CONTAINER).count
  end
  
  # Add product by name
  def add_product_by_name(product_name)
    ensure_on_products_page
    product_element = find_element(PRODUCT_NAME, text: product_name)
    container = product_element.ancestor(PRODUCT_CONTAINER)
    container.find(ADD_TO_CART_BUTTON).click
  end
  
  # Add first N products
  def add_products(count)
    ensure_on_products_page
    buttons = find_all_elements(ADD_TO_CART_BUTTON)
    count.times { |i| buttons[i].click if buttons[i] }
  end
  
  # Sort products
  def sort_products(sort_option)
    ensure_on_products_page
    select(sort_option, from: 'product_sort_container')
  end
  
  # Get product names
  def get_product_names
    ensure_on_products_page
    find_all_elements(PRODUCT_NAME).map(&:text)
  end
  
  # Get product prices
  def get_product_prices
    ensure_on_products_page
    find_all_elements(PRODUCT_PRICE).map do |price_element|
      price_element.text.gsub('$', '').to_f
    end
  end
  
  # Verify products are sorted by price (low to high)
  def sorted_by_price_low_to_high?
    prices = get_product_prices
    prices == prices.sort
  end
  
  # Verify products are sorted by price (high to low)
  def sorted_by_price_high_to_low?
    prices = get_product_prices
    prices == prices.sort.reverse
  end
  
  # Verify products are sorted by name (A to Z)
  def sorted_by_name_a_to_z?
    names = get_product_names
    names == names.sort
  end
  
  # Verify products are sorted by name (Z to A)
  def sorted_by_name_z_to_a?
    names = get_product_names
    names == names.sort.reverse
  end
end