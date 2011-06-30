# stamp

Format dates (and times, soon) based on examples, not arcane strftime directives.

[![Build Status](http://travis-ci.org/jeremyw/stamp.png)](http://travis-ci.org/jeremyw/stamp)

## Installation

Just `gem install stamp`, or add stamp to your Gemfile and `bundle install`.

## Usage

Date objects get a powerful new method: #stamp. Provide an example date string
with whatever month, day, year, and weekday parts you'd like, and your date
will be formatted accordingly:

```ruby
date = Date.new(2011, 6, 9)
date.stamp("March 1, 1999")         # "June  9, 2011"
date.stamp("Jan 1, 1999")           # "Jun  9, 2011"
date.stamp("Jan 01")                # "Jun 09"
date.stamp("Sunday, May 1, 2000")   # "Monday, June  9, 2011"
date.stamp("Sun Aug 5")             # "Mon Jun  9"
date.stamp("01/01/99")              # "06/09/11"
date.stamp("DOB: 01/01/2000")       # "DOB: 06/09/2011"
```

### Features

* Abbreviated and full names of months and weekdays are recognized.
* Days with or without a leading zero work instinctively.
* You can use whatever month, weekday, day, or year value makes sense in your
  examples.
* Include any extraneous text you'd like, e.g. "DOB:".

### Limitations

* "01/09/99" is assumed to be January 9, not September 1. Patches to make this
  configurable are welcome. Even better, make it smart enough to disambiguate
  given an example like 31/01/99, where 31 is obviously not a month.
* "01-Jan-1999" doesn't work yet (see @wip cucumber scenario). Patches welcome!
* Support for time formatting by example is coming soon. Patches welcome!

Did I mention? Patches welcome!

If you need more obscure formatting options, you can include any valid
[strftime](http://strfti.me) directives in your example string, and they'll
just be passed along:

```ruby
date.stamp("Week #%U, %Y")         # "Week #23, 2011"
````

[Check out http://strfti.me](http://strfti.me) for more ideas.

More coming soon, including time formats by example.

## Contributing to stamp

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Jeremy Weiskotten (@doctorzaius). See LICENSE.txt for
further details.
