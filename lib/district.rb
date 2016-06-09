require 'pry'
require_relative 'district_repository'

class District
  attr_reader :district_data,
              :name,
              :enrollment

  def initialize(district_data)
    @district_data = district_data
    @enrollment
  end

  def name
    district_data[:name].upcase
    # binding.pry
  end

  def enrollment
    DistrictRepository.find_enrollment(name)
  end

end
