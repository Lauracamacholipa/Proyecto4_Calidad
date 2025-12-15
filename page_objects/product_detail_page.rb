require_relative 'base_page'

class ProductDetailPage < BasePage
  # Selectors
  PRODUCT_DETAIL_CONTAINER = '.inventory_details'
  PRODUCT_NAME = '.inventory_details_name'
  PRODUCT_DESCRIPTION = '.inventory_details_desc'
  PRODUCT_PRICE = '.inventory_details_price'
  ADD_TO_CART_BUTTON = '.btn_inventory'
  BACK_TO_PRODUCTS_BUTTON = '#back-to-products'
  
  def initialize
    super
  end
  
  # Check if on product detail page
  def on_product_detail_page?
    element_present?(PRODUCT_DETAIL_CONTAINER)
  end
  
  # Ensure we're on product detail page
  def ensure_on_product_detail_page
    wait_for_element(PRODUCT_DETAIL_CONTAINER) unless on_product_detail_page?
  end
  
  # Get product name
  def get_product_name
    ensure_on_product_detail_page
    get_text(PRODUCT_NAME)
  end
  
  # Get product description
  def get_product_description
    ensure_on_product_detail_page
    get_text(PRODUCT_DESCRIPTION)
  end
  
  # Get product price
  def get_product_price
    ensure_on_product_detail_page
    get_text(PRODUCT_PRICE)
  end
  
  # Add product to cart from detail page
  def add_to_cart
    ensure_on_product_detail_page
    click_on_element(ADD_TO_CART_BUTTON)
  end
  
  # Go back to products
  def back_to_products
    click_on_element(BACK_TO_PRODUCTS_BUTTON)
  end
  
  # Get product details as hash
  def get_product_details
    {
      name: get_product_name,
      description: get_product_description,
      price: get_product_price
    }
  end
end