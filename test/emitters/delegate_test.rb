class DelegateTest < Minitest::Test
  def test_format_zone
    e = Stamp::Emitters::Delegate::ZONE

    assert_equal 'UTC', e.format(Time.now.utc)
  end

  def test_format_year
    e = Stamp::Emitters::Delegate::YEAR

    assert_equal '1999', e.format(dt(1, 1, 1999)).to_s
    assert_equal '2000', e.format(dt(1, 1, 2000)).to_s
    assert_equal '2001', e.format(dt(1, 1, 2001)).to_s
    assert_equal '2012', e.format(dt(1, 1, 2012)).to_s
  end

  def test_format_month
    e = Stamp::Emitters::Delegate::MONTH

    assert_equal '1', e.format(dt(1)).to_s
    assert_equal '5', e.format(dt(5)).to_s
    assert_equal '11', e.format(dt(11)).to_s
  end

  def test_format_day
    e = Stamp::Emitters::Delegate::DAY

    assert_equal '1', e.format(dt(1, 1)).to_s
    assert_equal '5', e.format(dt(1, 5)).to_s
    assert_equal '11', e.format(dt(1, 11)).to_s
    assert_equal '31', e.format(dt(1, 31)).to_s
  end
end
