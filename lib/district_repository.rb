require 'csv'
require 'pry'

class DistrictRepository

  # def initialize
  #
  # end

  def load_data(input)
    file = input[:enrollment][:kindergarten] #calls hash from test hardcoding, which points to the value of the string accepted by CSV.open
    content = CSV.open(file)
  end

  def find_by_name(district_name)
    content = CSV.open "./data/Kindergartners in full-day program.csv", headers: true, header_converters: :symbol

    content.each do |row|

      return district_name.upcase if row[:location].upcase.include?(district_name.upcase)
    end

  end

end
