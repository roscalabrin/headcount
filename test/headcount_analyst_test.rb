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

#truncate one of the assertions
  def test_kindergarten_participation_against_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0, ha.kindergarten_participation_against_high_school_graduation('EAST YUMA COUNTY RJ-2')
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

  def test_districts_correlate_across_state
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.508, ha.correlation_of_all_districts
  end

  def test_get_hash_method
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal ({2007=>0.39159, 2006=>0.35364, 2005=>0.26709, 2004=>0.30201, 2008=>0.38456, 2009=>0.39, 2010=>0.43628, 2011=>0.489, 2012=>0.47883, 2013=>0.48774, 2014=>0.49022}), ha.get_hash('ACADEMY 20')

    assert_equal ({2007=>0.0, 2006=>0.0, 2005=>0.0, 2004=>0.0, 2008=>0.0, 2009=>0.0, 2010=>0.0, 2011=>0.0, 2012=>0.0, 2013=>0.0, 2014=>0.0}), ha.get_hash('WEST YUMA COUNTY RJ-1')
  end

  def test_that_includes_all_district_names #modify depending on refactor
    skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 181, ha.list_of_all_districts.length
  end

  def test_correlation_across_subset_of_districts
    # skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 1.0, ha.correlation_across_subset_of_districts(['AKRON R-1', 'ASPEN 1', 'BUENA VISTA R-31', 'ACADEMY 20'])
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_subset_of_districts
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(:across => ['AKRON R-1', 'ASPEN 1', 'BUENA VISTA R-31', 'ACADEMY 20'])
  end

end
