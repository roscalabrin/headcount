require_relative 'test_helper'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def test_that_district_repository_exists
   dr = DistrictRepository.new
   ha = HeadcountAnalyst.new(dr)

   assert_instance_of HeadcountAnalyst, ha
  end

  def test_kindergarten_participation_rate_variation_against_state
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal nil, ha.kindergarten_participation_rate_variation('NEW YORK', :against => 'COLORADO')
    assert_equal nil, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'NEW YORK')
  end

  def test_kindergarten_participation_rate_variation_against_another_district
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.447, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    assert_equal nil, ha.kindergarten_participation_rate_variation('NEW YORK', :against => 'YUMA SCHOOL DISTRICT 1')
  end

  def test_high_school_graduation_rate_variation_district_against_state
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 1.195, ha.high_school_graduation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal nil, ha.high_school_graduation_rate_variation('PLACE', :against => 'COLORADO')
    assert_equal nil, ha.high_school_graduation_rate_variation('ACADEMY 20', :against => 'NOT COLORADO')
  end

  def test_kindergarten_participation_rate_variation_trend
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.447, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    assert_equal nil, ha.kindergarten_participation_rate_variation('NEW YORK', :against => 'YUMA SCHOOL DISTRICT 1')
    assert_equal nil, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'NEW YORK')
  end

  def test_that_it_calculates_participation_rate_average
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.4064509090909091, ha.average('ACADEMY 20', :kindergarten_participation)
  end

  def test_kindergarten_participation_rate_variation_trend_method
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal ({2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661}), ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_against_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
    assert_equal nil, ha.kindergarten_participation_against_high_school_graduation('NEW YORK')
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert ha.kindergarten_participation_correlates_with_high_school_graduation('ACADEMY 20')
    refute ha.kindergarten_participation_correlates_with_high_school_graduation('NEW YORK')
  end

  def test_get_hash_method
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal ({2007=>0.39159, 2006=>0.35364, 2005=>0.26709, 2004=>0.30201, 2008=>0.38456, 2009=>0.39, 2010=>0.43628, 2011=>0.489, 2012=>0.47883, 2013=>0.48774, 2014=>0.49022}), ha.get_hash('ACADEMY 20')
  end

  # def test_that_includes_all_district_names
  #   dr = DistrictRepository.new
  #   dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
  #   ha = HeadcountAnalyst.new(dr)
  #
  #   assert_equal 181, ha.list_of_all_districts.length
  # end

  def test_check_hash_syntax_in_argument #may end up deleting
    skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal "STATEWIDE", ha.check_for_statewide_as_argument(:for => 'STATEWIDE')
    assert_equal "ACADEMY 20", ha.check_for_statewide_as_argument(for: 'ACADEMY 20')
  end

  def test_check_something #may end up deleting
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    # assert_equal "STATEWIDE", ha.check_for_statewide_as_argument(:for => 'STATEWIDE')
    # assert_equal "ACADEMY 20", ha.check_for_statewide_as_argument(for: 'ACADEMY 20')
    assert_equal "test", ha.kindergarten_participation_correlates_with_high_school_graduation(for: "STATEWIDE")
  end

end
