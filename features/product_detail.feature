Feature: Detalle de producto
  As a user
  I want to view product details
  So that I can make informed decisions

  Background:
    Given I am logged in as "standard_user"

  @smoke @product_detail
  Scenario: View product details from inventory
    Given I am on the products page
    When I click on the "Sauce Labs Backpack" product image
    Then I should see the product detail page
    And I should see the product name "Sauce Labs Backpack"
    And I should see the product description 
    And I should see the product price "$29.99"
    And I should see the "Add to cart" button is visible
    And I should see the "Back to products" button is visible
    And I should see the product image is displayed

  @smoke @product_detail
  Scenario: Add product to cart from detail page
    Given I am viewing the "Sauce Labs Backpack" product detail
    And the shopping cart is empty
    When I click the "Add to cart" button
    Then the button text should change to "Remove"
    And the shopping cart badge should display "1" item
    And I should be able to navigate back to products
    When I click the "Back to products" button
    Then I should return to the inventory page
    And the cart badge should still show "1" item