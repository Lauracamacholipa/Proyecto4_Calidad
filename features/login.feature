Feature: Login a Saucedemo
  As a user
  I want to login to the application
  So that I can access the products and make purchases

  Background:
    Given I am on the login page

  @smoke @login
  Scenario: Login exitoso con usuario estándar
    When I enter username "standard_user" and password "secret_sauce"
    And I click the login button
    Then I should be redirected to the products page
    And I should see the products inventory

  @negative @login
  Scenario: Login falla con usuario bloqueado
    When I enter username "locked_out_user" and password "secret_sauce"
    And I click the login button
    Then I should see error message "Epic sadface: Sorry, this user has been locked out."
    And I should remain on the login page

  @negative @login
  Scenario: Login falla con credenciales inválidas
    When I enter username "usuario_inexistente" and password "password_incorrecta"
    And I click the login button
    Then I should see error message "Epic sadface: Username and password do not match any user in this service"

  @smoke @login
  Scenario Outline: Login con diferentes tipos de usuario
    When I enter username "<username>" and password "secret_sauce"
    And I click the login button
    Then I should see the products page

    Examples:
      | username       |
      | problem_user   |
      | performance_glitch_user |
      | error_user     |
      | visual_user    |