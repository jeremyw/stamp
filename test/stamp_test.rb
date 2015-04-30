require 'test_helper'

class TestStamp < Minitest::Test
  def test_that_it_has_a_version_number
    assert ::Stamp::VERSION > '0.1.0'
  end
end
