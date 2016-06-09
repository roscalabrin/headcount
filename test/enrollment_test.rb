require_relative 'test_helper'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_enrollment_exists
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert e
  end

  def test_that_kindergarten_participation_numbers_get_truncated
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.391, e.truncate(0.3915)
    assert_equal 0.391, e.truncate(0.391567)
  end

  def test_kindergarten_participation_by_year_truncated_result
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    result = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}

    assert_equal result, e.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_in_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
    assert_equal 0.353, e.kindergarten_participation_in_year(2011)
    assert_equal 0.267, e.kindergarten_participation_in_year(2012)
  end


end
