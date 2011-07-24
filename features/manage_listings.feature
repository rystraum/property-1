Feature: Manage listings
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  @javascript
  Scenario: Submit a new listing with all fields completed
    Given I am on the new listing page
    When I submit valid data in all form fields
    Then I should be on the page for that listing
    And should see all the data submitted for all the fields

  Scenario: Delete listing
    Given the following listings:
      |submission|
      |submission 1|
      |submission 2|
      |submission 3|
      |submission 4|
    When I delete the 3rd listing
    Then I should see the following listings:
      |Submission|
      |submission 1|
      |submission 2|
      |submission 4|
