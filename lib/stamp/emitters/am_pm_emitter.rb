module Stamp
  module Emitters
    class AmPmEmitter
      IDENTITY = lambda {|p| p }
      def initialize(options={}, &block)
        @options = options
        @modifier = block || IDENTITY
      end

      def field
        nil
      end

      def format(target)
        @modifier.call(lookup(target.send(:hour)))
      end

      def lookup(hour)
        hour < 12 ? "am" : "pm"
      end
    end
  end
end