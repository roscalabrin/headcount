class District
  attr_reader   :name
  attr_accessor :enrollment,
                :statewide_test,
                :economic_profile

  def initialize(district_data, enrollment = nil, statewide_test = nil, economic_profile = nil)
    @name = district_data[:name].upcase
    @enrollment = enrollment
    @statewide_test = statewide_test
    @economic_profile = economic_profile
  end

end
