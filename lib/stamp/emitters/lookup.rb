module Stamp
  module Emitters
    class Lookup
      attr_reader :field

      # @param [field] the field to be formatted (e.g. +:month+, +:year+)
      # @param [lookup] an array of the string values to be formatted (e.g. +Date::DAYNAMES+)
      #                 or a +call+able that returns the formatted value
      def initialize(field, lookup=nil)
        @field = field
        @lookup = lookup
      end

      def format(target)
        lookup(target.send(field))
      end

      def lookup(value)
        if @lookup.respond_to?(:call)
          @lookup.call(value)
        else
          @lookup[value]
        end
      end
    end
  end
end