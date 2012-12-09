# stamp

Format dates and times based on human-friendly examples, not arcane
[strftime](http://strfti.me) directives.

[![Build Status](https://secure.travis-ci.org/jeremyw/stamp.png)](http://travis-ci.org/jeremyw/stamp)

## Installation

Just `gem install stamp`, or add stamp to your Gemfile and `bundle install`.

## Usage

Your Ruby dates and times get a powerful new method: `stamp`.

You might be concerned that "stamp" isn't descriptive enough for developers
reading your code who aren't familiar with this gem. If that's the case, the
following aliases are provided:

* `stamp_like`
* `format_like`

### Dates

Give `Date#stamp` an example date string with whatever month, day, year,
and weekday parts you'd like, and your date will be formatted accordingly:

```ruby
date = Date.new(2011, 6, 9)
date.stamp("March 1, 1999")         #=> "June 9, 2011"
date.stamp("Jan 1, 1999")           #=> "Jun 9, 2011"
date.stamp("Jan 01")                #=> "Jun 09"
date.stamp("Sunday, May 1, 2000")   #=> "Thursday, June 9, 2011"
date.stamp("Sun Aug 5")             #=> "Thu Jun 9"
date.stamp("12/31/99")              #=> "06/09/11"
date.stamp("DOB: 12/31/2000")       #=> "DOB: 06/09/2011"
```

It even formats ordinal days!

```ruby
date.stamp("November 5th")          #=> "June 9th"
date.stamp("1st of Jan")            #=> "9th of Jun"
```

### Times

`Time#stamp` supports the same kinds of examples as `Date`, but also formats
hours, minutes, and seconds when it sees colon-separated values.

```ruby
time = Time.utc(2011, 6, 9, 20, 52, 30)
time.stamp("3:00 AM")               #=> "8:52 PM"
time.stamp("01:00:00 AM")           #=> "08:52:30 PM"
time.stamp("23:59")                 #=> "20:52"
time.stamp("23:59:59")              #=> "20:52:30"
time.stamp("Jan 1 at 01:00 AM")     #=> "Jun 9 at 08:52 PM"
time.stamp("23:59 UTC")             #=> "20:52 PST"
```

## Features

* Abbreviated and full names of months and weekdays are recognized.
* Days with or without a leading zero work instinctively.
* Standard time zone abbreviations are recognized; e.g. "UTC", "PST", "EST".
* Include any extraneous text you'd like; e.g. "DOB:".

### Disambiguation by value

You can use any month, weekday, day, or year value that makes sense in your
examples, and stamp can often infer your intent based on context, but there
may be times that you need to use unambiguous values to make your intent more
explicit.

For example, "01/09" could refer to January 9, September 1, or
January 2009. More explicit examples include "12/31", "31/12", and "12/99".

Using unambiguous values will also help people who read the code in the
future, including yourself, understand your intent.

### Rails Integration

Stamp makes it easy to configure your Rails application's common date and time
formats in a more self-documenting way with `DATE_FORMATS`:

```ruby
# config/initializers/date_formats.rb
Date::DATE_FORMATS[:short]    = Proc.new { |date| date.stamp("Sun Jan 5") }
Time::DATE_FORMATS[:military] = Proc.new { |time| time.stamp("5 January 23:59") }
```

To use your formats:

```ruby
Date.today.to_s(:short)   #=> "Sat Jul 16"
Time.now.to_s(:military)  #=> "16 July 15:35"
```

### Limitations

* `DateTime` should inherit stamp behavior from `Date`, but it hasn't been thoroughly tested. Patches welcome!

## Copyright

Copyright (c) 2011 Jeremy Weiskotten (@doctorzaius). See LICENSE.txt for
further details.
