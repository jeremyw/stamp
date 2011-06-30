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

    DATE_DELIMITER_REGEXP  = /(\/|\-)/ # forward slash or dash


    def stamp(example)
      strftime(strftime_directives(example))
    end

    def strftime_directives(example)
      directives = []
      previous_directive = nil

      terms = example.split(/\b/)

      terms.each_with_index do |term, index|
        directive = strftime_directive(term, previous_directive)
        directives << (directive || term)

        previous_term = term
        previous_directive = directive unless directive.nil?
      end

      directives.join
    end
    private :strftime_directives

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
        case previous_directive
        when '%m', '%b', '%B' # a month
          '%d' # day with leading zero
        when '%d', '%e'       # a day
          '%y' # two-digit year
        else
          '%m' # month
        end

      when ONE_DIGIT_REGEXP
        '%e' # day without leading zero
      end
    end
    private :strftime_directive
  end
end

Date.send(:include, ::Stamp)