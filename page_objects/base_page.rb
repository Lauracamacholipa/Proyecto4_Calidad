require 'capybara/dsl'

class BasePage
  include Capybara::DSL

  def initialize
    @wait_time = Capybara.default_max_wait_time
  end

  # Navigate to a specific path
  def navigate_to(path = '/')
    visit(path)
  end

  # Check if element is present
  def element_present?(selector, **options)
    has_css?(selector, **options)
  end

  # Check if element is not present
  def element_not_present?(selector, **options)
    has_no_css?(selector, **options)
  end

  # Wait for element to be visible
  def wait_for_element(selector, **options)
    default_options = { wait: @wait_time }
    has_css?(selector, **default_options.merge(options))
  end

  # Get current URL
  def current_url
    page.current_url
  end

  # Check if current URL includes path
  def url_includes?(path)
    current_url.include?(path)
  end

  # Find element with wait
  def find_element(selector, **options)
    find(selector, **options.merge(wait: @wait_time))
  end

  # Find all elements
  def find_all_elements(selector, **options)
    all(selector, **options)
  end

  # Fill in a field
  def fill_field(field, value, **options)
    fill_in(field, with: value, **options.merge(wait: @wait_time))
  end

  # Click on element
  def click_on_element(selector, **options)
    find_element(selector, **options).click
  end

  # Get text from element
  def get_text(selector, **options)
    find_element(selector, **options).text
  end

  # Check if text is present on page
  def text_present?(text, **options)
    has_content?(text, **options)
  end
end
