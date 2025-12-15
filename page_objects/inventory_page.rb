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
  INVENTORY_LIST = '.inventory_list'
  
  # Mapeo de valores del dropdown
  DROPDOWN_MAPPING = {
    'az' => 'Name (A to Z)',
    'za' => 'Name (Z to A)',
    'lohi' => 'Price (low to high)',
    'hilo' => 'Price (high to low)'
  }.freeze
  
  def initialize
    super
  end
  
  # === HELPERS CENTRALIZADOS ===
  
  def ensure_on_products_page
    return if on_products_page?
    navigate_to('/inventory.html')
    wait_for_element(PRODUCTS_TITLE, text: 'Products')
  end
  
  def get_product_names
    ensure_on_products_page
    find_all_elements(PRODUCT_NAME).map(&:text)
  end
  
  def get_product_prices
    ensure_on_products_page
    find_all_elements(PRODUCT_PRICE).map do |price_element|
      price_element.text.gsub('$', '').to_f
    end
  end
  
  # === MÉTODOS PRINCIPALES ===
  
  def on_products_page?
    url_includes?('/inventory.html') &&
    element_present?(PRODUCTS_TITLE, text: 'Products')
  end
  
  def get_product_count
    ensure_on_products_page
    find_all_elements(PRODUCT_CONTAINER).count
  end
  
  def add_product_by_name(product_name)
    ensure_on_products_page
    product_element = find_element(PRODUCT_NAME, text: product_name)
    container = product_element.ancestor(PRODUCT_CONTAINER)
    container.find(ADD_TO_CART_BUTTON).click
  end
  
  def add_products(count)
    ensure_on_products_page
    buttons = find_all_elements(ADD_TO_CART_BUTTON)
    count.times { |i| buttons[i].click if buttons[i] }
  end
  
  def add_product_by_index(index)
    ensure_on_products_page
    buttons = find_all_elements(ADD_TO_CART_BUTTON)
    buttons[index].click if buttons[index]
  end
  
  def sort_products(sort_option)
    ensure_on_products_page
    select(sort_option, from: 'product_sort_container')
    sleep 1 # Esperar reordenamiento
  end
  
  def get_selected_sort_option
    dropdown = find_element(SORT_DROPDOWN)
    selected_value = dropdown.value
    DROPDOWN_MAPPING[selected_value] || selected_value
  end
  
  def sorted_by_name_a_to_z?
    names = get_product_names
    names == names.sort
  end
  
  def sorted_by_name_z_to_a?
    names = get_product_names
    names == names.sort.reverse
  end
  
  def sorted_by_price_low_to_high?
    prices = get_product_prices
    prices == prices.sort
  end
  
  def sorted_by_price_high_to_low?
    prices = get_product_prices
    prices == prices.sort.reverse
  end
  
  def product_visible?(product_name)
    ensure_on_products_page
    element_present?(PRODUCT_NAME, text: product_name)
  end
  
  def click_product_image(product_name)
    ensure_on_products_page
    product_element = find_element(PRODUCT_NAME, text: product_name)
    container = product_element.ancestor(PRODUCT_CONTAINER)
    container.find('img.inventory_item_img').click
  end
  
  def click_product_name(product_name)
    ensure_on_products_page
    find_element(PRODUCT_NAME, text: product_name).click
  end
end