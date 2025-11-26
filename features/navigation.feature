Feature: Navegación en Saucedemo
  As a logged in user
  I want to navigate through the application
  So that I can access all functionalities

  Background:
    Given I am logged in as "standard_user"

  @smoke @navigation
  Scenario: Abrir y cerrar menú hamburguesa
    When I click the menu button
    Then I should see menu options "All Items, About, Logout, Reset App State"
    When I click the menu button again
    Then the menu should close

  @smoke @navigation
  Scenario: Logout desde el menú
    When I click the menu button
    And I click the logout link
    Then I should be redirected to the login page
    And the session should be cleared

  @smoke @navigation
  Scenario: Reset app state desde el menú
    Given I have added products to the cart
    When I click the menu button
    And I click the reset app state link
    Then the cart should be empty
    And all products should show "Add to cart" button

  @smoke @navigation
  Scenario: Navegar a About page
    When I click the menu button
    And I click the about link
    Then I should be redirected to the Sauce Labs website
    And I should see information about Sauce Labs