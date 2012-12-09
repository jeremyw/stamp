module Modifiable
  def modify(value)
    if @modifier
      @modifier.call(value)
    else
      value
    end
  end
end