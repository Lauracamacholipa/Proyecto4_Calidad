Feature: Proceso de checkout
  As a user
  I want to complete my purchase
  So that I can receive my products

  Background:
    Given I am logged in as "standard_user"
    And I have 1 product in the cart

  @smoke @checkout
  Scenario Outline: Complete checkout with different information
    When I proceed to checkout
    And I fill checkout information with "<first_name>" "<last_name>" "<postal_code>"
    And I complete the purchase
    Then I should see the order confirmation

    Examples:
      | first_name | last_name | postal_code |
      | Juan       | Perez     | 12345       |
      | Maria      | Gonzalez  | 54321       |
      | Carlos     | Lopez     | 67890       |

  @negative @checkout
  Scenario: Checkout validation shows error for empty fields
    When I proceed to checkout
    And I try to continue with empty fields
    Then I should see error "Error: First Name is required"