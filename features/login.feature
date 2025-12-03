Feature: Login to Saucedemo
  As a user
  I want to login to the application
  So that I can access products

  Background:
    Given I am on the login page

  @smoke @login
  Scenario: Login successful with standard user
    When I login as "standard_user" with password "secret_sauce"
    Then I should see inventory page
    And I should see product "Sauce Labs Backpack"

  @negative @login
  Scenario: Login fails with locked user
    When I login as "locked_out_user" with password "secret_sauce"
    Then I should see error "Epic sadface: Sorry, this user has been locked out."

  @smoke @login
  Scenario Outline: Login with different user types
    When I login as "<username>" with password "secret_sauce"
    Then I should see inventory page

    Examples:
      | username     |
      | problem_user |
      | error_user   |
      | visual_user  |

@negative @login
Scenario: Login fails with invalid credentials
  When I login as "invalid_user" with password "wrong_password"
  Then I should see error "Epic sadface: Username and password do not match any user in this service"