module Stamp
  module Emitters
    # Emits the given field as a two-digit number with a leading
    # zero if necessary.
    class TwoDigit
      include Modifiable

      attr_reader :field

      # @param [field] the field to be formatted (e.g. +:month+, +:year+)
      def initialize(field, &block)
        @field = field
        @modifier = block
      end

      def format(out, target)
        value = modify(target.send(field))
        out << (value < 10 ? '0' : '') << value.to_s
      end
    end
  end
end