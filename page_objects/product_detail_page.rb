require_relative 'base_page'

class ProductDetailPage < BasePage
  # Selectors
  PRODUCT_DETAIL_CONTAINER = '.inventory_details_container'
  PRODUCT_NAME = '.inventory_details_name'
  PRODUCT_DESCRIPTION = '.inventory_details_desc'
  PRODUCT_PRICE = '.inventory_details_price'
  PRODUCT_IMAGE = '.inventory_details_img'
  ADD_TO_CART_BUTTON = '.btn_inventory'
  BACK_BUTTON = '#back-to-products'
  
  def initialize
    super
  end
  
  # === MÉTODOS PRINCIPALES ===
  
  def on_product_detail_page?
    element_present?(PRODUCT_DETAIL_CONTAINER)
  end
  
  def ensure_on_product_detail_page
    wait_for_element(PRODUCT_DETAIL_CONTAINER) unless on_product_detail_page?
  end
  
  def get_product_name
    ensure_on_product_detail_page
    get_text(PRODUCT_NAME)
  end
  
  def get_product_description
    ensure_on_product_detail_page
    get_text(PRODUCT_DESCRIPTION)
  end
  
  def get_product_price
    ensure_on_product_detail_page
    get_text(PRODUCT_PRICE)
  end
  
  def add_to_cart
    ensure_on_product_detail_page
    click_on_element(ADD_TO_CART_BUTTON)
  end
  
  def remove_from_cart
    ensure_on_product_detail_page
    click_on_element(ADD_TO_CART_BUTTON) # El mismo botón cambia de "Add to cart" a "Remove"
  end
  
  def back_to_products
    click_on_element(BACK_BUTTON)
  end
  
  def get_product_details
    ensure_on_product_detail_page
    {
      name: get_product_name,
      description: get_product_description,
      price: get_product_price
    }
  end
  
  def product_image_visible?
    ensure_on_product_detail_page
    element = find_element(PRODUCT_IMAGE)
    element.visible? && element['src'] != '' && element['alt'] != ''
  end
  
  def button_text
    ensure_on_product_detail_page
    find_element(ADD_TO_CART_BUTTON).text
  end
end