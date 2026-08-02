require 'test_helper'

class TestStamp < Minitest::Test
  # September 8, 2011
  DATE_EXAMPLES = {
    'January'                  => 'September',
    'Jan'                      => 'Sep',
    'Jan 1'                    => 'Sep 8',
    'Jan 01'                   => 'Sep 08',
    'Jan 10'                   => 'Sep 08',
    'Jan 1, 1999'              => 'Sep 8, 2011',
    'Jan 12, 1999'             => 'Sep 08, 2011',
    '1 Jan 1999'               => '8 Sep 2011',
    '1/1/1999'                 => '9/8/2011',
    '31/01/2013'               => '08/09/2011',
    '13 January 1999'          => '08 September 2011',
    'Monday'                   => 'Thursday',
    'Tue, Jan 1'               => 'Thu, Sep 8',
    'Tuesday, January 1, 1999' => 'Thursday, September 8, 2011',
    '01/1999'                  => '09/2011',
    '01/01'                    => '09/08',
    '01/31'                    => '09/08',
    '01/99'                    => '09/11',
    '01/01/1999'               => '09/08/2011',
    '12/31/99'                 => '09/08/11',
    '31/12'                    => '08/09',
    '31/12/99'                 => '08/09/11',
    '31-Jan-1999'              => '08-Sep-2011',
    '1999-01-01'               => '2011-09-08',
    '1999-12-31'               => '2011-09-08',
    'DOB: 12-31-1999'          => 'DOB: 09-08-2011'
  }

  # [date, example, expected]
  ORDINAL_EXAMPLES = [
    ['Jan 1, 1999',  'July 4th',          'January 1st'],
    ['Jan 2, 1999',  'Dec 3rd',           'Jan 2nd'],
    ['Jan 3, 1999',  'Dec 2nd',           'Jan 3rd'],
    ['Jan 4, 1999',  'Jul 1st',           'Jan 4th'],
    ['Jan 5, 1999',  'Dec 1st',           'Jan 5th'],
    ['Jan 9, 1999',  'Dec 1st',           'Jan 9th'],
    ['Jan 10, 1999', 'Dec 1st',           'Jan 10th'],
    ['Jan 11, 1999', 'Dec 1st',           'Jan 11th'],
    ['Jan 12, 1999', 'Dec 1st',           'Jan 12th'],
    ['Jan 13, 1999', 'Dec 1st',           'Jan 13th'],
    ['Jan 14, 1999', 'Dec 1st',           'Jan 14th'],
    ['Jan 20, 1999', 'Dec 1st',           'Jan 20th'],
    ['Jan 21, 1999', 'Dec 1st',           'Jan 21st'],
    ['Jan 22, 1999', 'Dec 1st',           'Jan 22nd'],
    ['Jan 23, 1999', 'Dec 1st',           'Jan 23rd'],
    ['Jan 24, 1999', 'Dec 1st',           'Jan 24th'],
    ['Jan 1, 1999',  '4th of July',       '1st of January'],
    ['Jan 1, 1999',  '4th of July, 1999', '1st of January, 1999']
  ]

  # February 8, 2011 at 13:31:27, TZ=EST
  TIME_EXAMPLES = {
    '8:59 am'     => '1:31 pm',
    '8:59am'      => '1:31pm',
    '08:59 AM'    => '01:31 PM',
    '08:59 PM'    => '01:31 PM',
    '23:59'       => '13:31',
    '8:59:59 am'  => '1:31:27 pm',
    '08:59:59 AM' => '01:31:27 PM',
    '08:59:59 PM' => '01:31:27 PM',
    '23:59:59'    => '13:31:27',
    '8:59 PST'    => '1:31 EST'
  }

  # September 8, 2011 at 13:31:27
  DATE_TIME_EXAMPLES = {
    'Jan 1, 1999 8:59 am'             => 'Sep 8, 2011 1:31 pm',
    '08:59 AM 1999-12-31'             => '01:31 PM 2011-09-08',
    'Date: Jan 1, 1999 Time: 8:59 am' => 'Date: Sep 8, 2011 Time: 1:31 pm'
  }

  def test_that_it_has_a_version_number
    assert ::Stamp::VERSION > '0.1.0'
  end

  def test_date_examples
    DATE_EXAMPLES.each do |example, expected|
      assert_equal expected, dt.stamp(example), "example: #{example.inspect}"
    end
  end

  def test_ordinal_examples
    ORDINAL_EXAMPLES.each do |date, example, expected|
      assert_equal expected, Date.parse(date).stamp(example), "example: #{example.inspect}"
    end
  end

  def test_time_examples
    with_tz('EST') do
      time = Time.local(2011, 2, 8, 13, 31, 27)
      TIME_EXAMPLES.each do |example, expected|
        assert_equal expected, time.stamp(example), "example: #{example.inspect}"
      end
    end
  end

  def test_date_time_examples
    with_tz('EST') do
      time = Time.local(2011, 9, 8, 13, 31, 27)
      DATE_TIME_EXAMPLES.each do |example, expected|
        assert_equal expected, time.stamp(example), "example: #{example.inspect}"
      end
    end
  end

  def test_unrecognized_timezone_abbreviation_regression
    # "CAT" was missing from the timezone list due to a typo (BTTCAT)
    assert_equal '20:52 UTC', Time.utc(2011, 6, 9, 20, 52).stamp('23:59 CAT')
  end

  def test_strftime_directives_pass_through
    example = "John Cusack was in a movie about Jan (%-m) %e, %Y, but it wasn't very good."
    expected = "John Cusack was in a movie about Dec (%-m) %e, %Y, but it wasn't very good."
    assert_equal expected, Date.new(2012, 12, 21).stamp(example)
  end

  def test_plain_text_passes_through
    example = 'Marilyn Monroe was born on January 9, 1999.'
    expected = 'Marilyn Monroe was born on June 1, 1926.'
    assert_equal expected, Date.new(1926, 6, 1).stamp(example)
  end

  def test_aliases
    date = Date.new(2011, 12, 9)
    assert_equal '2011-12-09', date.stamp_like('1999-01-31')
    assert_equal '2011-12-09', date.format_like('1999-01-31')
  end

  private

  def with_tz(zone)
    old = ENV['TZ']
    ENV['TZ'] = zone
    yield
  ensure
    ENV['TZ'] = old
  end
end
