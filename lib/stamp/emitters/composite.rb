module Stamp
  module Emitters
    class Composite
      include Enumerable

      attr_reader :emitters

      def initialize(emitters=[])
        @emitters = emitters
      end

      def format(target)
        # NOTE using #each to build string because benchmarking shows
        # that it's ~20% faster than .map.join('')
        result = ''
        emitters.each { |e| result << e.format(target).to_s }
        result
      end

      def <<(emitter)    
        Array(emitter).each { |e| emitters << e }
      end

      def each(&block)
        emitters.each(&block)
      end

      def -(others)
        emitters - Array(others)
      end

      # Replace each element as we iterate with the result of the given block.
      def replace_each!
        emitters.each_with_index do |emitter, index|
          emitters[index] = yield(emitter)
        end

        self
      end
    end
  end
end
