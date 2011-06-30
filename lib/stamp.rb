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
    MONTHNAMES_REGEXP = /(#{Date::MONTHNAMES.compact.join('|')})/i
    ABBR_MONTHNAMES_REGEXP = /(#{Date::ABBR_MONTHNAMES.compact.join('|')})/i

    def stamp(example)
      strftime(strftime_directives(example))
    end

    def strftime_directives(example)
      directives = []
      terms = example.split(/\b/)

      terms.each_with_index do |term, index|
        previous_term = (index == 0)            ? nil : terms[index - 1]
        next_term     = (index == terms.size-1) ? nil : terms[index + 1]

        directives << (strftime_directive(term, previous_term, next_term) || term)
      end

      directives.join
    end
    private :strftime_directives

    def strftime_directive(term, previous_term=nil, next_term=nil)
      case term
      when MONTHNAMES_REGEXP
        '%B'
      when ABBR_MONTHNAMES_REGEXP
        '%b'
      when /\d{4}/
        '%Y'
      when /\d{2}/
        '%d'
      when /\d{1}/
        '%e'
      end
    end
    private :strftime_directive
  end
end

Date.send(:include, ::Stamp)