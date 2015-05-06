require 'test_helper'

class OrdinalTest < Minitest::Test
  def test_format_day
    e = Stamp::Emitters::Ordinal::DAY

    assert_equal '1st', e.format(dt(1, 1)).to_s
    assert_equal '2nd', e.format(dt(1, 2)).to_s
    assert_equal '3rd', e.format(dt(1, 3)).to_s
    assert_equal '4th', e.format(dt(1, 4)).to_s
    assert_equal '5th', e.format(dt(1, 5)).to_s
    assert_equal '9th', e.format(dt(1, 9)).to_s
    assert_equal '10th', e.format(dt(1, 10)).to_s
    assert_equal '11th', e.format(dt(1, 11)).to_s
    assert_equal '12th', e.format(dt(1, 12)).to_s
    assert_equal '13th', e.format(dt(1, 13)).to_s
    assert_equal '14th', e.format(dt(1, 14)).to_s
    assert_equal '20th', e.format(dt(1, 20)).to_s
    assert_equal '21st', e.format(dt(1, 21)).to_s
    assert_equal '22nd', e.format(dt(1, 22)).to_s
    assert_equal '23rd', e.format(dt(1, 23)).to_s
    assert_equal '24th', e.format(dt(1, 24)).to_s
    assert_equal '31st', e.format(dt(1, 31)).to_s
  end
end
