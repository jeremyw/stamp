module Stamp
  module Emitters
    class AmPm
      # @param [Array<String>]values for am pm text
      def initialize(values)
        @values = values
      end

      def format(target)
        @values[target.hour < 12 ? 0 : 1]
      end

      def field
        nil
      end

      UPPERCASE = new(%w(AM PM))
      LOWERCASE = new(%w(am pm))
    end
  end
end
