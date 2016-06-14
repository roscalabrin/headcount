require 'pry'
require 'csv'
require_relative 'economic_profile'
require_relative 'format'
require_relative 'economic_profile_parser'

class EconomicProfileRepository
  include Format
  include EconomicProfileParser

  attr_reader :economic_profile_collection

  def initialize
    @economic_profile_collection = {}
  end

  def load_data(file_tree)
    median_household_income_array = csv_parser_household(file_tree[:economic_profile][:median_household_income], :median_household_income)

    children_in_poverty_array = csv_parser_children(file_tree[:economic_profile][:children_in_poverty], :children_in_poverty)

    free_or_reduced_price_lunch_array = csv_parser_lunch(file_tree[:economic_profile][:free_or_reduced_price_lunch], :free_or_reduced_price_lunch)

    title_i_array = csv_parser_title_i(file_tree[:economic_profile][:title_i], :title_i)

      # merge_data(third_grade_array, eighth_grade_array, math_array, reading_array, writing_array)
      binding.pry
  end

end
