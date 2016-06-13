require_relative 'test_helper'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_enrollment_exists
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}})

    assert_instance_of Enrollment, e
  end

  def test_kindergarten_participation_by_year_truncated_result
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}})

    result = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}

    assert_equal result, e.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_in_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}})

    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
    assert_equal 0.353, e.kindergarten_participation_in_year(2011)
    assert_equal 0.267, e.kindergarten_participation_in_year(2012)
    assert_equal nil, e.kindergarten_participation_in_year(2009)
  end

  def test_graduation_rate_by_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}, :high_school_graduation_rates => {2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913,
     2014 => 0.898}})

    result = {2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}

    assert_equal result, e.graduation_rate_by_year
  end

  def test_graduation_rate_in_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}, :high_school_graduation_rates => {2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913,
     2014 => 0.898}})

    assert_equal 0.895, e.graduation_rate_in_year(2010)
    assert_equal 0.895, e.graduation_rate_in_year(2011)
    assert_equal 0.913, e.graduation_rate_in_year(2013)
    assert_equal nil, e.graduation_rate_in_year(2009)
  end

end
