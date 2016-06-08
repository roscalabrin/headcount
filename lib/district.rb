class District
  attr_reader :district_data,
              :name

  def initialize(district_data)
    @district_data = district_data
  end

  def name
    district_data[:name].upcase
  end
end
