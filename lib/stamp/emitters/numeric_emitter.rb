module Stamp
  module Emitters
    class NumericEmitter
      attr_reader :field

      # @param [field] the field to be formatted (e.g. +:month+, +:year+)
      def initialize(field)
        @field = field
      end

      def format(out, target)
        out << target.send(field)
      end
    end
  end
end