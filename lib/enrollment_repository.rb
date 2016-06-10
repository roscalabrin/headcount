require 'pry'
require 'csv'
require_relative 'enrollment'
require_relative 'parser'

class EnrollmentRepository
  include Format
  include Parser

  attr_reader :enrollment_collection

  def initialize
    @enrollment_collection = {}
  end

  def load_data(file_tree)
   filepath = file_tree[:enrollment][:kindergarten]
   filepath_2 = file_tree[:enrollment][:high_school_graduation]
#find a way to dynamically pass in the key (i.e. :kindergarten, or high_school_graduation, or whatever)
#maybe make a method that just extracts the filepath dynamically (def extract filepath, takes in the actual key as an arg)
   kindergarten_array = csv_parser(filepath, :kindergarten)
   high_school_array = csv_parser(filepath_2, :high_school_graduation)
  end

  def create_enrollment_object
    final.map do |item|
      enrollment_object = Enrollment.new(item)
      enrollment_collection[item[:name]] = enrollment_object
    end
    binding.pry
  end

  def find_by_name(district_name)
    enrollment_collection[district_name]
  end

end
