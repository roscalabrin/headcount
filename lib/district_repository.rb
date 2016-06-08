require 'csv'
require 'pry'

class DistrictRepository
  attr_reader :district_collection

  def initialize
    @district_collection = {}
  end

  def load_data(file_tree)
    filepath = file_tree[:enrollment][:kindergarten]
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      district_name = row[:location]#row[:location] is a string
      district_object = District.new({:name => district_name})
      district_collection[district_name] = district_object

      name = row[:location]
      district_collection[name] = District.new({:name => name}
    end


  end

  #need to take any CSV, pull only district name out of it, then attach that district name to instance of district class (object) and then stick that object into @district_collection

  # def load_data(input)
  #   file = input[:enrollment][:kindergarten] #calls hash from test hardcoding, which points to the value of the string accepted by CSV.open
  #   content = CSV.open(file)
  # end

  # def load_data(file_tree)
  #   filepath = file_tree[:enrollment][:kindergarten]
  #   years = []
  #   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
  #     years << ({:name => row[:location], row[:timeframe].to_i => row[:data].to_f})
  #   end
  #   puts years
  # end

  def find_by_name(district_name)
    content = CSV.open "./data/Kindergartners in full-day program.csv", headers: true, header_converters: :symbol

    content.each do |row|

      return district_name.upcase if row[:location].upcase.include?(district_name.upcase)
    end

  end

end
