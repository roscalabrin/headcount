require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  # method find_by_name returns nil or an instance of district having done a case insensitive search

  # find_all_matching - returns either [] or one or more matches which contain the supplied name fragment, case insensitive

  def test_that_district_repository_exists
   dr = DistrictRepository.new

   assert DistrictRepository
  end
#
  def test_that_it_loads_data_file
    dr = DistrictRepository.new
    content = dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert CSV, content.class
  end




  # dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})



end
