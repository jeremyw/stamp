require 'minitest/autorun'
require 'stamp'

class TranslatorTest < MiniTest::Unit::TestCase
  def test_hour_to_12_hour
    t = ::Stamp::StrftimeTranslator::HOUR_TO_12_HOUR

    assert_equal 12, t.call(0)
    assert_equal 5, t.call(5)
    assert_equal 12, t.call(12)
    assert_equal 5, t.call(17)
    assert_equal 12, t.call(24)
  end
end