Feature: Cart Management
  As a registered user
  I want to manage my shopping cart
  So that I can control my purchases

  Background:
    Given I am logged in as "standard_user"

  @smoke @cart
  Scenario Outline: Add and remove specific products from cart
    Given I add the first <initial_count> products to the cart
    When I remove <to_remove> products from the cart
    Then the cart badge should show <remaining_count> items

    Examples:
      | initial_count | to_remove | remaining_count |
      | 3             | 1         | 2               |
      | 2             | 2         | 0               |
      | 1             | 1         | 0               |
      | 6             | 3         | 3               |

  @smoke @cart
  Scenario: Continue shopping from cart
    Given I have "Sauce Labs Backpack" in the cart
    When I click "Continue Shopping" from cart page
    Then I should be redirected to the products page

  @cart @checkout
  Scenario: Checkout from cart
    Given I have "Sauce Labs Backpack" and "Sauce Labs Bike Light" in the cart
    When I click "Checkout" from cart page
    Then I should be redirected to checkout information page

  @cart @empty
  Scenario: Verify empty cart
    Given I have an empty cart
    When I view the cart page
    Then I should see the cart page with no items

  @cart @ui
  Scenario: Cart badge updates correctly when adding products
    Given I have an empty cart
    When I add "Sauce Labs Backpack" to the cart
    Then the cart badge should show 1 item
    When I add "Sauce Labs Bike Light" to the cart
    Then the cart badge should show 2 items