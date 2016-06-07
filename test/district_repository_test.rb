require './test/test_helper'
require './lib/district_repository'
require './lib/district'

class DistrictRepositoryTest < Minitest::Test

  # find_all_matching - returns either [] or one or more matches which contain the supplied name fragment, case insensitive

  def test_that_district_repository_exists
   dr = DistrictRepository.new

   assert DistrictRepository
  end

  def test_that_it_loads_data_file
    dr = DistrictRepository.new
    content = dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert CSV, content.class
  end

  def test_that_it_finds_an_existing_district_by_name
    dr = DistrictRepository.new

    assert_equal "ACADEMY 20", dr.find_by_name("ACADEMY 20")
  end

  def test_that_it_returns_nil_if_district_does_not_exist
    dr = DistrictRepository.new

    assert_equal nil, dr.find_by_name("whatever")
  end

  # def test_find_all_matching
  #
  # end



  # dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})



end
