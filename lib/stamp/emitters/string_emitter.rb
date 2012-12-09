module Stamp
  module Emitters
    class StringEmitter
      attr_reader :value

      def initialize(value)
        @value = value || ''
      end

      def format(target)
        value
      end
      alias :call :format

      def <<(other)
        value << other.value unless other.blank?
      end

      def blank?
        value.empty?
      end
    end
  end
end