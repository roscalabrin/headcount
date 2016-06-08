require './test/test_helper'
require './lib/enrollment_repository'
require './lib/enrollment'

class EnrollmentRepositoryTest < Minitest::Test

  def test_it_finds_instance_of_enrollment_by_name_if_exist
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    enrollment = er.find_by_name("ACADEMY 20")
    # enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})


    assert_instance_of Enrollment, enrollment
  end
end
