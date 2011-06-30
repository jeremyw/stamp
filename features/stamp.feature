Feature: Stamping a date
  In order to format dates in a more programmer-friendly way
  the stamp method
  formats a date given a human-readable example.

  Scenario Outline: Formatting dates by example
    Given the date October 9, 2011
    When I stamp the example "<example>"
    Then I produce "<output>"
    And I like turtles

    Examples:
      | example                  | output                   |
      | January                  | October                  |
      | Jan                      | Oct                      |
      | Jan 1                    | Oct  9                   |
      | Jan 01                   | Oct 09                   |
      | Jan 10                   | Oct 09                   |
      | Jan 1, 1999              | Oct  9, 2011             |
      | Monday                   | Sunday                   |
      | Mon                      | Sun                      |
      | Tue, Jan 1               | Sun, Oct  9              |
      | Tuesday, January 1, 1999 | Sunday, October  9, 2011 |
      | 01/1999                  | 10/2011                  |
      | 01/01                    | 10/09                    |
      | 01/31                    | 10/09                    |
      | 01/99                    | 10/11                    |
      | 01/01/1999               | 10/09/2011               |
      | 12/31/99                 | 10/09/11                 |
      | 31/12                    | 09/10                    |
      | 31/12/99                 | 09/10/11                 |
      | 31-Jan-1999              | 09-Oct-2011              |
      | 1999-12-31               | 2011-10-09               |
      | DOB: 12-31-1999          | DOB: 10-09-2011          |

  @wip
  Scenario Outline: Examples that aren't supported quite yet
    Given the date October 9, 2011
    When I stamp the example "<example>"
    Then I produce "<output>"

    Examples:
      | example | output |
      |         |        |

  Scenario: strftime directives just get passed through
    Given the date December 21, 2012
    When I stamp the example "John Cusack was in a movie about %b %d, %Y, but it wasn't very good."
    Then I produce "John Cusack was in a movie about Dec 21, 2012, but it wasn't very good."

  Scenario: Plain text just gets passed through
    Given the date December 9, 2011
    When I stamp the example "Just some plain old text."
    Then I produce "Just some plain old text."
