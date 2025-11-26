Feature: Productos y filtros
  As a user
  I want to view and filter products
  So that I can find what I need

  Background:
    Given I am on the login page
    When I login with username "standard_user" and password "secret_sauce"

  @smoke @products
  Scenario Outline: View products with different users
    Given I am logged in as "<username>"
    Then I should see the products page
    And I should see at least 1 product

    Examples:
      | username             |
      | standard_user        |
      | problem_user         |
      | visual_user          |

  @smoke @sorting
  Scenario Outline: Sort products by different criteria
    Given I am on the products page
    When I sort products by "<sort_criteria>"
    Then I should see products sorted by "<sort_criteria>"

    Examples:
      | sort_criteria        |
      | Name (A to Z)        |
      | Name (Z to A)        |
      | Price (low to high)  |
      | Price (high to low)  |