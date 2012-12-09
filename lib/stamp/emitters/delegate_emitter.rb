module Stamp
  module Emitters
    class DelegateEmitter
      attr_reader :field

      def initialize(field)
        @field = field
      end

      def format(target)
        target.send(field)
      end
    end
  end
end