require "date"
require "time"

require "stamp/translator"
require "stamp/version"

module Stamp

  # Transforms the given example dates/time format to a format string
  # suitable for strftime.
  #
  # @param  [String] example a human-friendly date/time example
  # @param  [#strftime] the Date or Time to be formatted. Optional, but may
  #                     be used to support certain edge cases
  # @return [String] a strftime-friendly format
  #
  # @example
  #   Stamp.strftime_format("Jan 1, 1999") #=> "%b %e, %Y"
  def self.strftime_format(example, target=nil)
    Stamp::StrftimeTranslator.new(target).translate(example)
  end

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

  # Transforms the given example date/time format to a format string
  # suitable for strftime.
  #
  # @param  [String] example a human-friendly date/time example
  # @return [String] a strftime-friendly format
  #
  # @example
  #   Date.today.strftime_format("Jan 1, 1999") #=> "%b %e, %Y"
  def strftime_format(example)
    # delegate to the class method, providing self as a target value to
    # support certain edge cases
    Stamp.strftime_format(example, self)
  end

end

Date.send(:include, ::Stamp)
Time.send(:include, ::Stamp)
