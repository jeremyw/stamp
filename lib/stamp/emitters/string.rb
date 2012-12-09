module Stamp
  module Emitters
    class String
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def format(target)
        value
      end

      def <<(emitter)
        value << emitter.value
      end

      def field
        nil
      end
    end
  end
end