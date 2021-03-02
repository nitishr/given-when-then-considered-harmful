Feature: Page access control

  Scenario Outline: Users are routed to pages by role
    Given I am an <role> user
    When I go to the <opened> page
    And I click on a 'button'
    Then I should be on the <landed_on> page
    Examples: Anonymous users are routed to the login page
      | role      | opened  | landed_on |
      | anonymous | public  | login     |
      | anonymous | private | login     |
      | anonymous | private | logout     |
    Examples: Unauthorized users are routed to the public page
      | role         | opened  | landed_on |
      | unauthorized | public  | public    |
      | unauthorized | private | public    |
    Examples: Authorized users are routed to the opened page
      | role       | opened  | landed_on |
      | authorized | public  | public    |
      | authorized | private | private   |
