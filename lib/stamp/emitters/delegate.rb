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

      def format(target)
        modify(target.send(field))
      end
    end
  end
end