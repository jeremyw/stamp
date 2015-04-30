$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'stamp'

require 'minitest/autorun'

module DateCreators
  def month(month_name)
    if month_name.is_a?(String)
      Date::MONTHNAMES.index(month_name) || Date::ABBR_MONTHNAMES.index(month_name)
    else
      month_name
    end
  end

  def dt(month_name = 'September', day = '8', year = 2011)
    Date.new(year.to_i, month(month_name), day.to_i)
  end

  def tm(hours = 13, minutes = 31, seconds = 27, month_name = 'September', day = '8', year = 2011)
    Time.local(year.to_i, month(month_name), day.to_i, hours.to_i, minutes.to_i, seconds.to_i)
  end
end

module Minitest
  class Test
    include DateCreators
  end
end
