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
    skip
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
        }
    economic_profile = EconomicProfile.new(data)

    assert_equal 50000, economic_profile.median_household_income_in_year(2005)
    assert_equal 50000, economic_profile.median_household_income_in_year(2009)
  end

end
