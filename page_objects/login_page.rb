require_relative 'base_page'

class LoginPage < BasePage
  # Selectors
  USERNAME_FIELD = '#user-name'
  PASSWORD_FIELD = '#password'
  LOGIN_BUTTON = '#login-button'
  ERROR_MESSAGE = '[data-test="error"]'
  INVENTORY_TITLE = '.title'
  PRODUCT_NAME = '.inventory_item_name'

  def initialize
    super
  end

  # Navigate to login page
  def open
    navigate_to('/')
    wait_for_login_page
  end

  # Wait for login page to load
  def wait_for_login_page
    wait_for_element(USERNAME_FIELD)
    wait_for_element(LOGIN_BUTTON)
  end

  # Check if on login page
  def on_login_page?
    element_present?(USERNAME_FIELD) && element_present?(LOGIN_BUTTON)
  end

  # Fill username field
  def enter_username(username)
    fill_field('user-name', username)
  end

  # Fill password field
  def enter_password(password)
    fill_field('password', password)
  end

  # Click login button
  def click_login
    click_on_element(LOGIN_BUTTON)
  end

  # Perform complete login
  def login(username, password)
    enter_username(username)
    enter_password(password)
    click_login
  end

  # Check if on inventory page (successful login)
  def on_inventory_page?
    url_includes?('/inventory.html') && 
    element_present?(INVENTORY_TITLE, text: 'Products')
  end

  # Wait for inventory page to load
  def wait_for_inventory_page
    wait_for_element(INVENTORY_TITLE)
    raise "Not on inventory page" unless on_inventory_page?
  end

  # Get error message text
  def error_message
    get_text(ERROR_MESSAGE)
  end

  # Check if error message is displayed
  def error_displayed?
    element_present?(ERROR_MESSAGE)
  end

  # Check if specific product is visible
  def product_visible?(product_name)
    element_present?(PRODUCT_NAME, text: product_name)
  end

  # Perform login and verify success
  def login_as(username, password = 'secret_sauce')
    open unless on_login_page?
    login(username, password)
    wait_for_inventory_page
  end
end
