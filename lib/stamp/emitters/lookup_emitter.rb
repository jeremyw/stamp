module Stamp
  module Emitters
    class LookupEmitter
      attr_reader :field

      # @param [field] the field to be formatted (e.g.: mon, year)
      # @param [lookup] an array or proc with the string values to be formatted (e.g.: Date::DAYNAMES)
      def initialize(field, lookup=nil)
        @field = field
        @lookup = lookup
      end

      def format(target)
        lookup(target.send(field))
      end
      alias :call :format

      def lookup(value)
        if @lookup.respond_to?(:call)
          @lookup.call(value)
        else
          @lookup[value]
        end
      end

      def regexp
        /^(#{@lookup.join('|')})$/i
      end
    end
  end
end