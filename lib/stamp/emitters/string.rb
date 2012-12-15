module Stamp
  module Emitters
    class String
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def format(out, target)
        out << value.to_s
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