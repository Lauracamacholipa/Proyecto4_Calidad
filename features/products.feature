Feature: Productos y filtros
  As a user
  I want to view and filter products
  So that I can find what I need

  @smoke @products
  Scenario Outline: View products with different user types
    Given I am logged in as "<username>"
    Then I should see the products page
    And I should see exactly 6 products displayed including "Sauce Labs Backpack", "Sauce Labs Bike Light", "Sauce Labs Bolt T-Shirt"
    And I should see the "Products" header
    And I should see the shopping cart icon
    And I should see the sort dropdown with "Name (A to Z)" selected
    And each product should have name and "Add to cart" button

    Examples:
      | username      |
      | standard_user |
      | problem_user  |
      | visual_user   |

  @smoke @sorting
  Scenario Outline: Sort products by different criteria
    Given I am logged in as "standard_user"
    Then I should see the products page
    When I select "<sort_criteria>" from the sort dropdown
    Then the dropdown should display "<sort_criteria>" as selected
    And I should see products sorted by "<sort_order>"
    And the first product should be "<first_product>"
    And the last product should be "<last_product>"

    Examples:
      | sort_criteria       | sort_order              | first_product               | last_product              |
      | Name (A to Z)       | alphabetical ascending  | Sauce Labs Backpack        | Test.allTheThings() T-Shirt (Red) |
      | Name (Z to A)       | alphabetical descending | Test.allTheThings() T-Shirt (Red) | Sauce Labs Backpack       |
      | Price (low to high) | price ascending         | Sauce Labs Onesie          | Sauce Labs Fleece Jacket  |
      | Price (high to low) | price descending        | Sauce Labs Fleece Jacket   | Sauce Labs Onesie         |