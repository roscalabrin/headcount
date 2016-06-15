require 'pry'
require_relative 'format'
require_relative 'economic_profile_repository'
require_relative 'custom_errors'

class EconomicProfile
  include Format

  attr_reader :economic_profile_data,
              :name

  def initialize(economic_profile_data)
    @name = economic_profile_data[:name].upcase
    @economic_profile_data = economic_profile_data
  end

 def median_household_income_in_year(year)
   valid_year?(year)
   year_ranges = economic_profile_data[:median_household_income].keys.map do |key|
     (key[0]..key[1])
   end.select {|key_array| key_array.include?(year)}

   result = year_ranges.map do |interval|
     economic_profile_data[:median_household_income][[interval.begin, interval.end].flatten]
   end
   result.reduce(:+)/result.size
 end

 def median_household_income_average
   sum = economic_profile_data[:median_household_income].values.reduce(:+)
   data_count = economic_profile_data[:median_household_income].values.length
   sum/data_count
 end

 def children_in_poverty_in_year(year)
  #  binding.pry
  economic_profile_data[:children_in_poverty][year]
 end

 def free_or_reduced_price_lunch_percentage_in_year(year)
   valid_year?(year)
   query_free_or_reduced_price_lunch_data(year, :percentage)
 end

 def free_or_reduced_price_lunch_number_in_year(year)
   valid_year?(year)
   query_free_or_reduced_price_lunch_data(year, :number).to_i
 end

 def query_free_or_reduced_price_lunch_data(year, data_type)
   economic_profile_data[:free_or_reduced_price_lunch].select do |hash|
     hash[:year] == year
   end[0][data_type]
 end

 def title_i_in_year(year)
   valid_year?(year)
   economic_profile_data[:title_i][year]
 end

end
