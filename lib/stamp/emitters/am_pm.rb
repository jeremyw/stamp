module Stamp
  module Emitters
    class AmPm
      include Modifiable

      AM = 'am'
      PM = 'pm'

      def initialize(&block)
        @modifier = block
      end

      def format(target)
        modify(target.hour < 12 ? AM : PM)
      end

      def field
        nil
      end
    end
  end
end