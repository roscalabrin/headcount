require 'pry'
require 'csv'
require_relative 'economic_profile'
# require_relative 'economic_profile_parser'

class EconomicProfileRepository
  # include Format
  # include EconomicProfileParser

  attr_reader :economic_profile_collection

  def initialize
    @economic_profile_collection = {}
  end

  def load_data(file_tree)

    # def csv_parser(filepath, argument, key)
    #  statewide_test_array = []
    #  CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
    #    statewide_test_array <<
    #    ({:name => row[:location].upcase, :year => row[:timeframe].to_i, row[argument].to_s.downcase => truncate(row[:data].to_f)})
    #  end
    #  group_data(statewide_test_array, key)
    # end

    median_household_income_array = csv_parser(file_tree[:economic_profile][:median_household_income], :score, 3)
    eighth_grade_array = csv_parser(file_tree[:statewide_testing][:eighth_grade], :score, 8)
    math_array = csv_parser(file_tree[:statewide_testing][:math], :race_ethnicity, :math)
    reading_array = csv_parser(file_tree[:statewide_testing][:reading], :race_ethnicity, :reading)
    writing_array = csv_parser(file_tree[:statewide_testing][:writing], :race_ethnicity, :writing)
  end

end
