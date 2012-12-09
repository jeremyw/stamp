module Stamp
  module Emitters
    class CompositeEmitter
      include Enumerable

      def initialize(emitters=nil)
        @emitters = []
        self << emitters if emitters
      end

      def format(target)
        @emitters.map { |e| e.format(target) }.join('')
      end
      alias :call :format

      def <<(emitter)
        if emitter.is_a?(Enumerable)
          emitter.each { |e| self << e }
        # elsif !emitter.is_a?(Emitter)
        #   raise "not an emitter: #{emitter.nil? ? "nil" : emitter}"
        elsif @emitters.last.is_a?(StringEmitter) && emitter.is_a?(StringEmitter)
          @emitters.last << emitter
        else
          @emitters << emitter unless emitter.respond_to?(:blank?) && emitter.blank?
        end
      end

      def each(&block)
        @emitters.each(&block)
      end

      def blank?
        @emitters.empty?
      end
    end
  end
end