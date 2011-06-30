# stamp

Format dates and times based on examples, not arcane strftime directives.

[![Build Status](http://travis-ci.org/jeremyw/stamp.png)](http://travis-ci.org/jeremyw/stamp)

## Installation

Just `gem install stamp`, or add stamp to your Gemfile and `bundle install`.

## Usage

```ruby
date = Date.new(2011, 6, 9)
date.stamp("January 1, 1999")       # June 6, 2011
date.stamp("Jan 09, 1999")          # Jun 06, 2011
date.stamp("Jan 1")                 # Jun 6
```

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
