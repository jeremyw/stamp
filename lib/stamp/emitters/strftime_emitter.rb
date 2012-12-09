module Stamp
  module Emitters
    class StrftimeEmitter
      def initialize(directive)
        @directive = directive
      end

      def format(target)
        target.strftime(@directive)
      end

      def field
        nil
      end
    end
  end
end