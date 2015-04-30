require 'test_helper'

class AmPmTest < Minitest::Test
  def test_format_lowercase
    e = Stamp::Emitters::AmPm::LOWERCASE
    assert_equal 'am', e.format(tm(0))
    assert_equal 'am', e.format(tm(1))
    assert_equal 'am', e.format(tm(11))
    assert_equal 'pm', e.format(tm(12))
    assert_equal 'pm', e.format(tm(13))
    assert_equal 'pm', e.format(tm(23))
  end

  def test_format_uppercase
    e = Stamp::Emitters::AmPm::UPPERCASE
    assert_equal 'AM', e.format(tm(1))
    assert_equal 'AM', e.format(tm(11))
    assert_equal 'PM', e.format(tm(12))
    assert_equal 'PM', e.format(tm(13))
    assert_equal 'PM', e.format(tm(23))
  end

  def test_field
    assert_nil Stamp::Emitters::AmPm::UPPERCASE.field
  end
end
