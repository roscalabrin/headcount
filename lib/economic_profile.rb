class EconomicProfile

  def initialize(economic_profile_data)
    @name = economic_profile_data[:name].upcase
    @economic_profile_data = economic_profile_data
  end

end
