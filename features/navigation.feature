Feature: Navigation in Saucedemo
  As a logged in user
  I want to navigate the application
  So that I can use key functionalities

  @smoke @navigation
  Scenario: Open and close side menu
    Given I am logged in as "standard_user"
    When I open the side menu
    Then I should see menu options
    When I close the side menu
    Then the menu should be closed

  @smoke @navigation  
  Scenario: Logout from side menu
    Given I am logged in as "standard_user"
    When I open the side menu
    And I select "Logout" from menu
    Then I should see login page

  @smoke @navigation
  Scenario: Reset app state
    Given I am logged in as "standard_user"
    And I have product "Sauce Labs Backpack" in cart
    When I open the side menu
    And I select "Reset App State" from menu
    And I reload page
    Then the cart should be empty
    And product "Sauce Labs Backpack" should show "Add to cart"