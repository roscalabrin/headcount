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
    median_household_income_array = csv_parser_household(file_tree[:economic_profile][:median_household_income])

    children_in_poverty_array = csv_parser_children(file_tree[:economic_profile][:children_in_poverty])

    free_or_reduced_price_lunch_array= csv_parser_lunch(file_tree[:economic_profile][:free_or_reduced_price_lunch], :poverty_level)

    # title_i_array = csv_parser(file_tree[:economic_profile][:title_i])
    #
  end

end
