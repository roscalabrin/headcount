require 'csv'
require 'pry'
require_relative 'enrollment'
class EnrollmentRepository

  def load_data(file_tree)
    filepath = file_tree[:enrollment][:kindergarten]
    years = []
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      years << ({:name => row[:location], row[:timeframe].to_i => row[:data].to_f})
    end
    puts years
  end

  def find_by_name(district_name)
    return district_name.upcase if 

  end
end

# e = EnrollmentRepository.new
# puts e.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }})
