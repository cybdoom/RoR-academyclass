Feature: I view the product manufacturer page
  In order to see info about a product manufacturer
  On the home page
  I click a product manufacturer link

  Scenario:
    Given I am on the home page
    When I follow "Adobe"
    Then I should see "Adobe Training Courses"
    And I should see "By Academy Class"
