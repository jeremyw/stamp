module Stamp
  module Emitters
    class OrdinalEmitter
      attr_reader :field

      def initialize(field, options={})
        @field = field
        @options = options
      end

      def format(target)
        ordinalize(target.send(field))
      end

      def ordinalize(number)
        if number.to_i % 100 / 10 == 1
          "#{number}th"
        else
          case number.to_i % 10
          when 1; "#{number}st"
          when 2; "#{number}nd"
          when 3; "#{number}rd"
          else    "#{number}th"
          end
        end
      end

      def blank?
        false
      end
    end
  end
end