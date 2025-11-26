Feature: Detalle de producto
  As a user
  I want to view product details
  So that I can make informed decisions

  Background:
    Given I am logged in as "standard_user"

  @smoke @product_detail
  Scenario: View product details from inventory
    Given I am on the products page
    When I click on the first product
    Then I should see the product detail page
    And I should see the product name
    And I should see the product description
    And I should see the product price

  @smoke @product_detail
  Scenario: Add product to cart from detail page
    Given I am viewing a product detail
    When I click "Add to cart" on the detail page
    Then the cart icon should show "1" item