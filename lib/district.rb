class District
  attr_reader   :name,
                :enrollment

  def initialize(district_data, enrollment = nil)
    @name = district_data[:name].upcase
    @enrollment = enrollment
  end

end
