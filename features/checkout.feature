Feature: Checkout Process
  As a registered user
  I want to complete the checkout process
  So that I can receive my purchased items

  Background:
    Given I am logged in as "standard_user"

  @smoke @checkout
  Scenario Outline: Complete checkout with different information
    Given I have "Sauce Labs Backpack" and "Sauce Labs Bike Light" in the cart
    When I proceed to checkout from cart
    And I fill checkout information with "<first>" "<last>" "<zip>"
    And I continue to checkout overview
    Then I should see item total of $39.98
    And I should see tax of $3.20
    And I should see total of $43.18
    When I complete the purchase
    Then I should see "Thank you for your order!"

    Examples:
      | first  | last     | zip   |
      | Juan   | Perez    | 12345 |
      | Maria  | Gonzalez | 54321 |

  @negative @checkout
  Scenario Outline: Checkout validation errors for missing fields
    Given I have "Sauce Labs Backpack" in the cart
    When I proceed to checkout from cart
    And I fill checkout information with "<first>" "<last>" "<zip>"
    And I click "Continue"
    Then I should see checkout error "<error_message>"

    Examples:
      | first | last  | zip   | error_message                     |
      |       | Perez | 12345 | Error: First Name is required     |
      | Juan  |       | 12345 | Error: Last Name is required      |
      | Juan  | Perez |       | Error: Postal Code is required    |

  @checkout @cancel
  Scenario: Cancel checkout process from information page
    Given I have "Sauce Labs Backpack" in the cart
    When I proceed to checkout from cart
    And I click "Cancel"
    Then I should be redirected to the cart page

  @checkout @prices
  Scenario: Verify payment totals are calculated correctly
    Given I have "Sauce Labs Backpack" and "Sauce Labs Bike Light" in the cart
    When I proceed to checkout from cart
    And I fill checkout information with "Ana" "Rodriguez" "10101"
    And I continue to checkout overview
    Then I should see item total of $39.98
    And I should see tax of $3.20
    And I should see total of $43.18
    When I complete the purchase
    Then I should see "Thank you for your order!"
  
  @checkout @calculations
  Scenario: Verify tax calculation is mathematically correct
    Given I have "Sauce Labs Onesie" in the cart
    And I have "Sauce Labs Bolt T-Shirt" in the cart
    When I proceed to checkout from cart
    And I fill checkout information with "Test" "User" "12345"
    And I continue to checkout overview
    Then the item total should be $23.98
    And the tax should be 8% of item total
    And the total should be item total plus tax