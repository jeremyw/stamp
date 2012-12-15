module Stamp
  module Emitters
    class Ordinal
      attr_reader :field

      # @param [field] the field to be formatted (e.g. +:month+, +:year+)
      def initialize(field)
        @field = field
      end

      def format(out, target)
        out << ordinalize(target.send(field))
      end

      # Cribbed from ActiveSupport::Inflector
      # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/inflector/methods.rb
      def ordinalize(number)
        number.to_s + if (11..13).include?(number % 100)
          'th'
        else
          case number % 10
            when 1; 'st'
            when 2; 'nd'
            when 3; 'rd'
            else    'th'
          end
        end
      end
    end
  end
end