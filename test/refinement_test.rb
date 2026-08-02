require 'test_helper'
require 'stamp/refinement'

using Stamp::Refinement

class RefinementTest < Minitest::Test
  def test_refined_date_and_time
    assert_equal 'Dec 21, 2012', Date.new(2012, 12, 21).stamp('Jan 1, 1999')
    assert_equal '20:52', Time.utc(2011, 6, 9, 20, 52).stamp('23:59')
  end

  def test_refined_aliases
    date = Date.new(2012, 12, 21)
    assert_equal 'Dec 21, 2012', date.stamp_like('Jan 1, 1999')
    assert_equal 'Dec 21, 2012', date.format_like('Jan 1, 1999')
  end

  def test_requiring_only_the_refinement_does_not_patch_core_classes
    code = 'require "stamp/refinement"; exit(Date.new(2020, 1, 1).respond_to?(:stamp) ? 1 : 0)'
    assert system(RbConfig.ruby, '-Ilib', '-e', code),
      'requiring stamp/refinement alone should not add Date#stamp'
  end
end
