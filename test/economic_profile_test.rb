require_relative '../lib/economic_profile'
require_relative 'test_helper'

class EconomicProfileTest < Minitest::Test

  # def test_economic_profile_basics
  #   data = {:median_household_income => {[2014, 2015] => 50000, [2013, 2014] => 60000},
  #           :children_in_poverty => {2012 => 0.1845},
  #           :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
  #           :title_i => {2015 => 0.543},
  #          }
  #
  #   ep = EconomicProfile.new(data)
  #   assert_equal 50000, ep.median_household_income_in_year(2015)
  #   assert_equal 55000, ep.median_household_income_average
  #   assert_in_delta 0.184, ep.children_in_poverty_in_year(2012), 0.005
  #   assert_equal 0.023, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  #   assert_in_delta 0.023, ep.free_or_reduced_price_lunch_percentage_in_year(2014), 0.005
  #   assert_equal 100, ep.free_or_reduced_price_lunch_number_in_year(2014)
  #   assert_in_delta 0.543, ep.title_i_in_year(2015), 0.005
  # end

  def test_economic_profile_exists
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
        }
    economic_profile = EconomicProfile.new(data)

    assert_instance_of EconomicProfile, economic_profile
  end

  def test_median_household_income_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
    economic_profile = epr.find_by_name('ACADEMY 20')

    assert_equal 85060, economic_profile.median_household_income_in_year(2005)

    assert_equal 87635, economic_profile.median_household_income_in_year(2009)
  end

  def test_median_household_income_average
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
    economic_profile = epr.find_by_name('ACADEMY 20')

    assert_equal 87635, economic_profile.median_household_income_average

    economic_profile = epr.find_by_name('DENVER COUNTY 1')

    assert_equal 47568, economic_profile.median_household_income_average
  end

  def test_children_in_poverty_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
    economic_profile = epr.find_by_name('ACADEMY 20')

    assert_equal 0.064, economic_profile.children_in_poverty_in_year(2012)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

    economic_profile = epr.find_by_name('ADAMS COUNTY 14')

    assert_equal 0.626, economic_profile.free_or_reduced_price_lunch_percentage_in_year(2001)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year_with_invalid_year
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

    economic_profile = epr.find_by_name('BRIGHTON 27')

    assert_raises(UnknownDataError) do
      economic_profile.free_or_reduced_price_lunch_percentage_in_year('2014')
    end
  end

  def test_free_or_reduced_price_lunch_number_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

    economic_profile = epr.find_by_name('AGATE 300')

    assert_equal 30, economic_profile.free_or_reduced_price_lunch_number_in_year(2004)
  end

  def test_free_or_reduced_price_lunch_number_in_year_with_invalid_year
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

    economic_profile = epr.find_by_name('BRIGHTON 27')

    assert_raises(UnknownDataError) do
      economic_profile.free_or_reduced_price_lunch_percentage_in_year('2014')
    end
  end

  def test_title_i_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

    economic_profile = epr.find_by_name('AGATE 300')

    assert_equal 0.178, economic_profile.title_i_in_year(2009)
  end

  def test_ftitle_i_in_year_with_invalid_year
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

    economic_profile = epr.find_by_name('BRIGHTON 27')

    assert_raises(UnknownDataError) do
      economic_profile.title_i_in_year(201)
    end
  end

end
