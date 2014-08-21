module Stamp
  module Emitters
    class Ambiguous
      attr_reader :potential_emitters

      def initialize(*emitters)
        @potential_emitters = emitters
      end

      def field
        nil
      end

      def disambiguate(emitters)
        other_emitters = emitters - self
        known_fields = other_emitters.map { |e| e.field }.compact

        potential_emitters.reject do |potential_emitter|
          known_fields.include?(potential_emitter.field)
        end.first
      end
    end
  end
end
