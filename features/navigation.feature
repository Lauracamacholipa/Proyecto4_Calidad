Feature: Navigation in Saucedemo
  As a logged in user
  I want to navigate the application
  So that I can use key functionalities

  Background:
    Given I am logged in as "standard_user"

  @smoke @navigation
  Scenario: Open and close side menu
    When I click the menu button
    Then I should see menu options including "Logout" and "Reset App State"
    When I click the close menu button
    Then the menu should not be visible

  @smoke @navigation  
  Scenario: Logout from side menu
    When I click the menu button
    And I click "Logout" in the menu
    Then I should be redirected to the login page

  @smoke @navigation
  Scenario: Reset app state from menu
    Given I add "Sauce Labs Backpack" to my shopping cart
    When I click the menu button
    And I click "Reset App State" in the menu
    And I click the close menu button
    And I return to products page using inventory link
    Then the cart should be empty
    And "Sauce Labs Backpack" should show "Add to cart" button