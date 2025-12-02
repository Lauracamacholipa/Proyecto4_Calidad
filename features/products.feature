Feature: Productos y filtros
  As a user
  I want to view and filter products
  So that I can find what I need

  # Background SIMPLIFICADO - usa step helper
  Background:
    Given I am on products page as "standard_user"

  @smoke @products
  Scenario Outline: View products with different user types
    Given I am logged in as "<username>"
    Then I should see the products page
    And I should see exactly 6 products displayed
    And I should see the "Products" header
    And each product should have name and "Add to cart" button
    And I should see products including "Sauce Labs Backpack", "Sauce Labs Bike Light", "Sauce Labs Bolt T-Shirt"

    Examples:
      | username      |
      | standard_user |
      | problem_user  |
      | visual_user   |

  @smoke @sorting
  Scenario Outline: Sort products by different criteria
    Given I am on products page as "standard_user"
    When I select "<sort_criteria>" from the sort dropdown
    Then the dropdown should display "<sort_criteria>" as selected
    And the first product should be "<first_product>"

    Examples:
      | sort_criteria       | first_product               |
      | Name (A to Z)       | Sauce Labs Backpack        |
      | Name (Z to A)       | Test.allTheThings() T-Shirt (Red) |
      | Price (low to high) | Sauce Labs Onesie          |
      | Price (high to low) | Sauce Labs Fleece Jacket   |