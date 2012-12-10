module Stamp
  module Emitters
    class StrftimeEmitter
      # strftime formatter references:
      # https://github.com/jruby/jruby/blob/master/lib/ruby/1.9/date/format.rb
      # https://github.com/rubinius/rubinius/blob/master/vm/util/strftime.c

      DIRECTIVES = {
        '%A' => Stamp::Emitters::Simple.new(:wday,  '%A') { |v| Date::DAYNAMES[v] },          # full weekday name, var length (Sunday..Saturday)
        '%B' => Stamp::Emitters::Simple.new(:month, '%B') { |v| Date::MONTHNAMES[v] },        # full month name, var length
        '%C' => Stamp::Emitters::Simple.new(:year,  '%C') { |v| "%2d" % (v/100).floor },      # century
        '%H' => Stamp::Emitters::Simple.new(:hour,  '%H') { |v| "%2d" % v },                  # hour 24-hour clock
        '%I' => Stamp::Emitters::Simple.new(:hour,  '%I') { |v| "%2.2d" % ((v -1) % 12 +1) }, # hour 12-hour clock with leading zero
        '%M' => Stamp::Emitters::Simple.new(:min,   '%M') { |v| "%2.2d" % v },                # minute
        '%P' => Stamp::Emitters::Simple.new(:hour,  '%P') { |v| v < 12 ? "am" : "pm" },       # am/pm
        '%S' => Stamp::Emitters::Simple.new(:sec,   '%S') { |v| "%2.2d" % v },                # second
        '%Y' => Stamp::Emitters::Simple.new(:year,  '%Y'),                                    # year 4 digit
        '%Z' => Stamp::Emitters::Simple.new(:zone,  '%Z'),                                    # timezone 3 letter (EST)
        '%a' => Stamp::Emitters::Simple.new(:wday,  '%a') { |v| Date::ABBR_DAYNAMES[v] },     # abbreviated weekday name
        '%b' => Stamp::Emitters::Simple.new(:month, '%b') { |v| Date::ABBR_MONTHNAMES[v] },   # abbreviated month name
        '%d' => Stamp::Emitters::Simple.new(:day,   '%d') { |v| "%2.2d" % v },                # day with leading zero
        '%e' => Stamp::Emitters::Simple.new(:day,   '%e') { |v| "%2d" % v },                  # day without leading zero
        '%l' => Stamp::Emitters::Simple.new(:hour,  '%l') { |v| "%2d" % ((v -1) % 12 +1) },   # hour without leading zero (but leading space)
        '%m' => Stamp::Emitters::Simple.new(:month, '%m') { |v| "%2.2d" % v },                # month with leading zero
        '%p' => Stamp::Emitters::Simple.new(:hour,  '%P') { |v| v < 12 ? "AM" : "PM" },       # AM/PM
        '%y' => Stamp::Emitters::Simple.new(:year,  '%y') { |v| "%2.2d" % (v % 100) }         # year 2 digit leading zero
      }

      def initialize(directive)
        @directive = directive
      end

      def format(target)
        target.strftime(@directive)
      end

      def field
        nil
      end

      def self.create(directive)
        DIRECTIVES[directive] || new(directive)
      end
    end
  end
end