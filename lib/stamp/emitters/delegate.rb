module Stamp
  module Emitters
    class Delegate
      include Modifiable

      attr_reader :field

      # @param [field] the field to be formatted (e.g. +:month+, +:year+)
      def initialize(field, &block)
        @field = field
        @modifier = block
      end

      def format(out, target)
        out << modify(target.send(field).to_s)
      end
    end
  end
end