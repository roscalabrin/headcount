class District
  attr_reader   :name
  attr_accessor :enrollment

  def initialize(district_data)
    @district_data = district_data
    @enrollment = 0
  end

  def name
    @district_data[:name].upcase
  end

end
