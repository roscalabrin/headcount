class District
  attr_reader   :name
  attr_accessor :enrollment,
                :statewide_test,
                :economic_profile

  def initialize(district_data, enroll= nil, statewide= nil, economic = nil)
    @name = district_data[:name].upcase
    @enrollment = enroll
    @statewide_test = statewide
    @economic_profile = economic
  end

end
