require 'test_helper'

class TwoDigitTest < Minitest::Test
  def test_format_year
    e = Stamp::Emitters::TwoDigit::YEAR

    assert_equal '99', e.format(dt(1, 1, 1999)).to_s
    assert_equal '00', e.format(dt(1, 1, 2000)).to_s
    assert_equal '01', e.format(dt(1, 1, 2001)).to_s
    assert_equal '12', e.format(dt(1, 1, 2012)).to_s
  end

  def test_format_month
    e = Stamp::Emitters::TwoDigit::MONTH

    assert_equal '01', e.format(dt(1)).to_s
    assert_equal '09', e.format(dt(9)).to_s
    assert_equal '11', e.format(dt(11)).to_s
  end

  def test_format_day
    e = Stamp::Emitters::TwoDigit::DAY

    assert_equal '01', e.format(dt(1, 1)).to_s
    assert_equal '09', e.format(dt(1, 9)).to_s
    assert_equal '11', e.format(dt(1, 11)).to_s
    assert_equal '31', e.format(dt(1, 31)).to_s
  end

  def test_format_day
    e = Stamp::Emitters::TwoDigit::DAY

    assert_equal '01', e.format(dt(1, 1)).to_s
    assert_equal '09', e.format(dt(1, 9)).to_s
    assert_equal '11', e.format(dt(1, 11)).to_s
    assert_equal '31', e.format(dt(1, 31)).to_s
  end

  def test_format_hour
    e = Stamp::Emitters::TwoDigit::HOUR

    assert_equal '00', e.format(tm(0)).to_s
    assert_equal '01', e.format(tm(1)).to_s
    assert_equal '09', e.format(tm(9)).to_s
    assert_equal '11', e.format(tm(11)).to_s
    assert_equal '23', e.format(tm(23)).to_s
  end

  def test_format_min
    e = Stamp::Emitters::TwoDigit::MIN

    assert_equal '00', e.format(tm(1, 0)).to_s
    assert_equal '01', e.format(tm(1, 1)).to_s
    assert_equal '09', e.format(tm(1, 9)).to_s
    assert_equal '11', e.format(tm(1, 11)).to_s
    assert_equal '23', e.format(tm(1, 23)).to_s
  end

  def test_format_sec
    e = Stamp::Emitters::TwoDigit::SEC

    assert_equal '00', e.format(tm(0, 0, 0)).to_s
    assert_equal '01', e.format(tm(0, 0, 1)).to_s
    assert_equal '09', e.format(tm(0, 0, 9)).to_s
    assert_equal '11', e.format(tm(0, 0, 11)).to_s
    assert_equal '59', e.format(tm(0, 0, 59)).to_s
  end
end
