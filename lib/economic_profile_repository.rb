require 'csv'
require_relative 'economic_profile'
require_relative 'format'
require_relative 'economic_profile_parser'

class EconomicProfileRepository
  include Format
  include EconomicProfileParser

  attr_reader :ep_group

  def initialize
    @ep_group = {}
  end

  def load_data(file_tree)
    median_household_income_array = csv_parser_household(file_tree[:economic_profile][:median_household_income], :median_household_income)

    children_in_poverty_array = csv_parser_children(file_tree[:economic_profile][:children_in_poverty], :children_in_poverty)

    free_or_reduced_price_lunch_array = csv_parser_lunch(file_tree[:economic_profile][:free_or_reduced_price_lunch], :free_or_reduced_price_lunch)

    title_i_array = csv_parser_title_i(file_tree[:economic_profile][:title_i], :title_i)

    children_in_poverty_array.unshift(:name=>'COLORADO', :children_in_poverty=>'N/A')
    merge_data(sort_data(median_household_income_array), sort_data(children_in_poverty_array), sort_data(free_or_reduced_price_lunch_array), sort_data(title_i_array))
  end

  def merge_data(median_household_income_array, children_in_poverty_array, free_or_reduced_price_lunch_array, title_i_array)
    economic_profile_info = median_household_income_array.zip(children_in_poverty_array).map do |hash|
         hash.reduce(&:merge)
       end.zip(free_or_reduced_price_lunch_array).map do |hash|
            hash.reduce(&:merge)
         end.zip(title_i_array).map do |hash|
              hash.reduce(&:merge)
            end

    create_economic_profile_object(economic_profile_info)
  end

  def create_economic_profile_object(economic_profile_info)
    economic_profile_info.map do |item|
      economic_profile_object = EconomicProfile.new(item)
      ep_group[item[:name]] = economic_profile_object
    end
  end

  def find_by_name(district_name)
    ep_group[district_name]
  end

end
