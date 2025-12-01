Feature: Login a Saucedemo
  As a user
  I want to login to the application with different credentials
  So that I can access the products securely

  Background:
    Given I am on the login page with all required elements

  @smoke @login
  Scenario: Login exitoso con usuario estándar
    When I enter username "standard_user" in the username field
    And I enter password "secret_sauce" in the password field
    And I click the login button with id "login-button"
    Then I should be redirected to the inventory page at "/inventory.html"
    And I should see the specific product "Sauce Labs Backpack"

  @negative @login
  Scenario: Login falla con usuario bloqueado
    When I enter username "locked_out_user" in the username field
    And I enter password "secret_sauce" in the password field
    And I click the login button with id "login-button"
    Then I should see exact error message "Epic sadface: Sorry, this user has been locked out." in the error container

  @negative @login
  Scenario: Login falla con credenciales inválidas
    When I enter username "usuario_inexistente" in the username field
    And I enter password "password_incorrecta" in the password field
    And I click the login button with id "login-button"
    Then I should see exact error message "Epic sadface: Username and password do not match any user in this service" in the error container

  @negative @login
  Scenario: Login falla sin username
    When I enter username "" in the username field
    And I enter password "secret_sauce" in the password field
    And I click the login button with id "login-button"
    Then I should see exact error message "Epic sadface: Username is required" in the error container

  @negative @login
  Scenario: Login falla sin password
    When I enter username "standard_user" in the username field
    And I enter password "" in the password field
    And I click the login button with id "login-button"
    Then I should see exact error message "Epic sadface: Password is required" in the error container

  @negative @login
  Scenario: Acceso directo a inventory sin login
    When I visit the inventory page directly at "/inventory.html"
    Then I should see exact error message "Epic sadface: You can only access '/inventory.html' when you are logged in." in the error container

  @performance @login
  Scenario: Login con usuario performance_glitch_user (5 segundos delay)
    When I enter username "performance_glitch_user" in the username field
    And I enter password "secret_sauce" in the password field
    And I click the login button with id "login-button"
    And I wait 6 seconds for the page to load
    Then I should be redirected to the inventory page at "/inventory.html"

  @smoke @login
  Scenario Outline: Login con diferentes tipos de usuario válidos
    When I enter username "<username>" in the username field
    And I enter password "secret_sauce" in the password field
    And I click the login button with id "login-button"
    Then I should be redirected to the inventory page at "/inventory.html"

    Examples:
      | username       |
      | problem_user   |
      | error_user     |
      | visual_user    |