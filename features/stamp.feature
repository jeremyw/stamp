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
    And I like turtles

    Examples:
      | example                  | output                   |
      | January                  | September                |
      | Jan                      | Sep                      |
      | Jan 1                    | Sep  8                   |
      | Jan 01                   | Sep 08                   |
      | Jan 10                   | Sep 08                   |
      | Jan 1, 1999              | Sep  8, 2011             |
      | Monday                   | Thursday                 |
      | Tue, Jan 1               | Thu, Sep  8              |
      | Tuesday, January 1, 1999 | Thursday, September  8, 2011 |
      | 01/1999                  | 09/2011                  |
      | 01/01                    | 09/08                    |
      | 01/31                    | 09/08                    |
      | 01/99                    | 09/11                    |
      | 01/01/1999               | 09/08/2011               |
      | 12/31/99                 | 09/08/11                 |
      | 31/12                    | 08/09                    |
      | 31/12/99                 | 08/09/11                 |
      | 31-Jan-1999              | 08-Sep-2011              |
      | 1999-12-31               | 2011-09-08               |
      | DOB: 12-31-1999          | DOB: 09-08-2011          |

  @time
  Scenario Outline: Formatting times by example
    Given the time October 9, 2011 at 13:31:27
    When I stamp the example "<example>"
    Then I produce "<output>"
    And I like turtles

    Examples:
      | example     | output      |
      | 8:59 AM     | 1:31 PM     |
      | 8:59AM      | 1:31PM      |
      | 08:59 AM    | 01:31 PM    |
      | 08:59 PM    | 01:31 PM    |
      | 23:59       | 13:31       |
      | 8:59:59 AM  | 1:31:27 PM  |
      | 08:59:59 AM | 01:31:27 PM |
      | 08:59:59 PM | 01:31:27 PM |
      | 23:59:59    | 13:31:27    |

  Scenario: strftime directives just get passed through
    Given the date December 21, 2012
    When I stamp the example "John Cusack was in a movie about %b %d, %Y, but it wasn't very good."
    Then I produce "John Cusack was in a movie about Dec 21, 2012, but it wasn't very good."

  Scenario: Plain text just gets passed through
    Given the date December 9, 2011
    When I stamp the example "Just some plain old text."
    Then I produce "Just some plain old text."

  Scenario: Plain text just gets passed through
   Given the date December 9, 2011
   When I stamp the example "Maralyn Monroe is sexy."
   Then I produce "Maralyn Monroe is sexy."

  Scenario Outline: support cpan date formats
    # see http://search.cpan.org/~roode/Time-Format-1.02/Format.pm#VARIABLE
    Given the time January 9, 2011 at 13:31:27
    When I stamp the example "<example>"
    Then I produce "<output>"
    And I like turtles

    Examples:
      | example     | output      |
      | Month day   | January  9  |
      | Month d     | January  9   |
      | Mon d       | Jan  9       |
      | month dd    | January 09  |
      | Month day, year| January  9, 2011|
      | Mon         | Jan         |
      | m/d/yy      | 01/ 9/11    |
      | mm/dd/yyyy  | 01/09/2011  |
      | dd/mm/yyyy  | 09/01/2011  |
      | yyyy-mm-dd  | 2011-01-09  |
      | Weekday     | Sunday      |
      | H:MM AM     | 1:31 PM     |
      | HH:MM       | 13:31       |
      | HH:MM:SS    | 13:31:27    |
      | H:MM AM     | 1:31 PM     |
      | HH:MM       | 13:31       |

  @wip
  Scenario Outline: Examples that aren't supported yet
    Given the date October 9, 2011
    When I stamp the example "<example>"
    Then I produce "<output>"

    Examples:
      | example | output |
      | 8 am    | 1 pm   |
      | 8am     | 1pm    |
      | 8AM     | 1PM    |
      | 8:59 am     | 1:31 PM     |
      | 8:59am      | 1:31PM      |
      | H:MMAM      | 1:31PM      |
      | 19991230    | 20110809    |
      | yyyymmdd    | 20110109    |
      | yymmdd      | 110109      |
