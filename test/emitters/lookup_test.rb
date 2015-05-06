class LookupTest < Minitest::Test
  def test_format_month
    e = Stamp::Emitters::Lookup::MONTH

    assert_equal 'January', e.format(dt(1)).to_s
    assert_equal 'February', e.format(dt(2)).to_s
    assert_equal 'March', e.format(dt(3)).to_s
    assert_equal 'December', e.format(dt(12)).to_s
  end

  def test_format_abbr_month
    e = Stamp::Emitters::Lookup::ABBR_MONTH

    assert_equal 'Jan', e.format(dt(1)).to_s
    assert_equal 'Feb', e.format(dt(2)).to_s
    assert_equal 'Mar', e.format(dt(3)).to_s
    assert_equal 'Dec', e.format(dt(12)).to_s
  end

  def test_format_day
    e = Stamp::Emitters::Lookup::DAY

    assert_equal 'Monday', e.format(dt(1, 3)).to_s
    assert_equal 'Tuesday', e.format(dt(1, 4)).to_s
    assert_equal 'Wednesday', e.format(dt(1, 5)).to_s
    assert_equal 'Thursday', e.format(dt(1, 6)).to_s
    assert_equal 'Sunday', e.format(dt(1, 9)).to_s
    assert_equal 'Monday', e.format(dt(1, 10)).to_s
  end

  def test_format_abbr_daynames
    e = Stamp::Emitters::Lookup::ABBR_DAY

    assert_equal 'Mon', e.format(dt(1, 3)).to_s
    assert_equal 'Tue', e.format(dt(1, 4)).to_s
    assert_equal 'Wed', e.format(dt(1, 5)).to_s
    assert_equal 'Thu', e.format(dt(1, 6)).to_s
    assert_equal 'Sun', e.format(dt(1, 9)).to_s
    assert_equal 'Mon', e.format(dt(1, 10)).to_s
  end
end
