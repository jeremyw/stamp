module Stamp
  module Emitters
    # Emits the given field as a two-digit number with a leading
    # zero if necessary.
    class TwoDigit
      attr_reader :field, :strftime_directive

      # @param [String|Symbol] field the field to be formatted (e.g. +:month+, +:year+)
      def initialize(field, strftime_directive)
        @field = field
        @strftime_directive = strftime_directive
      end

      def format(target)
        value = target.send(field) % 100
        # by definition, leading_zero option is true
        if value < 10
          "0#{value}"
        else
          value
        end
      end
      YEAR  = new(:year,  "%y")
      MONTH = new(:month, "%m")
      DAY   = new(:day,   "%d")
      HOUR  = new(:hour,  "%H")
      MIN   = new(:min,   "%M")
      SEC   = new(:sec,   "%S")
    end
  end
end
