module Stamp
  module Emitters
    # Emits hours as a two-digit number with a leading
    # zero if necessary.
    class TwelveHour
      attr_reader :leading_zero

      # @param [String|Symbol] field the field to be formatted (e.g. +:month+, +:year+)
      # @param [Hash] options the options for output
      # @option options [String] :leading_zero (default: false) pass true add a leading 0 to output
      def initialize(options = {})
        @leading_zero = options[:leading_zero]
      end

      # @param [Date|Time|DateTime] target the date to be formatted
      def format(target)
        value = target.hour
        value = ((value - 1) % 12) + 1
        if leading_zero && (value < 10)
          "0#{value}"
        else
          value
        end
      end

      def field
        :hour
      end

      LEADING_ZERO     = new(leading_zero: true)
      NON_LEADING_ZERO = new(leading_zero: false)
    end
  end
end
