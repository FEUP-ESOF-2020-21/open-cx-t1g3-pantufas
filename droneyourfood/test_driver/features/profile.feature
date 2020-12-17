Feature: Profile
  #uwu
  Scenario: User can navigate to his profile page by tapping the profile button
    Given I am logged in
    When I tap the "profile" button
    # Then I navigate to a page containing my email and username
    Then I expect the text "Ana Nachos" to be present
    And I expect the text "nachosuwu@protonmail.com" to be present

    Given I tap the back button
    Then I expect the text "Drone your food" to be present
    And I expect the text "List Products" to be present
    And I expect the text "List Categories" to be present

