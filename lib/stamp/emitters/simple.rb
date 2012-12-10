module Stamp
  module Emitters
    class Simple
      IDENTITY = lambda() {|d| d}
      attr_accessor :field
      attr_accessor :modifier
      def initialize(field=nil, legacy=nil, &block)
        @field=field
        @modifier=block || IDENTITY
      end

      def format(d)
        @modifier.call(d.send(@field))
      end
      alias :call :format
    end
  end
end
