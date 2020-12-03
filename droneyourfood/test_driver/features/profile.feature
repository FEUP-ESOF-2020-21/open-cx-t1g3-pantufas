Feature: Profile

    uwu

    Scenario: The profile button navigates to a page containing the user's email and username
        Given I am logged in
        When the profile button is tapped
        Then I navigate to a page containing my email and username