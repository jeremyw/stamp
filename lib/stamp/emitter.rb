module Stamp
  class Emitter
    attr_accessor :field

    def initialize(field) ; @field=field ; end
    def format(d) ; d.send(@field) ; end
    def inspect ; "[#{field}]" ; end
    def blank? ; false ; end
  end

  class CompositeEmitter < Emitter
    include Enumerable
    attr_accessor :emitters

    def initialize(emitters=nil)
      super("ce")
      @emitters=[]
      self << emitters if emitters
    end

    def format(d)
      @emitters.map {|e| e.format(d)}.join('')
    end
    alias :call :format

    def <<(emitter)
      if emitter.is_a?(Enumerable)
        emitter.each {|e| self << e }
      elsif ! emitter.is_a?(Emitter)
        raise "not an emitter: #{emitter.nil? ? "nil" : emitter}"
      elsif @emitters.last.is_a?(StringEmitter) && emitter.is_a?(StringEmitter)
        @emitters.last << emitter
      else
        @emitters << emitter unless emitter.blank?
      end
    end

    def each(&block) ; @emitters.each(&block) ; end

    def blank? ; @emitters.empty? ; end

    def inspect
      "ce[#{@emitters.map {|e| e.inspect}.join(",")}]"
    end
  end

  class StringEmitter < Emitter
    attr_accessor :value

    def initialize(value=' ')
      super('string')
      @value=value
    end

    def format(d)
      @value
    end
    alias :call :format

    def <<(other)
      @value << other.value unless other.blank?
    end

    def blank? ; @value.nil? || @value == ''; end

    def inspect ; "[='#{@value}']" ; end
  end

  class NumericEmitter < Emitter
    # @param  [field] the field to be formatted (e.g.: mon, year)
    # @param  [max] the maximum value for this year (e.g.: 100)
    # @param  [formatter] the string formatter for the value (e.g.: 2 => " 5", 2.2 => "05")
    #
    # Examples
    # (:year, 100, "2.2" ) ==> 2 digit year with leading 0
    def initialize(field, max=nil, formatter=nil, non_zero=false)
      super field
      @formatter = formatter
      @max = max
      @non_zero = non_zero
    end

    def format(d)
      value = super(d)
      value = value % @max if @max
      value = @max if value == 0 && non_zero
      value = "%#{@formatter}d" % value if @formatter
      value.to_s
    end
    alias :call :format

    def inspect ; "[#{field},#{ @max ? " < #{@max}" : ""}#{@non_zero ? "+-#{@max}" : ""} #{@formatter}]" ; end
  end

  class LookupEmitter < Emitter
    # @param  [field] the field to be formatted (e.g.: mon, year)
    # @param  [lookup] an array or proc with the string values to be formatted (e.g.: Date::DAYNAMES)
    # @param  [length] the length of the string value (e.g.: 3 => jan)
    # @param  [modifier] a method to call on the final string (e.g.: :upcase, :humanize
    def initialize(field, lookup=nil, length=nil, modifier=nil)
      super(field)
      @lookup = lookup
      @length=length
      @modifier=modifier
    end

    def format(d)
      value = super(d)
      value = lookup(value) if @lookup
      value = value[0, @length] if @length
      @modifier ? value.send(@modifier) : value
    end
    alias :call :format

    def lookup(value)
      @lookup.is_a?(Enumerable) ? @lookup[value] : @lookup.call(value)
    end
    def inspect ; "[#{field}#{@lookup ? "[#{@lookup.first}]" : ""}]#{@length ? "max #{@length}" : ""}#{@modifier ? ".#{@modifier}" : ""}" ; end
  end

  class AmPmEmitter < LookupEmitter
    def initialize(modifier=nil)
      super(:hour, true, nil, modifier)
    end
    def lookup(hour)
      hour < 12 ? "am" : "pm"
    end
    def inspect ; "am" ; end
  end

  class OrdinalEmitter < LookupEmitter
    def initialize(field, modifier=nil)
      super(field, true, nil, modifier)
    end
    def lookup(number)
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
    def inspect ; "#{field}th" ; end
  end
end
