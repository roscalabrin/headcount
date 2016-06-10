require_relative 'test_helper'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_that_it_loads_data_file
    # skip
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})

    assert_equal 181, er.enrollment_collection.length
  end

  def test_it_finds_instance_of_enrollment_by_name_if_exist
    # skip
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    enrollment = er.find_by_name("ACADEMY 20")

    assert_instance_of Enrollment, enrollment
  end

  def test_it_returns_the_name_of_the_district
    # skip
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    enrollment = er.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", enrollment.name
  end

  def test_that_it_loads_data_file_with_two_paths

    er = EnrollmentRepository.new
    er.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})

    assert_equal 181, er.enrollment_collection.length
  end




end
