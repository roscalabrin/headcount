require 'pry'
require 'csv'
# require_relative 'statewide_test'
require_relative 'parser2'

class StatewideTestRepository
  include Format
  include Parser2

  attr_reader :statetwide_test_collection

  def initialize
    @statewide_test_collection = {}
  end

  def load_data(file_tree)
  #  filepath = file_tree[:statewide_testing][:thrid_grade]

   third_grade_array = csv_parser(file_tree[:statewide_testing][:third_grade], :third_grade)

  #  eight_grade_array = csv_parser(file_tree[:statewide_testing][:eight_grade], :eight_grade)
  #  math_array = csv_parser(filepath, :math)
  #  reading_array = csv_parser(filepath, :reading)
  #  writing_array = csv_parser(filepath, :writing)
  #  binding.pry
  #  merge_data(kindergarten_array, high_school_array)
  end


  # def merge_data(kindergarten_array, high_school_array)
  #   enrollment_info = kindergarten_array.zip(high_school_array).map do |kindergarten_array|
  #     kindergarten_array.reduce(&:merge)
  #   end
  #   create_statewide_object(enrollment_info)
  # end

  # def create_statewide_object(statewide_info)
  #   statewide_info.map do |item|
  #     statewide_object = StatewideTest.new(item)
  #     state_wide_test_collection[item[:name]] = statewide_object
  #   end
  # end
  #
  def find_by_name(district_name)
    statewide_test_collection[district_name]
  end

end
