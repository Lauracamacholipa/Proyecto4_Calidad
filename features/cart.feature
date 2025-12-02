Feature: Cart Management
  As a registered user
  I want to manage my shopping cart
  So that I can control my purchases

Background:
  Given I am logged in as "standard_user"

@smoke @cart
Scenario Outline: Add and remove products from cart
  Given I have "<product_count>" products in the cart on cart page
  When I remove "<products_to_remove>" products from the cart on cart page
  Then the cart should show "<remaining_count>" items on cart page

Examples:
  | product_count | products_to_remove | remaining_count |
  | 3             | 1                  | 2               |
  | 2             | 2                  | 0               |
  | 1             | 1                  | 0               |
  | 4             | 2                  | 2               |
  | 6             | 3                  | 3               |

@smoke @cart
Scenario: Continue shopping from cart
  Given I have products in the cart on cart page
  When I click "Continue Shopping" on cart page
  Then I should be redirected to the products page from cart

@cart @checkout
Scenario: Checkout from cart
  Given I have 2 products in the cart on cart page
  When I click "Checkout" on cart page
  Then I should be redirected to checkout page

@cart @empty
Scenario: Verify empty cart
  Given I have 0 products in the cart on cart page
  Then the cart should show 0 items on cart page

@cart @ui
Scenario: Cart badge updates correctly
  Given I have 1 products in the cart on cart page
  Then the cart should show 1 items on cart page
  When I add one more product to cart
  Then the cart should show 2 items on cart page