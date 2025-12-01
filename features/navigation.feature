Feature: Navigation in Saucedemo
  As a logged in user
  I want to navigate through the application
  So that I can access all functionalities

  @smoke @navigation
  Scenario: Open and close hamburger menu
    Given I am logged in as "standard_user"
    When I click the hamburger menu button
    Then I should see the side menu with all options
    When I click the close menu button
    Then the side menu should not be visible

  @smoke @navigation
  Scenario: Logout from menu
    Given I am logged in as "standard_user"
    When I click the hamburger menu button
    And I click the logout option
    Then I should be redirected to the login page at "/"
    And I should see the login form elements

  @smoke @navigation
  Scenario: Reset app state from menu
    Given I am logged in as "standard_user"
    And I have added "Sauce Labs Backpack" to the cart
    And the cart shows "1" item
    When I click the hamburger menu button
    And I click the reset app state option
    And I click the close menu button
    And I reload the current page
    Then the "Sauce Labs Backpack" product should show "Add to cart" button
    And the cart should show "0" items

  @smoke @navigation
  Scenario: Navigate to About page
    Given I am logged in as "standard_user"
    When I click the hamburger menu button
    And I click the about option
    Then I should be redirected to the Sauce Labs website
    And I should see the text "Introducing Sauce AI: Intelligent Agents for Next-Gen Software Quality"