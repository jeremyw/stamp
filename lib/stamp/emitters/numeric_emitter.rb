module Stamp
  module Emitters
    class NumericEmitter
      attr_reader :field

      # @param [field] the field to be formatted (e.g.: mon, year)
      # @param [options]
      def initialize(field, options={})
        @field = field
        @options = options
      end

      def format(target)
        value = target.send(field)
        value = @options[:modifier].call(value) if @options[:modifier]
        value = '%2.2d' % value if @options[:leading_zero]
        value.to_s
      end
      alias :call :format
    end
  end
end