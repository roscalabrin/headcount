require 'pry'
require_relative 'district_repository'
require_relative 'enrollment'

class HeadcountAnalyst

  attr_reader :district_repository

  def initialize(dr)
    @district_repository = dr
  end

  def kindergarten_participation_rate_variation(district_1, state)
    district_1_average = average(district_1.upcase)
    state_average = average(state.fetch(:against).upcase)

    district_1_average/state_average
    # insert truncate method
    # p district_2
      # binding.pry
  end

  def average(dist_or_state)
    participation_rates = district_repository.district_collection.fetch(dist_or_state).enrollment.enrollment_data[:kindergarten_participation].values #an array

    participation_rates.reduce(:+) / participation_rates.length
  end

  # def average_district(district)
  #   district_data = district_repository.find_by_name(district.upcase).enrollment.enrollment_data.fetch(:kindergarten_participation)
  #   district_data.values
  #   total = district_data.values.inject(:+)
  #   total.to_f / district_data.values.length
  # end



  # binding.pry

  #idea = give access to the truncate method to format result


end
