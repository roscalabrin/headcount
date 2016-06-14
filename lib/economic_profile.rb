require 'pry'
require_relative 'format'
require_relative 'economic_profile_repository'

class EconomicProfile
  include Format

  attr_reader :economic_profile_data,
              :name

  def initialize(economic_profile_data)
    @name = economic_profile_data[:name].upcase
    @economic_profile_data = economic_profile_data
  end

end
