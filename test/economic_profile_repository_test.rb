require_relative '../lib/economic_profile_repository'
require_relative 'test_helper'

class EconomicProfileRepositoryTest < Minitest::Test

  def test_that_it_loads_all_files
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

    assert_equal 181, epr.economic_profile_collection.length
  end

  def test_it_finds_instance_of_economic_profile_by_name
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

    assert_instance_of EconomicProfile, economic_profile
  end



end
