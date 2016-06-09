require 'pry'
require_relative 'district_repository'
require_relative 'enrollment'

class HeadcountAnalyst

  attr_reader :district_repository

  def initialize(dr)
    @district_repository = dr
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    district_1 = average_district(district_1)
    district_2 = average_district(district_2.fetch(:against).upcase)

    p district_1/district_2
    # p district_2
      # binding.pry
  end

  def average_district(district)
    district_data = district_repository.find_by_name(district.upcase).enrollment.enrollment_data.fetch(:kindergarten_participation)
    district_data.values
    total = district_data.values.inject(:+)
    total.to_f / district_data.values.length
  end



  # binding.pry

  #idea = give access to the truncate method to format result


end
