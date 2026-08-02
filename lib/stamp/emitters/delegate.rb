module Stamp
  module Emitters
    class Delegate
      attr_reader :field, :strftime_directive

      # @param [Symbol|String] field the field to be formatted (e.g. +:month+, +:year+)
      def initialize(field, strftime_directive)
        @field = field
        @strftime_directive = strftime_directive
      end

      # @param [Date|Time|DateTime] target the date to be formatted
      def format(target)
        target.send(field)
      end

      ZONE  = new(:zone,  "%Z")
      YEAR  = new(:year,  "%Y")
      MONTH = new(:month, "%-m")
      DAY   = new(:day,   "%-d")
    end
  end
end
