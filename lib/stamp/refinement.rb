require "stamp/core"

module Stamp
  # An alternative to the default Date/Time monkey patches:
  #
  #   require "stamp/refinement"
  #   using Stamp::Refinement
  #
  #   Date.today.stamp("Jan 1, 1999")
  module Refinement
    [Date, Time].each do |klass|
      refine klass do
        def stamp(example)
          Stamp.format(self, example)
        end
        alias_method :stamp_like,  :stamp
        alias_method :format_like, :stamp
      end
    end
  end
end
