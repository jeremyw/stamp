module Stamp
  module Emitters
    class Composite
      include Enumerable

      def initialize
        @emitters = []
      end

      def format(target)
        # NOTE using #each to build string because benchmarking shows
        # that it's ~20% faster than .map.join('')
        result = ''
        @emitters.each { |e| result << e.format(target).to_s }
        result
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