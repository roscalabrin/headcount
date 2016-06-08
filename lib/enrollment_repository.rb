require 'csv'
require 'pry'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollment_collection

  def initialize
    @enrollment_collection = {}
  end

  def load_data(file_tree)
    filepath = file_tree[:enrollment][:kindergarten]
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      district_name = row[:location]
      year = row[:timeframe]
      data = row[:data]
      enrollment_object = Enrollment.new({:name => district_name, :kindergarten_participation => {year => data}})

      #refactor for above code:
      # name = row[:location]
      # district_collection[name] = District.new({:name => name}
    end
    binding.pry
  end

  def find_by_name(district_name)
    "test"

  end

end

#	#need to take any CSV, pull only enrollement information out of it, then attach that district name to instance of district class (object) and then stick that object into @district_collection


# e = EnrollmentRepository.new
# puts e.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }})

# def load_data(file_tree)
#   filepath = file_tree[:enrollment][:kindergarten]
#   years = []
#   CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
#     years << ({:name => row[:location], row[:timeframe].to_i => row[:data].to_f})
#   end
#   puts years
# end
