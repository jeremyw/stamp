Feature: Stamping a date
  In order to format dates in a more programmer-friendly way
  the stamp method
  formats a date given a human-readable example.

  Scenario Outline: Formatting dates by example
    Given the date December 9, 2011
    When I stamp the example "<example>"
    Then I produce "<output>"
    And I like turtles

    Examples:
      | example                 | output                    |
      | January                 | December                  |
      | Jan                     | Dec                       |
      | Jan 1                   | Dec  9                    |
      | Jan 01                  | Dec 09                    |
      | Jan 10                  | Dec 09                    |
      | Jan 1, 1999             | Dec  9, 2011              |
      | Sunday                  | Friday                    |
      | Sun                     | Fri                       |
      | Sun, Jan 1              | Fri, Dec  9               |
      | Sunday, January 1, 1999 | Friday, December  9, 2011 |
      | 01/1999                 | 12/2011                   |
      | 01/01                   | 12/09                     |
      | 01/31                   | 12/09                     |
      | 01/01/1999              | 12/09/2011                |
      | 01/01/99                | 12/09/11                  |
      | DOB: 01-31-1999         | DOB: 12-09-2011           |

  @wip
  Scenario Outline: Examples that aren't supported quite yet
    Given the date December 9, 2011
    When I stamp the example "<example>"
    Then I produce "<output>"

    Examples:
      | example     | output      |
      | 01-Jan-1999 | 09-Dec-2011 |

  Scenario: strftime directives just get passed through
    Given the date December 21, 2012
    When I stamp the example "John Cusack was in a movie about %b %d, %Y, but it wasn't very good."
    Then I produce "John Cusack was in a movie about Dec 21, 2012, but it wasn't very good."

  Scenario: Plain text just gets passed through
    Given the date December 9, 2011
    When I stamp the example "Just some plain old text."
    Then I produce "Just some plain old text."
