module Stamp
  module Emitters
    # Emits the target's UTC offset, e.g. "-0500" or "-05:00".
    class UtcOffset
      # @param [String] directive the strftime directive to delegate to
      #   (+"%z"+ or +"%:z"+)
      def initialize(directive)
        @directive = directive
      end

      def format(target)
        target.strftime(@directive)
      end

      def strftime_directive
        @directive
      end

      def field
        nil
      end

      PLAIN = new("%z")
      COLON = new("%:z")
    end
  end
end
