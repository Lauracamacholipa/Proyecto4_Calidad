Feature: Checkout Process
  As a registered user
  I want to complete the checkout process
  So that I can receive my purchased items

Background:
  Given I am logged in as "standard_user"

@smoke @checkout
Scenario Outline: Complete checkout with different information
  Given I have <product_count> product in the cart
  When I proceed to checkout
  And I fill checkout information with "<first_name>" "<last_name>" "<postal_code>"
  And I complete the purchase
  Then I should see the order confirmation

Examples:
  | product_count | first_name | last_name | postal_code |
  | 1             | Juan       | Perez     | 12345       |
  | 2             | Maria      | Gonzalez  | 54321       |
  | 3             | Carlos     | Lopez     | 67890       |

@negative @checkout
Scenario: Checkout validation shows error for empty fields
  Given I have 1 product in the cart
  When I proceed to checkout
  And I try to continue with empty fields
  Then I should see checkout error "Error: First Name is required"

@checkout @validation
Scenario: Checkout validation shows error for missing first name
  Given I have 1 product in the cart
  When I proceed to checkout
  When I fill checkout information with "" "Perez" "12345"
  Then I should see checkout error "Error: First Name is required"

@checkout @validation
Scenario: Checkout validation shows error for missing last name
  Given I have 1 product in the cart
  When I proceed to checkout
  When I fill checkout information with "Juan" "" "12345"
  Then I should see checkout error "Error: Last Name is required"

@checkout @validation
Scenario: Checkout validation shows error for missing postal code
  Given I have 1 product in the cart
  When I proceed to checkout
  When I fill checkout information with "Juan" "Perez" ""
  Then I should see checkout error "Error: Postal Code is required"

@checkout @cancel
Scenario: Cancel checkout process
  Given I have 2 products in the cart on cart page
  When I proceed to checkout
  And I click cancel button on checkout page
  Then I should be redirected to the cart page

@checkout @navigation
Scenario: Navigate back from checkout information
  Given I have 1 product in the cart
  When I proceed to checkout
  And I click cancel button on checkout page
  Then I should be redirected to the cart page

@checkout @prices
Scenario: Verify payment totals are correct
  Given I have 2 products in the cart
  When I proceed to checkout
  And I fill checkout information with "Ana" "Rodriguez" "10101"
  Then I should see the correct payment total including tax
  And I complete the purchase
  Then I should see the order confirmation

@checkout @prices  
Scenario: Verify itemized prices in checkout overview
  Given I have product "Sauce Labs Backpack" in the cart
  And I have product "Sauce Labs Bike Light" in the cart
  When I proceed to checkout
  And I fill checkout information with "Luis" "Martinez" "20202"
  Then I should see price "$29.99" for "Sauce Labs Backpack"
  And I should see price "$9.99" for "Sauce Labs Bike Light"
  And I should see the correct payment total including tax