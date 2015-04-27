module Stamp
  module Emitters
    # Emits the given field as a two-digit number with a leading
    # zero if necessary.
    class TwoDigit
      attr_reader :field

      # @param [String|Symbol] field the field to be formatted (e.g. +:month+, +:year+)
      def initialize(field)
        @field = field
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
      YEAR  = new(:year)
      MONTH = new(:month)
      DAY   = new(:day)
      HOUR  = new(:hour)
      MIN   = new(:min)
      SEC   = new(:sec)
    end
  end
end
