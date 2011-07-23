# stamp

Format dates and times based on human-friendly examples, not arcane
strftime directives.

[![Build Status](http://travis-ci.org/jeremyw/stamp.png)](http://travis-ci.org/jeremyw/stamp)

## Installation

Just `gem install stamp`, or add stamp to your Gemfile and `bundle install`.

## Usage

Your Ruby dates and times get a powerful new method: `stamp`.

### Dates

Give `Date#stamp` an example date string with whatever month, day, year,
and weekday parts you'd like, and your date will be formatted accordingly:

```ruby
date = Date.new(2011, 6, 9)
date.stamp("March 1, 1999")         #=> "June  9, 2011"
date.stamp("Jan 1, 1999")           #=> "Jun  9, 2011"
date.stamp("Jan 01")                #=> "Jun 09"
date.stamp("Sunday, May 1, 2000")   #=> "Thursday, June  9, 2011"
date.stamp("Sun Aug 5")             #=> "Thu Jun  9"
date.stamp("12/31/99")              #=> "06/09/11"
date.stamp("DOB: 12/31/2000")       #=> "DOB: 06/09/2011"
```

### Times

`Time#stamp` supports the same kinds of examples as `Date`, but also formats
hours, minutes, and seconds when it sees colon-separated values:

```ruby
time = Time.utc(2011, 6, 9, 20, 52, 30)
time.stamp("3:00 AM")               #=> " 8:52 PM"
time.stamp("01:00:00 AM")           #=> "08:52:30 PM"
time.stamp("23:59")                 #=> "20:52"
time.stamp("23:59:59")              #=> "20:52:30"
time.stamp("Jan 1 at 01:00 AM")     #=> "Jun  9 at 08:52 PM"
```

## Features

* Abbreviated and full names of months and weekdays are recognized.
* Days with or without a leading zero work instinctively.
* Include any extraneous text you'd like, e.g. "DOB:".

### Disambiguation by value

You can use any month, weekday, day, or year value that makes sense in your
examples, and stamp can often infer your intent based on context, but there
may be times that you need to use unambiguous values to make your intent more
explicit.

For example, "01/09" could refer to January 9, September 1, or
January 2009. More explicit examples include "12/31", "31/12", and "12/99".

Using unambiguous values will also help people who read the code in the
future understand your intent.

### Aliases

You might be concerned that the method name "stamp" isn't descriptive enough
for developers reading your code who aren't familiar with this gem. If that's
the case, the following aliases are available:

* `stamp_like`
* `format_like`

### Rails Integration

Stamp makes it easy to configure your application's common date and time
formats in a more self-documenting way with the `strftime_format` method:

```ruby
# config/initializers/time_formats.rb
Date::DATE_FORMATS[:short]    = Stamp.strftime_format("Mon Jan 1")
Time::DATE_FORMATS[:military] = Stamp.strftime_format("23:59")
```

To use your formats:

```ruby
Date.today.to_s(:short)  #=> "Sat Jul 16"
Time.now.to_s(:military)  #=> "15:35"
```

### Limitations

* Time zone support hasn't been implemented. Patches welcome!
* DateTime should inherit stamp behavior from Date, but it hasn't been thoroughly tested. Patches welcome!

### Advanced Usage

If you need more obscure formatting options, you can include any valid
[strftime](http://strfti.me) directives in your example string, and they'll
just be passed along:

```ruby
Date.today.stamp("Week #%U, 1999") #=> "Week #23, 2011"
````

Check out [http://strfti.me](http://strfti.me) for more ideas.

## Contributing to stamp

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Run `bundle install`
* Run `rake` to execute the cucumber specs and make sure they all pass
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Jeremy Weiskotten (@doctorzaius). See LICENSE.txt for
further details.
