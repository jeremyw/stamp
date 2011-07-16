require "stamp/translator"
require "stamp/version"
require "date"
require "time"

module Stamp
  # Formats a date/time using a human-friendly example as a template.
  #
  # @param  [String] example a human-friendly date/time example
  # @return [String] the formatted date or time
  #
  # @example
  #   Date.new(2012, 12, 21).stamp("Jan 1, 1999") #=> "Dec 21, 2012"
  def stamp(example)
    strftime(strftime_format(example))
  end
  alias :stamp_like  :stamp
  alias :format_like :stamp

  # Transforms the given string with example dates/times to a format string
  # suitable for strftime.
  #
  # @param  [String] example a human-friendly date/time example
  # @return [String] a strftime-friendly format
  #
  # @example
  #   Date.today.strftime_format("Jan 1, 1999") #=> "%b %e, %Y"
  def strftime_format(example)
    Stamp::StrftimeTranslator.new(self).translate(example)
  end
end


Date.send(:include, ::Stamp)
Time.send(:include, ::Stamp)
