class District
  attr_reader   :name
  attr_accessor :enrollment,
                :statewide_test

  def initialize(district_data, enrollment = nil, statewide_test = nil)
    @name = district_data[:name].upcase
    @enrollment = enrollment
    @statewide_test = statewide_test
  end

end
