module Stamp
  class StrftimeTranslator
    MONTHNAMES_REGEXP      = /^(#{Date::MONTHNAMES.compact.join('|')})$/i
    ABBR_MONTHNAMES_REGEXP = /^(#{Date::ABBR_MONTHNAMES.compact.join('|')})$/i
    DAYNAMES_REGEXP        = /^(#{Date::DAYNAMES.join('|')})$/i
    ABBR_DAYNAMES_REGEXP   = /^(#{Date::ABBR_DAYNAMES.join('|')})$/i
    TIMEZONE_REGEXP        = /^(AST|CET|CST|EET|EST|GMT|JST|MSK|MST|PST|UTC|WST)$/i

    ONE_DIGIT_REGEXP       = /^\d{1}$/
    TWO_DIGIT_REGEXP       = /^\d{2}$/
    FOUR_DIGIT_REGEXP      = /^\d{4}$/

    TIME_REGEXP            = /(\d{1,2})(:)(\d{2})(\s*)(:)?(\d{2})?(\s*)?([ap]m)?/i

    MERIDIAN_LOWER_REGEXP  = /^(a|p)m$/
    MERIDIAN_UPPER_REGEXP  = /^(A|P)M$/

    ORDINAL_DAY_REGEXP     = /^(\d{1,2})(st|nd|rd|th)$/

    # Disambiguate based on value
    OBVIOUS_YEARS          = 60..99
    OBVIOUS_MONTHS         = 12
    OBVIOUS_DAYS           = 13..31
    OBVIOUS_24_HOUR        = 13..23

    OBVIOUS_DATE_MAP = {
      OBVIOUS_YEARS  => '%y',
      OBVIOUS_MONTHS => '%m',
      OBVIOUS_DAYS   => '%d'
    }

    TWO_DIGIT_DATE_SUCCESSION = {
      :month => '%d',
      :day   => '%y',
      :year  => '%m'
    }

    TWO_DIGIT_TIME_SUCCESSION = {
      :hour   => '%M',
      :minute => '%S'
    }

    def initialize(target_date_or_time)
      @target = target_date_or_time
    end

    # Cribbed from ActiveSupport to format ordinal days (1st, 2nd, 23rd etc).
    def ordinalize(number)
      if (11..13).include?(number.to_i % 100)
        "#{number}th"
      else
        case number.to_i % 10
        when 1; "#{number}st"
        when 2; "#{number}nd"
        when 3; "#{number}rd"
        else    "#{number}th"
        end
      end
    end

    def translate(example)
      # extract any substrings that look like times, like "23:59" or "8:37 am"
      before, time_example, after = example.partition(TIME_REGEXP)

      # transform any date tokens to strftime directives
      words = strftime_directives(before.split(/\b/)) do |token, previous_part|
        strftime_date_directive(token, previous_part)
      end

      # transform the example time string to strftime directives
      unless time_example.empty?
        time_parts = time_example.scan(TIME_REGEXP).first
        words += strftime_directives(time_parts) do |token, previous_part|
          strftime_time_directive(token, previous_part)
        end
      end

      # recursively process any remaining text
      words << translate(after) unless after.empty?
      words.join
    end

    # Returns symbolic date part for given strftime directive.
    def date_part(strftime_directive)
      case strftime_directive
      when '%b', '%B', '%m'
        :month
      when '%d', '%e'
        :day
      when '%y', '%Y'
        :year
      when '%H', '%I', '%l'
        :hour
      when '%M'
        :minute
      when '%S'
        :second
      end
    end

    # Transforms tokens that look like date/time parts to strftime directives.
    def strftime_directives(tokens)
      previous_part = nil
      tokens.map do |token|
        directive = yield(token, previous_part)
        previous_part = date_part(directive) unless directive.nil?
        directive || token
      end
    end

    def strftime_time_directive(token, previous_part)
      case token
      when MERIDIAN_LOWER_REGEXP
        if RUBY_VERSION =~ /^1.8/ && @target.is_a?(Time)
          # 1.8.7 doesn't implement %P
          @target.strftime("%p").downcase
        else
          '%P'
        end

      when MERIDIAN_UPPER_REGEXP
        '%p'

      when TWO_DIGIT_REGEXP
        TWO_DIGIT_TIME_SUCCESSION[previous_part] ||
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

    def strftime_date_directive(token, previous_part)
      case token
      when MONTHNAMES_REGEXP
        '%B'

      when ABBR_MONTHNAMES_REGEXP
        '%b'

      when DAYNAMES_REGEXP
        '%A'

      when ABBR_DAYNAMES_REGEXP
        '%a'

      when TIMEZONE_REGEXP
        '%Z'

      when FOUR_DIGIT_REGEXP
        '%Y'

      when ORDINAL_DAY_REGEXP
        ordinalize(@target.day)

      when TWO_DIGIT_REGEXP
        value = token.to_i

        obvious_mappings =
          OBVIOUS_DATE_MAP.reject { |k,v| date_part(v) == previous_part }

        obvious_directive = obvious_mappings.find do |range, directive|
          break directive if range === value
        end

        # if the intent isn't obvious based on the example value, try to
        # disambiguate based on context
        obvious_directive ||
          TWO_DIGIT_DATE_SUCCESSION[previous_part] ||
          '%m'

      when ONE_DIGIT_REGEXP
        '%e' # day without leading zero
      end
    end

  end
end
