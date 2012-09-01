@stamp
Feature: Stamping a date
  In order to format dates in a more programmer-friendly way
  the stamp method
  formats a date given a human-readable example.

  @date
  Scenario Outline: Formatting dates by example
    Given the date September 8, 2011
    When I stamp the example "<example>"
    Then I produce "<output>"

    Examples:
      | example                  | output                       |
      | January                  | September                    |
      | Jan                      | Sep                          |
      | Jan 1                    | Sep  8                       |
      | Jan 01                   | Sep 08                       |
      | Jan 10                   | Sep 08                       |
      | Jan 1, 1999              | Sep  8, 2011                 |
      | Monday                   | Thursday                     |
      | Tue, Jan 1               | Thu, Sep  8                  |
      | Tuesday, January 1, 1999 | Thursday, September  8, 2011 |
      | 01/1999                  | 09/2011                      |
      | 01/01                    | 09/08                        |
      | 01/31                    | 09/08                        |
      | 01/99                    | 09/11                        |
      | 01/01/1999               | 09/08/2011                   |
      | 12/31/99                 | 09/08/11                     |
      | 31/12                    | 08/09                        |
      | 31/12/99                 | 08/09/11                     |
      | 31-Jan-1999              | 08-Sep-2011                  |
      | 1999-12-31               | 2011-09-08                   |
      | DOB: 12-31-1999          | DOB: 09-08-2011              |

  @time
  Scenario Outline: Formatting times by example
    Given the time September 8, 2011 at 13:31:27
    When I stamp the example "<example>"
    Then I produce "<output>"

    Examples:
      | example     | output      |
      | 8:59 am     | 1:31 pm     |
      | 8:59am      | 1:31pm      |
      | 08:59 AM    | 01:31 PM    |
      | 08:59 PM    | 01:31 PM    |
      | 23:59       | 13:31       |
      | 8:59:59 am  | 1:31:27 pm  |
      | 08:59:59 AM | 01:31:27 PM |
      | 08:59:59 PM | 01:31:27 PM |
      | 23:59:59    | 13:31:27    |

  @date
  @time
  Scenario Outline: Formatting dates and times by example
    Given the time September 8, 2011 at 13:31:27
    When I stamp the example "<example>"
    Then I produce "<output>"

    Examples:
      | example                         | output                            |
      | Jan 1, 1999 8:59 am             | Sep  8, 2011  1:31 pm             |
      | 08:59 AM 1999-12-31             | 01:31 PM 2011-09-08               |
      | Date: Jan 1, 1999 Time: 8:59 am | Date: Sep  8, 2011 Time:  1:31 pm |

  Scenario: strftime directives just get passed through
    Given the date December 21, 2012
    When I stamp the example "John Cusack was in a movie about %b %d, %Y, but it wasn't very good."
    Then I produce "John Cusack was in a movie about Dec 21, 2012, but it wasn't very good."

  Scenario: Plain text just gets passed through
    Given the date June 1, 1926
    When I stamp the example "Marilyn Monroe was born on January 1, 1999."
    Then I produce "Marilyn Monroe was born on June  1, 1926."

  Scenario Outline: Aliases for the stamp method
    Given the date December 9, 2011
    When I call "<alias>" with "1999-01-31"
    Then I produce "2011-12-09"

    Examples:
      | alias       |
      | stamp_like  |
      | format_like |

  @wip
  Scenario Outline: Examples that aren't supported yet
    Given the time September 8, 2011 at 13:31:27
    When I stamp the example "<example>"
    Then I produce "<output>"

    Examples:
      | example | output |
      | 8 am    | 1 pm   |
      | 8am     | 1pm    |
      | 8AM     | 1PM    |
