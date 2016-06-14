require_relative '../lib/economic_profile'
require_relative 'test_helper'

class EconomicProfileTest < Minitest::Test

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
    #fix for for when the year in found in more than one key

    # assert_equal 50000, economic_profile.median_household_income_in_year(2009)
  end

  def test_median_household_income_average
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
    economic_profile = epr.find_by_name('ACADEMY 20')

    assert_equal 85060, economic_profile.economic_profile.median_household_income_average
  end

end
