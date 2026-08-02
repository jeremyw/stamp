require "date"
require "time"

require "stamp/emitters/am_pm"
require "stamp/emitters/ambiguous"
require "stamp/emitters/composite"
require "stamp/emitters/delegate"
require "stamp/emitters/lookup"
require "stamp/emitters/ordinal"
require "stamp/emitters/string"
require "stamp/emitters/twelve_hour"
require "stamp/emitters/two_digit"
require "stamp/emitters/utc_offset"
require "stamp/disambiguator"
require "stamp/translator"
require "stamp/version"

module Stamp
  # Formats a date/time using a human-friendly example as a template,
  # without monkey patching Date or Time.
  #
  # @param [Date|Time|DateTime] target the date/time to format
  # @param [String] example a human-friendly date/time example
  #
  # @return [String] the formatted date or time
  #
  # @example
  #   Stamp.format(Date.new(2012, 12, 21), "Jan 1, 1999") #=> "Dec 21, 2012"
  def self.format(target, example)
    emitters(example).format(target)
  rescue NoMethodError => e
    raise e if target.respond_to?(e.name)
    raise ArgumentError,
      "#{example.inspect} requires ##{e.name}, which #{target.class} doesn't implement (e.g. a Date can't format time-of-day examples)"
  end

  # Translates a human-friendly example into a strftime format string.
  #
  # @param [String] example a human-friendly date/time example
  #
  # @return [String] the equivalent strftime format
  #
  # @raise [ArgumentError] if the example uses a feature strftime can't
  #   express (e.g. ordinal days like "1st")
  #
  # @example
  #   Stamp.strftime_format("Jan 1, 1999") #=> "%b %-d, %Y"
  def self.strftime_format(example)
    emitters(example).strftime_format
  end

  # Memoizes the emitters for each example to improve performance.
  def self.emitters(example)
    cache = (@emitters ||= {})
    cache.clear if cache.size >= 1000 # ponytail: crude cap to bound memory; LRU if it ever matters
    cache[example] ||= Disambiguator.new(Translator.new.translate(example)).disambiguate!
  end
  private_class_method :emitters

  # Formats a date/time using a human-friendly example as a template.
  #
  # @param [String] example a human-friendly date/time example
  #
  # @return [String] the formatted date or time
  #
  # @example
  #   Date.new(2012, 12, 21).stamp("Jan 1, 1999") #=> "Dec 21, 2012"
  def stamp(example)
    Stamp.format(self, example)
  end
  alias :stamp_like  :stamp
  alias :format_like :stamp
end
