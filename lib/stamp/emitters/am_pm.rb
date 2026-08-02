module Stamp
  module Emitters
    class AmPm
      attr_reader :strftime_directive

      # @param [Array<String>]values for am pm text
      def initialize(values, strftime_directive)
        @values = values
        @strftime_directive = strftime_directive
      end

      def format(target)
        @values[target.hour < 12 ? 0 : 1]
      end

      def field
        nil
      end

      UPPERCASE = new(%w(AM PM), "%p")
      LOWERCASE = new(%w(am pm), "%P")
    end
  end
end
