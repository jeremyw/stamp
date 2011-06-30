Feature: Stamping a date
  In order to format dates in a more programmer-friendly way
  the stamp method
  formats a date given a human-readable example.

  Scenario Outline: Various examples
    Given the date December 9, 2011
    When I stamp the example "<example>"
    Then I produce "<output>"
    And I like turtles

    Examples:
      | example      | output       |
      | pass-through | pass-through |
      | January      | December     |
      | Jan          | Dec          |
      | Jan 1        | Dec  9       |
      | Jan 01       | Dec 09       |
      | Jan 10       | Dec 09       |
      | Jan 1, 1999  | Dec  9, 2011 |
