module Stamp
  module Emitters
    class Composite
      include Enumerable

      def initialize
        @emitters = []
      end

      def format(out, target)
        @emitters.each { |e| e.format(out, target) }
        out
      end

      def <<(emitter)
        if emitter.is_a?(Enumerable)
          emitter.each { |e| @emitters << e }
        else
          @emitters << emitter
        end
      end

      def each(&block)
        @emitters.each(&block)
      end
    end
  end
end