require_relative 'test_helper'
require_relative '../lib/enrollment'

class FormatTest < Minitest::Test

  def test_that_kindergarten_participation_numbers_get_truncated
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 'N/A', e.truncate('LNE')
    assert_equal 0.391, e.truncate(0.3915)
    assert_equal 0.391, e.truncate(0.391567)
    assert_equal 0.0, e.truncate(0.0)
    assert_equal 0.0, e.truncate(0)
    assert_equal 0.0, e.truncate('NaN')
    assert_equal 0.390, e.truncate(0.39)
    assert_equal 0.300, e.truncate(0.3)
  end

end
