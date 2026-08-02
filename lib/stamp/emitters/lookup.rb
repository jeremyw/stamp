module Stamp
  module Emitters
    class Lookup
      attr_reader :field, :strftime_directive

      # @param [Symbol|String] field the field to be formatted (e.g. +:month+, +:year+)
      # @param [Array<String>] lookup an array of the string values to be formatted (e.g. +Date::DAYNAMES+)
      def initialize(field, lookup, strftime_directive)
        @field = field
        @lookup = lookup
        @strftime_directive = strftime_directive
      end

      def format(target)
        lookup(target.send(field))
      end

      def lookup(value)
        @lookup[value]
      end

      MONTH      = new(:month, Date::MONTHNAMES,      "%B")
      ABBR_MONTH = new(:month, Date::ABBR_MONTHNAMES, "%b")
      DAY        = new(:wday,  Date::DAYNAMES,        "%A")
      ABBR_DAY   = new(:wday,  Date::ABBR_DAYNAMES,   "%a")
    end
  end
end
