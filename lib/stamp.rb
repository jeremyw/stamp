require "stamp/version"
require "date"

module Stamp
  def self.included(klass)
    klass.class_eval do
      # extend ClassMethods
      include InstanceMethods
    end
  end

  # module ClassMethods
  # end

  module InstanceMethods

    MONTHNAMES_REGEXP      = /(#{Date::MONTHNAMES.compact.join('|')})/i
    ABBR_MONTHNAMES_REGEXP = /(#{Date::ABBR_MONTHNAMES.compact.join('|')})/i
    DAYNAMES_REGEXP        = /(#{Date::DAYNAMES.join('|')})/i
    ABBR_DAYNAMES_REGEXP   = /(#{Date::ABBR_DAYNAMES.join('|')})/i

    ONE_DIGIT_REGEXP       = /\d{1}/
    TWO_DIGIT_REGEXP       = /\d{2}/
    FOUR_DIGIT_REGEXP      = /\d{4}/

    # DATE_DELIMITER_REGEXP  = /(\/|\-)/ # forward slash or dash

    # OBVIOUS_MINUTES        = 32..59
    # OBVIOUS_HOURS
    # OBVIOUS_SECONDS

    OBVIOUS_YEARS          = 60..99
    OBVIOUS_MONTHS         = 12
    OBVIOUS_DAYS           = 28..31

    TIME_REGEXP            = /(\d{1,2}):(\d{2})\s*(a|p)?m?/i

    def stamp(example)
      strftime(strftime_directives(example))
    end

    def strftime_directives(example)
      transform_stamp_example(example).join
    end
    private :strftime_directives

    def transform_stamp_example(example)
      words = []
      previous_directive = nil

      before, time_string, after = example.partition(TIME_REGEXP)

      terms = before.split(/\b/)
      terms.each_with_index do |term, index|
        directive = strftime_directive(term, previous_directive)
        words << (directive || term)

        previous_directive = directive unless directive.nil?
      end

      # format time string and append

      words += transform_stamp_example(after) unless after.empty?
      words
    end
    private :transform_stamp_example

    def strftime_directive(term, previous_directive=nil)
      case term
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

      when TWO_DIGIT_REGEXP
        # try to discern obvious intent based on the example value
        case term.to_i
        when OBVIOUS_YEARS
          '%y'
        when OBVIOUS_MONTHS
          '%m'
        when OBVIOUS_DAYS
          '%d'
        else
          # the intent isn't obvious based on the example value, so try to
          # disambiguate based on context
          case previous_directive
          when '%m', '%b', '%B' # a month
            '%d' # day with leading zero
          when '%d', '%e'       # a day
            '%y' # two-digit year
          else
            '%m' # month
          end
        end

      when ONE_DIGIT_REGEXP
        '%e' # day without leading zero
      end
    end
    private :strftime_directive
  end
end


Date.send(:include, ::Stamp)
Time.send(:include, ::Stamp)
