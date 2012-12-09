require "date"
require "time"

require "stamp/emitters/am_pm_emitter"
require "stamp/emitters/composite_emitter"
require "stamp/emitters/delegate_emitter"
require "stamp/emitters/lookup_emitter"
require "stamp/emitters/numeric_emitter"
require "stamp/emitters/ordinal_emitter"
require "stamp/emitters/strftime_emitter"
require "stamp/emitters/string_emitter"
require "stamp/translator"
require "stamp/version"

module Stamp

  # Transforms the given example date/time format to a proc that
  # will render the date. This is suitable for Rails initializers.
  #
  # @example
  #   Date::DATE_FORMATS[:short] = Stamp.strftime_proc("Mon Jan 1")
  def self.strftime_proc(example,target=nil)
    Stamp::StrftimeTranslator.new.translate(example)
  end

  class << self
    alias :strftime_format :strftime_proc
  end

  # Formats a date/time using a human-friendly example as a template.
  #
  # @param  [String] example a human-friendly date/time example
  # @return [String] the formatted date or time
  #
  # @example
  #   Date.new(2012, 12, 21).stamp("Jan 1, 1999") #=> "Dec 21, 2012"
  def stamp(example)
    Stamp.strftime_proc(example).call(self)
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
  #   Date.today.strftime_format("Jan 1, 1999") #=> Proc.new {|date| date.strftime("%b %e, %Y") }
  def strftime_format(example)
    # delegate to the class method, providing self as a target value to
    # support certain edge cases
    Stamp.strftime_format(example)
  end
end

Date.send(:include, ::Stamp)
Time.send(:include, ::Stamp)
