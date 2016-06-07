require 'csv'

class DistrictRepository

  # def initialize
  #
  # end

  def load_data(input)
    file = input[:enrollment][:kindergarten]
    content = CSV.open(file)
  end

end
