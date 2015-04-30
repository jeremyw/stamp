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
    end
  end
end
