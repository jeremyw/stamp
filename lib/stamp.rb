require "stamp/version"
require "date"
require "time"

module Stamp
  MONTHNAMES_REGEXP      = /^(#{(Date::MONTHNAMES + %w(Month)).compact.join('|')})$/i
  ABBR_MONTHNAMES_REGEXP = /^(#{(Date::ABBR_MONTHNAMES + %w(mon)).compact.join('|')})$/i
  DAYNAMES_REGEXP        = /^(#{(Date::DAYNAMES + %w(Weekday)).join('|')})$/i
  ABBR_DAYNAMES_REGEXP   = /^(#{(Date::ABBR_DAYNAMES - %w(mon)).join('|')})$/i

  ONE_DIGIT_REGEXP       = /^\d{1}$/
  TWO_DIGIT_REGEXP       = /^\d{2}$/
  FOUR_DIGIT_REGEXP      = /^(\d{4}|yyyy|year)$/i

  TWO_DIGITYEAR          = /^([6-9]\d|yy|YY)$/
  TWO_DIGITMONTH         = /^(m|mm|M|MM12)$/
  SINGLEDAY_REGEXP       = /^(day|D|d)$/i
  DOUBLEDAY_REGEXP       = /^(dd|DD)$/i

  SINGLEHOUR_REGEXP      = /^(h)$/i
  DOUBLEHOUR_REGEXP      = /^(hh)$/i

  DOUBLEMINUTE_REGEXP    = /^(mm)$/i

  SECONDS_REGEXP         = /^(ss)$/i

  TIME_REGEXP            = /([0-9hH]{1,2})(:)([0-9mM]{2})(\s*)(:)?([0-9sS]{2})?(\s*)?([apAP]\.?[mM]\.?)?/i

  #NOTE: this does not work for 1.8.7/ree Time class
  MERIDIAN_LOWER_REGEXP  = /^(a|p)m$/ #a.m. Am
  MERIDIAN_UPPER_REGEXP  = /^(A|P)M$/i

  # Disambiguate based on value
  OBVIOUS_YEARS          = 60..99
  OBVIOUS_MONTHS         = 12
  OBVIOUS_DAYS           = 28..31
  OBVIOUS_24_HOUR        = 13..23

  TWO_DIGIT_DATE_SUCCESSION = {
    '%m' => '%d',
    '%b' => '%d',
    '%B' => '%d',
    '%d' => '%y',
    '%e' => '%y'
  }

  TWO_DIGIT_TIME_SUCCESSION = {
    '%H' => '%M',
    '%I' => '%M',
    '%l' => '%M',
    '%M' => '%S'
  }


  def stamp(example)
    strftime(strftime_format(example))
  end


  private

  # Transforms the given string with example dates/times to a format string
  # suitable for strftime.
  def strftime_format(example)
    # extract any substrings that look like times, like "23:59" or "8:37 am"
    before, time_example, after = example.partition(TIME_REGEXP)

    # transform any date tokens to strftime directives
    #splitting on a non % \b
    words = strftime_directives(before.split(/\b/)) do |token, previous_directive|
      strftime_date_directive(token, previous_directive)
    end

    # transform the example time string to strftime directives
    unless time_example.empty?
      time_parts = time_example.scan(TIME_REGEXP).first
      words += strftime_directives(time_parts) do |token, previous_directive|
        strftime_time_directive(token, previous_directive)
      end
    end

    # recursively process any remaining text
    words << strftime_format(after) unless after.empty?
    words.join
  end

  # Transforms tokens that look like date/time parts to strftime directives.
  def strftime_directives(tokens)
    previous_directive = nil
    tokens.map do |token|
      directive = yield(token, previous_directive)
      previous_directive = directive unless directive.nil?
      directive || token
    end
  end

  def strftime_time_directive(token, previous_directive)
    case token
    when MERIDIAN_LOWER_REGEXP
      '%P'

    when MERIDIAN_UPPER_REGEXP
      '%p'

    when SINGLEHOUR_REGEXP
      '%l'
    when DOUBLEHOUR_REGEXP
      '%H'
    when DOUBLEMINUTE_REGEXP
      '%M'
    when SECONDS_REGEXP
      '%S'

    when TWO_DIGIT_REGEXP
      TWO_DIGIT_TIME_SUCCESSION[previous_directive] ||
        case token.to_i
        when OBVIOUS_24_HOUR
          '%H' # 24-hour clock
        else
          '%I' # 12-hour clock with leading zero
        end

    when ONE_DIGIT_REGEXP
      '%l' # hour without leading zero
    end
  end

  def strftime_date_directive(token, previous_directive)
    case token
    when MONTHNAMES_REGEXP
      '%B'

    when ABBR_MONTHNAMES_REGEXP
      '%b'

    when DAYNAMES_REGEXP
      '%A'

    when ABBR_DAYNAMES_REGEXP
      '%a'

    when FOUR_DIGIT_REGEXP
      '%Y'
    when TWO_DIGITYEAR
      '%y'
    when TWO_DIGITMONTH
      '%m'
    when SINGLEDAY_REGEXP
      '%e'
    when DOUBLEDAY_REGEXP
      '%d'

    when TWO_DIGIT_REGEXP
      # try to discern obvious intent based on the example value
      case token.to_i
      when OBVIOUS_YEARS
        '%y'
      when OBVIOUS_MONTHS
        '%m'
      when OBVIOUS_DAYS
        '%d'
      else
        # the intent isn't obvious based on the example value, so try to
        # disambiguate based on context
        TWO_DIGIT_DATE_SUCCESSION[previous_directive] || '%m'
      end

    when ONE_DIGIT_REGEXP
      '%e' # day without leading zero
    end
  end
end


Date.send(:include, ::Stamp)
Time.send(:include, ::Stamp)
