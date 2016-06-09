require_relative 'test_helper'
require_relative '../lib/district_repository'
require_relative '../lib/district'

class DistrictRepositoryTest < Minitest::Test

  def test_that_district_repository_exists
   dr = DistrictRepository.new

   assert_instance_of DistrictRepository, dr
  end

  def test_that_it_loads_data_file
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_equal 181, dr.district_collection.length
  end

  def test_that_it_finds_an_existing_district_by_name
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_instance_of District, dr.find_by_name("ACADEMY 20")
    assert_instance_of District, dr.find_by_name("Colorado")
  end

  def test_that_it_finds_an_existing_district_by_name_and_its_case_insensitive
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_instance_of District, dr.find_by_name("AcadeMy 20")
  end

  def test_that_it_returns_nil_if_district_does_not_exist
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_equal nil, dr.find_by_name("whatever")
  end

  def test_find_all_matching_returns_empty_array_if_name_fragment_does_not_match
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_equal [], dr.find_all_matching("whatever")
  end

  def test_find_all_matching_returns_array_if_name_fragment_does_match
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_equal ["AGATE 300", "AGUILAR REORGANIZED 6","ARRIBA-FLAGLER C-20", "EAGLE COUNTY RE 50"], dr.find_all_matching("AG")

    assert_equal ["AGATE 300", "AGUILAR REORGANIZED 6","ARRIBA-FLAGLER C-20", "EAGLE COUNTY RE 50"], dr.find_all_matching("ag")
  end

  def test_it_creates_an_instance_of_enrollment_respository
    dr = DistrictRepository.new

    assert_instance_of EnrollmentRepository, dr.enrollment_repo
  end



end
