module Stamp
  module Emitters
    class AmPm
      # @param [Hash] options
      # @option options [Boolean] :upcase (default: false) uppercase meridian
      def initialize(options = {})
        @values = options[:upcase] ? %w(AM PM) : %w(am pm)
      end

      def format(target)
        @values[target.hour < 12 ? 0 : 1]
      end

      def field
        nil
      end
    end
  end
end
