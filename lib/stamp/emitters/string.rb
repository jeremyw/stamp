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

      # Literal text, with % escaped so strftime passes it through verbatim.
      def strftime_directive
        # value can be nil (unmatched optional capture groups become tokens)
        value.to_s.gsub("%", "%%")
      end

      def field
        nil
      end
    end
  end
end