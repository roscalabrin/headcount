require 'csv'
require 'pry'
class EnrollmentRepository

  # def initialize
  #
  # end

  def load_data(file_tree)
    filepath = file_tree[:enrollment][:kindergarten]
    years = []
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      years << ({:name => row[:location], row[:timeframe].to_i => row[:data].to_f})
    end
    binding.pry
    puts years.class
  end

end

e = Enrollment.new
puts e.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv"
  }})
