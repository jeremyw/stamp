module Stamp
  module Emitters
    class Delegate
      attr_reader :field

      # @param [Symbol|String] field the field to be formatted (e.g. +:month+, +:year+)
      def initialize(field)
        @field = field
      end

      # @param [Date|Time|DateTime] target the date to be formatted
      def format(target)
        target.send(field)
      end
    end
  end
end
