module Stamp
  module Emitters
    class AmPmEmitter
      def initialize(options={})
        @options = options
      end

      def field
        nil
      end

      def format(target)
        value = lookup(target.send(:hour))
        value = @options[:modifier].call(value) if @options[:modifier]
        value
      end

      def lookup(hour)
        hour < 12 ? "am" : "pm"
      end
    end
  end
end