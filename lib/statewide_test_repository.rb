require 'pry'
require 'csv'
require_relative 'statewide_test'
require_relative 'statewide_test_parser'

class StatewideTestRepository
  include Format
  include StatewideTestParser

  attr_reader :statewide_test_collection

  def initialize
    @statewide_test_collection = {}
  end

  def load_data(file_tree)
   third_grade_array = csv_parser(file_tree[:statewide_testing][:third_grade], :score, 3)
   eighth_grade_array = csv_parser(file_tree[:statewide_testing][:eighth_grade], :score, 8)
   math_array = csv_parser(file_tree[:statewide_testing][:math], :race_ethnicity, :math)
   reading_array = csv_parser(file_tree[:statewide_testing][:reading], :race_ethnicity, :reading)
   writing_array = csv_parser(file_tree[:statewide_testing][:writing], :race_ethnicity, :writing)

  merge_data(third_grade_array, eighth_grade_array, math_array, reading_array, writing_array)
  binding.pry
  end

  def merge_data(third_grade_array, eighth_grade_array, math_array, reading_array, writing_array)
  statewide_info = third_grade_array.zip(eighth_grade_array).map do |hash|
       hash.reduce(&:merge)
    end.zip(math_array).map do |hash|
         hash.reduce(&:merge)
      end.zip(reading_array).map do |hash|
           hash.reduce(&:merge)
         end.zip(writing_array).map do |hash|
              hash.reduce(&:merge)
            end
     create_statewide_object(statewide_info)
  end

  def create_statewide_object(statewide_info)
    statewide_info.map do |item|
      statewide_object = StatewideTest.new(item)
      statewide_test_collection[item[:name]] = statewide_object
    end
  end

  def find_by_name(district_name)
    statewide_test_collection[district_name]
  end

end
