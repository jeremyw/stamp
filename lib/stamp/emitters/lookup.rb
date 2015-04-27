module Stamp
  module Emitters
    class Lookup
      attr_reader :field

      # @param [Symbol|String] field the field to be formatted (e.g. +:month+, +:year+)
      # @param [Array<String>] lookup an array of the string values to be formatted (e.g. +Date::DAYNAMES+)
      def initialize(field, lookup)
        @field = field
        @lookup = lookup
      end

      def format(target)
        lookup(target.send(field))
      end

      def lookup(value)
        @lookup[value]
      end

      MONTH      = new(:month, Date::MONTHNAMES)
      ABBR_MONTH = new(:month, Date::ABBR_MONTHNAMES)
      DAY        = new(:wday,  Date::DAYNAMES)
      ABBR_DAY   = new(:wday,  Date::ABBR_DAYNAMES)
    end
  end
end
